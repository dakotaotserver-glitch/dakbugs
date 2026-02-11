local mType = Game.createMonsterType("Shadowstalker")
local monster = {}

monster.description = "a shadowstalker"
monster.experience = 4200
monster.outfit = {
	lookType = 456,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 853,
	bossRace = RARITY_BANE,
}

monster.health = 6100
monster.maxHealth = 6100
monster.race = "venom"
monster.corpse = 13865
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 40,
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
}

monster.loot = {
	{ name = "gold coin", chance = 50000, maxCount = 100 },
	{ name = "gold coin", chance = 50000, maxCount = 90 },
	{ name = "platinum coin", chance = 40430, maxCount = 5 },
	{ name = "yellow gem", chance = 530 },
	{ name = "great mana potion", chance = 9300 },
	{ name = "great health potion", chance = 6200 },
	{ name = "small topaz", chance = 10040, maxCount = 2 },
	{ name = "crawler head plating", chance = 50000 },
	{ name = "compound eye", chance = 14640 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -320, condition = { type = CONDITION_POISON, totalDamage = 80, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -250, range = 7, shootEffect = CONST_ANI_SMALLEARTH, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 42,
	mitigation = 1.26,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
	{ name = "invisible", interval = 2000, chance = 45, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
