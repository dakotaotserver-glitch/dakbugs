local storageValue = 65100
local initialDamageAmount = 100 -- Dano inicial
local damageInterval = 2000 -- 2 segundos (em milissegundos)
local fromPosition = {x = 33792, y = 31494, z = 15}
local toPosition = {x = 33819, y = 31517, z = 15}
local playerDamageTracker = {} -- Tabela para armazenar o dano de cada jogador

-- Função que verifica se o jogador está dentro da área
local function isPlayerInArea(player, fromPos, toPos)
    local playerPos = player:getPosition()
    return playerPos.x >= fromPos.x and playerPos.x <= toPos.x and
           playerPos.y >= fromPos.y and playerPos.y <= toPos.y and
           playerPos.z == fromPos.z
end

-- Função que aplica o dano contínuo crescente
local function applyContinuousDamage()
    local players = Game.getPlayers() -- Pega todos os jogadores online
    for _, player in ipairs(players) do
        if player:getStorageValue(storageValue) == 1 and isPlayerInArea(player, fromPosition, toPosition) then
            local playerId = player:getId()

            -- Se o jogador ainda não estiver na tabela de rastreamento de dano, inicialize com o dano inicial
            if not playerDamageTracker[playerId] then
                playerDamageTracker[playerId] = initialDamageAmount
            end

            local damageAmount = playerDamageTracker[playerId]
            player:addHealth(-damageAmount) -- Aplica o dano ao jogador
            player:getPosition():sendMagicEffect(CONST_ME_MORTAREA) -- Efeito visual de dano

            -- Aumentar o dano em 100 para a próxima iteração
            playerDamageTracker[playerId] = damageAmount + 100
        else
            -- Se o jogador sair da área ou não tiver a storage, resetar o dano
            playerDamageTracker[player:getId()] = nil
        end
    end

    -- Continuar aplicando dano a cada 2 segundos
    addEvent(applyContinuousDamage, damageInterval)
end

-- Inicia o loop de dano contínuo crescente
applyContinuousDamage()
