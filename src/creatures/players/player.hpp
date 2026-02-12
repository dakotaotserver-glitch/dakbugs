////////////////////////////////////////////////////////////////////////
// OpenTibia - An opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
////////////////////////////////////////////////////////////////////////

#pragma once

#include "creatures/creature.hpp"
#include "enums/forge_conversion.hpp"
#include "game/bank/bank.hpp"
#include "grouping/guild.hpp"
#include "items/cylinder.hpp"
#include "game/movement/position.hpp"
#include "creatures/creatures_definitions.hpp"
#include "creatures/players/animus_mastery/animus_mastery.hpp"
#include "server/server_definitions.hpp"
#include "creatures/players/proficiencies/proficiencies.hpp"
#include "creatures/players/proficiencies/proficiencies_definitions.hpp"
#include "creatures/players/attached_effects/player_attached_effects.hpp"

class AnimusMastery;
class House;
class NetworkMessage;
class Weapon;
class ProtocolGame;
class Party;
class Task;
class Guild;
class Imbuement;
class PreySlot;
class TaskHuntingSlot;
class Spell;
class PlayerWheel;
class PlayerAchievement;
class PlayerBadge;
class PlayerCyclopedia;
class PlayerTitle;
class PlayerVIP;
class Spectators;
class Account;
class RewardChest;
class Cylinder;
class Town;
class Reward;
class DepotChest;
class DepotLocker;
class Inbox;
class Vocation;
class Container;
class KV;
class BedItem;
class Npc;

struct ModalWindow;
struct Achievement;
struct VIPGroup;
struct Mount;
struct Wing;
struct Effect;
struct Shader;
struct Aura;
struct OutfitEntry;
struct Outfit;
struct FamiliarEntry;
struct Familiar;
struct Group;
struct Outfit_t;
struct TextMessage;
struct HighscoreCharacter;

enum class PlayerIcon : uint8_t;
enum class IconBakragore : uint8_t;
enum class HouseAuctionType : uint8_t;
enum class BidErrorMessage : uint8_t;
enum class TransferErrorMessage : uint8_t;
enum class AcceptTransferErrorMessage : uint8_t;
enum class ForgeClassifications_t : uint8_t;
enum class BosstiaryRarity_t : uint8_t;
enum ObjectCategory_t : uint8_t;
enum PreySlot_t : uint8_t;
enum SpeakClasses : uint8_t;
enum ChannelEvent_t : uint8_t;
enum SquareColor_t : uint8_t;
enum Resource_t : uint8_t;
enum VirtueMonk_t : uint8_t;

using GuildWarVector = std::vector<uint32_t>;
using StashContainerList = std::vector<std::pair<Item*, uint32_t>>;
using ItemVector = std::vector<std::shared_ptr<Item>>;
using UsersMap = std::map<uint32_t, std::shared_ptr<Player>>;
using InvitedMap = std::map<uint32_t, std::shared_ptr<Player>>;
using HouseMap = std::map<uint32_t, std::shared_ptr<House>>;

struct CharmInfo {
	uint16_t raceId = 0;
	uint8_t tier = 0;
};

struct ForgeHistory {
	ForgeAction_t actionType = ForgeAction_t::FUSION;
	uint8_t tier = 0;
	uint8_t bonus = 0;

	time_t createdAt;

	uint16_t historyId = 0;

	uint64_t cost = 0;
	uint64_t dustCost = 0;
	uint64_t coresCost = 0;
	uint64_t gained = 0;

	bool success = false;
	bool tierLoss = false;
	bool successCore = false;
	bool tierCore = false;
	bool convergence = false;

	std::string description;
	std::string firstItemName;
	std::string secondItemName;
};

struct OpenContainer {
	std::shared_ptr<Container> container;
	uint16_t index;
};

struct WeaponProficiencyPerk {
	uint8_t proficiencyLevel = 0;
	uint8_t perkPosition = 0;
};

