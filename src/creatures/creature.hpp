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

#include "creatures/creatures_definitions.hpp"
#include "game/game_definitions.hpp"
#include "game/movement/position.hpp"
#include "items/thing.hpp"
#include "map/map_const.hpp"
#include "utils/utils_definitions.hpp"

class CreatureEvent;
class Condition;
class Map;
class Container;
class Player;
class Monster;
class Npc;
class Item;
class Tile;
class Zone;
class MonsterType;
class Cylinder;
class ItemType;

struct CreatureIcon;
struct Position;

enum CreatureType_t : uint8_t;
enum ZoneType_t : uint8_t;
enum CreatureEventType_t : uint8_t;

using ConditionList = std::list<std::shared_ptr<Condition>>;
using CreatureEventList = std::list<std::shared_ptr<CreatureEvent>>;

static constexpr uint8_t WALK_TARGET_NEARBY_EXTRA_COST = 2;
static constexpr uint8_t WALK_FLOOR_CHANGE_EXTRA_COST = 2;
static constexpr uint8_t WALK_DIAGONAL_EXTRA_COST = 3;
static constexpr int32_t EVENT_CREATURECOUNT = 10;
static constexpr int32_t EVENT_CREATURE_THINK_INTERVAL = 1000;
static constexpr int32_t EVENT_CHECK_CREATURE_INTERVAL = (EVENT_CREATURE_THINK_INTERVAL / EVENT_CREATURECOUNT);

class FrozenPathingConditionCall {
public:
	explicit FrozenPathingConditionCall(Position newTargetPos) :
		targetPos(newTargetPos) { }

	bool operator()(const Position &startPos, const Position &testPos, const FindPathParams &fpp, int32_t &bestMatchDist) const;

	bool isInRange(const Position &startPos, const Position &testPos, const FindPathParams &fpp) const;

	Position getTargetPos() const {
		return targetPos;
	}

private:
	Position targetPos;
};

//////////////////////////////////////////////////////////////////////
// Defines the Base class for all creatures and base functions which
// every creature has

class Creature : virtual public Thing, public SharedObject {
protected:
	Creature();

public:
	static constexpr double speedA = 857.36;
	static constexpr double speedB = 261.29;
	static constexpr double speedC = -4795.01;

	virtual ~Creature();

	// non-copyable
	Creature(const Creature &) = delete;
	Creature &operator=(const Creature &) = delete;

	std::shared_ptr<Creature> getCreature() final {
		return static_self_cast<Creature>();
	}
	std::shared_ptr<Creature> getCreature() const final {
		return static_self_cast<Creature>();
	}
	std::shared_ptr<Player> getPlayer() override {
		return nullptr;
	}
	virtual std::shared_ptr<Player> getPlayer() const {
		return nullptr;
	}
	virtual std::shared_ptr<Npc> getNpc() {
		return nullptr;
	}
	virtual std::shared_ptr<Npc> getNpc() const {
		return nullptr;
	}
	virtual std::shared_ptr<Monster> getMonster() {
		return nullptr;
	}
	virtual std::shared_ptr<Monster> getMonster() const {
		return nullptr;
	}

	virtual const std::string &getName() const = 0;
	// Real creature name, set on creature creation "createNpcType(typeName) and createMonsterType(typeName)"
	virtual const std::string &getTypeName() const = 0;
	virtual const std::string &getNameDescription() const = 0;

	virtual CreatureType_t getType() const = 0;

	bool isPlayer() const {
		return getType() == CreatureType_t::CREATURETYPE_PLAYER;
	}

	bool isMonster() const {
		return getType() == CreatureType_t::CREATURETYPE_MONSTER;
	}

	virtual void setID() = 0;
	void setRemoved() {
		isInternalRemoved = true;
	}

	uint32_t getID() const {
		return id;
	}
	virtual void removeList() = 0;
	virtual void addList() = 0;

	virtual bool canSee(const Position &pos);
	virtual bool canSeeCreature(const std::shared_ptr<Creature> &creature) const;

	virtual RaceType_t getRace() const {
		return RACE_NONE;
	}
	virtual Skulls_t getSkull() const {
		return skull;
	}
	virtual Skulls_t getSkullClient(const std::shared_ptr<Creature> &creature) {
		return creature->getSkull();
	}
	void setSkull(Skulls_t newSkull);
	Direction getDirection() const {
		return direction;
	}
	void setDirection(Direction dir) {
		direction = dir;
	}

