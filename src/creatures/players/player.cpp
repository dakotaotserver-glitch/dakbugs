/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"

#include "account/account.hpp"
#include "config/configmanager.hpp"
#include "core.hpp"
#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/appearance/attached_effects/attached_effects.hpp"
#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/interactions/chat.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/npcs/npc.hpp"
#include "creatures/players/animus_mastery/animus_mastery.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "creatures/players/achievement/player_achievement.hpp"
#include "creatures/players/cyclopedia/player_badge.hpp"
#include "creatures/players/cyclopedia/player_cyclopedia.hpp"
#include "creatures/players/cyclopedia/player_title.hpp"
#include "creatures/players/grouping/party.hpp"
#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/storages/storages.hpp"
#include "creatures/players/vip/player_vip.hpp"
#include "creatures/players/wheel/player_wheel.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_group_type.hpp"
#include "enums/account_type.hpp"
#include "enums/object_category.hpp"
#include "enums/player_blessings.hpp"
#include "enums/player_icons.hpp"
#include "enums/player_cyclopedia.hpp"
#include "game/game.hpp"
#include "game/modal_window/modal_window.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_group_type.hpp"
#include "enums/account_type.hpp"
#include "enums/object_category.hpp"
#include "enums/player_blessings.hpp"
#include "enums/player_icons.hpp"
#include "enums/player_cyclopedia.hpp"
#include "game/game.hpp"
#include "game/modal_window/modal_window.hpp"
#include "game/scheduling/dispatcher.hpp"

#include "game/scheduling/save_manager.hpp"
#include "game/scheduling/task.hpp"
#include "grouping/familiars.hpp"
#include "grouping/guild.hpp"
#include "io/iobestiary.hpp"
#include "io/iologindata.hpp"
#include "io/ioprey.hpp"
#include "items/bed.hpp"
#include "items/containers/depot/depotchest.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/containers/rewards/reward.hpp"
#include "items/containers/rewards/rewardchest.hpp"
#include "items/items_classification.hpp"
#include "items/weapons/weapons.hpp"
#include "lib/metrics/metrics.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/actions.hpp"
#include "lua/creature/creatureevent.hpp"
#include "lua/creature/events.hpp"
#include "lua/creature/movement.hpp"
#include "map/spectators.hpp"
#include "creatures/players/vocations/vocation.hpp"
#include "creatures/players/components/wheel/wheel_definitions.hpp"

// Summer Update 2025
#include "creatures/players/proficiencies/proficiencies.hpp"
#include "creatures/players/proficiencies/proficiencies_definitions.hpp"
#include "lib/di/container.hpp"
#include "utils/pugicast.hpp"
#include "utils/const.hpp"
#include "utils/tools.hpp"

MuteCountMap Player::muteCountMap;

