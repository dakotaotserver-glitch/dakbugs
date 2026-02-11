local mType = Game.createMonsterType("Mindmasher")
local monster = {}

monster.description = "an mindmasher"
monster.experience = 6000
monster.outfit = {
	lookType = 403,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 855,
	bossRace = RARITY_BANE,
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "venom"
monster.corpse = 12525
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	canPushCreatures = false,
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
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Mindmasher", chance = 40, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 90 },
	{ name = "small emerald", chance = 2880, maxCount = 2 },
	{ name = "small sapphire", chance = 2880, maxCount = 2 },
	{ name = "great health potion", chance = 5090 },
	{ name = "great mana potion", chance = 5090, maxCount = 2 },
	{ name = "platinum coin", chance = 40430, maxCount = 4 },
	{ id = 10392, chance = 560 }, -- twin hooks
	{ id = 3097, chance = 560 }, -- dwarven ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 150, maxDamage = -463, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 5000 },
	{ name = "energy ring", interval = 4300, chance = 45, minDamage = -30, maxDamage = -650 },
}

monster.defenses = {
	defense = 35,
	armor = 40,
	mitigation = 1.21,
	{ name = "invisible", interval = 2000, chance = 45, effect = CONST_ME_MAGIC_BLUE },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 140, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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
