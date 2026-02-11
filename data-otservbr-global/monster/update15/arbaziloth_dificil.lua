local mType = Game.createMonsterType("Arbaziloth_dificil")
local monster = {}

monster.name = "Arbaziloth"
monster.description = "Arbaziloth"
monster.experience = 25000
monster.outfit = {
	lookType = 1798,
}

monster.events = {
		"ArbazilothDeath",
		"BossKillCounter",
		"GiveStorageOnKill",
}

monster.bosstiary = {
	bossRaceId = 2594,
	bossRace = RARITY_BANE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "blood"
monster.corpse = 50029
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "UH? WHAT.. ?. HOW... ?", yell = false },
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
	-- Common
	{ name = "crystal coin", chance = 100000, maxCount = 3 },
	{ name = "platinum coin", chance = 100000, maxCount = 75 }, -- Média de 75 (50-100)
	
	-- Uncommon
	{ name = "strong mana potion", chance = 90000, maxCount = 20 },
	{ name = "great mana potion", chance = 80000, maxCount = 15 },
	{ name = "great spirit potion", chance = 70000, maxCount = 6 },
	{ name = "ultimate mana potion", chance = 60000, maxCount = 40 },
	{ name = "ultimate health potion", chance = 50000, maxCount = 20 },
	{ name = "supreme health potion", chance = 40000, maxCount = 10 },
	{ name = "ultimate spirit potion", chance = 30000, maxCount = 15 },
	{ id = 3037, chance = 15000, maxCount = 2 }, -- yellow gem
	{ id = 3039, chance = 15000, maxCount = 2 }, -- red gem
	{ id = 3041, chance = 15000, maxCount = 2 }, -- blue gem

	-- Semi-Rare
	{ name = "devil helmet", chance = 10000 },
	{ name = "fire axe", chance = 9000 },
	{ name = "fire sword", chance = 9000 },
	{ name = "giant sword", chance = 8000 },
	{ name = "gold ring", chance = 8000 },
	{ name = "golden sickle", chance = 7000 },
	{ name = "ice rapier", chance = 7000 },
	{ name = "magma amulet", chance = 6000 },
	{ name = "magma legs", chance = 6000 },
	{ name = "might ring", chance = 5000 },
	{ name = "platinum amulet", chance = 5000 },
	{ name = "purple tome", chance = 5000 },
	{ name = "silver amulet", chance = 4000 },
	{ name = "skull staff", chance = 4000 },
	{ name = "spellweaver's robe", chance = 3000 },
	{ name = "stone skin amulet", chance = 3000 },
	{ name = "strange helmet", chance = 3000 },
	{ name = "underworld rod", chance = 3000 },
	{ name = "wand of inferno", chance = 3000 },
	{ id = 6299, chance = 10000}, -- death ring
	{ id = 3052, chance = 7000 }, -- life ring
	{ id = 3098, chance = 4000 }, -- ring of healing

	-- Rare
	{ name = "arbaziloth shoulder piece", chance = 2000 },
	{ name = "demon shield", chance = 2000 },
	{ name = "demonbone amulet", chance = 1500 },
	{ name = "demonrage sword", chance = 1500 },
	{ name = "giant amethyst", chance = 1500 },
	{ name = "giant emerald", chance = 1500 },
	{ name = "giant ruby", chance = 1500 },
	{ name = "giant sapphire", chance = 1500 },
	{ name = "magic plate armor", chance = 1000 },

	-- Very Rare
	{ name = "demon claws", chance = 500 },
	{ name = "demon in a green box", chance = 400 },--2
	{ name = "inferniarch arbalest", chance = 400 },
	{ name = "inferniarch battleaxe", chance = 400 },
	{ name = "inferniarch blade", chance = 400 },
	{ name = "inferniarch bow", chance = 400 },
	{ name = "inferniarch flail", chance = 400 },
	{ name = "inferniarch greataxe", chance = 400 },
	{ name = "inferniarch rod", chance = 400 },
	{ name = "inferniarch slayer", chance = 400 },
	{ name = "inferniarch wand", chance = 400 },
	{ name = "inferniarch warhammer", chance = 400 },
	{ name = "maliceforged helmet", chance = 400 },--2
	{ name = "hellstalker visor", chance = 400 },--2
	{ name = "dreadfire headpiece", chance = 400 },--2
	{ name = "demonfang mask", chance = 400 },--2
	{ name = "demon mengu", chance = 400 },--2
	{ id = 50061, chance = 500 }, --2
}

monster.attacks = {
    { name = "melee", interval = 2000, chance = 100, minDamage = -428, maxDamage = -630 }, 
    { name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -427, maxDamage = -730, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
    { name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -960, maxDamage = -1350, radius = 7, effect = CONST_ME_SMALLCLOUDS, target = false },
    { name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -630, maxDamage = -930, radius = 7, effect = CONST_ME_SOUND_WHITE, target = false },
    { name = "arbazilothwave", interval = 2000, chance = 15, minDamage = -850, maxDamage = -1050, target = true },
    { name = "arbazilothspells", interval = 2000, chance = 25, minDamage = -620, maxDamage = -760, target = true },
    { name = "combat", interval = 2000, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -620, maxDamage = -760, radius = 2, range = 7, shootEffect = CONST_ANI_SMALLSTONE, effect = CONST_ME_PINK_ENERGY_SPARK, target = true }
}

monster.defenses = {
	defense = 65,
	armor = 74,
	mitigation = 2.2,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 33 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

local lookTypes = { 1798, 1799, 1800, 1801, 1802 }

local function updateLookType(monster)
    local healthPercent = (monster:getHealth() / monster:getMaxHealth()) * 100
	local lookIndex = math.ceil((100 - healthPercent) / 20)
    lookIndex = math.max(lookIndex, 1) 
    monster:setOutfit({lookType = lookTypes[lookIndex]})
end

mType.onThink = function(monster, interval)
    if not monster then return true end
    updateLookType(monster)
    return true
end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
