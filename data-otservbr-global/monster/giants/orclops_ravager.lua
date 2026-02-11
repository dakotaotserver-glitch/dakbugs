local mType = Game.createMonsterType("Orclops Ravager")
local monster = {}

monster.description = "an orclops ravager"
monster.experience = 1100
monster.outfit = {
	lookType = 935,
	lookHead = 94,
	lookBody = 1,
	lookLegs = 80,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1320
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Desecrated Glade",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 25074
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Crushing! Smashing! Ripping! Yeah!!", yell = false },
	{ text = "It's clobberin time!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 50320, maxCount = 120 },
	{ name = "platinum coin", chance = 50320 },
	{ name = "strong health potion", chance = 50320 },
	{ name = "red mushroom", chance = 50320, maxCount = 3 },
	{ name = "bone toothpick", chance = 4900 },
	{ name = "beetle carapace", chance = 1800 },
	{ name = "black pearl", chance = 2510, maxCount = 3 },
	{ name = "small ruby", chance = 1940, maxCount = 3 },
	{ name = "small topaz", chance = 9700, maxCount = 2 },
	{ name = "brown crystal splinter", chance = 15290, maxCount = 2 },
	{ name = "pair of iron fists", chance = 910 },
	{ name = "war drum", chance = 910 },
	{ name = "berserk potion", chance = 910 },
	{ name = "dreaded cleaver", chance = 300 },
	{ name = "Reinvigorating Seeds", chance = 10000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -180, maxDamage = -220, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 35,
	mitigation = 1.24,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_HEALING, minDamage = 80, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
