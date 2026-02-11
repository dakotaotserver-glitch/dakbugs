local mType = Game.createMonsterType("Atab Arena")
local monster = {}

monster.name = "Atab"
monster.description = "a Atab"
monster.experience = 6800
monster.outfit = {
	lookType = 1701,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2438,
	bossRace = RARITY_BANE,
}


monster.health = 8100
monster.maxHealth = 8100
monster.race = "undead"
monster.corpse = 44444
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	{ text = "Mmmhaarrrgh!", yell = false },
}

monster.loot = {
	{ id = 3582, chance = 70080, maxCount = 8 }, -- ham
	{ name = "soul orb", chance = 35000 },
	{ name = "great mana potion", chance = 33000, maxCount = 3 },
	{ name = "great health potion", chance = 33000, maxCount = 3 },
	{ name = "flask of demonic blood", chance = 30000, maxCount = 4 },
	{ name = "small amethyst", chance = 24950, maxCount = 3 },
	{ name = "assassin star", chance = 24670, maxCount = 10 },
	{ name = "small diamond", chance = 15700, maxCount = 3 },
	{ name = "small ruby", chance = 15333, maxCount = 3 },
	{ name = "small emerald", chance = 15110, maxCount = 3 },
	{ name = "onyx arrow", chance = 14480, maxCount = 15 },
	{ name = "opal", chance = 4580, maxCount = 3 },
	{ name = "idol of Tukh", chance = 3000 },
	{ id = 282, chance = 3000 }, -- giant shimmering pearl (brown)
	{ name = "spiked squelcher", chance = 2200 },
	{ name = "knight armor", chance = 1980 },
	{ name = "crystal of the Mitmah", chance = 1250 },
	{ name = "war axe", chance = 1230 },
	{ name = "violet gem", chance = 1060 },
	{ name = "damaged armor plates", chance = 990 },
	{ name = "green gem", chance = 880 },
	{ name = "gold-brocaded cloth", chance = 840 },
	{ name = "wooden spellbook", chance = 620 },
	{ id = 3481, chance = 370 }, -- closed trap
	{ id = 3019, chance = 100 }, -- demonbone amulet
	{ name = "gold nuggets", chance = 730 },
	{ name = "ruby necklace", chance = 730 },
	--{ name = "Atab's Mitmah Helmet", chance = 730 }, 
	{ name = "crystal of the Mitmah", chance = 1250 },
	{ name = "Broken Mitmah Necklace", chance = 730 },
	{ id = 44729, chance = 1000 },
	{ id = 44433, chance = 1000 },
	{ id = 44672, chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -735, effect = 1 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -450, maxDamage = -622, range = 6, shootEffect = 39, effect = 17, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -650, range = 3, radius = 3, shootEffect = 26, effect = 10, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -2000, maxDamage = -3800, range = 6, radius = 8, shootEffect = 27, effect = 48, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -712, radius = 5, effect = 18, target = false },
	
}

monster.defenses = {
	defense = 86,
	armor = 86,
	mitigation = 2.37,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 450, maxDamage = 549, effect = 15, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
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
