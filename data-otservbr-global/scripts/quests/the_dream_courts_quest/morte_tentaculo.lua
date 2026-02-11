local nightmareTendrilRespawnEvent = CreatureEvent("NightmareTendrilRespawnEvent")

local respawnInterval = 15000 -- Intervalo de 15 segundos para respawn
local centralPosition = Position(32208, 32047, 15) -- Posição central para o respawn
local respawnRadius = 5 -- Raio de 5x5x5x5 ao redor da posição central

-- Função para gerar uma posição aleatória dentro de um raio 5x5x5x5
local function getRandomPosition(center, radius)
    local randomX = math.random(center.x - radius, center.x + radius)
    local randomY = math.random(center.y - radius, center.y + radius)
    return Position(randomX, randomY, center.z)
end

-- Função que spawna um "Nightmare Tendril" na posição fornecida
local function respawnNightmareTendril()
    local randomPosition = getRandomPosition(centralPosition, respawnRadius)

    -- Verifica se a posição está disponível para spawn
    local tile = Tile(randomPosition)
    if tile and not tile:getTopCreature() then
        Game.createMonster("Nightmare Tendril", randomPosition)
    else
        print("Posição bloqueada, Nightmare Tendril não pode nascer.")
    end
end

function nightmareTendrilRespawnEvent.onDeath(creature)
    if creature and creature:getName():lower() == "nightmare tendril" then
        -- Cria um evento para recriar o "Nightmare Tendril" 15 segundos após a morte
        addEvent(function()
            respawnNightmareTendril()
        end, respawnInterval)
    end
    return true
end

-- Registrar o evento de morte
nightmareTendrilRespawnEvent:register()