	bool isHealthHidden() const {
		return hiddenHealth;
	}
	void setHiddenHealth(bool b) {
		hiddenHealth = b;
	}

	bool isMoveLocked() const {
		return moveLocked;
	}
	void setMoveLocked(bool locked) {
		moveLocked = locked;
	}

	bool isDirectionLocked() const {
		return directionLocked;
	}

	void setDirectionLocked(bool locked) {
		directionLocked = locked;
	}

	int32_t getThrowRange() const final {
		return 1;
	}
	bool isPushable() override {
		return getWalkDelay() <= 0;
	}
	bool isRemoved() final {
		return isInternalRemoved;
	}
	virtual bool canSeeInvisibility() const {
		return false;
	}
	virtual bool isInGhostMode() const {
		return false;
	}

	int32_t getWalkSize();

	int32_t getWalkDelay(Direction dir = DIRECTION_NONE);
	int64_t getTimeSinceLastMove() const;

	int64_t getEventStepTicks(bool onlyDelay = false);
	uint16_t getStepDuration(Direction dir = DIRECTION_NONE);
	virtual uint16_t getStepSpeed() const {
		return getSpeed();
	}
	uint16_t getSpeed() const;
	void setSpeed(int32_t varSpeedDelta);

	void setBaseSpeed(uint16_t newBaseSpeed) {
		baseSpeed = newBaseSpeed;
	}
	uint16_t getBaseSpeed() const {
		return baseSpeed;
	}

	int32_t getHealth() const {
		return health;
	}

	bool isAlive() const {
		return !checkLessHealth();
	}

	bool checkLessHealth() const {
		return health <= 0;
	}

	virtual int32_t getMaxHealth() const {
		return healthMax;
	}
	uint32_t getMana() const {
		return mana;
	}
	virtual uint32_t getMaxMana() const {
		return mana;
	}

	uint32_t getManaShield() const {
		return manaShield;
	}

	void setManaShield(uint32_t value) {
		manaShield = value;
	}

	uint32_t getMaxManaShield() const {
		return maxManaShield;
	}

	void setMaxManaShield(uint32_t value) {
		maxManaShield = value;
	}

	int32_t getBuff(int32_t buff) {
		return varBuffs[buff];
	}

	int32_t getBuff(int32_t buff) const {
		return varBuffs[buff];
	}

	void setBuff(buffs_t buff, int32_t modifier) {
		varBuffs[buff] += modifier;
	}

	virtual std::vector<CreatureIcon> getIcons() const {
		std::vector<CreatureIcon> icons;
		icons.reserve(creatureIcons.size());
		for (const auto &[_, icon] : creatureIcons) {
			if (icon.isSet()) {
				icons.push_back(icon);
			}
		}
		return icons;
	}

	virtual CreatureIcon getIcon(const std::string &key) const {
		if (!creatureIcons.contains(key)) {
			return CreatureIcon();
		}
		return creatureIcons.at(key);
	}

	bool hasIcon(const std::string &key) const {
		return creatureIcons.contains(key);
	}

	void setIcon(const std::string &key, CreatureIcon icon) {
		creatureIcons[key] = icon;
		iconChanged();
	}

	void removeIcon(const std::string &key) {
		creatureIcons.erase(key);
		iconChanged();
	}

	void clearIcons() {
		creatureIcons.clear();
		iconChanged();
	}

	void iconChanged();

	const Outfit_t getCurrentOutfit() const {
		return currentOutfit;
	}
	void setCurrentOutfit(Outfit_t outfit) {
		currentOutfit = outfit;
	}
	const Outfit_t getDefaultOutfit() const {
		return defaultOutfit;
	}
	void setDefaultOutfit(Outfit_t outfit) {
		defaultOutfit = outfit;
	}
	bool isWearingSupportOutfit() const {
		auto outfit = currentOutfit.lookType;
		return outfit == 75 || outfit == 266 || outfit == 302;
	}
	bool isInvisible() const;
	ZoneType_t getZoneType();

	std::unordered_set<std::shared_ptr<Zone>> getZones();

	// walk functions
	void startAutoWalk(const std::vector<Direction> &listDir, bool ignoreConditions = false);
	void addEventWalk(bool firstStep = false);
	void stopEventWalk();
	void resetMovementState();

