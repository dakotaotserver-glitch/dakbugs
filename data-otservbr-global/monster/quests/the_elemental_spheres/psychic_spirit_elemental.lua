local mType = Game.createMonsterType("Psychic Spirit Elemental")
local monster = {}

monster.description = "a psychic spirit elemental"
monster.experience = 1300
monster.outfit = {
	lookType = 1840,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 1400
monster.maxHealth = 1400
monster.race = "blood"
monster.corpse = 51279
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 20000,
	chance = 15,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
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
    -- common
	{ name = "gold coin", chance = 80000, maxCount = 130 },
    { name = "holy ash", chance = 70000 },
    -- uncommon
	{ name = "small topaz", chance = 25000, maxCount = 2 },
    -- Semi-rare
	{ name = "moonlight rod", chance = 4000 },
	{ name = "spirited soil", chance = 3800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
    { name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -200, radius = 4, effect = CONST_ME_GREEN_ENERGYSHOCK, target = false },
	{ name = "spirit elemental ring", interval = 5000, chance = 10, minDamage = -65, maxDamage = -510 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
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
