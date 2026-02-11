local addCharmItem = Action()

local CHARM_ITEM_ID = 61756        -- ID do item que da charm points
local CHARM_AMOUNT = 100           -- Quantidade de pontos de charme por uso
local MAX_ITEM_USES = 3            -- Quantidade maxima de usos permitida por jogador
local USAGE_TRACK_STORAGE = 12346  -- Storage para rastrear quantas vezes o item foi usado

function addCharmItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica quantas vezes o jogador ja usou o item
    local timesUsed = player:getStorageValue(USAGE_TRACK_STORAGE)
    if timesUsed < 0 then timesUsed = 0 end

    if timesUsed >= MAX_ITEM_USES then
        player:sendCancelMessage("Voce ja utilizou este item o numero maximo de vezes permitido (" .. MAX_ITEM_USES .. ").")
        return true
    end

    -- Adiciona pontos de charme via sistema oficial
    player:addCharmPoints(CHARM_AMOUNT)
    player:setStorageValue(USAGE_TRACK_STORAGE, timesUsed + 1)

    -- Envia mensagem de confirmacao
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu " .. CHARM_AMOUNT .. " pontos de charme.")

    -- Remove o item do inventario
    item:remove(1)
    return true
end

addCharmItem:id(CHARM_ITEM_ID)
addCharmItem:register()