Player::Player(std::shared_ptr<ProtocolGame> p) :
	lastPing(OTSYS_TIME()),
	lastPong(lastPing),
	lastLoad(OTSYS_TIME()),
	inbox(std::make_shared<Inbox>(ITEM_INBOX)),
	client(std::move(p)),
	m_animusMastery(*this),
	m_playerAttachedEffects(*this) {
	m_playerVIP = std::make_unique<PlayerVIP>(*this);
	m_wheelPlayer = std::make_unique<PlayerWheel>(*this);
	m_playerAchievement = std::make_unique<PlayerAchievement>(*this);
	m_playerBadge = std::make_unique<PlayerBadge>(*this);
	m_playerCyclopedia = std::make_unique<PlayerCyclopedia>(*this);
	m_playerTitle = std::make_unique<PlayerTitle>(*this);
	m_playerVIP(*this),
	m_wheelPlayer(*this),
	m_playerAchievement(*this),
	m_playerBadge(*this),
	m_playerCyclopedia(*this),
	m_playerTitle(*this),
	m_animusMastery(*this),
	m_playerAttachedEffects(*this) { }

Player::~Player() {
	for (const auto &item : inventory) {
		if (item) {
			item->resetParent();
			item->stopDecaying();
		}
	}

	for (const auto &[depotId, depotLocker] : depotLockerMap) {
		if (depotId == 0) {
			continue;
		}

		depotLocker->removeInbox(inbox);
	}

	setWriteItem(nullptr);
	setEditHouse(nullptr);
	logged = false;
}

bool Player::setVocation(uint16_t vocId) {
	const auto &voc = g_vocations().getVocation(vocId);
	if (!voc) {
		return false;
	}
	vocation = voc;

	updateRegeneration();
	g_game().addPlayerVocation(static_self_cast<Player>());
	return true;
}

uint16_t Player::getVocationId() const {
	return vocation->getId();
}

bool Player::isPushable() {
	if (hasFlag(PlayerFlags_t::CannotBePushed)) {
		return false;
	}
	return Creature::isPushable();
}

std::shared_ptr<Task> Player::createPlayerTask(uint32_t delay, std::function<void(void)> f, const std::string &context) {
	return std::make_shared<Task>(std::move(f), context, delay);
}

uint32_t Player::playerFirstID = 0x10000000;
uint32_t Player::playerLastID = 0x50000000;
uint32_t Player::getFirstID() {
	return playerFirstID;
}
uint32_t Player::getLastID() {
	return playerLastID;
}

void Player::setID() {
	// guid = player id from database
	if (id == 0 && guid != 0) {
		id = getFirstID() + guid;
		if (id == std::numeric_limits<uint32_t>::max()) {
			g_logger().error("[{}] Player {} has max 'id' value of uint32_t", __FUNCTION__, getName());
		}
	}
}

std::string Player::getDescription(int32_t lookDistance) {
	std::ostringstream s;
	std::string subjectPronoun = getSubjectPronoun();
	capitalizeWords(subjectPronoun);
	const auto playerTitle = title().getCurrentTitle() == 0 ? "" : (", " + title().getCurrentTitleName());

	if (lookDistance == -1) {
		s << "yourself" << playerTitle << ".";

		if (group->access) {
			s << " You are " << group->name << '.';
		} else if (hasFlag(PlayerFlags_t::IsGameTester)) {
			s << " You are a " << group->name << '.';
		} else if (vocation->getId() != VOCATION_NONE) {
			s << " You are " << vocation->getVocDescription() << '.';
		} else {
			s << " You have no vocation.";
		}

		if (!loyaltyTitle.empty()) {
			s << " You are a " << loyaltyTitle << ".";
		}

		if (isVip()) {
			s << " You are VIP.";
		}
	} else {
		s << name;
		if (!group->access) {
			s << " (Level " << level << ')';
		}

		s << playerTitle << ". " << subjectPronoun;

		if (group->access) {
			s << " " << getSubjectVerb() << " " << group->name << '.';
		} else if (hasFlag(PlayerFlags_t::IsGameTester)) {
			s << " " << getSubjectVerb() << " a " << group->name << '.';
		} else if (vocation->getId() != VOCATION_NONE) {
			s << " " << getSubjectVerb() << " " << vocation->getVocDescription() << '.';
		} else {
			s << " has no vocation.";
		}

		if (!loyaltyTitle.empty()) {
			std::string article = "a";
			if (loyaltyTitle[0] == 'A' || loyaltyTitle[0] == 'E' || loyaltyTitle[0] == 'I' || loyaltyTitle[0] == 'O' || loyaltyTitle[0] == 'U') {
				article = "an";
			}
			s << " " << subjectPronoun << " " << getSubjectVerb() << " " << article << " " << loyaltyTitle << ".";
		}

		if (isVip()) {
			s << " " << subjectPronoun << " " << getSubjectVerb() << " VIP.";
		}
	}

	if (m_party) {
		if (lookDistance == -1) {
			s << " Your party has ";
		} else {
			s << " " << subjectPronoun << " " << getSubjectVerb() << " in a party with ";
		}

		const size_t memberCount = m_party->getMemberCount() + 1;
		if (memberCount == 1) {
			s << "1 member and ";
		} else {
			s << memberCount << " members and ";
		}

		const size_t invitationCount = m_party->getInvitationCount();
		if (invitationCount == 1) {
			s << "1 pending invitation.";
		} else {
			s << invitationCount << " pending invitations.";
		}
	}

	if (guild && guildRank) {
		const size_t memberCount = guild->getMemberCount();
		if (memberCount >= 1000) {
			s << "";
			return s.str();
		}

		if (lookDistance == -1) {
			s << " You are ";
		} else {
			s << " " << subjectPronoun << " " << getSubjectVerb() << " ";
		}

		s << guildRank->name << " of the " << guild->getName();
		if (!guildNick.empty()) {
			s << " (" << guildNick << ')';
		}

		if (memberCount == 1) {
			s << ", which has 1 member, " << guild->getMembersOnline().size() << " of them online.";
		} else {
			s << ", which has " << memberCount << " members, " << guild->getMembersOnline().size() << " of them online.";
		}
	}
	return s.str();
}

std::shared_ptr<Item> Player::getInventoryItem(Slots_t slot) const {
	if (slot < CONST_SLOT_FIRST || slot > CONST_SLOT_LAST) {
		return nullptr;
	}
	return inventory[slot];
}

bool Player::isItemAbilityEnabled(Slots_t slot) const {
	return inventoryAbilities[slot];
}

void Player::setItemAbility(Slots_t slot, bool enabled) {
	inventoryAbilities[slot] = enabled;
}

void Player::setVarSkill(skills_t skill, int32_t modifier) {
	varSkills[skill] += modifier;
}

bool Player::isSuppress(ConditionType_t conditionType, bool attackerPlayer) const {
	auto minDelay = g_configManager().getNumber(MIN_DELAY_BETWEEN_CONDITIONS);
	if (IsConditionSuppressible(conditionType) && checkLastConditionTimeWithin(conditionType, minDelay)) {
		return true;
	}

	auto conditionId = static_cast<size_t>(conditionType);
	return (m_conditionSuppressionCount[conditionId] > 0);
}

void Player::addConditionSuppressions(const std::array<ConditionType_t, ConditionType_t::CONDITION_COUNT> &addConditions) {
	for (auto conditionType : addConditions) {
		auto conditionId = static_cast<size_t>(conditionType);
		if (conditionId >= ConditionType_t::CONDITION_COUNT) {
			continue;
		}
		if (m_conditionSuppressionCount[conditionId] < UINT8_MAX) {
			m_conditionSuppressionCount[conditionId]++;
		}
	}
}

void Player::removeConditionSuppressions(const std::vector<ConditionType_t> &toRemoveConditions) {
	for (auto conditionType : toRemoveConditions) {
		if (conditionType == ConditionType_t::CONDITION_NONE) {
			continue;
		}
		auto conditionSize = static_cast<size_t>(conditionType);
		if (conditionSize >= ConditionType_t::CONDITION_COUNT) {
			continue;
		}
		if (m_conditionSuppressionCount[conditionSize] > 0) {
			m_conditionSuppressionCount[conditionSize]--;
			if (m_conditionSuppressionCount[conditionSize] == 0) {
				sendIcons();
			}
		}
	}
}

std::shared_ptr<Item> Player::getWeapon(Slots_t slot, bool ignoreAmmo) const {
	const auto &item = inventory[slot];
	if (!item) {
		return nullptr;
	}

	const WeaponType_t &weaponType = item->getWeaponType();
	if (weaponType == WEAPON_NONE || weaponType == WEAPON_SHIELD || weaponType == WEAPON_AMMO) {
		return nullptr;
	}

	if (!ignoreAmmo && (weaponType == WEAPON_DISTANCE || weaponType == WEAPON_MISSILE)) {
		const ItemType &it = Item::items[item->getID()];
		if (it.ammoType != AMMO_NONE) {
			return getQuiverAmmoOfType(it);
		}
	}

	return item;
}

bool Player::hasQuiverEquipped() const {
	const auto &quiver = inventory[CONST_SLOT_RIGHT];
	return quiver && quiver->isQuiver() && quiver->getContainer();
}

bool Player::hasWeaponDistanceEquipped() const {
	const auto &item = inventory[CONST_SLOT_LEFT];
	return item && item->getWeaponType() == WEAPON_DISTANCE;
}

std::shared_ptr<Item> Player::getQuiverAmmoOfType(const ItemType &it) const {
	if (!hasQuiverEquipped()) {
		return nullptr;
	}

	const auto &quiver = inventory[CONST_SLOT_RIGHT];
	for (const auto &container = quiver->getContainer();
	     const auto &ammoItem : container->getItemList()) {
		if (ammoItem->getAmmoType() == it.ammoType) {
			if (level >= Item::items[ammoItem->getID()].minReqLevel) {
				return ammoItem;
			}
		}
	}
	return nullptr;
}

std::shared_ptr<Item> Player::getWeapon(bool ignoreAmmo /* = false*/) const {
	const auto &itemLeft = getWeapon(CONST_SLOT_LEFT, ignoreAmmo);
	if (itemLeft) {
		return itemLeft;
	}

	const auto &itemRight = getWeapon(CONST_SLOT_RIGHT, ignoreAmmo);
	if (itemRight) {
		return itemRight;
	}
	return nullptr;
}

WeaponType_t Player::getWeaponType() const {
	const auto &item = getWeapon();
	if (!item) {
		return WEAPON_NONE;
	}
	return item->getWeaponType();
}

int32_t Player::getWeaponSkill(const std::shared_ptr<Item> &item) const {
	if (!item) {
		return getSkillLevel(SKILL_FIST);
	}

	int32_t attackSkill;

	const WeaponType_t &weaponType = item->getWeaponType();
	switch (weaponType) {
		case WEAPON_FIST: {
			attackSkill = getSkillLevel(SKILL_FIST);
			break;
		}
		
		case WEAPON_SWORD: {
			attackSkill = getSkillLevel(SKILL_SWORD);
			break;
		}

		case WEAPON_CLUB: {
			attackSkill = getSkillLevel(SKILL_CLUB);
			break;
		}

		case WEAPON_AXE: {
			attackSkill = getSkillLevel(SKILL_AXE);
			break;
		}

		case WEAPON_MISSILE:
		case WEAPON_DISTANCE: {
			attackSkill = getSkillLevel(SKILL_DISTANCE);
			break;
		}

		default: {
			attackSkill = 0;
			break;
		}
	}
	return attackSkill;
}

uint16_t Player::getDistanceAttackSkill(const int32_t attackSkill, const int32_t weaponAttack) const {
	// Correct calculation of getWeaponSkill function (getMaxWeaponDamage) for Paladins
	const double skillFactor = (attackSkill + 4) / 28.;
	return weaponAttack * skillFactor - weaponAttack;
}

uint16_t Player::getAttackSkill(const std::shared_ptr<Item> &item) const {
	if (!item) {
		return getSkillLevel(SKILL_FIST);
	}
	int32_t attackSkill;
	const WeaponType_t &weaponType = item->getWeaponType();
	switch (weaponType) {
		case WEAPON_FIST: {
			attackSkill = getSkillLevel(SKILL_FIST);
			break;
		}
		
		case WEAPON_SWORD: {
			attackSkill = getSkillLevel(SKILL_SWORD);
			break;
		}
		case WEAPON_CLUB: {
			attackSkill = getSkillLevel(SKILL_CLUB);
			break;
		}
		case WEAPON_AXE: {
			attackSkill = getSkillLevel(SKILL_AXE);
			break;
		}
		case WEAPON_MISSILE:
		case WEAPON_DISTANCE: {
			attackSkill = getSkillLevel(SKILL_DISTANCE);
			break;
		}
		default: {
			attackSkill = 0;
			break;
		}
	}
	// Correct calculation of getWeaponSkill function (getMaxWeaponDamage)
	const double skillFactor = (attackSkill + 4) / 28.;
	const auto weaponAttack = item->getAttack();
	return weaponAttack * skillFactor - weaponAttack;
}

uint8_t Player::getWeaponSkillId(const std::shared_ptr<Item> &item) const {
	uint8_t skillId;
	const WeaponType_t &weaponType = item->getWeaponType();
	switch (weaponType) {
		case WEAPON_FIST: {
			skillId = 11;
			break;
		}
		case WEAPON_SWORD: {
			skillId = 8;
			break;
		}
		case WEAPON_CLUB: {
			skillId = 9;
			break;
		}
		case WEAPON_AXE: {
			skillId = 10;
			break;
		}
		default: {
			skillId = 11;
			break;
		}
	}
	return skillId;
}

uint16_t Player::calculateFlatDamageHealing() const {
	uint16_t constA = 0;
	uint16_t constB = 0;
	double constC = 0;
	if (level < 500) {
		constA = 0;
		constB = 0;
		constC = 0.2f;
	} else if (level >= 500 && level <= 1100) {
		constA = 100;
		constB = 500;
		constC = 0.1667f;
	} else if (level >= 1100 && level <= 1800) {
		constA = 200;
		constB = 1101;
		constC = 0.1429f;
	} else if (level >= 1800 && level <= 2600) {
		constA = 300;
		constB = 1800;
		constC = 0.1250f;
	} else if (level > 2600) {
		constA = 400;
		constB = 2600;
		constC = 0.111f;
	}
	return constA + (level - constB) * constC;
}

uint16_t Player::attackTotal(uint16_t flatBonus, uint16_t equipment, uint16_t skill) const {
	double fightFactor = 0;
	switch (fightMode) {
		case FIGHTMODE_ATTACK: {
			fightFactor = 1.2f * equipment;
			break;
		}
		case FIGHTMODE_BALANCED: {
			fightFactor = 1.0f * equipment;
			break;
		}
		case FIGHTMODE_DEFENSE: {
			fightFactor = 0.6f * equipment;
			break;
		}
		default: {
			fightFactor = 1.0f * equipment;
			break;
		}
	}
	fightFactor = std::floor(fightFactor);
	const double skillFactor = (skill + 4) / 28.;
	return flatBonus + (fightFactor * skillFactor);
}

uint16_t Player::attackRawTotal(uint16_t flatBonus, uint16_t equipment, uint16_t skill) const {
	const double skillFactor = (skill + 4) / 28.;
	return flatBonus + (equipment * skillFactor);
}

int32_t Player::getArmor() const {
	int32_t armor = 0;

	static constexpr Slots_t armorSlots[] = { CONST_SLOT_HEAD, CONST_SLOT_NECKLACE, CONST_SLOT_ARMOR, CONST_SLOT_LEGS, CONST_SLOT_FEET, CONST_SLOT_RING, CONST_SLOT_AMMO };
	for (const Slots_t &slot : armorSlots) {
		const auto &inventoryItem = inventory[slot];
		if (inventoryItem) {
			armor += inventoryItem->getArmor();
		}
	}
	return armor * static_cast<int32_t>(vocation->armorMultiplier);
}

void Player::getShieldAndWeapon(std::shared_ptr<Item> &shield, std::shared_ptr<Item> &weapon) const {
	shield = nullptr;
	weapon = nullptr;

	for (uint32_t slot = CONST_SLOT_RIGHT; slot <= CONST_SLOT_LEFT; slot++) {
		const auto &item = inventory[slot];
		if (!item) {
			continue;
		}

		switch (item->getWeaponType()) {
			case WEAPON_NONE:
				break;

			case WEAPON_SHIELD: {
				if (!shield || (shield && item->getDefense() > shield->getDefense())) {
					shield = item;
				}
				break;
			}

			default: { // weapons that are not shields
				weapon = item;
				break;
			}
		}
	}
}

float Player::getMitigation() const {
	return wheel().calculateMitigation();
}

double Player::getCombatTacticsMitigation() const {
	double fightFactor = 0.0;
	switch (fightMode) {
		case FIGHTMODE_ATTACK: {
			fightFactor = 0.8f;
			break;
		}
		case FIGHTMODE_BALANCED: {
			fightFactor = 1.0f;
			break;
		}
		case FIGHTMODE_DEFENSE: {
			fightFactor = 1.2f;
			break;
		}
		default:
			break;
	}
	return fightFactor;
}

int32_t Player::getDefense(bool sendToClient /* = false*/) const {
	int32_t defenseSkill = getSkillLevel(SKILL_FIST);
	int32_t defenseValue = 7;
	std::shared_ptr<Item> weapon;
	std::shared_ptr<Item> shield;
	getShieldAndWeapon(shield, weapon);

	if (weapon) {
		defenseValue = (weapon->getDefense() + equippedWeaponProficiency.defense) + (weapon->getExtraDefense() + equippedWeaponProficiency.weaponShieldMod);
#ifdef DEBUG_SUMMER_UPDATE_2025_LOG
		//g_logger().warn("[{}] defenseValue {} / weapon->getDefense() {} / weapon->getExtraDefense() {} / weaponShieldMod {} / defense {}", __FUNCTION__, defenseValue, weapon->getDefense(), weapon->getExtraDefense(), equippedWeaponProficiency.weaponShieldMod, equippedWeaponProficiency.defense);
#endif // DEBUG_SUMMER_UPDATE_2025_LOG
		defenseSkill = getWeaponSkill(weapon);
	}

	if (shield) {
		defenseValue = (weapon != nullptr) ? shield->getDefense() + (weapon->getExtraDefense() + equippedWeaponProficiency.weaponShieldMod) : shield->getDefense();
		// Wheel of destiny - Combat Mastery
		if (shield->getDefense() > 0) {
			defenseValue += wheel().getMajorStatConditional("Combat Mastery", WheelMajor_t::DEFENSE);
		}
		defenseSkill = getSkillLevel(SKILL_SHIELD);
	}

	if (defenseSkill == 0) {
		switch (fightMode) {
			case FIGHTMODE_ATTACK:
			case FIGHTMODE_BALANCED:
				return 1;
			case FIGHTMODE_DEFENSE:
				return 2;
		}
	}

	auto defenseScalingFactor = shield ? 0.16f : (weapon && weapon->getDefense() > 0 ? 0.146f : 0.15f);
	return ((defenseSkill / 4.0 + 2.23) * defenseValue * getDefenseFactor(sendToClient) * defenseScalingFactor) * vocation->defenseMultiplier;
}

uint16_t Player::getDefenseEquipment() const {
	uint16_t defenseValue = 6;
	std::shared_ptr<Item> weapon;
	std::shared_ptr<Item> shield;
	getShieldAndWeapon(shield, weapon);
	if (weapon) {
		defenseValue = (weapon->getDefense() + equippedWeaponProficiency.defense) + (weapon->getExtraDefense() + equippedWeaponProficiency.weaponShieldMod);
#ifdef DEBUG_SUMMER_UPDATE_2025_LOG
		//g_logger().warn("[{}] defenseValue {} / weapon->getDefense() {} / weapon->getExtraDefense() {} / weaponShieldMod {} / defense {}", __FUNCTION__, defenseValue, weapon->getDefense(), weapon->getExtraDefense(), equippedWeaponProficiency.weaponShieldMod, equippedWeaponProficiency.defense);
#endif // DEBUG_SUMMER_UPDATE_2025_LOG
	}
	if (shield) {
		defenseValue = weapon != nullptr ? (shield->getDefense() +  equippedWeaponProficiency.defense) + (weapon->getExtraDefense() + equippedWeaponProficiency.weaponShieldMod) : shield->getDefense();
#ifdef DEBUG_SUMMER_UPDATE_2025_LOG
		//g_logger().warn("[{}] defenseValue {} / shield->getDefense() {} / weapon->getExtraDefense() {} / weaponShieldMod {} / defense {}", __FUNCTION__, defenseValue, shield->getDefense(), weapon->getExtraDefense(), equippedWeaponProficiency.weaponShieldMod, equippedWeaponProficiency.defense);
#endif // DEBUG_SUMMER_UPDATE_2025_LOG
		if (shield->getDefense() > 0) {
			defenseValue += wheel().getMajorStatConditional("Combat Mastery", WheelMajor_t::DEFENSE);
		}
	}
	return defenseValue;
}

float Player::getAttackFactor() const {
	switch (fightMode) {
		case FIGHTMODE_ATTACK:
			return 1.0f;
		case FIGHTMODE_BALANCED:
			return 0.75f;
		case FIGHTMODE_DEFENSE:
			return 0.5f;
		default:
			return 1.0f;
	}
}

float Player::getDefenseFactor(bool sendToClient /* = false*/) const {
	switch (fightMode) {
		case FIGHTMODE_ATTACK:
			if (sendToClient) {
				return 0.5f;
			}
			return (OTSYS_TIME() - lastAttack) < getAttackSpeed() ? 0.5f : 1.0f;
		case FIGHTMODE_BALANCED:
			if (sendToClient) {
				return 0.75f;
			}
			return (OTSYS_TIME() - lastAttack) < getAttackSpeed() ? 0.75f : 1.0f;
		case FIGHTMODE_DEFENSE:
			return 1.0f;
		default:
			return 1.0f;
	}
}

std::vector<double> Player::getDamageAccuracy(const ItemType &it) const {
	std::vector<double> accuracy = {};
	const auto distanceValue = getSkillLevel(SKILL_DISTANCE);
	if (it.ammoType == AMMO_BOLT || it.ammoType == AMMO_ARROW) {
		accuracy.push_back(std::min<double>(90, (1.20f * (distanceValue + 1))));
		accuracy.push_back(std::min<double>(90, (3.20f * distanceValue)));
		accuracy.push_back(std::min<double>(90, (2.00f * distanceValue)));
		accuracy.push_back(std::min<double>(90, (1.55f * distanceValue)));
		accuracy.push_back(std::min<double>(90, (1.20f * (distanceValue + 1))));
		accuracy.push_back(std::min<double>(90, distanceValue));
	} else {
		accuracy.push_back(std::min<double>(75, distanceValue + 1));
		accuracy.push_back(std::min<double>(75, 2.40f * (distanceValue + 8)));
		accuracy.push_back(std::min<double>(75, 1.55f * (distanceValue + 6)));
		accuracy.push_back(std::min<double>(75, 1.25f * (distanceValue + 3)));
		accuracy.push_back(std::min<double>(75, distanceValue + 1));
		accuracy.push_back(std::min<double>(75, 0.80f * (distanceValue + 3)));
		accuracy.push_back(std::min<double>(75, 0.70f * (distanceValue + 2)));
	}
	return accuracy;
}

void Player::setLastWalkthroughAttempt(int64_t walkthroughAttempt) {
	lastWalkthroughAttempt = walkthroughAttempt;
}

void Player::setLastWalkthroughPosition(Position walkthroughPosition) {
	lastWalkthroughPosition = walkthroughPosition;
}

std::shared_ptr<Inbox> Player::getInbox() const {
	return inbox;
}

std::unordered_set<PlayerIcon> Player::getClientIcons() {
	std::unordered_set<PlayerIcon> icons;

	for (const auto &condition : conditions) {
		if (!isSuppress(condition->getType(), false)) {
			auto conditionIcons = condition->getIcons();
			icons.insert(conditionIcons.begin(), conditionIcons.end());
			if (icons.size() == 9) {
				return icons;
			}
		}
	}

	if (pzLocked && icons.size() < 9) {
		icons.insert(PlayerIcon::RedSwords);
	}

	const auto &tile = getTile();
	if (tile && tile->hasFlag(TILESTATE_PROTECTIONZONE)) {
		if (icons.size() < 9) {
			icons.insert(PlayerIcon::Pigeon);
		}
		client->sendRestingStatus(1);

		icons.erase(PlayerIcon::Swords);
	} else {
		client->sendRestingStatus(0);
	}

	return icons;
}

const std::unordered_set<std::shared_ptr<MonsterType>> &Player::getCyclopediaMonsterTrackerSet(bool isBoss) const {
	return isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;
}

void Player::addMonsterToCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient /* = false */) {
	if (!client) {
		return;
	}

	const uint16_t raceId = mtype ? mtype->info.raceid : 0;
	auto &tracker = isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;
	if (tracker.emplace(mtype).second) {
		if (reloadClient && raceId != 0) {
			if (isBoss) {
				client->parseSendBosstiary();
			} else {
				client->sendBestiaryEntryChanged(raceId);
			}
		}

		client->refreshCyclopediaMonsterTracker(tracker, isBoss);
	}
}