	void goToFollowCreature_async(std::function<void()> &&onComplete = nullptr);
	virtual void goToFollowCreature();

	// walk events
	virtual void onWalk(Direction &dir);
	virtual void onWalkAborted() { }
	virtual void onWalkComplete() { }

	// follow functions
	std::shared_ptr<Creature> getFollowCreature() const {
		return m_followCreature.lock();
	}
	virtual bool setFollowCreature(const std::shared_ptr<Creature> &creature);

	// follow events
	virtual void onFollowCreature(const std::shared_ptr<Creature> &) {
		/* empty */
	}
	virtual void onFollowCreatureComplete(const std::shared_ptr<Creature> &) {
		/* empty */
	}

	// combat functions
	std::shared_ptr<Creature> getAttackedCreature() const {
		return m_attackedCreature.lock();
	}
	virtual bool setAttackedCreature(const std::shared_ptr<Creature> &creature);

	/**
	 * @brief Mitigates damage inflicted on a creature.
	 * Used to mitigate the damage inflicted on a creature during combat.
	 * @note If the server is running in dev mode, this function will also log details about the mitigation process.
	 * @param creature Reference to the creature that is receiving the damage.
	 * @param combatType Type of combat that is inflicting the damage. Note that mana drain and life drain are not mitigated.
	 * @param blockType Reference to the block type, which may be modified to BLOCK_ARMOR if the damage is reduced to 0.
	 * @param damage Reference to the amount of damage inflicted, which will be reduced by the creature's mitigation factor.
	 */
	void mitigateDamage(const CombatType_t &combatType, BlockType_t &blockType, int32_t &damage) const;
	virtual BlockType_t blockHit(const std::shared_ptr<Creature> &attacker, const CombatType_t &combatType, int32_t &damage, bool checkDefense = false, bool checkArmor = false, bool field = false);

	void applyAbsorbDamageModifications(const std::shared_ptr<Creature> &attacker, int32_t &damage, CombatType_t combatType) const;

	bool setMaster(const std::shared_ptr<Creature> &newMaster, bool reloadCreature = false);

	void removeMaster() {
		if (getMaster()) {
			m_master.reset();
		}
	}

	bool isSummon() const {
		return !m_master.expired();
	}

	/**
	 * hasBeenSummoned doesn't guarantee master still exists
	 */
	bool hasBeenSummoned() const {
		return summoned;
	}
	std::shared_ptr<Creature> getMaster() const {
		return m_master.lock();
	}

	const auto &getSummons() const {
		return m_summons;
	}

	virtual int32_t getArmor() const {
		return 0;
	}
	virtual float getMitigation() const {
		return 0;
	}
	virtual int32_t getDefense(bool = false) const {
		return 0;
	}
	virtual float getAttackFactor() const {
		return 1.0f;
	}
	virtual float getDefenseFactor(bool = false) const {
		return 1.0f;
	}

	virtual uint8_t getSpeechBubble() const {
		return SPEECHBUBBLE_NONE;
	}

	virtual bool addCondition(const std::shared_ptr<Condition> &condition, bool force = false);
	bool addCombatCondition(const std::shared_ptr<Condition> &condition, bool force = false);
	void removeCondition(ConditionType_t conditionType, ConditionId_t conditionId, bool force = false);
	void removeCondition(ConditionType_t type);
	void removeCondition(const std::shared_ptr<Condition> &condition);
	void removeCombatCondition(ConditionType_t type);
	std::shared_ptr<Condition> getCondition(ConditionType_t type) const;
	std::shared_ptr<Condition> getCondition(ConditionType_t type, ConditionId_t conditionId, uint32_t subId = 0) const;
	std::vector<std::shared_ptr<Condition>> getCleansableConditions() const;
	std::vector<std::shared_ptr<Condition>> getConditionsByType(ConditionType_t type) const;
	void executeConditions(uint32_t interval);
	bool hasCondition(ConditionType_t type, uint32_t subId = 0) const;

	virtual bool isImmune([[maybe_unused]] CombatType_t type) const {
		return false;
	}
	virtual bool isImmune([[maybe_unused]] ConditionType_t type) const {
		return false;
	}
	virtual bool isSuppress([[maybe_unused]] ConditionType_t type, [[maybe_unused]] bool attackerPlayer) const {
		return false;
	}

	virtual bool isAttackable() const {
		return true;
	}
	virtual Faction_t getFaction() const {
		return FACTION_DEFAULT;
	}

