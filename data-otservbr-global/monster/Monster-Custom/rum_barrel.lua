local mType = Game.createMonsterType("Rum Barrel")
local monster = {}

monster.description = "Rum Barrel"
monster.experience = 0
monster.outfit = {
    lookTypeEx = 2519,
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 0
monster.speed = 30 -- Mantém uma velocidade padrão

monster.events = {
    "RumBarrelDeath",
	
-- Adiciona o evento customizado
}

monster.changeTarget = {
    interval = 0,
    chance = 0,
}

monster.strategiesTarget = {
    nearest = 0,
}

monster.flags = {
    summonable = false,
    attackable = true,
    hostile = false,
    convinceable = false,
    pushable = true, -- Permite que a criatura seja arrastada
    rewardBoss = false,
    illusionable = false,
    canPushItems = false,
    canPushCreatures = false,
    staticAttackChance = 1000000,
    targetDistance = 0,
    runHealth = 0,
    healthHidden = false,
    isBlockable = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}

monster.light = {
    level = 0,
    color = 0,
}

monster.voices = {
    interval = 5000,
    chance = 10,
}

monster.loot = {}

monster.attacks = {}

monster.defenses = {
    defense = 60,
    armor = 82,
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

monster.immunities = {}

mType:register(monster)

-- Evento para impedir o movimento

