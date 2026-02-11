local mType = Game.createMonsterType("Albino Dragon")
local monster = {}

monster.description = "a Albino Dragon"
monster.experience = 2250
monster.outfit = {
	lookType = 1683,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 44178
monster.speed = 197
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 300,
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

monster.raceId = 2416
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 50,
	FirstUnlock = 1,
	SecondUnlock = 25,
	CharmsPoints = 30,
	Stars = 3,
	Occurrence = 0,
	Locations = "Hellgorge, Dragon Lair (Fenrock), Dragon Lair (Ankrahmun), Dragonblaze Peaks, Dragon Lair (Pits of Inferno)",
}



monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "GRRRRAAAWRR!", "GNARRRRL!!", yell = true },
}

monster.loot = {
    -- Comum
    { id = 3031, chance = 100000, maxCount = 80 }, -- gold coin
    { id = 3035, chance = 99000, maxCount = 10 }, -- platinum coin
    { id = 3583, chance = 80000, maxCount = 3 }, -- dragon ham

    -- Incomum
    { id = 2842, chance = 11000 }, -- Gemmed Book
    { id = 2903, chance = 9500 }, -- golden mug
    { id = 3029, chance = 13000 }, -- small sapphire
    { id = 3051, chance = 10250 }, -- energy ring
    { id = 3450, chance = 18000, maxCount = 10 }, -- power bolt
    { id = 3732, chance = 10000, maxCount = 2 }, -- green mushroom
    { name = "Royal Spear", chance = 7500, maxCount = 8 },

    -- Semi-raro
    { name = "Strong Health Potion", chance = 2200, maxCount = 2 },
    { id = 3061, chance = 1800 }, -- life crystal

    -- Raro
    { id = 3280, chance = 900 }, -- fire sword
	{ name = "strange helmet", chance = 650 },
    { id = 3392, chance = 450 }, -- royal helmet
    { id = 3428, chance = 750 }, -- tower shield
    { id = 44179, chance = 10 }, -- bottled dragon breath
    { name = "Albino Dragon Leather", chance = 100000 },

    -- Muito raro (não revelados oficialmente)
    -- { name = "???" , chance = 100 },
}


monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -160, maxDamage = -600 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -350, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "firefield", interval = 1000, chance = 10, range = 7, radius = 6, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 45,
	mitigation = 1.32,
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 400, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
