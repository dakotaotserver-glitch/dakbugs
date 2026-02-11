local respawnItem = Action()
local itemRespawnTime = 300 * 1000 -- 2 minutos (120 segundos)

function respawnItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Armazena a posição e o action id do item
    local itemPosition = fromPosition
    local itemActionId = item:getActionId()
    local itemId = item:getId()

    -- Remove o item
    item:remove()
   -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "O item sera restaurado em 2 minutos.")

    -- Adiciona evento para recriar o item após 2 minutos
    addEvent(function()
        local newItem = Game.createItem(itemId, 1, itemPosition)
        if newItem then
            newItem:setActionId(itemActionId)
        end
    end, itemRespawnTime)

    return true
end

respawnItem:aid(33157)
respawnItem:register()
