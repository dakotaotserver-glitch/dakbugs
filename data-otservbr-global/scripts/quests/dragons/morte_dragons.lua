local areaFromPosition = Position(33194, 30935, 13) -- Posição inicial da área
local areaToPosition = Position(33224, 30978, 13) -- Posição final da área
local resetTime = 30 * 60 * 1000 -- Tempo para resetar as storages (30 minutos em milissegundos)

-- Tabela de criaturas e suas respectivas storages
local creaturesStorages = {
    ["maliz"] = 65092,
    ["vengar"] = 65093,
    ["bruton"] = 65094,
    ["greedok"] = 65095,
    ["vilear"] = 65096,
    ["crultor"] = 65097,
    ["despor"] = 65098
}

-- Tabela das posições e do item a ser removido ao matar a criatura "despor"
local itemPositionsDespor = {
    Position(33208, 30964, 13),
    Position(33209, 30964, 13),
    Position(33210, 30964, 13),
    Position(33211, 30964, 13)
}
local itemToRemove = 44718
local returnTime = 60 * 1000 -- Tempo para retorno dos itens (1 minuto em milissegundos)

-- Evento para criaturas rastreadas
local deathEvent = CreatureEvent("CreatureDeathDragon")

-- Evento para monitorar a morte dos jogadores
local playerDeathEvent = CreatureEvent("PlayerDeathResetStorages")

-- Função para resetar as storages dos jogadores na área
local function resetStoragesInArea(fromPos, toPos, storageList)
    local playersInArea = Game.getPlayers()
    for _, player in ipairs(playersInArea) do
        local playerPosition = player:getPosition()
        if playerPosition:isInRange(fromPos, toPos) and playerPosition.z == fromPos.z then
            -- Reseta cada storage na lista para -1
            for _, storageId in ipairs(storageList) do
                player:setStorageValue(storageId, -1)
            end
           -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your storages have been reset.")
        end
    end
end

-- Função para resetar storages individuais para um jogador específico (usado quando o jogador morre)
local function resetPlayerStorages(player, storageList)
    for _, storageId in ipairs(storageList) do
        player:setStorageValue(storageId, -1)
    end
   -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your storages have been reset due to your death.")
end

-- Função para remover e restaurar itens quando "despor" morrer
local function handleDesporItems()
    -- Remover os itens das posições especificadas
    for _, position in ipairs(itemPositionsDespor) do
        local item = Tile(position):getItemById(itemToRemove)
        if item then
            item:remove()
        end
    end

    -- Restaurar os itens após o tempo especificado
    addEvent(function()
        for _, position in ipairs(itemPositionsDespor) do
            Game.createItem(itemToRemove, 1, position)
        end
    end, returnTime)
end

-- Função chamada quando uma das criaturas monitoradas morre
function deathEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified)
    local creatureName = creature:getName():lower() -- Obtém o nome da criatura em minúsculo

    -- Verifica se a criatura está na lista de criaturas para rastrear
    local storageId = creaturesStorages[creatureName]
    if not storageId then
        return true -- Se a criatura não estiver na lista, termina a execução
    end

    -- Lista de storages a serem resetadas (inicializa com a storage da criatura morta)
    local storageResetList = {storageId}

    -- Verifica se a criatura é "despor" para remover e restaurar os itens
    if creatureName == "despor" then
        handleDesporItems()
    end

    -- Obtém todos os jogadores dentro da área especificada
    local playersInArea = Game.getPlayers()
    for _, player in ipairs(playersInArea) do
        local playerPosition = player:getPosition()
        -- Verifica se o jogador está dentro da área e no mesmo andar (z)
        if playerPosition:isInRange(areaFromPosition, areaToPosition) and playerPosition.z == areaFromPosition.z then
            -- Verifica se o jogador participou da morte da criatura
            if creature:getDamageMap()[player:getId()] then
                player:setStorageValue(storageId, 1) -- Define a storage apropriada para o jogador
               -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received storage " .. storageId .. " for killing " .. creatureName .. ".")

                -- Vincula o evento de morte do jogador para garantir que a `storage` seja resetada caso ele morra
                player:registerEvent("PlayerDeathResetStorages")

                -- Sinalizador para indicar que a storage deve ser resetada quando morrer
                player:setStorageValue(65099, 1)
            end
        end
    end

    -- Agenda o reset das storages após o tempo especificado
    addEvent(resetStoragesInArea, resetTime, areaFromPosition, areaToPosition, storageResetList)

    return true
end

-- Função chamada quando o jogador morre
function playerDeathEvent.onDeath(player, corpse, killer, mostDamageKiller, unjustified)
    -- Verifica se o jogador possui o sinalizador 65099 indicando que possui storages a serem resetadas
    if player:getStorageValue(65099) == 1 then
        -- Reseta todas as storages dos bosses monitorados
        resetPlayerStorages(player, {65092, 65093, 65094, 65095, 65096, 65097, 65098})
        player:setStorageValue(65099, -1) -- Remove o sinalizador de reset
    end
    return true
end

-- Registra os eventos de morte no servidor
deathEvent:register()
playerDeathEvent:register()
