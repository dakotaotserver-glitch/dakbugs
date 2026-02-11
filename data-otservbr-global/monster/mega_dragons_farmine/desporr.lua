local mType = Game.createMonsterType("Desporr")
local monster = {}

monster.description = "a despor"
monster.experience = 78100
monster.outfit = {
	lookType = 1712,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}
monster.events = {
"GreedokHealthChange",
"CreatureDeathDragon",
}


monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 44663
monster.speed = 170
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Just Look at me!", yell = false },
	{ text = "I'll stare you down", yell = false },
	{ text = "Let me have a look", yell = false },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 320, maxDamage = -1250 },
	{ name = "combat", interval = 2500, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -850, range = 2, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -800, length = 8, spread = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2500, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -800, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -1200, radius = 4, effect = 54, target = true },
	{ name = "root", interval = 2000, chance = 15, target = true },
	{ name = "death chain", interval = 2500, chance = 20, minDamage = -400, maxDamage = -1250, range = 8 },
	{ name = "fear", interval = 3500, chance = 20, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -1100, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -1250, radius = 4, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -1350, radius = 7, effect = 221, target = true },
	{ name = "largefirering", interval = 2000, chance = 10, minDamage = -800, maxDamage = -1400, target = false },
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -1350, radius = 7, effect = 216, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -500, maxDamage = -1200, range = 8, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -500, maxDamage = -1200, radius = 8, effect = 23, target = false },
	{ name = "largeicering", interval = 2000, chance = 10, minDamage = -800, maxDamage = -1400, target = false },
	{ name = "largeblackring", interval = 2000, chance = 10, minDamage = -900, maxDamage = -1500, target = false },
}

monster.defenses = {
	defense = 86,
	armor = 76,
	mitigation = 1.96,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)