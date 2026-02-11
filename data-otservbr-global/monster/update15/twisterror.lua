local mType = Game.createMonsterType("Twisterror")
local monster = {}

monster.description = "Twisterror"
monster.experience = 25000
monster.outfit = {
	lookType = 1792,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2605,
	bossRace = RARITY_BANE,
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 50042
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
	{ name = "platinum coin", chance = 100000, maxcount = 97 },
	{ name = "demonic matter", chance = 90000 },
	-- semi-rare
	{ name = "skin of twisterror", chance = 4000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -428, maxDamage = -630 },
	{ name = "combat", interval = 1800, chance = 45, type = COMBAT_ENERGYDAMAGE, minDamage = -380, maxDamage = -521, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2100, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -332, maxDamage = -411, range = 5, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_PINK_ENERGY_SPARK, target = true },
	{ name = "combat", interval = 2100, chance = 35, type = COMBAT_MANADRAIN, minDamage = -284, maxDamage = -376, range = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SOUND_PURPLE, target = true },
	{ name = "combat", interval = 2100, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -319, maxDamage = -361, range = 5, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -950, radius = 5, effect = CONST_ME_INSECTS, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 74,
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