	virtual void changeHealth(int32_t healthChange, bool sendHealthChange = true);
	virtual void changeMana(int32_t manaChange);

	void gainHealth(const std::shared_ptr<Creature> &attacker, int32_t healthGain);
	virtual void drainHealth(const std::shared_ptr<Creature> &attacker, int32_t damage);
	virtual void drainMana(const std::shared_ptr<Creature> &attacker, int32_t manaLoss);

	virtual bool challengeCreature(const std::shared_ptr<Creature> &, [[maybe_unused]] int targetChangeCooldown) {
		return false;
	}

	void onDeath();
	virtual uint64_t getGainedExperience(const std::shared_ptr<Creature> &attacker) const;
	void addDamagePoints(const std::shared_ptr<Creature> &attacker, int32_t damagePoints);
	bool hasBeenAttacked(uint32_t attackerId) const;

	// combat event functions
	virtual void onAddCondition(ConditionType_t type);
	virtual void onAddCombatCondition(ConditionType_t type);
	virtual void onEndCondition(ConditionType_t type);
	void onTickCondition(ConditionType_t type, bool &bRemove);
	virtual void onCombatRemoveCondition(const std::shared_ptr<Condition> &condition);
	virtual void onAttackedCreature(const std::shared_ptr<Creature> &)
	/* empty */
	;
	virtual void onAttacked();
	virtual void onAttackedCreatureDrainHealth(const std::shared_ptr<Creature> &target, int32_t points);
	virtual void onTargetCreatureGainHealth(const std::shared_ptr<Creature> &, int32_t) { }
	virtual bool onKilledCreature(const std::shared_ptr<Creature> &target, bool lastHit = true);
	virtual void onGainExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target);
	virtual void onGainSharedExperience(uint64_t gainExp, const std::shared_ptr<Creature> &target);
	virtual void onAttackedCreatureBlockHit(BlockType_t blockType);
	virtual void onBlockHit();
	virtual void onChangeZone(ZoneType_t zone);
	virtual void onAttackedCreatureChangeZone(ZoneType_t zone);
	virtual void onIdleStatus();

	virtual void getCreatureLight(LightInfo &light) const;
	void setNormalCreatureLight();
	virtual void setCreatureLight(LightInfo lightInfo);
	virtual LightInfo getCreatureLight() const;

	virtual void onThink(uint32_t interval);
	virtual void onAttacking(uint32_t interval);
	virtual void onWalking() { }
	virtual void onCreatureAppear(const std::shared_ptr<Creature> &creature, bool isLogin);
	virtual void onRemoveCreature(const std::shared_ptr<Creature> &creature, bool isLogout);
	virtual void onCreatureDisappear(const std::shared_ptr<Creature> &creature, bool isLogout);
	virtual void onCreatureSay(const std::shared_ptr<Creature> &creature, SpeakClasses type, const std::string &text);

	virtual void onPlacedCreature();
	virtual void onRemovedCreature();

	virtual bool getCombatValues(int32_t &min, int32_t &max) {
		min = 0;
		max = 0;
		return false;
	}

	size_t getMessageBuffer() const {
		return messageBuffer;
	}
	void decreaseMessageBuffer() {
		messageBuffer--;
	}

	virtual void setParent(const std::shared_ptr<Cylinder> &cylinder) override {
		tile = static_self_cast<Tile>(cylinder);
		Creature::setParent(cylinder);
	}

	std::shared_ptr<Tile> getTile();
	const std::shared_ptr<Tile> getTile() const;
	bool isRemoved() const;

	Position getPosition() const final;

	template <typename Callable, typename... Args>
	void callCreatureSayEvent(CreatureEventType_t type, Callable &&cb, Args &&...args) {
		for (const auto &creatureEvent : eventsList) {
			if (creatureEvent->getEventType() == type) {
				creatureEvent->executeEvent(static_self_cast<Creature>(), std::forward<Args>(args)...);
			}
		}
	}

	size_t getSummonsSize() const {
		return m_summons.size();
	}
	void setDropLoot(bool _lootDrop) {
		lootDrop = _lootDrop;
	}
	void setLootContainers(bool _lootContainers) {
		lootContainers = _lootContainers;
	}
	void setSkillLoss(bool _skillLoss) {
		skillLoss = _skillLoss;
	}
	void setGuildWar(bool _guildWar) {
		guildWar = _guildWar;
	}

	// creature script events
	bool registerCreatureEvent(uint32_t eventId);
	bool unregisterCreatureEvent(uint32_t eventId);

	void registerCreatureEvent(CreatureEventType_t type);
	bool unregisterCreatureEvent(CreatureEventType_t type);

	CreatureEventList getCreatureEvents(CreatureEventType_t type);

	void setSkull(Skulls_t newSkull) {
		skull = newSkull;
	}
	Skulls_t getSkull() const {
		return skull;
	}

	void setShield(PartyShields_t newPartyShield) {
		partyShield = newPartyShield;
	}
	PartyShields_t getPartyShield() const {
		return partyShield;
	}

	void setEmblem(GuildEmblems_t newGuildEmblem) {
		guildEmblem = newGuildEmblem;
	}
	GuildEmblems_t getGuildEmblem() const {
		return guildEmblem;
	}

	bool hasAttacked(const std::shared_ptr<Player> &attacked) const;
	bool setAttackedCreature(const std::shared_ptr<Creature> &creature);
	std::shared_ptr<Creature> getAttackedCreature() {
		return attackedCreature;
	}

	uint64_t getLostExperience() const;

	void dropLoot(const std::shared_ptr<Container> &corpse);
	uint16_t getLookCorpse() const;
	void getPathSearchParams(const std::shared_ptr<Creature> &creature, FindPathParams &fpp) const;

	void attachEvent(std::shared_ptr<Task> event);
	bool detachEvent(std::shared_ptr<Task> event);
	void onExpireEvent(std::shared_ptr<Task> event);

	friend class Game;
	friend class Map;
	friend class LuaScriptInterface;