struct WeaponProficiencyData {
	uint32_t experience = 0;
	std::vector<WeaponProficiencyPerk> activePerks;
};

struct WeaponProficiencyAugment {
	uint16_t spellId = 0;
	WeaponProficiencyPerkAugmentType_t augmentType = PROFICIENCY_AUGMENTTYPE_NONE;
	float value = 0;
};

struct EquippedWeaponProficiencyBonuses {
	uint8_t attack = 0;
	uint8_t defense = 0;
	uint8_t weaponShieldMod = 0;
	std::map<skills_t, uint8_t> skillBonus;
	int32_t specialMagicLevel[COMBAT_COUNT] = { 0 };
	std::vector<WeaponProficiencyAugment> spellAugments;
	float bestiaryRacePercentDamageGain = 0;
	float damageGainBossAndSinisterEmbraced = 0;
	uint16_t critHitChance = 0;
	int32_t critHitChanceForElementIdToSpellsAndRunes[COMBAT_COUNT] = { 0 };
	uint16_t critHitChanceForOffensiveRunes = 0;
	uint16_t critHitChanceForAutoAttack = 0;
	uint16_t critExtraDamage = 0;
	int32_t critExtraDamageForElementIdToSpellsAndRunes[COMBAT_COUNT] = { 0 };
	uint16_t critExtraDamageForOffensiveRunes = 0;
	uint16_t critExtraDamageForAutoAttack = 0;
	uint16_t manaLeech = 0;
	uint16_t lifeLeech = 0;
	uint8_t manaGainOnHit = 0;
	uint8_t lifeGainOnHit = 0;
	uint8_t manaGainOnKill = 0;
	uint8_t lifeGainOnKill = 0;
	std::map<uint8_t, float> gainDamageAtRange;
	float rangedHitChance = 0;
	uint8_t attackRange = 0;
	std::map<CombatType_t, float> skillPercentageAsExtraDamageForAutoAttack;
	std::map<CombatType_t, float> skillPercentageAsExtraDamageForSpells;
	std::map<CombatType_t, float> skillPercentageAsExtraHealingForSpells;

	uint8_t bestiaryId = 0;

	void reset() {
		attack = 0;
		defense = 0;
		weaponShieldMod = 0;
		skillBonus.clear();
		std::fill(std::begin(specialMagicLevel), std::end(specialMagicLevel), 0);
		spellAugments.clear();
		bestiaryRacePercentDamageGain = 0;
		damageGainBossAndSinisterEmbraced = 0;
		critHitChance = 0;
		std::fill(std::begin(critHitChanceForElementIdToSpellsAndRunes), std::end(critHitChanceForElementIdToSpellsAndRunes), 0);
		critHitChanceForOffensiveRunes = 0;
		critHitChanceForAutoAttack = 0;
		critExtraDamage = 0;
		std::fill(std::begin(critExtraDamageForElementIdToSpellsAndRunes), std::end(critExtraDamageForElementIdToSpellsAndRunes), 0);
		critExtraDamageForOffensiveRunes = 0;
		critExtraDamageForAutoAttack = 0;
		manaLeech = 0;
		lifeLeech = 0;
		manaGainOnHit = 0;
		lifeGainOnHit = 0;
		manaGainOnKill = 0;
		lifeGainOnKill = 0;
		gainDamageAtRange.clear();
		rangedHitChance = 0;
		attackRange = 0;
		skillPercentageAsExtraDamageForAutoAttack.clear();
		skillPercentageAsExtraDamageForSpells.clear();
		skillPercentageAsExtraHealingForSpells.clear();

		bestiaryId = 0;
	}
};

using MuteCountMap = std::map<uint32_t, uint16_t>;

static constexpr uint16_t PLAYER_MAX_SPEED = std::numeric_limits<uint16_t>::max();
static constexpr uint16_t PLAYER_MIN_SPEED = 10;
static constexpr uint8_t PLAYER_SOUND_HEALTH_CHANGE = 10;
static constexpr int32_t NOTIFY_DEPOT_BOX_RANGE = 1;

