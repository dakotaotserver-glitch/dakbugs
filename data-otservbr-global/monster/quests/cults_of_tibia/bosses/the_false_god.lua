local mType = Game.createMonsterType("The False God")
local monster = {}

monster.description = "The False God"
monster.experience = 50000
monster.outfit = {
	lookType = 984,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1409,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	canPushCreatures = false,
	staticAttackChance = 95,
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
	{ text = "CREEEAK!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 60000, maxCount = 200 },
	{ name = "platinum coin", chance = 70000, maxCount = 30 },
	{ name = "energy bar", chance = 10000, maxCount = 5 },
	{ name = "great spirit potion", chance = 15000, maxCount = 10 },
	{ name = "piece of hell steel", chance = 8000, maxCount = 15 },
	{ name = "red piece of cloth", chance = 9000, maxCount = 6 },
	{ name = "small amethyst", chance = 12000, maxCount = 10 },
	{ name = "small diamond", chance = 12000, maxCount = 10 },
	{ name = "small emerald", chance = 12000, maxCount = 10 },
	{ name = "small sapphire", chance = 12000, maxCount = 14 },
	{ name = "small topaz", chance = 12000, maxCount = 10 },
	{ name = "ultimate health potion", chance = 15000, maxCount = 10 },
	{ id = 3031, chance = 5000 }, -- blue gem
	-- { name = "giant shimmering pearl", chance = 5000 },
	{ name = "giant sword", chance = 3000 },
	{ id = 3038, chance = 5000 }, -- green gem
	{ name = "iron ore", chance = 5280 },
	{ name = "magic sulphur", chance = 4000 },
	{ name = "mino shield", chance = 3500 },
	{ name = "mysterious remains", chance = 3000 },
	{ name = "necromantic rust", chance = 3000 },
	{ name = "pair of iron fists", chance = 1410 },
	{ name = "piece of royal steel", chance = 2500 },
	{ id = 3039, chance = 5000 }, -- red gem
	{ name = "silver token", chance = 1000 },
	{ name = "underworld rod", chance = 2000 },
	{ id = 3036, chance = 5000 }, -- violet gem
	{ name = "war axe", chance = 2000 },
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ name = "blood of the mountain charm", chance = 1000 },
	{ name = "execowtioner axe", chance = 800 },
	{ name = "maimer", chance = 800 },
	{ name = "ornate mace", chance = 800 },
	{ name = "velvet mantle", chance = 800 },
	{ name = "gold token", chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 100, maxDamage = -700, range = 4, radius = 4, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -650, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
