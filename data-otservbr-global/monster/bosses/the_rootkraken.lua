local mType = Game.createMonsterType("The Rootkraken")
local monster = {}

monster.description = "a The Rootkraken"
monster.experience = 700000
monster.outfit = {
	lookType = 1765,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}
monster.events = {
"RootkrakenDeath",
"rooktrkrakenTeleport",
"RootkrakenImmunity",
"RootkrakenKillStorage",


}

monster.health = 1000000
monster.maxHealth = 1000000
monster.race = "venom"
monster.corpse = 49120
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 30,
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
	{ name = "purple tome", chance = 1180 },
	{ name = "gold coin", chance = 60000, maxCount = 100 },
	{ name = "gold coin", chance = 60000, maxCount = 100 },
	{ name = "small emerald", chance = 9690, maxCount = 5 },
	{ name = "small amethyst", chance = 7250, maxCount = 5 },
	{ name = "small ruby", chance = 7430, maxCount = 5 },
	{ name = "small topaz", chance = 7470, maxCount = 5 },
	{ id = 3039, chance = 2220 }, -- red gem
	{ name = "demonic essence", chance = 14630 },
	{ name = "talon", chance = 3430 },
	{ name = "platinum coin", chance = 90540, maxCount = 8 },
	{ name = "might ring", chance = 1890 },
	{ id = 3049, chance = 2170 }, -- stealth ring
	{ name = "platinum amulet", chance = 680 },
	{ name = "orb", chance = 2854 },
	{ name = "gold ring", chance = 1050 },
	{ id = 3098, chance = 1990 }, -- ring of healing
	{ name = "giant sword", chance = 1980 },
	{ name = "ice rapier", chance = 1550 },
	{ name = "golden sickle", chance = 1440 },
	{ name = "fire axe", chance = 4030 },
	{ name = "devil helmet", chance = 1180 },
	{ name = "golden legs", chance = 440 },
	{ name = "magic plate armor", chance = 130 },
	{ name = "mastermind shield", chance = 480 },
	{ name = "demon shield", chance = 740 },
	{ name = "fire mushroom", chance = 19660, maxCount = 6 },
	{ name = "demon horn", chance = 14920 },
	{ name = "assassin star", chance = 12550, maxCount = 10 },
	{ name = "demonrage sword", chance = 70 },
	{ id = 7393, chance = 90 }, -- demon trophy
	{ name = "great mana potion", chance = 22220, maxCount = 3 },
	{ name = "ultimate health potion", chance = 19540, maxCount = 3 },
	{ name = "great spirit potion", chance = 18510, maxCount = 3 },



	{ name = "Ultimate Health Potion", chance = 10750, maxCount = 50 },
	{ name = "Ultimate Spirit Potion", chance = 10750, maxCount = 50 },
	{ name = "Supreme Health Potion", chance = 10750, maxCount = 50 },
	{ name = "Crystal Coin", chance = 10750, maxCount = 50 },
	{ name = "Platinum Coin", chance = 10750, maxCount = 50 },
	{ name = "Great Spirit Potion", chance = 10750, maxCount = 50 },
	{ name = "Great Mana Potion", chance = 10750, maxCount = 50 },
	
	
	{ name = "Amber with a Bug", chance = 2000 },
	{ name = "Giant Topaz", chance = 2000 },
	{ name = "Yellow Gem", chance = 2000 },
	{ name = "amber crossbow", chance = 2000 },
	{ name = "amber bow", chance = 2000 },
	{ name = "Amber Bludgeon", chance = 2000 },
	{ name = "Amber Cudgel", chance = 2000 },
	{ name = "Amber Sabre", chance = 2000 },
	{ name = "Amber Slayer", chance = 2000 },
	{ name = "Amber Axe", chance = 2000 },
	{ name = "Amber Greataxe", chance = 2000 },
	{ name = "amber rod", chance = 2000 },
	{ name = "Amber Wand", chance = 2000 },

}


monster.attacks = {
{ name = "melee", interval = 2000, chance = 100, minDamage = 800, maxDamage = -3270 },
{ name = "root", interval = 4000, chance = 8, target = true },
{ name = "fear", interval = 3500, chance = 6, target = true },
{ name = "holy_death_spell_aoe", interval = 2000, chance = 15, minDamage = -1200, maxDamage = -4000, target = false },
{ name = "earth_spell_aoe", interval = 2000, chance = 15, minDamage = -1200, maxDamage = -4000, target = false },
{ name = "life_ice_aoe", interval = 2000, chance = 8, minDamage = -1200, maxDamage = -4000, target = false },
{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -2500, range = 4, radius = 1, shootEffect = 11, effect = 264,  target = true },
}

monster.defenses = {
	defense = 80,
	armor = 100,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 1050, maxDamage = 3860, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
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
