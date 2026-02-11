local function createSpawnAnomalyRoom(valueGlobalStorage)
    -- Criar as criaturas "Spark of Destruction" ao redor da posição central
    Game.createMonster("Spark of Destruction", Position(32267, 31253, 14), false, true)
    Game.createMonster("Spark of Destruction", Position(32274, 31255, 14), false, true)
    Game.createMonster("Spark of Destruction", Position(32274, 31249, 14), false, true)
    Game.createMonster("Spark of Destruction", Position(32267, 31249, 14), false, true)

    -- Criar o "Charged Anomaly" na posição central
    local createdAnomaly = Game.createMonster("Charged Anomaly", Position(32271, 31249, 14), false, true)

    -- Verificação se o monstro foi criado corretamente
    if createdAnomaly then
    end

    -- Atualiza o GlobalStorage para a próxima fase
    Game.setStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly, valueGlobalStorage + 1)
   -- print("GlobalStorage atualizado para: " .. Game.getStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly))
end

local anomalyTransform = CreatureEvent("AnomalyTransform")

function anomalyTransform.onThink(creature)
    if not creature then
        return false
    end

    -- Verifica o valor do GlobalStorage e a porcentagem de vida atual da criatura
    local anomalyGlobalStorage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly)

    -- Inicializa o GlobalStorage se ele não estiver definido corretamente
    if anomalyGlobalStorage < 0 then
        anomalyGlobalStorage = 0
        Game.setStorageValue(GlobalStorage.HeartOfDestruction.ChargedAnomaly, 0)
    end

    local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
   -- print("HP atual: " .. hpPercent .. "% | GlobalStorage atual: " .. anomalyGlobalStorage)

    -- Executa a transformação para cada fase corretamente
    if hpPercent <= 75 and anomalyGlobalStorage == 0 then
       -- print("Fase 1: Vida <= 75% - Iniciando transformação para a próxima fase.")
        creature:remove()
        createSpawnAnomalyRoom(anomalyGlobalStorage)
    elseif hpPercent <= 50 and anomalyGlobalStorage == 2 then
        --print("Fase 2: Vida <= 50% - Iniciando transformação para a próxima fase.")
        creature:remove()
        createSpawnAnomalyRoom(anomalyGlobalStorage)
    elseif hpPercent <= 25 and anomalyGlobalStorage == 4 then
       -- print("Fase 3: Vida <= 25% - Iniciando transformação para a próxima fase.")
        creature:remove()
        createSpawnAnomalyRoom(anomalyGlobalStorage)
    elseif hpPercent <= 5 and anomalyGlobalStorage == 6 then
       -- print("Fase 4: Vida <= 5% - Iniciando transformação para a próxima fase.")
        creature:remove()
        createSpawnAnomalyRoom(anomalyGlobalStorage)
    end

    return true
end

anomalyTransform:register()