protected:
	virtual bool useCacheMap() const {
		return false;
	}

	std::map<uint32_t, std::shared_ptr<ProtocolGame>> knownPlayerSet;

	int32_t health = 1000;
	int32_t healthMax = 1000;
	uint32_t level = 1;
	uint32_t magLevel = 0;
	uint32_t mana = 0;
	uint32_t manaMax = 0;
	uint32_t manaShield = 0;
	uint32_t maxManaShield = 0;
	uint32_t soul = 0;
	uint32_t soulMax = 100;
	uint32_t levelPercent = 0;
	uint32_t magLevelPercent = 0;
	uint8_t experienceBonus = 0;

	Position masterPos;

	int64_t lastWalkthroughAttempt = 0;
	Position lastWalkthroughPosition;

	double skills[SKILL_LAST + 1][3] = {};
	double_t townWarDefenseModifier = 1.0;

	int32_t varSkills[SKILL_LAST + 1] = {};
	int32_t varStats[STAT_LAST + 1] = {};
	int32_t varSpecialSkills[SPECIALSKILL_LAST + 1] = {};

	bool lootDrop = true;
	bool lootContainers = true;
	bool skillLoss = true;
	bool guildWar = false;

	struct Familiar {
		std::string name;
		uint16_t looktype;

		bool operator<(const Familiar &rhs) const {
			return name < rhs.name;
		}
	};

	std::set<uint32_t> registered_events;
	std::vector<Familiar> unlockedFamiliars;

	std::vector<std::shared_ptr<Condition>> getMuteConditions() const;

	virtual void onDie();
	virtual void onAdvance(EventInfo &event);

	uint32_t id = 0;
	bool summoned = false;
	bool isInternalRemoved = false;
	bool moveLocked = false;
	bool directionLocked = false;
	bool hiddenHealth = false;
	bool localMapCacheUpToDate = false;
	Skulls_t skull = SKULL_NONE;
	PartyShields_t partyShield = SHIELD_NONE;
	GuildEmblems_t guildEmblem = GUILDEMBLEM_NONE;

	std::shared_ptr<Creature> attackedCreature;
	std::shared_ptr<Creature> followCreature;

	uint32_t eventWalk = 0;
	uint32_t walkTaskEvent = 0;
	uint32_t actionTaskEvent = 0;
	uint32_t quickLootFallbackToMainContainerEvent = 0;
	uint32_t lastAttack = 0;
	uint32_t lastHit = 0;
	uint32_t blockCount = 0;
	uint32_t blockTicks = 0;
	uint32_t lastCloseTime = 0;
	uint32_t messageBuffer = 0;
	uint32_t nextStepId = 0;

	CombatType_t lastDamageSource = COMBAT_NONE;
	uint32_t lastHitCreatureId = 0;
	uint32_t blockHitCreatureId = 0;
	uint64_t experience = 0;

	Direction direction = DIRECTION_SOUTH;
	Outfit_t currentOutfit = {};
	Outfit_t defaultOutfit = {};

	Position postTeleportPos;
	LightInfo creatureLight;

	std::shared_ptr<Task> walkTask;

	std::weak_ptr<Creature> m_master;
	std::vector<std::weak_ptr<Creature>> m_summons;

	std::unordered_map<std::string, CreatureIcon> creatureIcons;
	bool iconChangedFlag = false;

	std::array<int32_t, BUFF_LAST + 1> varBuffs = {};

	std::vector<std::shared_ptr<Condition>> conditions;

	std::shared_ptr<Tile> tile;

	std::vector<std::shared_ptr<CreatureEvent>> eventsList;
	std::vector<std::weak_ptr<Creature>> corpseOwnerList;

	std::map<uint32_t, int64_t> damageMap;

	std::list<std::shared_ptr<Task>> eventList;
	mutable std::mutex eventLock;

	std::mutex quickLootMutex;

	uint16_t baseSpeed = 220;
	int32_t varSpeed = 0;

	std::array<uint64_t, CONDITION_LAST + 1> conditionLastExecute = {};
	std::array<int32_t, CONDITION_LAST + 1> conditionSuppressions = {};
	std::array<int32_t, CONDITION_LAST + 1> conditionCounts = {};

	uint64_t yellTicks = 0;
	uint32_t yellSpeedTicks = 0;
	uint32_t messageTicks = 0;
	int64_t lastGossip = 0;
	uint32_t premiumDays = 0;

	double inventoryWeight = 0.0;

	uint64_t lastPong = 0;
	uint64_t lastPing = 0;

	int64_t lastLogout = 0;
	int64_t staminaMs = 0;
	int8_t bedPartnerDir = -1;
	uint64_t lastDepotId = -1;
	uint64_t lastMail = 0;
	uint16_t lastMailSender = 0;
	time_t lastLogin = 0;
	time_t lastLogout = 0;

	std::weak_ptr<Creature> m_followCreature;
	std::weak_ptr<Creature> m_attackedCreature;

	// variables
	std::string name;
	std::string nameDescription;
	std::string specialDescription;

	std::string guildNick;

	Rank_t guildRank = RANK_NONE;

	uint64_t guildContribution = 0;
	uint8_t guildLevel = 0;

	bool localMapCache[MAP_MAX_LAYERS][MAP_MAX_CLIENT_VIEWPORT_X * 2 + 1][MAP_MAX_CLIENT_VIEWPORT_Y * 2 + 1] = {};
	bool floors[8] = {};

	GuildWarVector guildWarVector;

	std::map<uint8_t, uint64_t> items;

	uint32_t chaseMode = CHASEMODE_STANDSTILL;
	uint32_t fightMode = FIGHTMODE_ATTACK;
	uint32_t secureMode = SECUREMODE_SAFETY_ON;

	// account variables
	std::shared_ptr<Account> account;
	AccountType_t accountType = ACCOUNT_TYPE_NORMAL;
	OperatingSystem_t operatingSystem = CLIENTOS_NONE;
	uint16_t protocolVersion = 0;

	// main variables
	void updateMapCache();
	int64_t getStepDelay(Direction dir) const;
	int64_t getStepDelay() const;

	uint32_t getMaxViewportX() const {
		return maxViewportX;
	}
	uint32_t getMaxViewportY() const {
		return maxViewportY;
	}
	uint32_t getLastStepCost() const {
		return lastStepCost;
	}

	uint32_t getAccountID() const {
		return account ? account->getID() : 0;
	}

	std::string getAccountName() const {
		return account ? account->getName() : std::string();
	}

	AccountErrors_t getAccountErrors() const {
		return account ? account->getErrors() : ACCOUNT_ERROR_NO_ERROR;
	}

	AccountType_t getAccountType() const {
		return accountType;
	}

	uint32_t getLevel() const {
		return level;
	}

	uint8_t getLevelPercent() const {
		return levelPercent;
	}

	uint32_t getMagicLevel() const {
		return magLevel + varStats[STAT_MAGICPOINTS];
	}
	uint32_t getBaseMagicLevel() const {
		return magLevel;
	}
	uint8_t getMagicLevelPercent() const {
		return magLevelPercent;
	}

	uint8_t getSoul() const {
		return soul;
	}

	bool isAccessPlayer() const {
		return group->access;
	}
	bool isPremium() const;

	uint16_t getHelpers() const;

	const std::vector<std::shared_ptr<Party>> &getParties() const {
		return parties;
	}
	std::vector<std::shared_ptr<Party>> &getParties() {
		return parties;
	}
	bool canOpenCorpse(uint32_t ownerId) const;

	uint16_t getBaseSpeed() const {
		return baseSpeed + varSpeed;
	}

	bool isSuppressedEvent(CreatureEventType_t eventType);

	bool isLoginEventSuppressed();

	bool isUpdateEventSuppressed();

	bool isRemoveEventSuppressed();

	bool isLoadEventSuppressed();

	bool isThinkEventSuppressed();

	void updateBaseSpeed() {
		if (!hasFlag(PlayerFlag_SetMaxSpeed)) {
			baseSpeed = vocation->getBaseSpeed() + (2 * (level - 1));
		}
	}

	void updateInventoryWeight();

	void setVarSkill(skills_t skill, int32_t modifier);
	void setVarStats(stats_t stat, int32_t modifier);
	void addVarStats(stats_t stat, int32_t modifier);
	int32_t getVarStats(stats_t stat) const;
	int getDefaultStats(stats_t stat) const;

	void setVarSpecialSkill(SpecialSkills_t specskill, int32_t modifier);
	int32_t getVarSpecialSkill(SpecialSkills_t specskill) const;

	uint32_t getStepTicks() const {
		return stepTicks;
	}

	void setStepTicks(uint32_t ticks) {
		stepTicks = ticks;
	}

	uint32_t getStepDuration() const {
		if (level == 1) {
			return stepDuration * lastStepCost;
		}
		return stepDuration;
	}

	uint32_t getFollowSpeed() const {
		return getSpeed();
	}

	int32_t getStepSpeed() const override {
		return getSpeed();
	}

	void updateMapCache() const;

	bool openCorpse(const std::shared_ptr<Item> &corpse, uint32_t flags);

	int32_t getPercentSkill(skills_t skill) const {
		return skills[skill][SKILL_PERCENT];
	}

	void notifyEvent(const std::shared_ptr<Event> &event) {
		// Notify event for monster and npc for potions
	}

	// helpers
	void addDamagePoints(const std::shared_ptr<DamageMap> &damageMap);
	void sendMessage(MessageClasses mclass, const std::string &message) const;

	void clearPlayer() {
		player = nullptr;
	}

