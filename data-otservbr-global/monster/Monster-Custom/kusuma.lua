local mType = Game.createMonsterType("Kusuma")
local monster = {}

monster.description = "Kusuma"
monster.experience = 21500
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 61,
	lookLegs = 53,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "blood"
monster.corpse = 28664
monster.speed = 685
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	 
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.hazard = {
    criticalChance = 30.5, -- 10,5%
    canDodge = true, -- Activate/deactivate crit possibility on the animal
    canSpawnPod = true, -- Enable/disable possibility to drop spawn pod when killing the bug
    canDealMoreDamage = true -- Enable/Disable Increased Damage
}

monster.loot = {
	{name = "Gold Coin", minCount = 10, maxCount = 250, chance = 100000},
	{name = "platinum coin", minCount = 5, maxCount = 90, chance = 100000},
	{name = "Ultimate Health Potion", minCount = 1, maxCount = 5, chance = 50000},
	{name = "Soul Orb", chance = 301320},
	{name = "Demonic Essence", chance = 301320},
	{name = "Great Spirit Potion", chance = 301320},
	{name = "Small Emerald", chance = 301320},
	{name = "Flask of Demonic Blood", chance = 301320},																
	{name = "Peacock Feather Fan", chance = 301320},
	{name = "Golden Lotus Brooch", chance = 301320},	
	{name = "Muck Rod", chance = 301320},
	{name = "Green Piece of Cloth", chance = 2510},	
	{name = "Snakebite Rod", chance = 2110},	
	{name = "Leaf Star", chance = 3030},
	{name = "Necrotic Rod", chance = 2510},	
	{name = "White Pearl", chance = 42420},
	{name = "Blue Gem", chance = 2410},	
	{name = "Green Gem", chance = 221510},
	{name = "Gold Ingot", chance = 201510},
	{name = "Swamplair Armor", chance = 161510},
	{name = "Giant Emerald", chance = 8500},
	{name = "Oriental Shoes", chance = 5110},
	{name = "Terra Hood", chance = 1000}
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "timira fire ring", interval = 3500, chance = 50, minDamage = -360, maxDamage = -425 },
	{ name = "death chain", interval = 2500, chance = 30, minDamage = -190, maxDamage = -225, range = 3, target = true },
	{ name = "mana drain chain", interval = 2500, chance = 20, minDamage = -100, maxDamage = -130 },
	{ name = "timira explosion", interval = 4200, chance = 40, minDamage = -350, maxDamage = -560 },
	{ name = "combat", interval = 5500, chance = 45, type = COMBAT_PHYSICALDAMAGE, minDamage = -580, maxDamage = -620, length = 6, spread = 2, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_ENERGYDAMAGE, minDamage = -230, maxDamage = -450, range = 1, radius = 1, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 50},
	{type = COMBAT_ENERGYDAMAGE, percent = 50},
	{type = COMBAT_EARTHDAMAGE, percent = 50},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 40},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 40},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 40}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
end

mType:register(monster)
