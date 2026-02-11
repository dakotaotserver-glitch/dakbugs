local mType = Game.createMonsterType("Spellreaper Inferniarch")
local monster = {}

monster.description = "a Spellreaper Inferniarch"
monster.experience = 9400
monster.outfit = {
	lookType = 1792,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2599
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
    Locations = "Castle Catacombs L01 - Corrupted Basement, Castle Catacombs L02 - Searing Hall, Castle Catacombs L03 - Drowned Dungeons, Withering Grounds",
}

monster.health = 11800
monster.maxHealth = 11800
monster.race = "undead"
monster.corpse = 49990
monster.speed = 180
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
	{ text = "CHA..RAK!", yell = false },
}

monster.loot = {
	-- common
	{ name = "platinum Coin", chance = 80000, maxCount = 5 },
	-- uncommon
	{ name = "small ruby", chance = 15000, maxCount = 2 },
	{ name = "fire mushroom", chance = 15000, maxCount = 2 },
	-- semi-rare
    { name = "black pearl", chance = 4000 },
    { name = "demonic core essence", chance = 4000 },
    { name = "prismatic quartz", chance = 4000 },
    { name = "wand of inferno", chance = 4000 },
	-- rare
    { name = "spellbook of mind control", chance = 900 },
	{ name = "Mummified Demon Finger", chance = 900 },
    { name = "spellreaper staff totem", chance = 900 },
    { name = "demonic matter", chance = 900 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -328, maxDamage = -530 },
	{ name = "combat", interval = 1800, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -280, maxDamage = -421, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2100, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -232, maxDamage = -311, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PINK_ENERGY_SPARK, target = true },
	{ name = "combat", interval = 2100, chance = 35, type = COMBAT_MANADRAIN, minDamage = -184, maxDamage = -276, range = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SOUND_PURPLE, target = true },
	{ name = "combat", interval = 2100, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -219, maxDamage = -261, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -600, maxDamage = -850, radius = 5, effect = CONST_ME_INSECTS, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 74,
	mitigation = 2.13,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)