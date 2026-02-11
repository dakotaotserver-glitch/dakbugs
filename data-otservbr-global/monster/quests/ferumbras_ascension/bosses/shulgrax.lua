local mType = Game.createMonsterType("Shulgrax")
local monster = {}

monster.description = "Shulgrax"
monster.experience = 500000
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 62,
	lookLegs = 2,
	lookFeet = 87,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "undead"
monster.corpse = 22495
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1191,
	bossRace = RARITY_ARCHFOE,
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
	{ text = "DAMMMMNNNNAAATIONN!", yell = false },
	{ text = "I WILL FEAST ON YOUR SOUL!", yell = true },
	{ text = "YOU ARE ALL DAMNED!", yell = true },
}

monster.loot = {
	{ name = "silver token", chance = 1000000 },
	{ name = "gold coin", chance = 98000, maxCount = 200 },
	{ name = "platinum coin", chance = 8000, maxCount = 30 },
	{ name = "flask of demonic blood", chance = 10000, maxCount = 5 },
	{ name = "great mana potion", chance = 23000, maxCount = 5 },
	{ name = "great spirit potion", chance = 46100, maxCount = 5 },
	{ name = "ultimate health potion", chance = 23000, maxCount = 5 },
	{ name = "onyx chip", chance = 46100, maxCount = 5 },
	{ name = "opal", chance = 46100, maxCount = 5 },
	{ name = "small diamond", chance = 10000, maxCount = 5 },
	{ name = "small emerald", chance = 10000, maxCount = 5 },
	{ name = "small ruby", chance = 10000, maxCount = 5 },
	{ name = "small topaz", chance = 10000, maxCount = 5 },
	{ name = "bloody edge", chance = 1000 },
	{ name = "chaos mace", chance = 1000 },
	{ id = 6299, chance = 1300 }, -- death ring
	{ name = "wand of starstorm", chance = 1000 },
	{ name = "demonbone amulet", chance = 1000 },
	{ name = "demonic essence", chance = 11000 },
	{ name = "dreaded cleaver", chance = 1300 },
	{ id = 3038, chance = 1000 }, -- green gem
	{ name = "lightning legs", chance = 1000 },
	{ name = "lightning pendant", chance = 1000 },
	{ name = "pair of iron fists", chance = 1000 },
	{ id = 3039, chance = 1000 }, -- red gem
	{ name = "shadow sceptre", chance = 1900 },
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 3037, chance = 1000 }, -- yellow gem
	{ name = "demon shield", chance = 700 },
	{ name = "magic plate armor", chance = 700 },
	{ name = "rift bow", chance = 700 },
	{ name = "rift crossbow", chance = 700 },
	{ name = "ruthless axe", chance = 700 },
	{ name = "treader of torment", chance = 500, unique = true },
	{ name = "maimer", chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -700 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -700, maxDamage = -900, length = 10, spread = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 25, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -800, length = 10, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 6000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "shulgrax summon", interval = 5000, chance = 5, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
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
