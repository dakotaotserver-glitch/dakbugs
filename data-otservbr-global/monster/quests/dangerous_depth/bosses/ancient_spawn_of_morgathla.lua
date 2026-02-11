local mType = Game.createMonsterType("Ancient Spawn of Morgathla")
local monster = {}

monster.description = "Ancient Spawn Of Morgathla"
monster.experience = 70000
monster.outfit = {
	lookType = 1055,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}
monster.events = {
"AncientSpawnTeleport",
"AncientSpawnDeath",
}
monster.bosstiary = {
	bossRaceId = 1551,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 900000
monster.maxHealth = 900000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 325 }, -- platinum coin
	{ id = 3043, chance = 10000, maxCount = 1 }, -- crystal coin
	{ name = "great mana potion", chance = 80000, maxCount = 15 },
	{ name = "great spirit potion", chance = 80000, maxCount = 30 },
	{ name = "ultimate health potion", chance = 80000, maxCount = 38 },
	{ name = "ancient stone", chance = 40000, maxCount = 4 },
	{ name = "blue crystal shard", chance = 60000, maxCount = 10 },
	{ id = 3041, chance = 20000, maxCount = 2 }, -- blue gem
	{ id = 282, chance = 30000, maxCount = 3 }, -- giant shimmering pearl
	{ name = "green crystal shard", chance = 60000, maxCount = 11 },
	{ id = 3038, chance = 20000, maxCount = 2 }, -- green gem
	{ name = "huge chunk of crude iron", chance = 60000, maxCount = 10 },
	{ name = "magic sulphur", chance = 60000, maxCount = 10 },
	{ name = "mastermind potion", chance = 40000, maxCount = 4 },
	{ name = "onyx chip", chance = 40000, maxCount = 5 },
	{ id = 3039, chance = 20000, maxCount = 2 }, -- red gem
	{ name = "scarab coin", chance = 80000, maxCount = 75 },
	{ name = "small amethyst", chance = 80000, maxCount = 29 },
	{ name = "small diamond", chance = 70000, maxCount = 20 },
	{ name = "small emerald", chance = 70000, maxCount = 20 },
	{ name = "small ruby", chance = 70000, maxCount = 20 },
	{ name = "small topaz", chance = 80000, maxCount = 36 },
	{ name = "violet crystal shard", chance = 60000, maxCount = 8 },
	{ id = 3036, chance = 20000, maxCount = 2 }, -- violet gem
	{ id = 3037, chance = 20000, maxCount = 2 }, -- yellow gem
	{ name = "daramian waraxe", chance = 35000 },
	{ name = "luminous orb", chance = 35000 },
	{ id = 3046, chance = 35000 }, -- magic light wand
	{ id = 3098, chance = 35000 }, -- ring of healing
	{ name = "scarab amulet", chance = 35000 },
	{ name = "scarab pincers", chance = 35000 },
	{ name = "scarab shield", chance = 35000 },
	
	-- Semi-Raro
	{ name = "gold token", chance = 20000, maxCount = 2 },
	{ name = "silver token", chance = 20000, maxCount = 2 },
	{ name = "bonebreaker", chance = 15000 },
	{ name = "djinn blade", chance = 15000 },
	{ name = "enchanted chicken wing", chance = 15000 },
	{ name = "oriental shoes", chance = 15000 },
	{ name = "springsprout rod", chance = 15000 },
	{ name = "terra hood", chance = 15000 },
	{ name = "terra mantle", chance = 15000 },
	{ name = "terra legs", chance = 15000 },
	{ name = "underworld rod", chance = 15000 },
	{ name = "warrior's shield", chance = 15000 },
	
	-- Raro
	{ name = "depth scutum", chance = 8000 },
	{ name = "depth claws", chance = 8000 },
	{ name = "maxilla maximus", chance = 8000 },
	{ name = "plan for a makeshift armour", chance = 8000 },
	{ name = "ravager's axe", chance = 8000 },
	{ name = "scorpion sceptre", chance = 8000 },
	
	-- Muito Raro
	{ name = "candle stump", chance = 5000 },
	{ name = "crude wood planks", chance = 5000 },
	{ name = "earthborn titan armor", chance = 5000 },
	{ name = "fireborn giant armor", chance = 5000 },
	{ name = "robe of the underworld", chance = 5000 },
	{ name = "tinged pot", chance = 5000 }
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 850, maxDamage = -1650 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_LIFEDRAIN, minDamage = -335, maxDamage = -1280, range = 7, radius = 5, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -490, maxDamage = -1200, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -600, maxDamage = -1300, radius = 7, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -800, maxDamage = -1600, range = 7, radius = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true },
}

monster.defenses = {
	defense = 190,
	armor = 190,
	--	mitigation = ???,
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
