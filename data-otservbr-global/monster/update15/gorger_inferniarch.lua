local mType = Game.createMonsterType("Gorger Inferniarch")
local monster = {}

monster.description = "a Gorger Inferniarch"
monster.experience = 7680
monster.outfit = {
	lookType = 1797,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2604
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Azzifon Castle Attic, Azzilon Castle Lv+1, Azzilon Castle Lv+2, Azzilon Castle Lv+3, Azzilon Castle Lv0",
}

monster.health = 9450
monster.maxHealth = 9450
monster.race = "undead"
monster.corpse = 50010
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 5,
	random = 5,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Kar Ath... Ul!", yell = false },
}

monster.loot = {
	-- common
	{ name = "platinum coin", chance = 80000, maxCount = 5 },
	-- semi-rare
	{ name = "small sapphire", chance = 4000, maxCount = 3 },
	{ id = 3093, chance = 4000 }, -- club ring
	{ name = "spiked squelcher", chance = 4000 },
	{ name = "demonic core essence", chance = 4000 },
	{ name = "gorger antlers", chance = 4000 },
	-- rare

	{ id = 3053, chance = 950 }, -- time ring
	{ name = "demonic matter", chance = 900 },
	{ name = "mummified demon finger", chance = 900 },
	-- very rare
	{ id = 3040, chance = 100 }, -- golden nugget
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -189, maxDamage = -513 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -379, maxDamage = -458, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -428, maxDamage = -495, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "gorgewave", interval = 3000, chance = 30, minDamage = -430, maxDamage = -469, target = true },
}
monster.defenses = {
	defense = 50,
	armor = 74,
	mitigation = 1.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)