void Player::removeMonsterFromCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient /* = false */) {
	if (!client) {
		return;
	}

	const uint16_t raceId = mtype ? mtype->info.raceid : 0;
	auto &tracker = isBoss ? m_bosstiaryMonsterTracker : m_bestiaryMonsterTracker;

	if (tracker.erase(mtype) > 0) {
		if (reloadClient && raceId != 0) {
			if (isBoss) {
				client->parseSendBosstiary();
			} else {
				client->sendBestiaryEntryChanged(raceId);
			}
		}

		client->refreshCyclopediaMonsterTracker(tracker, isBoss);
	}
}

void Player::sendBestiaryEntryChanged(uint16_t raceid) const {
	if (client) {
		client->sendBestiaryEntryChanged(raceid);
	}
}

void Player::refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const {
	if (client) {
		client->refreshCyclopediaMonsterTracker(trackerList, isBoss);
	}
}

bool Player::isBossOnBosstiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const {
	return monsterType ? m_bosstiaryMonsterTracker.contains(monsterType) : false;
}

bool Player::isMonsterOnBestiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const {
	return monsterType ? m_bestiaryMonsterTracker.contains(monsterType) : false;
}


std::shared_ptr<Vocation> Player::getVocation() const {
	return vocation;
}

OperatingSystem_t Player::getOperatingSystem() const {
	return operatingSystem;
}

void Player::setOperatingSystem(OperatingSystem_t clientos) {
	operatingSystem = clientos;
}

bool Player::isOldProtocol() const {
	return client && client->oldProtocol;
}

uint32_t Player::getProtocolVersion() const {
	if (!client) {
		return 0;
	}

	return client->getVersion();
}

bool Player::hasSecureMode() const {
	return secureMode;
}

void Player::setParty(std::shared_ptr<Party> newParty) {
	m_party = std::move(newParty);
}

std::shared_ptr<Party> Player::getParty() const {
	return m_party;
}

int32_t Player::getCleavePercent(bool useCharges) const {
	int32_t result = cleavePercent;
	for (const auto &item : getEquippedItems()) {
		const ItemType &it = Item::items[item->getID()];
		if (!it.abilities) {
			continue;
		}

		const int32_t cleave_percent = it.abilities->cleavePercent;
		if (cleave_percent != 0) {
			result += cleave_percent;
			const uint16_t charges = item->getCharges();
			if (useCharges && charges != 0) {
				g_game().transformItem(item, item->getID(), charges - 1);
			}
		}
	}

	return result;
}

void Player::updateInventoryWeight() {
	if (hasFlag(PlayerFlags_t::HasInfiniteCapacity)) {
		return;
	}

	inventoryWeight = 0;
	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (item) {
			inventoryWeight += item->getWeight();
		}
	}
}

void Player::updateInventoryImbuement(bool decayOnly) {
	const auto tile = getTile();
	const bool isInProtectionZone = tile && tile->hasFlag(TILESTATE_PROTECTIONZONE);
	const bool isInFightMode = hasCondition(CONDITION_INFIGHT);
	const bool nonAggressiveFightOnly = g_configManager().getBoolean(TOGGLE_IMBUEMENT_NON_AGGRESSIVE_FIGHT_ONLY);

	for (auto [slot, item] : getAllSlotItems()) {
		if (item->getTopParent().get() != this) {
			continue;
		}

		const uint8_t imbuementSlots = item->getImbuementSlot();
		for (uint8_t imbuementSlot = 0; imbuementSlot < imbuementSlots; ++imbuementSlot) {
			ImbuementInfo imbuementInfo;
			if (!item->getImbuementInfo(imbuementSlot, &imbuementInfo)) {
				continue;
			}

			const auto imbuement = imbuementInfo.imbuement;
			const auto categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());

			const bool aggressive = categoryImbuement->agressive;
			const bool aggressiveCondition = aggressive && !isInFightMode;
			const bool nonAggressiveCondition = nonAggressiveFightOnly && !aggressive && isInFightMode;
			const bool passiveCondition = categoryImbuement->passive;
			const bool isInBackpack = item->getContainer() && item->getParent()->getPlayer() == this;

			if (isInBackpack || aggressiveCondition || nonAggressiveCondition || passiveCondition || isInProtectionZone) {
				continue;
			}

			if (imbuementInfo.duration == 0) {
				item->removeItemImbuementStats(imbuement);
				continue;
			}

			if (decayOnly) {
				if (isInProtectionZone) { // Adicionado: Sempre skip decay se in PZ, mesmo equipped
					continue;
				}
				imbuementInfo.duration -= EVENT_IMBUEMENT_INTERVAL / 1000;
				item->decayImbuementTime(imbuementSlot, imbuementInfo.duration);
				if (imbuementInfo.duration <= 0) {
					item->removeItemImbuementStats(imbuement);
				}
				continue;
			}

			item->addItemImbuementStats(imbuement, false);
		}
	}
}

phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> Player::getAllSlotItems() const {
	phmap::flat_hash_map<uint8_t, std::shared_ptr<Item>> itemMap;
	for (uint8_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		itemMap[i] = item;
	}

	return itemMap;
}

uint16_t Player::getLoyaltySkill(skills_t skill) const {
	uint16_t level = getBaseSkill(skill);
	absl::uint128 currReqTries = vocation->getReqSkillTries(skill, level);
	absl::uint128 nextReqTries = vocation->getReqSkillTries(skill, level + 1);
	if (currReqTries >= nextReqTries) {
		// player has reached max skill
		return skills[skill].level;
	}

	absl::uint128 tries = skills[skill].tries;
	const absl::uint128 totalTries = vocation->getTotalSkillTries(skill, skills[skill].level) + tries;
	absl::uint128 loyaltyTries = (totalTries * getLoyaltyBonus()) / 100;
	while ((tries + loyaltyTries) >= nextReqTries) {
		loyaltyTries -= nextReqTries - tries;
		level++;
		tries = 0;

		currReqTries = nextReqTries;
		nextReqTries = vocation->getReqSkillTries(skill, level + 1);
		if (currReqTries >= nextReqTries) {
			loyaltyTries = 0;
			break;
		}
	}
	return level;
}

uint16_t Player::getBaseSkill(uint8_t skill) const {
	return skills[skill].level;
}

double_t Player::getSkillPercent(skills_t skill) const {
	return skills[skill].percent;
}

bool Player::getAddAttackSkill() const {
	return addAttackSkillPoint;
}

BlockType_t Player::getLastAttackBlockType() const {
	return lastAttackBlockType;
}

uint64_t Player::getLastConditionTime(ConditionType_t type) const {
	if (!lastConditionTime.contains(static_cast<uint8_t>(type))) {
		return 0;
	}
	return lastConditionTime.at(static_cast<uint8_t>(type));
}

void Player::updateLastConditionTime(ConditionType_t type) {
	lastConditionTime[static_cast<uint8_t>(type)] = OTSYS_TIME();
}

bool Player::checkLastConditionTimeWithin(ConditionType_t type, uint32_t interval) const {
	if (!lastConditionTime.contains(static_cast<uint8_t>(type))) {
		return false;
	}
	const auto last = lastConditionTime.at(static_cast<uint8_t>(type));
	return last > 0 && ((OTSYS_TIME() - last) < interval);
}

uint64_t Player::getLastAttack() const {
	return lastAttack;
}

bool Player::checkLastAttackWithin(uint32_t interval) const {
	return lastAttack > 0 && ((OTSYS_TIME() - lastAttack) < interval);
}

const auto tile = getTile();
const bool isInProtectionZone = tile && tile->hasFlag(TILESTATE_PROTECTIONZONE);
const bool isInFightMode = hasCondition(CONDITION_INFIGHT);

for (auto [slot, item] : getAllSlotItems()) {
    if (item->getTopParent().get() != this) {
        continue;
    }

    const uint8_t imbuementSlots = item->getImbuementSlot();
    for (uint8_t imbuementSlot = 0; imbuementSlot < imbuementSlots; ++imbuementSlot) {
        ImbuementInfo imbuementInfo;
        if (!item->getImbuementInfo(imbuementSlot, &imbuementInfo)) {
            continue;
        }

        const auto imbuement = imbuementInfo.imbuement;
        const auto categoryImbuement = g_imbuements().getCategoryByID(imbuement->getCategory());

        bool isPassiveException = (imbuement->getName() == "Increase Capacity" || imbuement->getName() == "Paralysis Deflection" || imbuement->getName() == "Increase Speed");  // Use names or IDs for exceptions

        const bool isInBackpack = item->getContainer() && item->getParent()->getPlayer() == this;

        if (isInBackpack) {
            continue;
        }

        // Para normais (!passive): skip se PZ ou !fight
        if (!isPassiveException) {
            if (isInProtectionZone) {
                continue;
            }
            if (!isInFightMode) {
                continue;
            }
        }

        if (imbuementInfo.duration == 0) {
            removeItemImbuementStats(imbuement);
            continue;
        }

        if (decayOnly) {
            imbuementInfo.duration -= EVENT_IMBUEMENT_INTERVAL / 1000;
            item->decayImbuementTime(imbuementSlot, imbuementInfo.duration);
            if (imbuementInfo.duration <= 0) {
                removeItemImbuementStats(imbuement);
            }
            continue;
        }

        addItemImbuementStats(imbuement, false);
    }
}

        addItemImbuementStats(imbuement, false);
    }


		g_creatureEvents().playerAdvance(static_self_cast<Player>(), skill, (skills[skill].level - 1), skills[skill].level);

		sendUpdateSkills = true;
		currReqTries = nextReqTries;
		nextReqTries = vocation->getReqSkillTries(skill, skills[skill].level + 1);
		if (currReqTries >= nextReqTries) {
			count = 0;
			break;
		}

	skills[skill].tries += count;

	double_t newPercent;
	if (nextReqTries > currReqTries) {
		newPercent = Player::getPercentLevel(skills[skill].tries, nextReqTries);
	} else {
		newPercent = 0;
	}

	if (skills[skill].percent != newPercent) {
		skills[skill].percent = newPercent;
		sendUpdateSkills = true;
	}

	if (sendUpdateSkills) {
		sendSkills();
		sendStats();
	}
1

void Player::setVarStats(stats_t stat, int32_t modifier) {
	varStats[stat] += modifier;

	switch (stat) {
		case STAT_MAXHITPOINTS: {
			if (getHealth() > getMaxHealth()) {
				Creature::changeHealth(getMaxHealth() - getHealth());
			} else {
				g_game().addCreatureHealth(static_self_cast<Player>());
			}
			break;
		}

		case STAT_MAXMANAPOINTS: {
			if (getMana() > getMaxMana()) {
				Creature::changeMana(getMaxMana() - getMana());
			} else {
				g_game().addPlayerMana(static_self_cast<Player>());
			}
			break;
		}

		default: {
			break;
		}
	}
}

int32_t Player::getDefaultStats(stats_t stat) const {
	switch (stat) {
		case STAT_MAXHITPOINTS:
			return healthMax;
		case STAT_MAXMANAPOINTS:
			return manaMax;
		case STAT_MAGICPOINTS:
			return getBaseMagicLevel();
		default:
			return 0;
	}
}

void Player::syncOpenContainers() {
	if (client) {
		client->syncOpenContainers();
	}
}

void Player::addContainer(uint8_t cid, const std::shared_ptr<Container> &container) {
	if (cid > 0xF) {
		return;
	}

	if (!container) {
		return;
	}

	const auto it = openContainers.find(cid);
	if (it != openContainers.end()) {
		OpenContainer &openContainer = it->second;
		openContainer.container = container;
		openContainer.index = 0;
	} else {
		OpenContainer openContainer;
		openContainer.container = container;
		openContainer.index = 0;
		openContainers[cid] = openContainer;
	}
}

