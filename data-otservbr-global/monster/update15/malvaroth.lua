local mType = Game.createMonsterType("Malvaroth")
local monster = {}

monster.description = "Malvaroth"
monster.experience = 28000
monster.outfit = {
	lookType = 1794,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2607,
	bossRace = RARITY_BANE,
}

monster.health = 40000
monster.maxHealth = 40000
monster.race = "blood"
monster.corpse = 50050
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
	{ name = "platinum coin", chance = 100000, maxcount = 50 },
	{ name = "blue crystal splinter", chance = 50000 },
	{ name = "green crystal splinter", chance = 50000 },
	{ name = "great spirit potion", chance = 50000 },
	{ name = "small sapphire", chance = 50000, maxcount = 3 },
	-- uncommon
	{ name = "brinebrute claw", chance = 15000 },
	{ name = "demonic core essence", chance = 15000 },
	{ name = "demonic matter", chance = 15000 },
	{ id = 3098, chance = 4000 }, -- ring of healing
	-- rare
	{ name = "skin of malvaroth", chance = 900 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -650 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -600, maxDamage = -950, radius = 4, effect = CONST_ME_SLASH, target = false },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -850, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2100, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -580, maxDamage = -860, range = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -520, maxDamage = -930, range = 4, effect = CONST_ME_BIG_SCRATCH, target = true },
}

monster.defenses = {
	defense = 70,
	armor = 80,
	mitigation = 2.5,
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
