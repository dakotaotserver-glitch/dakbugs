local mType = Game.createMonsterType("Spirit Overlord")
local monster = {}

monster.description = "Spirit Overlord"
monster.experience = 2800
monster.outfit = {
	lookType = 1840,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ElementalOverlordDeath",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 51279
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 212,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
    -- common
    { name = "reality splinter", chance = 100000 },
	{ name = "gold coin", chance = 80000, maxCount = 120 },
	{ name = "platinum coin", chance = 75000, maxCount = 7 },
    { name = "holy ash", chance = 70000 },
    -- uncommon
    { name = "great spirit potion", chance = 25000, maxCount = 3 },
    -- rare
	{ name = "holy orchid", chance = 980 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HOLYDAMAGE, minDamage = -170, maxDamage = -620, length = 8, spread = 0, effect = CONST_ME_HOLYDAMAGE, target = false },
	{ name = "condition", type = CONDITION_DAZZLED, interval = 2000, chance = 35, minDamage = -50, maxDamage = -320, range = 7, radius = 1, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