void Player::closeContainer(uint8_t cid) {
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}

	const OpenContainer &openContainer = it->second;
	const auto &container = openContainer.container;

	if (container && container->isAnyKindOfRewardChest() && !hasOtherRewardContainerOpen(container)) {
		removeEmptyRewards();
	}
	openContainers.erase(it);
}

void Player::removeEmptyRewards() {
	std::erase_if(rewardMap, [this](const auto &rewardBag) {
		auto [id, reward] = rewardBag;
		if (reward->empty()) {
			getRewardChest()->removeItem(reward);
			return true;
		}
		return false;
	});
}

bool Player::hasOtherRewardContainerOpen(const std::shared_ptr<Container> &container) const {
	return std::ranges::any_of(openContainers.begin(), openContainers.end(), [container](const auto &containerPair) {
		return containerPair.second.container != container && containerPair.second.container->isAnyKindOfRewardContainer();
	});
}

void Player::setContainerIndex(uint8_t cid, uint16_t index) {
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return;
	}
	it->second.index = index;
}

std::shared_ptr<Container> Player::getContainerByID(uint8_t cid) {
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return nullptr;
	}
	return it->second.container;
}

int8_t Player::getContainerID(const std::shared_ptr<Container> &container) const {
	for (const auto &[containerId, containerInfo] : openContainers) {
		if (containerInfo.container == container) {
			return containerId;
		}
	}
	return -1;
}

uint16_t Player::getContainerIndex(uint8_t cid) const {
	const auto it = openContainers.find(cid);
	if (it == openContainers.end()) {
		return 0;
	}
	return it->second.index;
}

bool Player::canOpenCorpse(uint32_t ownerId) const {
	return getID() == ownerId || (m_party && m_party->canOpenCorpse(ownerId));
}

uint16_t Player::getLookCorpse() const {
	if (sex == PLAYERSEX_FEMALE) {
		return ITEM_FEMALE_CORPSE;
	}
	return ITEM_MALE_CORPSE;
}

void Player::addStorageValue(const uint32_t key, const int32_t value, const bool isLogin /* = false*/) {
	if (IS_IN_KEYRANGE(key, RESERVED_RANGE)) {
		if (IS_IN_KEYRANGE(key, OUTFITS_RANGE)) {
			outfits.emplace_back(
				value >> 16,
				value & 0xFF
			);
			return;
		}
		if (IS_IN_KEYRANGE(key, MOUNTS_RANGE)) {
			// do nothing
		} else if (IS_IN_KEYRANGE(key, WING_RANGE)) {
			// do nothing
		} else if (IS_IN_KEYRANGE(key, EFFECT_RANGE)) {
			// do nothing
		} else if (IS_IN_KEYRANGE(key, AURA_RANGE)) {
			// do nothing
		} else if (IS_IN_KEYRANGE(key, SHADER_RANGE)) {
			// do nothing
		} else if (IS_IN_KEYRANGE(key, FAMILIARS_RANGE)) {
			familiars.emplace_back(
				value >> 16
			);
			return;
		} else {
			g_logger().warn("Unknown reserved key: {} for player: {}", key, getName());
			return;
		}
	}

	if (value != -1) {
		int32_t oldValue = getStorageValue(key);
		storageMap[key] = value;

		if (!isLogin) {
			auto currentFrameTime = g_dispatcher().getDispatcherCycle();
			g_events().eventOnStorageUpdate(static_self_cast<Player>(), key, value, oldValue, currentFrameTime);
			g_callbacks().executeCallback(EventCallback_t::playerOnStorageUpdate, &EventCallback::playerOnStorageUpdate, getPlayer(), key, value, oldValue, currentFrameTime);
		}
	} else {
		storageMap.erase(key);
	}
}

int32_t Player::getStorageValue(const uint32_t key) const {
	int32_t value = -1;
	const auto it = storageMap.find(key);
	if (it == storageMap.end()) {
		return value;
	}

	value = it->second;
	return value;
}

int32_t Player::getStorageValueByName(const std::string &storageName) const {
	const auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		return -1;
	}
	const uint32_t key = it->second;

	return getStorageValue(key);
}

void Player::addStorageValueByName(const std::string &storageName, const int32_t value, const bool isLogin /* = false*/) {
	auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		g_logger().error("[{}] Storage name '{}' not found in storage map, register your storage in 'storages.xml' first for use", __func__, storageName);
		return;
	}
	const uint32_t key = it->second;
	addStorageValue(key, value, isLogin);
}

std::shared_ptr<KV> Player::kv() const {
	return g_kv().scoped("player")->scoped(fmt::format("{}", getGUID()));
}

bool Player::canSee(const Position &pos) {
	if (!client) {
		return false;
	}
	return client->canSee(pos);
}

bool Player::canSeeCreature(const std::shared_ptr<Creature> &creature) const {
	if (creature.get() == this) {
		return true;
	}

	if (creature->isInGhostMode() && !group->access) {
		return false;
	}

	if (!creature->getPlayer() && !canSeeInvisibility() && creature->isInvisible()) {
		return false;
	}
	return true;
}

bool Player::canWalkthrough(const std::shared_ptr<Creature> &creature) {
	if (group->access || creature->isInGhostMode()) {
		return true;
	}

	const auto &player = creature->getPlayer();
	const auto &monster = creature->getMonster();
	const auto &npc = creature->getNpc();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	if (player) {
		const auto &playerTile = player->getTile();
		if (!playerTile || (!playerTile->hasFlag(TILESTATE_NOPVPZONE) && !playerTile->hasFlag(TILESTATE_PROTECTIONZONE) && player->getLevel() > static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL)) && g_game().getWorldType() != WORLD_TYPE_NO_PVP)) {
			return false;
		}

		const auto &playerTileGround = playerTile->getGround();
		if (!playerTileGround || !playerTileGround->hasWalkStack()) {
			return false;
		}

		const auto &thisPlayer = getPlayer();
		if ((OTSYS_TIME() - lastWalkthroughAttempt) > 2000) {
			thisPlayer->setLastWalkthroughAttempt(OTSYS_TIME());
			return false;
		}

		if (creature->getPosition() != lastWalkthroughPosition) {
			thisPlayer->setLastWalkthroughPosition(creature->getPosition());
			return false;
		}

		thisPlayer->setLastWalkthroughPosition(creature->getPosition());
		return true;
	} else if (npc) {
		const auto &tile = npc->getTile();
		const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
		return (houseTile != nullptr);
	}

	return false;
}

bool Player::canWalkthroughEx(const std::shared_ptr<Creature> &creature) const {
	if (group->access) {
		return true;
	}

	const auto &monster = creature->getMonster();
	if (monster) {
		if (!monster->isFamiliar()) {
			return false;
		}
		return true;
	}

	const auto &player = creature->getPlayer();
	const auto &npc = creature->getNpc();
	if (player) {
		const auto &playerTile = player->getTile();
		return playerTile && (playerTile->hasFlag(TILESTATE_NOPVPZONE) || playerTile->hasFlag(TILESTATE_PROTECTIONZONE) || player->getLevel() <= static_cast<uint32_t>(g_configManager().getNumber(PROTECTION_LEVEL)) || g_game().getWorldType() == WORLD_TYPE_NO_PVP);
	} else if (npc) {
		const auto &tile = npc->getTile();
		const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(tile);
		return (houseTile != nullptr);
	} else {
		return false;
	}
}

RaceType_t Player::getRace() const {
	return RACE_BLOOD;
}

uint64_t Player::getMoney() const {
	uint64_t moneyCount = 0;

	auto countMoneyInContainer = [&moneyCount](const auto &self, const std::shared_ptr<Container> &container) -> void {
		for (const auto &item : container->getItemList()) {
			if (const auto &tmpContainer = item->getContainer()) {
				self(self, tmpContainer);
			} else {
				moneyCount += item->getWorth();
			}
		}
	};

	for (int32_t i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i) {
		const auto &item = inventory[i];
		if (!item) {
			continue;
		}

		if (const auto &container = item->getContainer()) {
			countMoneyInContainer(countMoneyInContainer, container);
		} else {
			moneyCount += item->getWorth();
		}
	}

	return moneyCount;
}

std::pair<uint64_t, uint64_t> Player::getForgeSliversAndCores() const {
	uint64_t sliverCount = 0;
	uint64_t coreCount = 0;

	// Check items from inventory
	for (const auto &item : getAllInventoryItems()) {
		if (!item) {
			continue;
		}

		sliverCount += item->getForgeSlivers();
		coreCount += item->getForgeCores();
	}

	// Check items from stash
	for (const auto &stashToSend = getStashItems();
	     const auto &[itemId, itemCount] : stashToSend) {
		if (itemId == ITEM_FORGE_SLIVER) {
			sliverCount += itemCount;
		}
		if (itemId == ITEM_FORGE_CORE) {
			coreCount += itemCount;
		}
	}

	return std::make_pair(sliverCount, coreCount);
}

