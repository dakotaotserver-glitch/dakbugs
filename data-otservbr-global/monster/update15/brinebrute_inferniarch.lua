local mType = Game.createMonsterType("Brinebrute Inferniarch")
local monster = {}

monster.description = "a Brinebrute Inferniarch"
monster.experience = 23500
monster.outfit = {
	lookType = 1794,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2601
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
    Locations = "Castle Catacombs L01 - Corrupted Basement, Castle Catacombs L02 - Searing Hall, Castle Catacombs L03 - Drowned Dungeons, Withering Grounds",
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "undead"
monster.corpse = 49998
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
	{ text = "Garrr...Garrr!", yell = false },
}

monster.loot = {
	-- common
	{ name = "platinum coin", chance = 80000, maxCount = 5 },
	{ name = "great spirit potion", chance = 50000, maxCount = 2 },
	{ name = "brinebrute claw", chance = 50000 },
	-- uncommon
	{ name = "small sapphire", chance = 15000, maxCount = 2 },
	{ id = 3039, chance = 15000 }, -- red gem
	{ name = "blue crystal shard", chance = 15000, maxCount = 2 },
	{ name = "violet crystal shard", chance = 15000, maxCount = 2 },
	{ name = "green crystal shard", chance = 15000, maxCount = 2 },
	{ name = "green crystal splinter", chance = 15000 },
	{ name = "brown crystal splinter", chance = 15000 },
    { name = "blue crystal splinter", chance = 15000 },
    -- semi-rare
    { id = 3038, chance = 4000 }, -- green gem
    { id = 3048, chance = 4000 }, -- might ring
    { name = "stone skin amulet", chance = 4000 },
	{ id = 3098, chance = 4000 }, -- ring of healing
	{ name = "giant sword", chance = 4000 },
	{ name = "ultimate health potion", chance = 4000 },
	{ name = "demonic matter", chance = 4000 },
    { name = "demonic core essence", chance = 4000 },
    { name = "bloodstained scythe", chance = 4000 },
    -- rare
    { name = "gold ring", chance = 900 },
    { name = "mummified demon finger", chance = 900 },
    -- very rare
    { name = "demonrage sword", chance = 100 },
    { name = "demon shield", chance = 100 },
    { name = "crusader helmet", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -850, radius = 4, effect = CONST_ME_SLASH, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -530, length = 6, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 80,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
}

mType:register(monster)