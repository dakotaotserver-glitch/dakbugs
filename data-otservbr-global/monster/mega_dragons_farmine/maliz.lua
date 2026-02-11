local mType = Game.createMonsterType("Maliz")
local monster = {}

monster.description = "a maliz"
monster.experience = 78100
monster.outfit = {
	lookType = 34,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}
monster.events = {"CreatureDeathDragon",}
monster.raceId = 34
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 5,
	Occurrence = 0,
	Locations = "nimmerset",
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "blood"
monster.corpse = 0
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
	rewardBoss = false,
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
	{ text = "STRIKE THE EARTH!!!", yell = false },
	{ text = "STRIKE THE EARTH!!!", yell = false },
	{ text = "STRIKE THE EARTH!!!", yell = false },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 320, maxDamage = -1250 },
	{ name = "combat", interval = 2500, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -850, range = 2, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -1100, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -800, range = 7, radius = 4, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_SMALLPLANTS, target = true },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -1000, radius = 4, effect = 55, target = true },
	{ name = "death chain", interval = 2500, chance = 50, minDamage = -300, maxDamage = -850, range = 8 },
}

monster.defenses = {
	defense = 86,
	armor = 76,
	mitigation = 1.96,
}
monster.heals = {
	{ type = COMBAT_EARTHDAMAGE, percent = 1000 },
}
monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 500 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)