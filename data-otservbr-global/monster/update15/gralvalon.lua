local mType = Game.createMonsterType("Gralvalon")
local monster = {}

monster.description = "Gralvalon"
monster.experience = 24000
monster.outfit = {
	lookType = 1793,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2606,
	bossRace = RARITY_BANE,
}

monster.health = 33000
monster.maxHealth = 33000
monster.race = "blood"
monster.corpse = 50046
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 30,
	damage = 10,
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

monster.loot = {
	-- common
	{ name = "demonic matter", chance = 90000 },
	{ name = "platinum coin", chance = 100000, maxcount = 50 },
	{ name = "sniper arrow", chance = 85000, maxcount = 6 },
	{ id = 32769, chance = 80000, maxcount = 3 }, -- white gem
	-- rare
	{ name = "skin of gralvalon", chance = 900 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -650 },
	{ name = "combat", interval = 2000, chance = 45, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -950, radius = 4, effect = CONST_ME_YELLOWENERGY , target = false },
	{ name = "combat", interval = 2500, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -357, maxDamage = -441, range = 5, shootEffect = CONST_ANI_ONYXARROW, effect = CONST_ME_MORTAREA , target = true },
	{ name = "combat", interval = 4000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -234, maxDamage = -375, range = 5, effect = CONST_ME_WHITEFLOWER , target = true },
	{ name = "combat", interval = 5000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -376, maxDamage = -494, radius = 3, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 65,
	armor = 73,
	mitigation = 2.2,
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
