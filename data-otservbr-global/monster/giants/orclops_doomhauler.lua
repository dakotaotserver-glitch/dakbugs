local mType = Game.createMonsterType("Orclops Doomhauler")
local monster = {}

monster.description = "an orclops doomhauler"
monster.experience = 1200
monster.outfit = {
	lookType = 934,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1314
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Desecrated Glade, Edron Orc Cave",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 25078
monster.speed = 120
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
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Me mash!", yell = false },
	{ text = "GRRRRR!", yell = true },
	{ text = "Muhahaha!", yell = false },
	{ text = "Me strong, you weak!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 50320, maxCount = 185 },
	{ name = "red mushroom", chance = 50320, maxCount = 3 },
	{ name = "strong health potion", chance = 50320 },
	{ name = "mysterious fetish", chance = 20000 },
	{ name = "orcish axe", chance = 50320 },
	{ name = "bone toothpick", chance = 20000 },
	{ name = "beetle carapace", chance = 4900 },
	{ name = "bug meat", chance = 1800, maxCount = 2 },
	{ name = "black pearl", chance = 12750, maxCount = 2 },
	{ name = "small ruby", chance = 2510, maxCount = 3 },
	{ name = "spiked squelcher", chance = 1940 },
	{ name = "onion", chance = 1000, maxCount = 2 },
	{ name = "small topaz", chance = 8870, maxCount = 2 },
	{ name = "brown crystal splinter", chance = 9700, maxCount = 2 },
	{ name = "pair of iron fists", chance = 15290 },
	{ name = "war drum", chance = 910 },
	{ name = "berserk potion", chance = 910 },
	{ name = "beetle necklace", chance = 910 },
	{ name = "dreaded cleaver", chance = 300 },
	{ name = "Reinvigorating Seeds", chance = 10000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -117, maxDamage = -220, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
	-- curse
	{ name = "condition", type = CONDITION_CURSED, interval = 2000, chance = 50, minDamage = -100, maxDamage = -200, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 35,
	mitigation = 1.32,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