void Player::onReceiveMail() {
	if (isNearDepotBox()) {
		sendTextMessage(MESSAGE_EVENT_ADVANCE, "New mail has arrived.");
...(truncated 264023 characters)...es = newRemoveTimes;
}

uint8_t Player::getRemoveTimes() const {
	return bossRemoveTimes;
}

void Player::sendMonsterPodiumWindow(const std::shared_ptr<Item> &podium, const Position &position, uint16_t itemId, uint8_t stackpos) const {
	if (client) {
		client->sendMonsterPodiumWindow(podium, position, itemId, stackpos);
	}
}

void Player::sendBosstiaryEntryChanged(uint32_t bossid) const {
	if (client) {
		client->sendBosstiaryEntryChanged(bossid);
	}
}

void Player::sendInventoryImbuements(const std::map<Slots_t, std::shared_ptr<Item>> &items) const {
	if (client) {
		client->sendInventoryImbuements(items);
	}
}

/*******************************************************************************
 * Interfaces
 ******************************************************************************/

// Wheel interface
PlayerWheel &Player::wheel() {
	return m_wheelPlayer;
}

const PlayerWheel &Player::wheel() const {
	return m_wheelPlayer;
}

// Achievement interface
PlayerAchievement &Player::achiev() {
	return m_playerAchievement;
}

const PlayerAchievement &Player::achiev() const {
	return m_playerAchievement;
}

// Badge interface
PlayerBadge &Player::badge() {
	return m_playerBadge;
}

const PlayerBadge &Player::badge() const {
	return m_playerBadge;
}

// Title interface
PlayerTitle &Player::title() {
	return m_playerTitle;
}

const PlayerTitle &Player::title() const {
	return m_playerTitle;
}

// Cyclopedia
PlayerCyclopedia &Player::cyclopedia() {
	return m_playerCyclopedia;
}

const PlayerCyclopedia &Player::cyclopedia() const {
	return m_playerCyclopedia;
}

// VIP interface
PlayerVIP &Player::vip() {
	return m_playerVIP;
}

const PlayerVIP &Player::vip() const {
	return m_playerVIP;
}

// Animus Mastery interface
AnimusMastery &Player::animusMastery() {
	return m_animusMastery;
}

const AnimusMastery &Player::animusMastery() const {
	return m_animusMastery;
}

// Attached Effects interface
PlayerAttachedEffects &Player::attachedEffects() {
	return m_playerAttachedEffects;
}

const PlayerAttachedEffects &Player::attachedEffects() const {
	return m_playerAttachedEffects;
}

void Player::sendLootMessage(const std::string &message) const {
	const auto &party = getParty();
	if (!party) {
		sendTextMessage(MESSAGE_LOOT, message);
		return;
	}

	if (const auto &partyLeader = party->getLeader()) {
		partyLeader->sendTextMessage(MESSAGE_LOOT, message);
	}
	for (const auto &partyMember : party->getMembers()) {
		if (partyMember) {
			partyMember->sendTextMessage(MESSAGE_LOOT, message);
		}
	}
}

std::shared_ptr<Container> Player::getLootPouch() {
	// Allow players with CM access or higher have the loot pouch anywhere
	const auto &parentItem = getParent() ? getParent()->getItem() : nullptr;
	if (isPlayerGroup() && parentItem && parentItem->getID() != ITEM_STORE_INBOX) {
		return nullptr;
	}

	const auto &inventoryItems = getInventoryItemsFromId(ITEM_GOLD_POUCH);
	if (inventoryItems.empty()) {
		return nullptr;
	}
	const auto &containerItem = inventoryItems.front();
	if (!containerItem) {
		return nullptr;
	}
	const auto &container = containerItem->getContainer();
	if (!container) {
		return nullptr;
	}

	return container;
}

std::shared_ptr<Container> Player::getStoreInbox() const {
	const auto &thing = getThing(CONST_SLOT_STORE_INBOX);
	if (!thing) {
		return nullptr;
	}

	const auto &storeInbox = thing->getContainer();
	return storeInbox ? storeInbox : nullptr;
}

bool Player::hasPermittedConditionInPZ() const {
	static const std::unordered_set<ConditionType_t> allowedConditions = {
		CONDITION_ENERGY,
		CONDITION_FIRE,
		CONDITION_POISON,
		CONDITION_BLEEDING,
		CONDITION_CURSED,
		CONDITION_DAZZLED
	};

	bool hasPermittedCondition = false;
	for (const auto &condition : allowedConditions) {
		if (!condition) {
			continue;
		}

		if (getCondition(condition)) {
			hasPermittedCondition = true;
			break;
		}
	}

	return hasPermittedCondition;
}

uint16_t Player::getDodgeChance() const {
	uint16_t chance = 0;

	if (const auto &playerArmor = getInventoryItem(CONST_SLOT_ARMOR); playerArmor && playerArmor->getTier() > 0) {
		chance += static_cast<uint16_t>(playerArmor->getDodgeChance() * 100);
		if (const auto &playerBoots = getInventoryItem(CONST_SLOT_FEET); playerBoots && playerBoots->getTier() > 0) {
			double_t amplificationChange = playerBoots->getAmplificationChance() / 100;
			double_t bonus = chance * (1 + amplificationChange);
			chance = static_cast<uint16_t>(bonus);
		}
	}

	chance += m_wheelPlayer.getStat(WheelStat_t::DODGE);

	return chance;
}

uint8_t Player::isRandomMounted() const {
	return randomMount;
}

void Player::setRandomMount(uint8_t isMountRandomized) {
	randomMount = isMountRandomized;
}

void Player::sendFYIBox(const std::string &message) const {
	if (client) {
		client->sendFYIBox(message);
	}
}

void Player::parseBestiarySendRaces() const {
	if (client) {
		client->parseBestiarySendRaces();
	}
}

void Player::sendBestiaryCharms() const {
	if (client) {
		client->sendBestiaryCharms();
	}
}

void Player::addBestiaryKillCount(uint16_t raceid, uint32_t amount) {
	const uint32_t oldCount = getBestiaryKillCount(raceid);
	const uint32_t key = STORAGEVALUE_BESTIARYKILLCOUNT + raceid;
	addStorageValue(key, static_cast<int32_t>(oldCount + amount), true);
}

uint32_t Player::getBestiaryKillCount(uint16_t raceid) const {
	const uint32_t key = STORAGEVALUE_BESTIARYKILLCOUNT + raceid;
	const auto value = getStorageValue(key);
	return value > 0 ? static_cast<uint32_t>(value) : 0;
}

void Player::setGUID(uint32_t newGuid) {
	this->guid = newGuid;
}

uint32_t Player::getGUID() const {
	return guid;
}

bool Player::canSeeInvisibility() const {
	return hasFlag(PlayerFlags_t::CanSenseInvisibility) || group->access;
}

void Player::checkAndShowBlessingMessage() {
	auto adventurerBlessingLevel = g_configManager().getNumber(ADVENTURERSBLESSING_LEVEL);
	auto willNotLoseBless = getLevel() < adventurerBlessingLevel && getVocationId() > VOCATION_NONE;
	std::string bless = getBlessingsName();
	std::ostringstream blessOutput;

	if (willNotLoseBless) {
		auto addedBless = false;
		for (uint8_t i = 2; i <= 6; i++) {
			if (!hasBlessing(i)) {
				addBlessing(i, 1);
				addedBless = true;
			}
		}
		sendBlessStatus();
		if (addedBless) {
			blessOutput << fmt::format("You have received adventurer's blessings for being level lower than {}!\nYou are still blessed with {}", adventurerBlessingLevel, bless);
		}
	} else {
		bless.empty() ? blessOutput << "You lost all your blessings." : blessOutput << "You are still blessed with " << bless;
	}

	if (!blessOutput.str().empty()) {
		sendTextMessage(MESSAGE_EVENT_ADVANCE, blessOutput.str());
	}
}

bool Player::canSpeakWithHireling(uint8_t speechbubble) {
	const auto &playerTile = getTile();
	const auto &house = playerTile ? playerTile->getHouse() : nullptr;
	if (speechbubble == SPEECHBUBBLE_HIRELING && (!house || house->getHouseAccessLevel(static_self_cast<Player>()) == HOUSE_NOT_INVITED)) {
		return false;
	}

	return true;
}

uint16_t Player::getPlayerVocationEnum() const {
	const auto &vocationPtr = getVocation();
	if (!vocation) {
		return 0;
	}

	const int cipTibiaId = vocationPtr->getClientId();
	if (cipTibiaId == 1 || cipTibiaId == 11) {
		return Vocation_t::VOCATION_KNIGHT_CIP; // Knight
	} else if (cipTibiaId == 2 || cipTibiaId == 12) {
		return Vocation_t::VOCATION_PALADIN_CIP; // Paladin
	} else if (cipTibiaId == 3 || cipTibiaId == 13) {
		return Vocation_t::VOCATION_SORCERER_CIP; // Sorcerer
	} else if (cipTibiaId == 4 || cipTibiaId == 14) {
		return Vocation_t::VOCATION_DRUID_CIP; // Druid
	} else if (cipTibiaId == 5 || cipTibiaId == 15) {
		return Vocation_t::VOCATION_MONK_CIP; // Monk
	}

	return Vocation_t::VOCATION_NONE;
}

BidErrorMessage Player::canBidHouse(uint32_t houseId) {
	using enum BidErrorMessage;
	const auto house = g_game().map.houses.getHouseByClientId(houseId);
	if (!house) {
		return Internal;
	}

	if (getPlayerVocationEnum() == Vocation_t::VOCATION_NONE) {
		return Rookgaard;
	}

	if (!isPremium()) {
		return Premium;
	}

	if (getAccount()->getHouseBidId() != 0) {
		return OnlyOneBid;
	}

	if (getBankBalance() < (house->getRent() + house->getHighestBid())) {
		return NotEnoughMoney;
	}

	if (house->isGuildhall()) {
		if (getGuildRank() && getGuildRank()->level != 3) {
			return Guildhall;
		}

		if (getGuild() && getGuild()->getBankBalance() < (house->getRent() + house->getHighestBid())) {
			return NotEnoughGuildMoney;
		}
	}

	return NoError;
}

TransferErrorMessage Player::canTransferHouse(uint32_t houseId, uint32_t newOwnerGUID) {
	using enum TransferErrorMessage;
	const auto house = g_game().map.houses.getHouseByClientId(houseId);
	if (!house) {
		return Internal;
	}

	if (getGUID() != house->getOwner()) {
		return NotHouseOwner;
	}

	if (getGUID() == newOwnerGUID) {
		return AlreadyTheOwner;
	}

	const auto newOwner = g_game().getPlayerByGUID(newOwnerGUID, true);
	if (!newOwner) {
		return CharacterNotExist;
	}

	if (newOwner->getPlayerVocationEnum() == Vocation_t::VOCATION_NONE) {
		return Rookgaard;
	}

	if (!newOwner->isPremium()) {
		return Premium;
	}

	if (newOwner->getAccount()->getHouseBidId() != 0) {
		return OnlyOneBid;
	}

	return Success;
}

AcceptTransferErrorMessage Player::canAcceptTransferHouse(uint32_t houseId) {
	using enum AcceptTransferErrorMessage;
	const auto house = g_game().map.houses.getHouseByClientId(houseId);
	if (!house) {
		return Internal;
	}

	if (getGUID() != house->getBidder()) {
		return NotNewOwner;
	}

	if (!isPremium()) {
		return Premium;
	}

	if (getAccount()->getHouseBidId() != 0) {
		return AlreadyBid;
	}

	if (getPlayerVocationEnum() == Vocation_t::VOCATION_NONE) {
		return Rookgaard;
	}

	if (getBankBalance() < (house->getRent() + house->getInternalBid())) {
		return Frozen;
	}

	if (house->getTransferStatus()) {
		return AlreadyAccepted;
	}

	return Success;
}

/*******************************************************************************
 * Charms
 ******************************************************************************/

 uint32_t Player::getCharmPoints() const {
	return charmPoints;
}

void Player::setCharmPoints(uint32_t points) {
	charmPoints = points;
}

uint32_t Player::getMinorCharmEchoes() const {
	return minorCharmEchoes;
}

void Player::setMinorCharmEchoes(uint32_t points) {
	minorCharmEchoes = points;
}

uint32_t Player::getMaxCharmPoints() const {
	return maxCharmPoints;
}

void Player::setMaxCharmPoints(uint32_t points) {
	maxCharmPoints = points;
}

uint32_t Player::getMaxMinorCharmEchoes() const {
	return maxMinorCharmEchoes;
}

void Player::setMaxMinorCharmEchoes(uint32_t points) {
	maxMinorCharmEchoes = points;
}

bool Player::hasCharmExpansion() const {
	return charmExpansion;
}

void Player::setCharmExpansion(bool onOff) {
	charmExpansion = onOff;
}

void Player::setUsedCharmRunesBit(int32_t bit) {
	usedCharmRunesBit = bit;
}

int32_t Player::getUsedCharmRunesBit() const {
	return usedCharmRunesBit;
}

void Player::setUnlockedCharmRunesBit(int32_t bit) {
	unlockedCharmRunesBit = bit;
}

int32_t Player::getUnlockedCharmRunesBit() const {
	return unlockedCharmRunesBit;
}

uint16_t Player::getRaceIdByCharmsArray(charmRune_t charmId) const {
	if (charmId == CHARM_NONE || charmId > charmsArray.size()) {
		return 0;
	}
	return charmsArray[charmId].raceId;
}

void Player::setRaceIdByCharmsArray(charmRune_t charmId, uint16_t newRaceId) {
	charmsArray[charmId].raceId = newRaceId;
}

uint8_t Player::getTierByCharmsArray(charmRune_t charmId) const {
	if (charmId == CHARM_NONE || charmId > charmsArray.size()) {
		return 0;
	}
	return charmsArray[charmId].tier;
}

void Player::setTierByCharmsArray(charmRune_t charmId, uint8_t newTier) {
	charmsArray[charmId].tier = newTier;
}

std::shared_ptr<Charm> Player::isApplyCharm(charmRune_t charmId, const std::string &monsterName) {
	const uint16_t playerCharmRaceId = getRaceIdByCharmsArray(charmId);
	if (playerCharmRaceId != 0) {
		const auto &mType = g_monsters().getMonsterType(monsterName);
		if (mType && playerCharmRaceId == mType->info.raceid) {
			if (const auto &charm = g_iobestiary().getBestiaryCharm(charmId)) {
				const auto charmTier = getTierByCharmsArray(charmId);
				if (charm->chance[charmTier] >= uniform_random(1, 10000) / 100.0) {
					return charm;
				}
			}
		}
	}

	return nullptr;
}



bool Player::isFirstOnStack() const {
	const auto &playerTile = getTile();
	if (!playerTile) {
		return true;
	}

	const auto &bottomCreature = playerTile->getBottomCreature();
	const auto &bottomPlayer = bottomCreature ? bottomCreature->getPlayer() : nullptr;
	return !bottomPlayer || this == bottomPlayer.get();
}

/*******************************************************************************
 * Monk Update
 ******************************************************************************/

void Player::sendHarmonyProtocol() const {
	if (client) {
		client->sendHarmonyProtocol(m_harmony);
	}
}

uint8_t Player::getHarmony() const {
	return m_harmony;
}

void Player::setHarmony(const uint8_t harmonyValue) {
	const uint8_t minHarmony = (getVirtue() == VIRTUE_HARMONY) ? 1 : 0;
	m_harmony = static_cast<uint8_t>(std::clamp<int>(harmonyValue, minHarmony, 5));
	sendHarmonyProtocol();
}

void Player::addHarmony(const uint8_t harmonyValue) {
	setHarmony(m_harmony + harmonyValue);
}

void Player::removeHarmony(const uint8_t harmonyValue) {
	int newHarmony = static_cast<int>(m_harmony) - static_cast<int>(harmonyValue);
	setHarmony(static_cast<uint8_t>(std::max(newHarmony, 0)));
}

void Player::sendSereneProtocol() const {
	if (client) {
		client->sendSereneProtocol(m_serene);
	}
}

bool Player::isSerene() const {
	return m_serene;
}

void Player::setSerene(const bool isSerene) {
	if (m_serene == isSerene) {
		return;
	}
	m_serene = isSerene;
	sendSereneProtocol();
	
	if (getVirtue() == VIRTUE_JUSTICE) {
		sendSkills();
	}
}

uint64_t Player::getSereneCooldown() {
	const uint64_t timenow = OTSYS_TIME();
	if (m_serene_cooldown > timenow) {
		return m_serene_cooldown - timenow;
	}
	return 0;
}

void Player::setSereneCooldown(const uint64_t addTime) {
	const uint64_t timenow = OTSYS_TIME();
	m_serene_cooldown = timenow + addTime;
}

void Player::sendVirtueProtocol() const {
	if (client && m_virtue != VIRTUE_NONE) {
		client->sendVirtueProtocol(static_cast<uint8_t>(m_virtue));
	}
}

VirtueMonk_t Player::getVirtue() const {
	return m_virtue;
}

void Player::setVirtue(const VirtueMonk_t virtueEnum) {
	switch (virtueEnum) {
		case VIRTUE_HARMONY:
		case VIRTUE_JUSTICE:
		case VIRTUE_SUSTAIN:
			m_virtue = virtueEnum;
			break;
		default:
			m_virtue = VIRTUE_NONE;
			break;
	}
	
	sendVirtueProtocol();
	
	if (m_virtue != VIRTUE_NONE) {
		sendSkills();
	}
}

uint16_t Player::getMantraTotal() const {
	int32_t mantra = 0;
	static constexpr Slots_t mantraSlots[] = { CONST_SLOT_HEAD, CONST_SLOT_NECKLACE, CONST_SLOT_ARMOR, CONST_SLOT_LEGS, CONST_SLOT_RING };
	for (const Slots_t& slot : mantraSlots) {
		const auto& inventoryItem = inventory[slot];
		if (inventoryItem) {
			const ItemType &itemType = Item::items[inventoryItem->getID()];
			if (itemType.mantra > 0) {
				mantra += itemType.mantra;
			}
		}
	}
	return static_cast<uint16_t>(mantra);
}

int16_t Player::getMantraAbsorbPercent(int16_t mantraAbsorbValue) const {
	const float multiplier = 1.0f;

	if (m_party) {
		for (const auto &partyMember : m_party->getMembers()) {
			if (partyMember && partyMember->getMantraTotal() < mantraAbsorbValue) {
				if (partyMember->wheel().getConvictionPerkActived(WheelConvictionPerk_t::GUIDING_PRESENCE) ) {
					mantraAbsorbValue = partyMember->getMantraTotal();
				}
			}
		}

		if (m_party->getLeader() && m_party->getLeader()->getMantraTotal() < mantraAbsorbValue) {
			if (m_party->getLeader()->wheel().getConvictionPerkActived(WheelConvictionPerk_t::GUIDING_PRESENCE) ) {
				mantraAbsorbValue = m_party->getLeader()->getMantraTotal();
			}
		}
	}

	if (mantraAbsorbValue <= 0) {
		return 0;
	}

#ifdef DEBUG_UPDATE15_LOG
	g_logger().warn("[{}] mantraAbsorbValue {}", __FUNCTION__, mantraAbsorbValue);
#endif // DEBUG_UPDATE15_LOG

	return static_cast<int16_t>(std::floor(mantraAbsorbValue * multiplier));
}

/*******************************************************************************
* Summer Update 2025
******************************************************************************/

void Player::onApplyImbuementOnScroll(const Imbuement* imbuement) {
	if (!imbuement) {
		return;
	}

	const uint16_t newScrollId = imbuement->getScrollId();
	if (newScrollId == 0) {
		return;
	}

	if (removeItemOfType(ITEM_BLANK_IMBUEMENT_SCROLL, 1, -1, false)) {
		const auto &newImbuementScrollItem = Item::CreateItem(newScrollId, 1);
		auto returnValue = g_game().internalPlayerAddItem(static_self_cast<Player>(), newImbuementScrollItem, false, CONST_SLOT_WHEREEVER);
		if (returnValue != RETURNVALUE_NOERROR) {
			g_logger().error("[{}] - An error occurred while player with name {} try to apply imbuement, item already contains imbuement", __FUNCTION__, this->getName());
			this->sendImbuementResult("An error ocurred, please reopen imbuement window.");
			return;
		}
	}
}

void Player::onClearAllImbuementsOnEtcher(const std::shared_ptr<Item> &item) {
	if (!item) {
		return;
	}

	if (getItemTypeCount(ITEM_ETCHER) < 1) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have an etcher.");
		return;
	}

	bool removedImbuement = false; 

	for (uint8_t slot = 0; slot < item->getImbuementSlot(); slot++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slot, &imbuementInfo)) {
			continue;
		}

		removedImbuement = true;
	}

	if (removedImbuement) {
		if (removeItemOfType(ITEM_ETCHER, 1, -1, false)) {
			for (uint8_t slot = 0; slot < item->getImbuementSlot(); slot++) {
				ImbuementInfo imbuementInfo;
				if (!item->getImbuementInfo(slot, &imbuementInfo)) {
					continue;
				}

				const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuementInfo.imbuement->getBaseID());
				if (!baseImbuement) {
					return;
				}

				if (item->getParent() == getPlayer()) {
					removeItemImbuementStats(imbuementInfo.imbuement);
				}

				item->clearImbuement(slot, imbuementInfo.imbuement->getID());
			}

			updateImbuementTrackerStats();

			this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You successfully extracted all imbuements from the object.");
		}
	}
}

