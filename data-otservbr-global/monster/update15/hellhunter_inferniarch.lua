local mType = Game.createMonsterType("Hellhunter Inferniarch")
local monster = {}

monster.description = "a Hellhunter Inferniarch"
monster.experience = 9100
monster.outfit = {
	lookType = 1793,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2600
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

monster.health = 11300
monster.maxHealth = 11300
monster.race = "undead"
monster.corpse = 49994
monster.speed = 175
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
	targetDistance = 3,
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
	{ text = "Ardash... El...!", "Urrrglll!", yell = false },
}

monster.loot = {
	-- common
	{ name = "platinum Coin", chance = 80000, maxCount = 5 },
	-- uncommon
	{ name = "assassin star", chance = 15000, maxCount = 3 },
	{ name = "onyx arrow", chance = 15000, maxCount = 2 },
	{ name = "small amethyst", chance = 15000, maxCount = 2 },
	-- semi-rare
    { name = "sniper arrow", chance = 4000, maxCount = 3 },
	{ name = "cyan crystal fragment", chance = 4000 },
	{ name = "dark helmet", chance = 4000 },
	{ id = 6299, chance = 4000 }, -- death ring
    { name = "demonic core essence", chance = 4000 },
	-- rare
	{ name = "Mummified Demon Finger", chance = 900 },
    { name = "demonic matter", chance = 900 },
	{ name = "hellhunter eye", chance = 900 },
	-- very rare
	{ name = "composite hornbow", chance = 150 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -850, radius = 4, effect = CONST_ME_YELLOWENERGY , target = false },
	{ name = "combat", interval = 2500, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -257, maxDamage = -341, range = 5, shootEffect = CONST_ANI_ONYXARROW, effect = CONST_ME_MORTAREA , target = true },
	{ name = "combat", interval = 4000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -134, maxDamage = -275, range = 5, effect = CONST_ME_WHITEFLOWER , target = true },
	{ name = "combat", interval = 5000, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -276, maxDamage = -394, radius = 3, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 73,
	mitigation = 2.19,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)