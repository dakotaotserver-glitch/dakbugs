local goshnarsSpiteDamageEvent = CreatureEvent("WeakSpotDamage")
local storageValue = 65100
local resetTime = 1800 -- Tempo em segundos para resetar a storage
local radius = 30 -- Raio de ação (12 tiles em todas as direções)

-- Função para adicionar storage a todos os jogadores no raio
local function applyStorageToPlayers(position)
    local players = Game.getSpectators(position, false, true, radius, radius, radius, radius)
    for _, player in ipairs(players) do
        if player:isPlayer() then
            player:setStorageValue(storageValue, 1)
           -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Advanced!") -- Enviar mensagem para o jogador
            
            -- Resetar a storage após 1 minuto
            addEvent(function()
                player:setStorageValue(storageValue, -1) -- Resetar storage após o tempo
--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Storage reset!") -- Mensagem de reset
            end, resetTime * 1000) -- Conversão para milissegundos
        end
    end
end

-- Evento de dano
function goshnarsSpiteDamageEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:isMonster() and creature:getName():lower() == "a weak spot" then
        if attacker and attacker:isPlayer() then
            applyStorageToPlayers(creature:getPosition())
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

-- Registrar o evento
goshnarsSpiteDamageEvent:register()
