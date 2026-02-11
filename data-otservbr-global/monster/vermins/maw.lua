local mType = Game.createMonsterType("Maw")
local monster = {}

monster.description = "a maw"
monster.experience = 6500
monster.outfit = {
	lookType = 458,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}


monster.bosstiary = {
	bossRaceId = 857,
	bossRace = RARITY_BANE,
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "venom"
monster.corpse = 13937
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "Kropp!", yell = false },
	{ text = "Zopp!", yell = false },
}

monster.loot = {
	{ name = "small ruby", chance = 8180, maxCount = 4 },
	{ name = "gold coin", chance = 49000, maxCount = 100 },
	{ name = "gold coin", chance = 50000, maxCount = 97 },
	{ name = "platinum coin", chance = 66000, maxCount = 6 },
	{ name = "great mana potion", chance = 8950 },
	{ id = 281, chance = 2600 }, -- giant shimmering pearl (green)
	{ name = "ultimate health potion", chance = 4000, maxCount = 2 },
	{ name = "gold ingot", chance = 5160 },
	{ name = "kollos shell", chance = 66000 },
	{ name = "compound eye", chance = 66000 },
	{ name = "hive bow", chance = 250 },
	{ name = "Gooey Mass", chance = 650 },

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -835 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 500, maxDamage = -700, range = 7, radius = 3, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONHIT, target = true },
}

monster.defenses = {
	defense = 45,
	armor = 59,
	mitigation = 1.71,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