void Player::applyImbuementScrollToItem(const uint16_t scrollId, const std::shared_ptr<Item> &item) {
	if (!client || !item) {
		return;
	}

	if (item->getImbuementSlot() <= 0) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item is not imbuable.");
		return;
	}

	const auto &itemParent = item->getTopParent();
	if (itemParent && itemParent != getPlayer()) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to pick up the item to imbue it.");
		return;
	}

	const uint8_t itemSlots = item->getImbuementSlot();
	uint8_t slot = itemSlots;

	for (uint8_t slotid = 0; slotid < itemSlots; slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			slot = slotid;
			break;
		}
	}

	if (slot < 0 || slot >= itemSlots) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have apply imbuement in an invalid slot.");
		return;
	}

	uint16_t imbuementId = 0;

	std::vector<Imbuement*> imbuements = g_imbuements().getImbuements(static_self_cast<Player>(), item);
	for (const Imbuement* imbuement : imbuements) {
		const uint16_t newScrollId = imbuement->getScrollId();
		if (newScrollId == scrollId) {
			imbuementId = imbuement->getID();
			break;
		}
	}

	const Imbuement* imbuement = g_imbuements().getImbuement(imbuementId);
	if (!imbuement) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have a valid imbuement.");
		return;
	}

	ImbuementInfo imbuementInfo;
	if (item->getImbuementInfo(slot, &imbuementInfo)) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have try to apply imbuement, item already contains imbuement.");
		return;
	}

	for (uint8_t i = 0; i < itemSlots; i++) {
		if (i == slot) {
			continue;
		}

		ImbuementInfo existingImbuement;
		if (item->getImbuementInfo(i, &existingImbuement) && existingImbuement.imbuement) {
			if (existingImbuement.imbuement->getName() == imbuement->getName()) {
				this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot apply the same imbuement in multiple slots.");
				return;
			}
		}
	}

	if (getItemTypeCount(scrollId) < 1) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have an imbuement scroll.");
		return;
	}

	const BaseImbuement* baseImbuement = g_imbuements().getBaseByID(imbuement->getBaseID());
	if (!baseImbuement) {
		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have a valid tier imbuement.");
		return;
	}

	if (removeItemOfType(scrollId, 1, -1, false)) {
		item->setImbuement(slot, imbuement->getID(), baseImbuement->duration);

		// Update imbuement stats item if the item is equipped
		if (item->getParent() == getPlayer()) {
			ImbuementInfo oldImb;
			if (item->getImbuementInfo(slot, &oldImb) && oldImb.imbuement) {
				removeItemImbuementStats(oldImb.imbuement);
			}

			addItemImbuementStats(imbuement);
			updateImbuementTrackerStats();
		}

		this->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have successfully imbued the object.");
	}
}

EquippedWeaponProficiencyBonuses &Player::getEquippedWeaponProficiency(){
	return equippedWeaponProficiency;
}

void Player::addWeaponProficiencyExperience(const std::shared_ptr<MonsterType> &mType, const ForgeClassifications_t classification, const bool bossSoulpit) {
	uint32_t addProficiencyExperience = 0;
	if (bossSoulpit) {
		addProficiencyExperience = 1500;
	} else {
		if (mType->isBoss()) {
			const BosstiaryRarity_t bosstiaryRace = mType->info.bosstiaryRace;
			switch (bosstiaryRace) {
				case BosstiaryRarity_t::RARITY_BANE: addProficiencyExperience = 500; break;
				case BosstiaryRarity_t::RARITY_ARCHFOE: addProficiencyExperience = 5000; break;
				case BosstiaryRarity_t::RARITY_NEMESIS: addProficiencyExperience = 15000; break;
				default:
					g_logger().error("[{}] Monster {} Invalid bosstiaryRace value: {}.", __FUNCTION__, mType->name, bosstiaryRace);
					addProficiencyExperience = 0;
					break;
			}
		} else {
			const uint8_t bestiaryStars = mType->info.bestiaryStars;
			switch (bestiaryStars) {
				case 0: addProficiencyExperience = 1; break;
				case 1: addProficiencyExperience = 30; break;
				case 2: addProficiencyExperience = 70; break;
				case 3: addProficiencyExperience = 100; break;
				case 4: addProficiencyExperience = 165; break;
				case 5: addProficiencyExperience = 240; break;
				default:
					g_logger().error("[{}] Monster {} Invalid bestiaryStars value: {}.", __FUNCTION__, mType->name, bestiaryStars);
					addProficiencyExperience = 0;
					break;
			}

			if (classification == ForgeClassifications_t::FORGE_INFLUENCED_MONSTER) {
				addProficiencyExperience = static_cast<uint32_t>(addProficiencyExperience * 1.1);
			} else if (classification == ForgeClassifications_t::FORGE_FIENDISH_MONSTER) {
				addProficiencyExperience = static_cast<uint32_t>(addProficiencyExperience * 2.5);
			}
		}
	}

	const auto &weapon = getWeapon(true);
	if (!weapon) {
		return;
	}

	const uint16_t weaponItemId = weapon->getID();

	const ItemType &itemType = Item::items[weaponItemId];
	if (!itemType.proficiencyId) {
		return ;
	}

	const uint8_t addLifeGainOnKill = equippedWeaponProficiency.lifeGainOnKill;
	if (addLifeGainOnKill > 0) {
		CombatDamage proficiencyLifeOnKill;
		proficiencyLifeOnKill.primary.value = addLifeGainOnKill;
		proficiencyLifeOnKill.primary.type = COMBAT_HEALING;
		g_game().combatChangeHealth(nullptr, static_self_cast<Player>(), proficiencyLifeOnKill);
	}

	const uint8_t addManaGainOnKill = equippedWeaponProficiency.manaGainOnKill;
	if (addManaGainOnKill > 0) {
		CombatDamage proficiencyManaOnKill;
		proficiencyManaOnKill.primary.value = addManaGainOnKill;
		proficiencyManaOnKill.origin = ORIGIN_NONE;
		g_game().combatChangeMana(nullptr, static_self_cast<Player>(), proficiencyManaOnKill);
	}

	sendWeaponProficiencyExperience(weaponItemId, addProficiencyExperience);
}

void Player::sendWeaponProficiencyExperience(const uint16_t itemId, const uint32_t addProficiencyExperience) {
	const ItemType &itemType = Item::items[itemId];
	if (!itemType.proficiencyId) {
		return ;
	}

	auto iter = weaponProficiencies.find(itemId);
	if (iter == weaponProficiencies.end()) {
		if (addProficiencyExperience > 0) {
			WeaponProficiencyData data;
			data.experience = addProficiencyExperience;
			iter = weaponProficiencies.emplace(itemId, std::move(data)).first;
		}

		if (client) {
			client->sendWeaponProficiencyExperience(itemId, addProficiencyExperience);
		}
	} else {
		iter->second.experience += addProficiencyExperience;

		if (client) {
			client->sendWeaponProficiencyExperience(itemId, iter->second.experience);
		}
	}
}

void Player::sendWeaponProficiencyInfo(const uint16_t itemId) const {
	if (client) {
		client->sendWeaponProficiencyInfo(itemId);
	}
}

void Player::resetAllWeaponProficiencyPerks(const uint16_t itemId) {
	auto it = weaponProficiencies.find(itemId);
	if (it == weaponProficiencies.end()) {
		return;
	}

	it->second.activePerks.clear();
}

