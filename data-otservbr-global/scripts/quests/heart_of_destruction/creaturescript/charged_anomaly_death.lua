local config = {
    bossName = "Anomaly",
    bossPosition = Position(32271, 31249, 14), -- Posição exata onde o chefe deve ser criado
}

local monsterTable = {
    [1] = 72500,
    [3] = 145000,
    [5] = 217500,
    [7] = 275500,
}

local chargedAnomalyDeath = CreatureEvent("ChargedAnomalyDeath")

function chargedAnomalyDeath.onDeath(creature)
    if not creature then
        return true
    end

    -- Obter o valor do GlobalStorage atual
    local anomalyGlobalStorage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly)
    if anomalyGlobalStorage < 0 then
        anomalyGlobalStorage = 0 -- Inicializa se não estiver definido
    end

    -- Determina a quantidade de saúde a ser removida com base na fase atual
    local healthRemove = monsterTable[anomalyGlobalStorage]
    if not healthRemove then
      return true
    end

    -- Cria o monstro "Anomaly" na posição especificada no config
    local boss = Game.createMonster(config.bossName, config.bossPosition, false, true)
    if not boss then
       return true
    end

  boss:addHealth(-healthRemove)

    Game.setStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly, anomalyGlobalStorage + 1)

    return true
end

chargedAnomalyDeath:register()