private:
	std::vector<std::shared_ptr<Party>> parties;
	std::shared_ptr<Vocation> vocation;

	std::shared_ptr<Player> player;

	uint32_t lastAttack = 0;
	uint32_t staminaMinutes = 0;

	std::string name;
	std::string nameDescription;

	uint8_t soulMax = 0;

	uint32_t windowTextId = 0;
	uint32_t writeItem = 0;
	uint32_t maxWriteLen = 0;

	HouseList ownedHouses;

	uint32_t maxViewportX = MAP_MAX_CLIENT_VIEWPORT_X;
	uint32_t maxViewportY = MAP_MAX_CLIENT_VIEWPORT_Y;
	uint32_t lastStepCost = 1;
	uint32_t messageBuffer = 0;
	uint32_t stepTicks = 0;
	uint32_t stepDuration = 0;

	double inventoryWeight = 0;
	double capacity = 400.00;

	uint32_t damageImmunities = 0;
	uint32_t conditionImmunities = 0;
	uint32_t conditionSuppressions = 0;

	uint32_t nextStepEvent = 0;
	uint32_t actionTaskEvent = 0;
	uint32_t walkUpdateEvent = 0;

	time_t lastFailedFollow = 0;

	time_t skullTicks = 0;
	uint32_t lastSkullTime = 0;

	ItemMap inventory;

	bool pzLocked = false;
	bool isConnecting = false;

	std::weak_ptr<Container> lootContainer;
	std::weak_ptr<Container> mailBox;

	void updateItemsLight(bool internal = false);
	virtual int32_t getStepSpeed() const {
		return getSpeed();
	}
	void updateBaseSpeed();

	friend class Player;
	friend class Monster;
	friend class Npc;
};
