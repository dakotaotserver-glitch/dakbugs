local mType = Game.createMonsterType("Broodrider Inferniarch")
local monster = {}

monster.description = "a Broodrider Inferniarch"
monster.experience = 7850
monster.outfit = {
	lookType = 1796,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2603
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

monster.health = 9600
monster.maxHealth = 9600
monster.race = "undead"
monster.corpse = 50006
monster.speed = 165
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
	{ text = "Mah...Hun Hur...!", yell = false },
}

monster.loot = {
	-- common
	{ name = "platinum coin", chance = 80000, maxCount = 5 },
	-- uncommon
	{ name = "Blue Crystal Splinter", chance = 5000, maxCount = 3 },
	-- semi-rare
	{ name = "Drill Bolt", chance = 4000, maxCount = 3 },
    { name = "Power Bolt", chance = 4000, maxCount = 3 },
    { name = "Onyx Chip", chance = 4000, maxCount = 3 },
    { name = "demonic core essence", chance = 4000 },
    { name = "Broodrider Saddle", chance = 4000 },
	-- rare
    { name = "Magma Legs", chance = 900 },
	{ name = "demonic matter", chance = 900 },
	{ name = "mummified demon finger", chance = 900 },
	-- very rare
    { name = "Arbalest", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -219, maxDamage = -261 },
	{ name = "broodriderewave", interval = 3000, chance = 25, minDamage = -430, maxDamage = -469, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -167, maxDamage = -374, effect = CONST_ME_BITE, target = true},
    { name = "combat", interval = 2000, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -219, maxDamage = -261, range = 5, shootEffect = CONST_ANI_INFERNALBOLT, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 80,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)