class Player final : public Creature, public Cylinder, public Bankable {
public:
	class PlayerLock {
	public:
		explicit PlayerLock(const std::shared_ptr<Player> &p) :
			player(p) {
			player->mutex.lock();
		}

		PlayerLock(const PlayerLock &) = delete;

		~PlayerLock() {
			player->mutex.unlock();
		}

	private:
		const std::shared_ptr<Player> &player;
	};

	explicit Player(std::shared_ptr<ProtocolGame> p);
	~Player() override;

	// non-copyable
	Player(const Player &) = delete;
	Player &operator=(const Player &) = delete;

	std::shared_ptr<Player> getPlayer() override {
		return static_self_cast<Player>();
	}
	std::shared_ptr<Player> getPlayer() const override {
		return static_self_cast<Player>();
	}

	static std::shared_ptr<Task> createPlayerTask(uint32_t delay, std::function<void(void)> f, const std::string &context);

	void setID() override;

	void setOnline(bool value) override {
		online = value;
	}
	bool isOnline() const override {
		return online;
	}

	static uint32_t getFirstID();
	static uint32_t getLastID();

	static MuteCountMap muteCountMap;

	const std::string &getName() const override {
		return name;
	}
	void setName(const std::string &name) {
		this->name = name;
	}
	const std::string &getTypeName() const override {
		return name;
	}
	const std::string &getNameDescription() const override {
		return name;
	}
	std::string getDescription(int32_t lookDistance) override;

	CreatureType_t getType() const override {
		return CREATURETYPE_PLAYER;
	}

	uint16_t getCurrentMount() const;
	void setCurrentMount(uint16_t mountId);
	bool isMounted() const {
		return defaultOutfit.lookMount != 0;
	}
	bool toggleMount(bool mount);
	bool tameMount(uint16_t mountId);
	bool untameMount(uint16_t mountId);
	bool hasMount(const std::shared_ptr<Mount> &mount) const;
	bool hasAnyMount() const;
	uint16_t getRandomMountId() const;
	void dismount();

	void setOutfitsModified(bool modified);
	void setMountsModified(bool modified);
	bool isOutfitsModified() const;
	bool isMountsModified() const;

	uint16_t getDodgeChance() const;

	bool isRandomMounted() const;
	void setRandomMount(bool randomizeMount);

	void sendFYIBox(const std::string &message) const;

	void parseBestiarySendRaces() const;
	void sendBestiaryCharms() const;
	void addBestiaryKillCount(uint16_t raceid, uint32_t amount);
	uint32_t getBestiaryKillCount(uint16_t raceid) const;

	void setGUID(uint32_t newGuid);
	uint32_t getGUID() const;
	bool canSeeInvisibility() const override;

	void setDailyReward(uint8_t reward);

	void removeList() override;
	void addList() override;
	void removePlayer(bool displayEffect, bool forced = true);

	static uint64_t getExpForLevel(const uint32_t level);

	uint16_t getStaminaMinutes() const;

	void sendItemsPrice() const;

	void sendForgingData() const;

	bool addOfflineTrainingTries(skills_t skill, uint64_t tries);

	void addOfflineTrainingTime(int32_t addTime);
	void removeOfflineTrainingTime(int32_t removeTime);
	int32_t getOfflineTrainingTime() const;

	int8_t getOfflineTrainingSkill() const;
	void setOfflineTrainingSkill(int8_t skill);

	uint64_t getBankBalance() const override;
	void setBankBalance(uint64_t balance) override;

	[[nodiscard]] std::shared_ptr<Guild> getGuild() const;
	void setGuild(const std::shared_ptr<Guild> &guild);

	[[nodiscard]] GuildRank_ptr getGuildRank() const;
	void setGuildRank(GuildRank_ptr newGuildRank);

	bool isGuildMate(const std::shared_ptr<Player> &player) const;

	[[nodiscard]] const std::string &getGuildNick() const;
	void setGuildNick(std::string nick);

