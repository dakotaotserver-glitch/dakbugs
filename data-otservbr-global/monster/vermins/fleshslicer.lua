local mType = Game.createMonsterType("Fleshslicer")
local monster = {}

monster.description = "a fleshslicer"
monster.experience = 5500
monster.outfit = {
	lookType = 457,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 858,
	bossRace = RARITY_BANE,
}

monster.health = 5700
monster.maxHealth = 5700
monster.race = "venom"
monster.corpse = 13870
monster.speed = 197
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "small ruby", chance = 23280, maxCount = 5 },
	{ name = "gold coin", chance = 50000, maxCount = 100 },
	{ name = "gold coin", chance = 50000, maxCount = 100 },
	{ name = "platinum coin", chance = 45000, maxCount = 5 },
	{ id = 3039, chance = 4480 }, -- red gem
	{ name = "titan axe", chance = 1440 },
	{ name = "great mana potion", chance = 20400, maxCount = 2 },
	{ name = "ultimate health potion", chance = 9250, maxCount = 2 },
	{ name = "spidris mandible", chance = 27440 },
	{ name = "compound eye", chance = 13210, maxCount = 2 },

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -110, maxDamage = -350, radius = 3, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 65,
	mitigation = 1.77,
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
