local mType = Game.createMonsterType("Bakragore")
local monster = {}

monster.description = "Bakragore"
monster.experience = 15000000
monster.outfit = {
	lookType = 1671,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RottenBloodBakragoreDeath",
}

monster.bosstiary = {
	bossRaceId = 2367,
	bossRace = RARITY_NEMESIS,
}

monster.health = 660000
monster.maxHealth = 660000
monster.race = "undead"
monster.corpse = 44012
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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

monster.summon = {
	maxSummons = 8,
	summons = {
		{ name = "Mushroom", chance = 100, interval = 1000, count = 4 },
		{ name = "Pillar Of Dark Energy", chance = 100, interval = 1000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Light ... darkens!", yell = false },
	{ text = "Light .. the ... darkness!", yell = false },
	{ text = "Darkness ... is ... light!", yell = false },
	{ text = "WILL ... PUNISH ... YOU!", yell = false },
	{ text = "RAAAR!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 8938, maxCount = 200 },
	{ name = "supreme health potion", chance = 8938, maxCount = 300 },
	{ name = "ultimate mana potion", chance = 11433, maxCount = 300 },
	{ name = "ultimate spirit potion", chance = 11433, maxCount = 300 },
	{ name = "berserk potion", chance = 10938, maxCount = 90 },
	{ name = "bullseye potion", chance = 10938, maxCount = 90 },
	{ name = "mastermind potion", chance = 10938, maxCount = 30 },
	{ name = "blue gem", chance = 10570, maxCount = 10 },
	{ name = "giant amethyst", chance = 10570, maxCount = 10 },
	{ name = "giant emerald", chance = 10570, maxCount = 10 },
	{ name = "giant ruby", chance = 10570, maxCount = 10 },
	{ name = "giant sapphire", chance = 10570, maxCount = 10 },
	{ name = "giant topaz", chance = 10570, maxCount = 10 },
	{ name = "violet gem", chance = 10970, maxCount = 10 },
	{ name = "yellow gem", chance = 10970, maxCount = 10 },
	{ name = "figurine of bakragore", chance = 10970 },
	{ name = "bakragore's amalgamation", chance = 570 },
	{ name = "spiritual horseshoe", chance = 470 },
	{ id = 43895, chance = 360 }, -- Bag you covet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 1200, maxDamage = -3600 },
	{ name = "largedeathring2", interval = 4000, chance = 15, minDamage = -2500, maxDamage = -4500, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -2600, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -1000, maxDamage = -1500, radius = 7, effect = 32, target = false },
	{ name = "speed", interval = 2000, chance = 7, speedChange = -300, radius = 5, effect = 20, target = false, duration = 10000 },
	{ name = "largeenergyring2", interval = 4000, chance = 15, minDamage = -3200, maxDamage = -4500, target = false },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -1200, maxDamage = -2200, range = 7, radius = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -2500, maxDamage = -3500, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -2500, maxDamage = -3500, length = 8, spread = 0, effect = CONST_ME_ELECTRICALSPARK, target = false },

}

monster.defenses = {
	defense = 135,
	armor = 135,
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_HEALING, minDamage = 2500, maxDamage = 3500, effect = 14, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 700, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
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