local mType = Game.createMonsterType("Sineater Inferniarch")
local monster = {}

monster.description = "a Sineater Inferniarch"
monster.experience = 7250
monster.outfit = {
	lookType = 1795,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2602
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
    Locations = "Azzifon Castle Attic, Azzilon Castle Lv+1, Azzilon Castle Lv+2, Azzilon Castle Lv+3, Azzilon Castle Lv0",
}

monster.health = 9150
monster.maxHealth = 9150
monster.race = "undead"
monster.corpse = 50002
monster.speed = 160
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
	targetDistance = 1,
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
	{ name = "great mana potion", chance = 6000, maxCount = 3 },
	-- semi-rare
    { name = "small ruby", chance = 4000, maxCount = 2 },
	{ name = "demonic core essence", chance = 4000 },
	{ name = "sineater wing", chance = 4000 },
	{ name = "ruby necklace", chance = 4000 },
	{ name = "wand of defiance", chance = 4000 },
	{ id = 3039, chance = 4000 }, -- red gem
	-- rare
	{ name = "mummified demon finger", chance = 900 },
    { name = "demonic matter", chance = 900 },
	{ name = "wooden spellbook", chance = 900 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -550 },
	{ name = "firefield", interval = 2000, chance = 10, range = 5, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -365, maxDamage = -632, range = 5, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 68,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)