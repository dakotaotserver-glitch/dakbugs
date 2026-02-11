local itemID = 32591
local resetActionID = 33173 -- Action ID do tile que reseta a storage 33016
local triggerActionID = 33012 -- Action ID do tile que ativa o dano
local resetTilePosition = {x = 33769, y = 31504, z = 13} -- Posição fixa do tile com Action ID 33173
local storageKey = 33014 -- Chave de armazenamento para marcar se o jogador usou o item
local damageAppliedStorage = 33016 -- Chave de armazenamento para rastrear se o dano já foi aplicado
local damageDelay = 5 -- Tempo em segundos para o jogador usar o item
local allowedArea = { -- Área permitida para usar o item e para aplicar o dano
    from = {x = 33793, y = 31496, z = 14},
    to = {x = 33819, y = 31518, z = 14}
}

-- Função para verificar se o jogador está na área permitida
local function isPlayerInAllowedArea(player)
    local playerPos = player:getPosition()
    if playerPos.x >= allowedArea.from.x and playerPos.x <= allowedArea.to.x and
       playerPos.y >= allowedArea.from.y and playerPos.y <= allowedArea.to.y and
       playerPos.z == allowedArea.from.z then
        return true
    end
    return false
end

-- Função para aplicar o dano ao jogador
local function applyDamage(player)
    if player and player:isPlayer() and isPlayerInAllowedArea(player) then
        local maxHealth = player:getMaxHealth()
        local damage = math.ceil(maxHealth / 2) -- Calcula metade da vida máxima
        player:addHealth(-damage) -- Aplica dano fixo de metade da vida
        player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your health has been reduced to half because you did not use the required item in time.")
        player:setStorageValue(damageAppliedStorage, 1) -- Marca que o dano foi aplicado
    end
end

local action = Action()

-- Função chamada quando o jogador usa um item
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == itemID then
        if isPlayerInAllowedArea(player) then
            player:removeItem(itemID, 1)
            player:setStorageValue(storageKey, 1) -- Marca que o jogador usou o item
            player:setStorageValue(damageAppliedStorage, 1) -- Garante proteção contra o dano
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have used the item in time and avoided taking damage.")
            player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot use this item outside the allowed area.")
        end
    end
    return true
end

-- Evento chamado quando o jogador pisa em um tile
local playerEnterRoom = MoveEvent("PlayerEnterRoom")

function playerEnterRoom.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if player then
        -- Reset da estorage 33016 na posição específica com Action ID 33173
        if position.x == resetTilePosition.x and position.y == resetTilePosition.y and position.z == resetTilePosition.z and item:getActionId() == resetActionID then
            player:setStorageValue(damageAppliedStorage, -1) -- Reseta o valor para -1
           -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your damage protection has been reset.")
            return true
        end

        -- Verificação para programar o dano ao pisar no tile com Action ID 33012
        if item:getActionId() == triggerActionID and isPlayerInAllowedArea(player) then
            player:setStorageValue(storageKey, -1) -- Reseta a storage para marcar que o jogador ainda não usou o item

            -- Programa o dano após o tempo definido
            addEvent(function()
                local player = Player(creature:getId()) -- Garante que o jogador ainda é válido
                if player then
                    local itemUsed = player:getStorageValue(storageKey)
                    local damageApplied = player:getStorageValue(damageAppliedStorage)

                    -- Aplica dano se:
                    -- - O jogador não usou o item (storageKey == -1)
                    -- - O jogador ainda não tem proteção (damageAppliedStorage ~= 1)
                    if itemUsed == -1 and damageApplied ~= 1 and isPlayerInAllowedArea(player) then
                        applyDamage(player)
                    end
                end
            end, damageDelay * 1000)
        end
    end
    return true
end

-- Registrando o evento de entrada e saída da sala
action:id(itemID)
action:register()
playerEnterRoom:aid(resetActionID) -- Associando o Action ID 33173 ao evento
playerEnterRoom:aid(triggerActionID) -- Associando o Action ID 33012 ao evento
playerEnterRoom:register()
