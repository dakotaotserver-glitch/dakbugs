local mType = Game.createMonsterType("Murcion")
local monster = {}

monster.description = "Murcion"
monster.experience = 3250000
monster.outfit = {
	lookType = 1664,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RottenBloodBossDeath",
}

monster.bosstiary = {
	bossRaceId = 2362,
	bossRace = RARITY_NEMESIS,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44015
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}
monster.summon = {
	maxSummons = 8,  
	summons = {
		{ name = "Mushroom", chance = 100, interval = 1000, count = 8 }, 
	},
}

monster.voices = {}

monster.loot = {
	{ name = "crystal coin", chance = 12317, maxCount = 91 },
	{ id = 3039, chance = 10896, maxCount = 2 }, -- red gem
	{ name = "amber with a bug", chance = 14590, maxCount = 1 },
	{ name = "amber with a dragonfly", chance = 5405, maxCount = 1 },
	{ name = "bullseye potion", chance = 10821, maxCount = 44 },
	{ name = "green gem", chance = 7763, maxCount = 4 },
	{ name = "mastermind potion", chance = 9534, maxCount = 15 },
	{ name = "supreme health potion", chance = 6212, maxCount = 102 },
	{ name = "ultimate mana potion", chance = 8785, maxCount = 29 },
	{ name = "ultimate spirit potion", chance = 8783, maxCount = 161 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2000, maxDamage = -3300 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -3000, maxDamage = -4000, radius = 7, effect = CONST_ME_MORTAREA, target = false },
	{ name = "largedeathring2", interval = 2000, chance = 10, minDamage = -2200, maxDamage = -3200, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -1400, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -500, maxDamage = -1000, radius = 7, effect = 32, target = false },
	{ name = "speed", interval = 2000, chance = 7, speedChange = -300, radius = 5, effect = 20, target = false, duration = 10000 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1500, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)