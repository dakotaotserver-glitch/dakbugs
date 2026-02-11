local mType = Game.createMonsterType("The Baron from Below")
local monster = {}

monster.description = "The Baron From Below"
monster.experience = 50000
monster.outfit = {
	lookType = 1045,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
	"TheBaronFromBelowThink",
	"MonsterKillStoragebosswar",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27633
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1518,
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
	{ text = "Krrrk!", yell = false },
}

monster.loot = {
    -- Comuns
    { id = 3035, chance = 100000, maxCount = 65 },  -- platinum coin
    { name = "ultimate health potion", chance = 40000, maxCount = 12 },
    { name = "great mana potion", chance = 40000, maxCount = 9 },
    { name = "great spirit potion", chance = 40000, maxCount = 14 },
    { id = 27713, chance = 80000, maxCount = 8 },   -- heavy crystal fragment
    { name = "mastermind potion", chance = 25000, maxCount = 2 },
    { name = "small amethyst", chance = 20000, maxCount = 12 },
    { name = "small diamond", chance = 20000, maxCount = 12 },
    { name = "small emerald", chance = 20000, maxCount = 12 },
    { name = "small ruby", chance = 20000, maxCount = 12 },
    { name = "small topaz", chance = 20000, maxCount = 12 },
    { name = "violet crystal shard", chance = 20000, maxCount = 7 },

    -- Incomuns / Raros
    { id = 3041, chance = 1500 },        -- blue gem
    { name = "calopteryx cape", chance = 1500 },
    { id = 27622, chance = 1500 },       -- chitinous mouth (baron)
    { name = "crystal mace", chance = 1500 },
    { id = 3280, chance = 2000 },        -- fire sword
    { id = 3038, chance = 1500 },        -- green gem
    { name = "huge chunk of crude iron", chance = 1200, maxCount = 2 },
    { name = "huge shell", chance = 1200 },
    { name = "longing eyes", chance = 1200 },
    { name = "luminous orb", chance = 1200 },
    { name = "magic sulphur", chance = 1200, maxCount = 2 },
    { name = "magma coat", chance = 1000 },
    { id = 3039, chance = 1200 },        -- red gem
    { name = "slightly rusted helmet", chance = 1200 },
    { name = "slightly rusted shield", chance = 1200 },
    { name = "slimy leg", chance = 1200 },
    { id = 3081, chance = 2500 },        -- stone skin amulet
    { id = 3036, chance = 1200 },        -- violet gem
    { id = 3074, chance = 2000 },        -- wand of inferno
    { id = 3037, chance = 1200 },        -- yellow gem
    { name = "gold token", chance = 1200 },
    { name = "silver token", chance = 1200 },

    -- Muito Raros (ajustado: 0.5% ~ 1%)
    { name = "badger boots", chance = 1000 },              -- 1%
    { name = "candle stump", chance = 600 },               -- 0.6%
    { name = "gnome armor", chance = 600 },                -- 0.6%
    { name = "gnome shield", chance = 800 },               -- 0.8%
    { name = "gnome sword", chance = 800 },                -- 0.8%
    { name = "gnomish footwraps", chance = 600 },          -- 0.6%
    { name = "mallet head", chance = 2000 },                -- 0.4%
    { name = "plan for a makeshift armour", chance = 400 } -- 0.4%
}


monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1000, radius = 8, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, length = 8, spread = 5, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, length = 8, spread = 9, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -1000, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -1000, radius = 5, effect = CONST_ME_SMALLPLANTS, target = false },
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