	bool isInWar(const std::shared_ptr<Player> &player) const;
	bool isInWarList(uint32_t guild_id) const;

	void setLastWalkthroughAttempt(int64_t walkthroughAttempt);
	void setLastWalkthroughPosition(Position walkthroughPosition);

	std::shared_ptr<Inbox> getInbox() const;

	std::unordered_set<uint16_t> getClientIcons();

	const GuildWarVector &getGuildWarVector() const {
		return guildWarVector;
	}

	// Reload active wars from database into guildWarVector
	void reloadGuildWarList();

	const std::unordered_set<std::shared_ptr<MonsterType>> &getCyclopediaMonsterTrackerSet(bool isBoss) const;

	void addMonsterToCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient = false);

	void removeMonsterFromCyclopediaTrackerList(const std::shared_ptr<MonsterType> &mtype, bool isBoss, bool reloadClient = false);

	void sendBestiaryEntryChanged(uint16_t raceid) const;

	void refreshCyclopediaMonsterTracker(bool isBoss = false) const {
		refreshCyclopediaMonsterTracker(getCyclopediaMonsterTrackerSet(isBoss), isBoss);
	}

	void refreshCyclopediaMonsterTracker(const std::unordered_set<std::shared_ptr<MonsterType>> &trackerList, bool isBoss) const;

	bool isBossOnBosstiaryTracker(const std::shared_ptr<MonsterType> &monsterType) const;

	std::shared_ptr<Vocation> getVocation() const;

	OperatingSystem_t getOperatingSystem() const;
	void setOperatingSystem(OperatingSystem_t clientos);

	bool isOldProtocol() const;

	uint32_t getProtocolVersion() const;

	bool hasSecureMode() const;

	uint8_t getOpenedContainersLimit() const;

	void setParty(std::shared_ptr<Party> newParty);
	std::shared_ptr<Party> getParty() const;

	int32_t getCleavePercent(bool useCharges = false) const;

	void setCleavePercent(int32_t value);

	int32_t getPerfectShotDamage(uint8_t range, bool useCharges = false) const;

	void setPerfectShotDamage(uint8_t range, int32_t damage);

	int32_t getSpecializedMagicLevel(CombatType_t combat, bool useCharges = false) const;

	void setSpecializedMagicLevel(CombatType_t combat, int32_t value);

	int32_t getMagicShieldCapacityFlat(bool useCharges = false) const;

	void setMagicShieldCapacityFlat(int32_t value);

	int32_t getMagicShieldCapacityPercent(bool useCharges = false) const;

	void setMagicShieldCapacityPercent(int32_t value);

	double_t getReflectPercent(CombatType_t combat, bool useCharges = false) const override;

	int32_t getReflectFlat(CombatType_t combat, bool useCharges = false) const override;

	PartyShields_t getPartyShield(const std::shared_ptr<Player> &player);
	bool isInviting(const std::shared_ptr<Player> &player) const;
	bool isPartner(const std::shared_ptr<Player> &player) const;
	void sendPlayerPartyIcons(const std::shared_ptr<Player> &player);
	bool addPartyInvitation(const std::shared_ptr<Party> &party);
	void removePartyInvitation(const std::shared_ptr<Party> &party);
	void clearPartyInvitations();

	GuildEmblems_t getGuildEmblem(const std::shared_ptr<Player> &player) const;
	uint8_t getPartySpellbookFilter() const;

	// Hazard system
	bool getHazard() const {
		return hazard;
	}
	void setHazardSystemPoints(int32_t count);
	int32_t getHazardSystemPoints() const {
		return hazardPoints;
	}

	void sendHazardSystemMessage(const std::string &msg) const;
	void setHazardSystemCriticalChance(uint8_t chance) {
		hazardCriticalChance = chance;
	}
	uint8_t getHazardSystemCriticalChance() const {
		return hazardCriticalChance;
	}
	// Hazard system
	void addCondition(Condition* condition, bool force = false) override;

};
