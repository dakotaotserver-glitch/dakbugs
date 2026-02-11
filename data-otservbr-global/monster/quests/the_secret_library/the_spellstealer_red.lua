local mType = Game.createMonsterType("The Spellstealer Red")
local monster = {}

monster.description = "The Spellstealer Red"
monster.experience = 0
monster.outfit = {
	lookType = 12,
	lookHead = 94,
	lookBody = 113,
	lookLegs = 94,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 280000
monster.maxHealth = 280000
monster.race = "undead"
monster.corpse = 6068
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 100,
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
	healthHidden = true,
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

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 50, minDamage = 450, maxDamage = -1150 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, range = 1200, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -300, length = 1250, spread = 0, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
