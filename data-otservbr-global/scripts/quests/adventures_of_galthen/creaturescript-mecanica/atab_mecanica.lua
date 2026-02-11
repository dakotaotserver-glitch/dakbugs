local atabTeleportEvent = CreatureEvent("AtabTeleportEvent")

local teleportPosition = Position(34034, 31562, 10) -- Posição para onde os jogadores serão teleportados
local spawnPosition = Position(34039, 31562, 10) -- Posição onde a nova criatura "Atab Arena" será criada
local healthThreshold = 40 -- Porcentagem de vida para acionar o teleporte
local radiusX, radiusY, radiusZ = 10, 10, 10 -- Raio de alcance em torno da criatura

local STORAGE_TELEPORT_TRIGGERED = 10001 -- Armazenamento específico para rastrear se o teleporte já foi acionado para a criatura

-- Função para criar os Atab Minions ao redor da posição dada
local function createMinionsAroundPosition(centerPosition, minionsCount)
    local possibleOffsets = { {-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1} }
    local createdPositions = {}

    -- Embaralha a lista de offsets para garantir que os minions sejam criados em posições aleatórias
    for i = #possibleOffsets, 2, -1 do
        local j = math.random(1, i)
        possibleOffsets[i], possibleOffsets[j] = possibleOffsets[j], possibleOffsets[i]
    end

    -- Cria os minions em posições aleatórias ao redor do centro
    for i = 1, minionsCount do
        local offset = possibleOffsets[i]
        local minionPosition = Position(centerPosition.x + offset[1], centerPosition.y + offset[2], centerPosition.z)
        if Game.createMonster("Atab Minions", minionPosition) then
            minionPosition:sendMagicEffect(CONST_ME_TELEPORT)
            table.insert(createdPositions, minionPosition)
        end
    end
end

function atabTeleportEvent.onThink(creature)
    -- Verifica se a criatura é o monstro correto
    if not creature:isMonster() or creature:getName():lower() ~= "atab" then
        return true
    end

    -- Verifica se o teleporte já foi acionado para essa criatura específica usando storage
    if creature:getStorageValue(STORAGE_TELEPORT_TRIGGERED) == 1 then
        return true
    end

    -- Calcula a porcentagem de vida atual
    local healthPercentage = (creature:getHealth() / creature:getMaxHealth()) * 100

    -- Verifica se a vida está abaixo ou igual ao limiar
    if healthPercentage <= healthThreshold then
        creature:setStorageValue(STORAGE_TELEPORT_TRIGGERED, 1) -- Marca o teleporte como já acionado para essa criatura

        -- Obtém todos os jogadores no raio especificado ao redor da criatura
        local spectators = Game.getSpectators(creature:getPosition(), false, false, radiusX, radiusX, radiusY, radiusY, radiusZ, radiusZ)

        -- Filtra apenas jogadores e armazena em uma lista
        local players = {}
        for _, spectator in ipairs(spectators) do
            if spectator:isPlayer() then
                table.insert(players, spectator)
            end
        end

        -- Define o número aleatório de jogadores a serem teleportados (entre 1 e o número total de jogadores disponíveis, máximo de 5)
        local playersToTeleport = math.random(1, math.min(5, #players))

        -- Seleciona aleatoriamente os jogadores que serão teleportados
        for i = 1, playersToTeleport do
            local index = math.random(1, #players)
            local player = table.remove(players, index) -- Remove o jogador da lista para evitar seleção duplicada
            if player then
                player:teleportTo(teleportPosition)
                teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            end
        end

        -- Remove a criatura original "Atab"
        creature:remove()

        -- Cria uma nova criatura de nome "Atab Arena" na posição especificada
        local newAtab = Game.createMonster("Atab Arena", spawnPosition)
        if newAtab then
            spawnPosition:sendMagicEffect(CONST_ME_TELEPORT)

            -- Chance de 50% para criar de 1 a 8 minions ao redor do Atab Arena
            if math.random(100) <= 50 then
                local minionsCount = math.random(1, 8) -- Número aleatório de minions entre 1 e 8
                createMinionsAroundPosition(spawnPosition, minionsCount)
            end
        end
    end

    return true
end

atabTeleportEvent:register()
