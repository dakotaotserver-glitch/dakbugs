local mType = Game.createMonsterType("The Mega Magmaoid")
local monster = {}

monster.description = "The Mega Magmaoid"
monster.experience = 80000
monster.outfit = {
	lookType = 1413,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}
monster.events = {
"MagmaoidMassiveMagmaoidDeath",
}

monster.bosstiary = {
	bossRaceId = 2060,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 104000
monster.maxHealth = 104000
monster.race = "undead"
monster.corpse = 36847
monster.speed = 500
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
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
}

monster.loot = {
	{ name = "platinum coin", mincount = 50, maxcount = 100, chance = 100000 },
    { name = "crystal coin", mincount = 1, maxcount = 5, chance = 80000 },
    { name = "violet gem", chance = 10000 },
	{ name = "eldritch breeches", chance = 1000 },
    { name = "eldritch cowl", chance = 1000 },
    { name = "eldritch hood", chance = 1000 },
    { name = "eldritch bow", chance = 800 },
    { name = "eldritch quiver", chance = 800 },
    { name = "eldritch claymore", chance = 900 },
    { name = "eldritch greataxe", chance = 900 },
    { name = "eldritch warmace", chance = 900 },
    { name = "eldritch crescent moon spade", chance = 900 },
    { name = "eldritch shield", chance = 900 },
    { name = "eldritch cuirass", chance = 900 },
    { name = "eldritch folio", chance = 900 },
    { name = "eldritch tome", chance = 900 },
    { name = "eldritch rod", chance = 900 },
    { name = "eldritch wand", chance = 900 },
	{ name = "eldritch monk boots", chance = 1000 },

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -275, maxDamage = -750 },
	{ name = "combat", interval = 2000, chance = 75, type = COMBAT_FIREDAMAGE, minDamage = -725, maxDamage = -1000, radius = 3, range = 8, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "combat", interval = 3700, chance = 37, type = COMBAT_FIREDAMAGE, minDamage = -1700, maxDamage = -2750, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 3100, chance = 27, type = COMBAT_FIREDAMAGE, minDamage = -1000, maxDamage = -2000, range = 8, effect = CONST_ME_FIREAREA, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 0,
	mitigation = 2.0,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 500 },
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

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
