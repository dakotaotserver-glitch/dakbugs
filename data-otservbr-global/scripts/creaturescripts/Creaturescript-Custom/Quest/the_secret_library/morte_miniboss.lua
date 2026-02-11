-- Definindo a tabela de armazenamento e o tempo de reset
local creaturesToStorages = {
    ["The Spellstealer"] = 65028,
    ["The Scion of Havoc"] = 65029,
    ["The Devourer of Secrets"] = 65030,
    ["Brother Chill"] = 65031,
    ["Brother Freeze"] = 65032
}

local resetInterval = 3600  -- 1 hora em segundos

-- Função para resetar o armazenamento
local function resetStorages()
    for _, storageId in pairs(creaturesToStorages) do
        -- Itera por todos os jogadores e reseta o armazenamento
        for _, player in ipairs(Game.getPlayers()) do
            if player:getStorageValue(storageId) == 1 then
                player:setStorageValue(storageId, 0)
            end
        end
    end
end

-- Função para agendar o reset a cada intervalo
local function scheduleStorageReset()
    addEvent(function()
        resetStorages()
        scheduleStorageReset()  -- Agende o próximo reset
    end, resetInterval * 1000)  -- Convertendo segundos para milissegundos
end

-- Função para lidar com a morte da criatura
local creatureDeathEvent = CreatureEvent("CreatureDeathStorage")

function creatureDeathEvent.onDeath(creature, corpse, killer)
    -- Obtém a posição da criatura morta
    local creaturePosition = creature:getPosition()

    -- Define o raio de alcance (20 tiles em X, Y e Z)
    local radiusX, radiusY, radiusZ = 20, 20, 20

    -- Obtém todos os jogadores dentro do raio de 20 tiles ao redor da posição da criatura morta
    local spectators = Game.getSpectators(creaturePosition, false, true, radiusX, radiusX, radiusY, radiusY, -radiusZ, radiusZ)

    -- Verifica se a criatura morta está na lista de criaturas que devem dar storage
    local storage = creaturesToStorages[creature:getName()]
    if storage then
        -- Para cada jogador encontrado dentro do raio
        for _, spectator in ipairs(spectators) do
            if spectator:isPlayer() then
                local player = spectator
                -- Atribui a storage para o jogador
                player:setStorageValue(storage, 1)
            end
        end
    end

    return true
end

creatureDeathEvent:register()

-- Iniciar o agendamento de reset
scheduleStorageReset()
