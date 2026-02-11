local teleportScourgeEvent = Action()

local requiredStorages = {65028, 65029, 65030, 65031, 65032}
local scourgeOriginalPosition = Position(32726, 32710, 11)
local scourgeNewPosition = Position(32726, 32727, 11)
local scourgeName = "The Scourge of Oblivion"
local summonCreatures = {"Imp Intruder", "Invading Demon", "Ravenous Beyondling", "Rift Breacher", "Rift Minion", "Rift Spawn", "Yalahari Despoiler"}
local respawnInterval = 2 * 60 * 1000  -- 1 minuto em milissegundos
local respawnEventId = nil  -- Armazena o ID do evento de respawn para cancelamento
local resetPosition = Position(32726, 32734, 11) -- Posição central para o reset de storages
local resetRadius = 30 -- Raio para redefinição de storages

-- Função para criar as criaturas ao redor de uma posição
local function summonCreaturesAroundPosition(position)
    local positionsAround = {
        Position(position.x + 1, position.y, position.z),
        Position(position.x - 1, position.y, position.z),
        Position(position.x, position.y + 1, position.z),
        Position(position.x, position.y - 1, position.z),
        Position(position.x + 1, position.y + 1, position.z),
        Position(position.x + 1, position.y - 1, position.z),
        Position(position.x - 1, position.y + 1, position.z),
        Position(position.x - 1, position.y - 1, position.z)
    }

    for i, creatureName in ipairs(summonCreatures) do
        local summonPosition = positionsAround[i]
        if summonPosition then
            Game.createMonster(creatureName, summonPosition)
        end
    end
end

-- Função para limpar a sala de criaturas
local function clearRoom(position)
    local radiusX, radiusY, radiusZ = 20, 20, 20
    local creaturesInRoom = Game.getSpectators(position, false, false, radiusX, radiusX, radiusY, radiusY, -radiusZ, radiusZ)
    for _, creature in ipairs(creaturesInRoom) do
        if creature:isMonster() then
            -- Remover todas as criaturas da sala
            creature:remove()
        end
    end
end

-- Função para iniciar o respawn periódico
local function startPeriodicRespawn(position)
    respawnEventId = addEvent(function()
        summonCreaturesAroundPosition(position)
        startPeriodicRespawn(position)
    end, respawnInterval)
end

-- Função para parar o respawn periódico
local function stopPeriodicRespawn()
    if respawnEventId then
        stopEvent(respawnEventId)
        respawnEventId = nil
    end
end

-- Função para lidar com a morte de The Scourge of Oblivion
local function onScourgeDeath()
    stopPeriodicRespawn()  -- Para o respawn periódico
    clearRoom(scourgeNewPosition)  -- Limpa a sala de todas as criaturas
end

-- Função para resetar storages dos jogadores em uma área
local function resetPlayerStorages()
    local playersInArea = Game.getSpectators(resetPosition, false, true, resetRadius, resetRadius, resetRadius, resetRadius)
    for _, player in ipairs(playersInArea) do
        for _, storage in ipairs(requiredStorages) do
            player:setStorageValue(storage, 0)
        end
    end
end

-- Função para lidar com o uso do item
function teleportScourgeEvent.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o jogador possui todas as storages necessárias
    for _, storage in ipairs(requiredStorages) do
        if player:getStorageValue(storage) < 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa derrotar todos os mini-bosses para teleportar The Scourge of Oblivion.")
            return true
        end
    end

    -- Transformar o item em outro ID e criar efeito de raio
    item:transform(28139)
    fromPosition:sendMagicEffect(171)

    -- Tenta encontrar a criatura 'The Scourge of Oblivion' na posição original
    local scourge = Tile(scourgeOriginalPosition):getTopCreature()
    if scourge and scourge:getName():lower() == scourgeName:lower() then
        -- Teleporta a criatura para a nova posição
        scourge:teleportTo(scourgeNewPosition)
        scourgeNewPosition:sendMagicEffect(171)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Scourge of Oblivion foi teleportado para a arena!")

        -- Criar criaturas ao redor da nova posição e iniciar respawn periódico
        summonCreaturesAroundPosition(scourgeNewPosition)
        startPeriodicRespawn(scourgeNewPosition)

        -- Vincular evento de morte de "The Scourge of Oblivion"
        scourge:registerEvent("onScourgeDeath")

        -- Resetar storages dos jogadores na área especificada
        resetPlayerStorages()
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Scourge of Oblivion nao foi encontrado na posicao original.")
    end

    return true
end

teleportScourgeEvent:aid(33033) -- Action ID do item
teleportScourgeEvent:register()

-- Função para lidar com a morte de "The Scourge of Oblivion"
local scourgeDeathEvent = CreatureEvent("onScourgeDeath")

function scourgeDeathEvent.onDeath(creature)
    if creature:getName():lower() == scourgeName:lower() then
        onScourgeDeath()
    end
    return true
end

scourgeDeathEvent:register()
