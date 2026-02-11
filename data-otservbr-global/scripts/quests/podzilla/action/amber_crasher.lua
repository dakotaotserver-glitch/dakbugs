local action = Action()

function action.onUse(player, item, fromPosition, itemEx, toPosition, target, isHotkey)
    local itemIdToCheck = 49120 
    local storageKey = 65125 
    local rewardItemId = 46628 

    if item.itemid == itemIdToCheck then
        if player:getStorageValue(storageKey) ~= 1 then
            player:addItem(rewardItemId, 1)
            player:setStorageValue(storageKey, 1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu um Amber Crusher!")
        end

        return false
    end

    return true
end

action:id(49120)
action:register()