void Player::applyEquippedWeaponProficiency(const uint16_t itemId) {
	auto it = weaponProficiencies.find(itemId);
	if (it == weaponProficiencies.end()) {
		return;
	}

	const WeaponProficiencyData& playerProficiencyData = it->second;

	const WeaponProficiencyStruct* proficiencyData = g_proficiencies().getProficiencyByItemId(itemId);
	if (!proficiencyData) {
		return;
	}

	equippedWeaponProficiency.reset();

	for (const auto &lvl : proficiencyData->proficiencyDataLevel) {
		for (const auto &perk : lvl.proficiencyDataPerks) {
			auto perkActive = std::find_if(
				playerProficiencyData.activePerks.begin(), playerProficiencyData.activePerks.end(),
				[&](const WeaponProficiencyPerk &p) {
					return p.proficiencyLevel == lvl.proficiencyLevel && p.perkPosition == perk.positionSlot;
				}
			);

			if (perkActive == playerProficiencyData.activePerks.end()) {
				continue;
			}

			if (perk.perkValue < 0.0f) {
				continue;
			}

			int32_t damageTypeIndex = 0;
			if (perk.damageType > 0) {
				switch (perk.damageType) {
					case PROFICIENCY_DAMAGETYPE_FIRE: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_FIREDAMAGE);
						break;
					}
					case PROFICIENCY_DAMAGETYPE_EARTH: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_EARTHDAMAGE);
						break;
					}
					case PROFICIENCY_DAMAGETYPE_ENERGY: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_ENERGYDAMAGE);
						break;
					}
					case PROFICIENCY_DAMAGETYPE_ICE: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_ICEDAMAGE);
						break;
					}
					case PROFICIENCY_DAMAGETYPE_HOLY: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_HOLYDAMAGE);
						break;
					}
					case PROFICIENCY_DAMAGETYPE_DEATH: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_DEATHDAMAGE);
						break;
					}
					case PROFICIENCY_DAMAGETYPE_HEALING: {
						damageTypeIndex = static_cast<int32_t>(COMBAT_HEALING);
						break;
					}
				}
			}

			skills_t skillTypeIndex = SKILL_NONE;
			if (perk.skillId > 0) {
				switch (perk.skillId) {
					case PROFICIENCY_SKILL_MAGIC: {
						skillTypeIndex = SKILL_MAGLEVEL;
						break;
					}
					case PROFICIENCY_SKILL_SHIELD: {
						skillTypeIndex = SKILL_SHIELD;
						break;
					}
					case PROFICIENCY_SKILL_DISTANCE: {
						skillTypeIndex = SKILL_DISTANCE;
						break;
					}
					case PROFICIENCY_SKILL_SWORD: {
						skillTypeIndex = SKILL_SWORD;
						break;
					}
					case PROFICIENCY_SKILL_CLUB: {
						skillTypeIndex = SKILL_CLUB;
						break;
					}
					case PROFICIENCY_SKILL_AXE: {
						skillTypeIndex = SKILL_AXE;
						break;
					}
					case PROFICIENCY_SKILL_FIST: {
						skillTypeIndex = SKILL_FIST;
						break;
					}
					case PROFICIENCY_SKILL_FISHING: {
						skillTypeIndex = SKILL_FISHING;
						break;
					}
				}
			}

			switch (perk.perkType) {
				case PROFICIENCY_PERK_ATTACK_DAMAGE: {
					equippedWeaponProficiency.attack += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_DEFENSE: {
					equippedWeaponProficiency.defense += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_WEAPON_SHIELD_MOD: {
					equippedWeaponProficiency.weaponShieldMod += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_SKILLID_BONUS: {
					if (skillTypeIndex != SKILL_NONE) {
						equippedWeaponProficiency.skillBonus[skillTypeIndex] = std::max(0, equippedWeaponProficiency.skillBonus[skillTypeIndex] + static_cast<uint8_t>(perk.perkValue));
					}
					break;
				}
				case PROFICIENCY_PERK_SPECIAL_MAGIC_LEVEL: {
					if (damageTypeIndex > 0) {
						equippedWeaponProficiency.specialMagicLevel[damageTypeIndex] = std::max(0, equippedWeaponProficiency.specialMagicLevel[damageTypeIndex] + static_cast<int32_t>(perk.perkValue));
					}
					break;
				}
				case PROFICIENCY_PERK_AUGMENT_TYPE: {
					if (perk.augmentType != PROFICIENCY_AUGMENTTYPE_NONE && perk.spellId > 0) {
						WeaponProficiencyAugment augment;
						augment.spellId = perk.spellId;
						augment.augmentType = static_cast<WeaponProficiencyPerkAugmentType_t>(perk.augmentType);
						augment.value = perk.perkValue;
						equippedWeaponProficiency.spellAugments.push_back(augment);
					}
					break;
				}
				case PROFICIENCY_PERK_BESTIARY_DAMAGE: {
					if (perk.bestiaryId > 0) {
						equippedWeaponProficiency.bestiaryRacePercentDamageGain += perk.perkValue;
						equippedWeaponProficiency.bestiaryId = perk.bestiaryId;
					}
					break;
				}
				case PROFICIENCY_PERK_DAMAGE_GAIN_BOSS_AND_SINISTER_EMBRACED: {
					equippedWeaponProficiency.damageGainBossAndSinisterEmbraced += perk.perkValue;
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_HIT_CHANCE: {
					equippedWeaponProficiency.critHitChance += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_HIT_CHANCE_FOR_ELEMENT_ID_SPELLS_AND_RUNES: {
					if (damageTypeIndex > 0) {
						equippedWeaponProficiency.critHitChanceForElementIdToSpellsAndRunes[damageTypeIndex] = std::max(0, equippedWeaponProficiency.critHitChanceForElementIdToSpellsAndRunes[damageTypeIndex] + static_cast<uint16_t>(perk.perkValue * 10000.0f));
					}
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_HIT_CHANCE_FOR_OFFENSIVE_RUNES: {
					equippedWeaponProficiency.critHitChanceForOffensiveRunes += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_HIT_CHANCE_FOR_AUTOATTACK: {
					equippedWeaponProficiency.critHitChanceForAutoAttack += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_EXTRA_DAMAGE: {
					equippedWeaponProficiency.critExtraDamage += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_EXTRA_DAMAGE_FOR_ELEMENT_ID_SPELLS_AND_RUNES: {
					if (damageTypeIndex > 0) {
						equippedWeaponProficiency.critExtraDamageForElementIdToSpellsAndRunes[damageTypeIndex] = std::max(0, equippedWeaponProficiency.critExtraDamageForElementIdToSpellsAndRunes[damageTypeIndex] + static_cast<uint16_t>(perk.perkValue * 10000.0f));
					}
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_EXTRA_DAMAGE_FOR_OFFENSIVE_RUNES: {
					equippedWeaponProficiency.critExtraDamageForOffensiveRunes += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_CRITICAL_EXTRA_DAMAGE_FOR_AUTOATTACK: {
					equippedWeaponProficiency.critExtraDamageForAutoAttack += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_MANA_LEECH: {
					equippedWeaponProficiency.manaLeech += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_LIFE_LEECH: {
					equippedWeaponProficiency.lifeLeech += static_cast<uint16_t>(perk.perkValue * 10000.0f);
					break;
				}
				case PROFICIENCY_PERK_MANA_GAIN_ONHIT: {
					equippedWeaponProficiency.manaGainOnHit += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_LIFE_GAIN_ONHIT: {
					equippedWeaponProficiency.lifeGainOnHit += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_MANA_GAIN_ONKILL: {
					equippedWeaponProficiency.manaGainOnKill += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_LIFE_GAIN_ONKILL: {
					equippedWeaponProficiency.lifeGainOnKill += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_GAIN_DAMAGE_AT_RANGE: {
					if (perk.range > 0) {
						uint8_t actualDamageWeaponProficiencyByRange = 0;
						auto it = equippedWeaponProficiency.gainDamageAtRange.find(perk.range);
						if (it != equippedWeaponProficiency.gainDamageAtRange.end()) {
							actualDamageWeaponProficiencyByRange += it->second;
						}

						equippedWeaponProficiency.gainDamageAtRange[perk.range] = actualDamageWeaponProficiencyByRange + static_cast<uint8_t>(perk.perkValue);
					}
					break;
				}
				case PROFICIENCY_PERK_RANGED_HIT_CHANCE: {
					equippedWeaponProficiency.rangedHitChance += perk.perkValue;
					break;
				}
				case PROFICIENCY_PERK_ATTACK_RANGE: {
					equippedWeaponProficiency.attackRange += static_cast<uint8_t>(perk.perkValue);
					break;
				}
				case PROFICIENCY_PERK_SKILLID_PERCENTAGE_AS_EXTRA_DAMAGE_FOR_AUTOATTACK: {
					if (skillTypeIndex != SKILL_NONE) {
						equippedWeaponProficiency.skillPercentageAsExtraDamageForAutoAttack[skillTypeIndex] = std::max(0.0f, equippedWeaponProficiency.skillPercentageAsExtraDamageForAutoAttack[skillTypeIndex] + perk.perkValue);
					}
					break;
				}
				case PROFICIENCY_PERK_SKILLID_PERCENTAGE_AS_EXTRA_DAMAGE_FOR_SPELLS: {
					if (skillTypeIndex != SKILL_NONE) {
						equippedWeaponProficiency.skillPercentageAsExtraDamageForSpells[skillTypeIndex] = std::max(0.0f, equippedWeaponProficiency.skillPercentageAsExtraDamageForSpells[skillTypeIndex] + perk.perkValue);
					}
					break;
				}
				case PROFICIENCY_PERK_SKILLID_PERCENTAGE_AS_EXTRA_HEALING_FOR_SPELLS: {
					if (skillTypeIndex != SKILL_NONE) {
						equippedWeaponProficiency.skillPercentageAsExtraHealingForSpells[skillTypeIndex] = std::max(0.0f, equippedWeaponProficiency.skillPercentageAsExtraHealingForSpells[skillTypeIndex] + perk.perkValue);
					}
					break;
				}
			}
		}
	}

	sendStats();
	sendSkills();

#ifdef DEBUG_SUMMER_UPDATE_2025_LOG
	g_logger().warn("--------------  {} --------------", __FUNCTION__);
	if (equippedWeaponProficiency.attack > 0) { g_logger().warn("[{}] attack +{}", __FUNCTION__, equippedWeaponProficiency.attack); }
	if (equippedWeaponProficiency.defense > 0) { g_logger().warn("[{}] defense +{}", __FUNCTION__, equippedWeaponProficiency.defense); }
	if (equippedWeaponProficiency.weaponShieldMod > 0) { g_logger().warn("[{}] weaponShieldMod +{}", __FUNCTION__, equippedWeaponProficiency.weaponShieldMod); }
	const char* skillNames[] = {
		"Fist",
		"Club",
		"Sword",
		"Axe",
		"Distance",
		"Shield",
		"Fishing",
		"Crit Chance",
		"Crit Damage",
		"Life Leech Chance",
		"Life Leech Amount",
		"Mana Leech Chance",
		"Mana Leech Amount"
	};
	for (const auto &[skill, bonus] : equippedWeaponProficiency.skillBonus) {
		if (bonus > 0) {
			const int8_t skillIndex = static_cast<int8_t>(skill);
			std::string skillName;
			if (skillIndex >= SKILL_FIRST && skillIndex <= SKILL_MANA_LEECH_AMOUNT) {
				skillName = skillNames[skillIndex];
			} else if (skill == SKILL_MAGLEVEL) {
				skillName = "Magic Level";
			} else if (skill == SKILL_LEVEL) {
				skillName = "Level";
			} else {
				skillName = "Unknown";
			}

			g_logger().warn("[{}] skillBonus +{} ({})", __FUNCTION__, bonus, skillName);
		}
	}
	const char* combatTypeNames[COMBAT_COUNT] = {
		"Physical",
		"Energy",
		"Earth",
		"Fire",
		"Undefined",
		"Life Drain",
		"Mana Drain",
		"Healing",
		"Drown",
		"Ice",
		"Holy",
		"Death",
		"Agony",
		"Neutral"
	};
	for (uint8_t i = 0; i < COMBAT_COUNT; ++i) {
		if (equippedWeaponProficiency.specialMagicLevel[i] > 0) {
			g_logger().warn("[{}] {} specialMagicLevel +{}", __FUNCTION__, combatTypeNames[i], equippedWeaponProficiency.specialMagicLevel[i]);
		}
	}
	for (const auto &augment : equippedWeaponProficiency.spellAugments) {
		g_logger().warn("[{}] AUGMENT spellId {} augmentType {} value +{}", __FUNCTION__, augment.spellId, augment.augmentType, (augment.value * 100));
	}
	if (equippedWeaponProficiency.bestiaryRacePercentDamageGain > 0) { g_logger().warn("[{}] bestiaryRacePercentDamageGain +{}% [bestiaryId {}]", __FUNCTION__, (equippedWeaponProficiency.bestiaryRacePercentDamageGain * 100), equippedWeaponProficiency.bestiaryId); }
	if (equippedWeaponProficiency.damageGainBossAndSinisterEmbraced > 0) { g_logger().warn("[{}] damageGainBossAndSinisterEmbraced +{}%", __FUNCTION__, (equippedWeaponProficiency.damageGainBossAndSinisterEmbraced * 100)); }
	if (equippedWeaponProficiency.critHitChance > 0) { g_logger().warn("[{}] critHitChance +{}%", __FUNCTION__, (equippedWeaponProficiency.critHitChance / 100)); }
	for (uint8_t i = 0; i < COMBAT_COUNT; ++i) {
		if (equippedWeaponProficiency.critHitChanceForElementIdToSpellsAndRunes[i] > 0) {
			g_logger().warn("[{}] {} critHitChanceForElementIdToSpellsAndRunes : +{}%", __FUNCTION__, combatTypeNames[i], (equippedWeaponProficiency.critHitChanceForElementIdToSpellsAndRunes[i] / 100));
		}
	}
	if (equippedWeaponProficiency.critHitChanceForOffensiveRunes > 0) { g_logger().warn("[{}] critHitChanceForOffensiveRunes +{}%", __FUNCTION__, (equippedWeaponProficiency.critHitChanceForOffensiveRunes / 100)); }
	if (equippedWeaponProficiency.critHitChanceForAutoAttack > 0) { g_logger().warn("[{}] critHitChanceForAutoAttack +{}%", __FUNCTION__, (equippedWeaponProficiency.critHitChanceForAutoAttack / 100)); }
	if (equippedWeaponProficiency.critExtraDamage > 0) { g_logger().warn("[{}] critExtraDamage +{}%", __FUNCTION__, (equippedWeaponProficiency.critExtraDamage / 100)); }
	for (uint8_t i = 0; i < COMBAT_COUNT; ++i) {
		if (equippedWeaponProficiency.critExtraDamageForElementIdToSpellsAndRunes[i] > 0) {
			g_logger().warn("[{}] {} critExtraDamageForElementIdToSpellsAndRunes : +{}%", __FUNCTION__, combatTypeNames[i], (equippedWeaponProficiency.critExtraDamageForElementIdToSpellsAndRunes[i] / 100));
		}
	}
	if (equippedWeaponProficiency.critExtraDamageForOffensiveRunes > 0) { g_logger().warn("[{}] critExtraDamageForOffensiveRunes +{}%", __FUNCTION__, (equippedWeaponProficiency.critExtraDamageForOffensiveRunes / 100)); }
	if (equippedWeaponProficiency.critExtraDamageForAutoAttack > 0) { g_logger().warn("[{}] critExtraDamageForAutoAttack +{}%", __FUNCTION__, (equippedWeaponProficiency.critExtraDamageForAutoAttack / 100)); }
	if (equippedWeaponProficiency.manaLeech > 0) { g_logger().warn("[{}] manaLeech +{}%", __FUNCTION__, (equippedWeaponProficiency.manaLeech / 100)); }
	if (equippedWeaponProficiency.lifeLeech > 0) { g_logger().warn("[{}] lifeLeech +{}%", __FUNCTION__, (equippedWeaponProficiency.lifeLeech / 100)); }
	if (equippedWeaponProficiency.manaGainOnHit > 0) { g_logger().warn("[{}] manaGainOnHit +{}", __FUNCTION__, equippedWeaponProficiency.manaGainOnHit); }
	if (equippedWeaponProficiency.lifeGainOnHit > 0) { g_logger().warn("[{}] lifeGainOnHit +{}", __FUNCTION__, equippedWeaponProficiency.lifeGainOnHit); }
	if (equippedWeaponProficiency.manaGainOnKill > 0) { g_logger().warn("[{}] manaGainOnKill +{}", __FUNCTION__, equippedWeaponProficiency.manaGainOnKill); }
	if (equippedWeaponProficiency.lifeGainOnKill > 0) { g_logger().warn("[{}] lifeGainOnKill +{}", __FUNCTION__, equippedWeaponProficiency.lifeGainOnKill); }
	for (const auto &[damage, range] : equippedWeaponProficiency.gainDamageAtRange) {
		g_logger().warn("[{}] gainDamageAtRange +{} (range: {})", __FUNCTION__, damage, range);
	}
	if (equippedWeaponProficiency.rangedHitChance > 0) { g_logger().warn("[{}] rangedHitChance +{}%", __FUNCTION__, equippedWeaponProficiency.rangedHitChance); }
	if (equippedWeaponProficiency.attackRange > 0) { g_logger().warn("[{}] attackRange +{}%", __FUNCTION__, equippedWeaponProficiency.attackRange); }
	for (const auto &[skill, bonus] : equippedWeaponProficiency.skillPercentageAsExtraDamageForAutoAttack) {
		const int8_t skillIndex = static_cast<int8_t>(skill);
		std::string skillName;
		if (skillIndex >= SKILL_FIRST && skillIndex <= SKILL_MANA_LEECH_AMOUNT) {
			skillName = skillNames[skillIndex];
		} else if (skill == SKILL_MAGLEVEL) {
			skillName = "Magic Level";
		} else if (skill == SKILL_LEVEL) {
			skillName = "Level";
		} else {
			skillName = "Unknown";
		}

		g_logger().warn("[{}] skillPercentageAsExtraDamageForAutoAttack +{}% ({})", __FUNCTION__, (bonus * 100), skillName);
	}
	for (const auto &[skill, bonus] : equippedWeaponProficiency.skillPercentageAsExtraDamageForSpells) {
		const int8_t skillIndex = static_cast<int8_t>(skill);
		std::string skillName;
		if (skillIndex >= SKILL_FIRST && skillIndex <= SKILL_MANA_LEECH_AMOUNT) {
			skillName = skillNames[skillIndex];
		} else if (skill == SKILL_MAGLEVEL) {
			skillName = "Magic Level";
		} else if (skill == SKILL_LEVEL) {
			skillName = "Level";
		} else {
			skillName = "Unknown";
		}

		g_logger().warn("[{}] skillPercentageAsExtraDamageForSpells +{}% ({})", __FUNCTION__, (bonus * 100), skillName);
	}
	for (const auto &[skill, bonus] : equippedWeaponProficiency.skillPercentageAsExtraHealingForSpells) {
		const int8_t skillIndex = static_cast<int8_t>(skill);
		std::string skillName;
		if (skillIndex >= SKILL_FIRST && skillIndex <= SKILL_MANA_LEECH_AMOUNT) {
			skillName = skillNames[skillIndex];
		} else if (skill == SKILL_MAGLEVEL) {
			skillName = "Magic Level";
		} else if (skill == SKILL_LEVEL) {
			skillName = "Level";
		} else {
			skillName = "Unknown";
		}

		g_logger().warn("[{}] skillPercentageAsExtraHealingForSpells +{}% ({})", __FUNCTION__, (bonus * 100), skillName);
	}
	g_logger().warn("");
#endif // DEBUG_SUMMER_UPDATE_2025_LOG
}

void Player::removeEquippedWeaponProficiency(const uint16_t itemId) {
	auto it = weaponProficiencies.find(itemId);
	if (it == weaponProficiencies.end()) {
		return;
	}

	const WeaponProficiencyData& playerProficiencyData = it->second;

	const WeaponProficiencyStruct* proficiencyData = g_proficiencies().getProficiencyByItemId(itemId);
	if (!proficiencyData) {
		return;
	}

	equippedWeaponProficiency.reset();

	sendStats();
	sendSkills();

#ifdef DEBUG_SUMMER_UPDATE_2025_LOG
	g_logger().warn("--------------  {} --------------", __FUNCTION__);
#endif // DEBUG_SUMMER_UPDATE_2025_LOG
}

/* //////////////////////////////////////////////////////////////////////////////// */

/* //////////////////////////////////////////////////////////////////////////////// */

struct CountMap {
	const int limit;
	const int factor;
	const int offset;

	CountMap(int lim, int fac, int off) :
		limit(lim), factor(fac), offset(off) { }

	template <typename T>
	int calculate(const T killAmount) const {
		if (killAmount <= limit) {
			return (std::max<T>(0, killAmount - offset) * 100) / limit / factor;
		}

		return 100 / factor;
	}
};

void Player::updateSkullTicks(int32_t ticks) {
	if (ticks > 0) {
		skullTicks += ticks;
	}

	int unjusKillsPerDay = g_configManager().getNumber(FRAG_LIMIT);
	int unjusKillsPerWeek = g_configManager().getNumber(FRAG_LIMIT_INTERVAL);
	int unjusKillsPerMonth = g_configManager().getNumber(FRAG_LIMIT_MONTH);
	int64_t timeNow = OTSYS_TIME() / 1000;
	int32_t fragTime = g_configManager().getNumber(FRAG_TIME);
	if (unjusKillsPerDay != 0) {
		int64_t timeDay = timeNow - (24 * 60 * 60);
		int32_t kills = 0;
		for (const auto &kill : unjustifiedKills) {
			if (kill.time >= timeDay && kill.unavenged) {
				++kills;
			}
		}

		if (getSkull() != SKULL_RED && kills >= unjusKillsPerDay) {
			setSkull(SKULL_RED);
		}
	}

	if (unjusKillsPerWeek != 0) {
		int64_t timeWeek = timeNow - (7 * 24 * 60 * 60);
		int32_t kills = 0;
		for (const auto &kill : unjustifiedKills) {
			if (kill.time >= timeWeek && kill.unavenged) {
				++kills;
			}
		}

		if (getSkull() != SKULL_RED && kills >= unjusKillsPerWeek) {
			setSkull(SKULL_RED);
		}
	}

	if (unjusKillsPerMonth != 0) {
		int64_t timeMonth = timeNow - (30 * 24 * 60 * 60);
		int32_t kills = 0;
		for (const auto &kill : unjustifiedKills) {
			if (kill.time >= timeMonth && kill.unavenged) {
				++kills;
			}
		}

		if (getSkull() != SKULL_RED && kills >= unjusKillsPerMonth) {
			setSkull(SKULL_RED);
		}
	}

	int32_t fragDuration = g_configManager().getNumber(RED_SKULL_DURATION);
	if (getSkull() == SKULL_RED && skullTicks < (fragDuration * 24 * 60 * 60)) {
		setSkull(SKULL_RED);
	}

	if (getSkull() == SKULL_BLACK && skullTicks < (fragDuration * 24 * 60 * 60)) {
		setSkull(SKULL_BLACK);
	}

	if (skullTicks < fragTime && !hasCondition(CONDITION_INFIGHT)) {
		skullTicks = 0;
	}
}

int32_t Player::getFrags() const {
	int32_t frags = 0;
	int64_t timeNow = OTSYS_TIME() / 1000;
	int32_t fragTime = g_configManager().getNumber(FRAG_TIME);
	for (const auto &kill : unjustifiedKills) {
		if (kill.time >= (timeNow - fragTime)) {
			++frags;
		}
	}

	return frags;
}

void Player::setSkullTicks(int32_t ticks) {
	skullTicks = ticks;
}

bool Player::hasAttacked(const std::shared_ptr<Player> &attacked) const {
	if (hasFlag(PlayerFlags_t::HasNoAttackRestrictions) || !attacked) {
		return false;
	}

	return attackedSet.contains(attacked->guid);
}

void Player::addAttacked(const std::shared_ptr<Player> &attacked) {
	if (hasFlag(PlayerFlags_t::HasNoAttackRestrictions) || !attacked || attacked->guid == guid) {
		return;
	}

	attackedSet.insert(attacked->guid);
}

void Player::removeAttacked(const std::shared_ptr<Player> &attacked) {
	if (!attacked || attacked->guid == guid) {
		return;
	}

	attackedSet.erase(attacked->guid);
}

void Player::clearAttacked() {
	attackedSet.clear();
}

void Player::addUnjustifiedDead(const std::shared_ptr<Player> &attacked) {
	unjustifiedKills.emplace_back(attacked->guid, OTSYS_TIME(), true);
	sendTextMessage(MESSAGE_EVENT_ADVANCE, fmt::format("Warning! The murder of {} was not justified.", attacked->getName()));
}

void Player::sendCreatureSkull(const std::shared_ptr<Creature> &creature) const {
	if (client) {
		client->sendCreatureSkull(creature);
	}
}

void Player::checkSkullTicks(int32_t ticks) {
	int32_t difference = skullTicks - ticks;
	if (difference > 0) {
		skullTicks -= difference;
	}

	if (skullTicks <= 0) {
		switch (getSkull()) {
			case SKULL_BLACK: {
				setSkull(SKULL_RED);
				sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are no longer black skulled.");
				break;
			}

			case SKULL_RED: {
				setSkull(SKULL_NONE);
				sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are no longer red skulled.");
				break;
			}

			default:
				break;
		}
	}
}

bool Player::canImbueItem(Imbuement* imbuement, uint8_t slot, const Item* item) const {
	if (!item) {
		return false;
	}

	const ItemType &it = Item::items[item->getID()];

	if (it.getImbuingSlots() < (slot + 1)) {
		return false;
	}

	const CategoryImbuement* category = g_imbuements().getCategoryByID(imbuement->getCategory());

	const auto &itSlot = it.slotPosition;

	if (itSlot & SLOTP_ARMOR) {
		if (category->id == 1 || category->id == 2) { // Exemplos; ajuste conforme as categories existentes
			return true;
		}
	} else if (itSlot & SLOTP_LEGS) {
		if (category->id == 3 || category->id == 4) {
			return true;
		}
	} else if (itSlot & SLOTP_FEET) {
		if (category->id == 10 || category->id == 11 || category->id == 19) { // Adicionado 19 para Vibrancy
			return true;
		}
	} else if (itSlot & SLOTP_HEAD) {
		if (category->id == 5 || category->id == 6) {
			return true;
		}
	} else if (itSlot & SLOTP_NECKLACE) {
		if (category->id == 7 || category->id == 8 || category->id == 9) {
			return true;
		}
	} else if (itSlot & SLOTP_RING) {
		if (category->id == 12 || category->id == 13) {
			return true;
		}
	} else if (itSlot & SLOTP_HAND) {
		if (it.weaponType == WEAPON_SHIELD) {
			if (category->id == 14 || category->id == 15) {
				return true;
			}
		} else if (it.weaponType == WEAPON_WAND || it.weaponType == WEAPON_ROD) {
			if (category->id == 16 || category->id == 17) {
				return true;
			}
		} else {
			if (category->id == 18) {
				return true;
			}
		}
	} else {
		return false;
	}

	return false;
}

void Player::addCondition(Condition* condition, bool force /* = false */) override {
	if (condition->getType() == CONDITION_PARALYZE) {
		Item* boots = getInventoryItem(CONST_SLOT_FEET);
		if (boots) {
			const auto& imbuementInfos = boots->getImbuementInfos();
			for (const auto& imbInfo : imbuementInfos) {
				if (imbInfo.id == 0) {
					continue;
				}
				Imbuement* imbuement = Imbuements::getInstance().getImbuement(imbInfo.id);
				if (imbuement) {
					int32_t vibrancyChance = imbuement->absorbPercent[combatTypeToIndex(COMBAT_UNDEFINEDDAMAGE)];
					if (vibrancyChance > 0) { // Detecta vibrancy
						uint32_t ownerId = condition->getOwner();
						bool isPvP = false;
						if (ownerId != 0) {
							Creature* attacker = g_game.getCreatureByID(ownerId);
							if (attacker && attacker->getPlayer()) {
								isPvP = true;
							}
						}

						if (isPvP) {
							// Deflete PvP paralyze
							return; // Não adiciona
						} else {
							// Non-PvP: Adiciona e remove com chance
							Creature::addCondition(condition, force);
							if (uniform_random(1, 100) <= vibrancyChance) {
								removeCondition(CONDITION_PARALYZE);
							}
							return;
						}
					}
				}
			}
		}
	}

	// Padrão para outras condições
	Creature::addCondition(condition, force);
}
