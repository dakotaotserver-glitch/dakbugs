local mType = Game.createMonsterType("The Count of the Core")
local monster = {}

monster.description = "The Count Of The Core"
monster.experience = 300000
monster.outfit = {
	lookType = 1046,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
	"MonsterKillStoragebosswar",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27637
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1519,
	bossRace = RARITY_BANE,
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
	{ text = "Shluush!", yell = false },
	{ text = "Sluuurp!", yell = false },
}

monster.loot = {
    -- Comuns
    { id = 3035, chance = 100000, maxCount = 70 }, -- platinum coin
    { id = 27713, chance = 80000, maxCount = 8 }, -- heavy crystal fragment
    { name = "mastermind potion", chance = 40000, maxCount = 3 },
    { id = 3081, chance = 40000 }, -- stone skin amulet
    { id = 3056, chance = 35000 }, -- amber staff
    { name = "ultimate health potion", chance = 35000, maxCount = 13 },
    { name = "great mana potion", chance = 35000, maxCount = 18 },
    { name = "great spirit potion", chance = 35000, maxCount = 18 },
    { name = "small amethyst", chance = 30000, maxCount = 15 },
    { name = "small diamond", chance = 25000, maxCount = 10 },
    { name = "small emerald", chance = 25000, maxCount = 12 },
    { name = "small ruby", chance = 25000, maxCount = 10 },
    { name = "small topaz", chance = 25000, maxCount = 10 },
    { name = "green crystal shard", chance = 20000, maxCount = 6 },
    { name = "huge chunk of crude iron", chance = 15000, maxCount = 2 },
    { name = "magic sulphur", chance = 15000, maxCount = 3 },

    -- Incomuns
    { id = 3041, chance = 7000 }, -- blue gem
    { id = 27626, chance = 6000 }, -- chitinous mouth (count)
    { id = 3043, chance = 6000 }, -- crystal coin
    { name = "crystalline armor", chance = 6000 },
    { id = 3085, chance = 5000 }, -- dragon necklace
    { id = 3062, chance = 5000 }, -- fire axe
    { id = 3280, chance = 5000 }, -- fire sword
    { id = 282, chance = 5000 }, -- giant shimmering pearl
    { id = 3281, chance = 4000 }, -- giant sword
    { id = 30886, chance = 4000 }, -- guardian axe
    { name = "gold token", chance = 4000 },
    { id = 3038, chance = 4000 }, -- green gem
    { name = "harpoon of a giant snail", chance = 4000 },
    { name = "huge spiky snail shell", chance = 3000 },
    { name = "luminous orb", chance = 3000 },
    { id = 3039, chance = 3000 }, -- red gem

    -- Semi-Raros
    { name = "slightly rusted helmet", chance = 1800 },
    { name = "slightly rusted shield", chance = 1800 },
    { name = "silver token", chance = 1800 },
    { name = "twiceslicer", chance = 1700 },
    { id = 3074, chance = 1700 }, -- wand of inferno
    { id = 3037, chance = 1700 }, -- yellow gem

    -- Raros
    { name = "gnomish footwraps", chance = 800 },
    { name = "candle stump", chance = 700 },
    { name = "gnome shield", chance = 700 },
    { name = "gnome sword", chance = 700 },
    { name = "mallet handle", chance = 2000 },
    { name = "tinged pot", chance = 700 },

    -- Muito Raro
    { name = "gnome helmet", chance = 300 },
}


monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, range = 3, length = 9, spread = 4, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1500, radius = 8, effect = CONST_ME_BLACKSMOKE, target = false },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
