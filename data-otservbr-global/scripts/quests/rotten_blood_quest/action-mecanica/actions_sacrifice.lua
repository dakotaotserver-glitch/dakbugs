local sacrificialPlate = Action()

function sacrificialPlate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local kv = player:kv():scoped("rotten-blood-quest")
    local access = kv:get("access") or 0

    if access >= 4 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have access.")
        return true
    end

    if player:getItemCount(32594) < 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Find the keeper of the sanguine tears and offer his life fluids to the sanguine master of this realm.")
        return false
    end

    -- Primeiro sacrifício
    if access < 2 then
        if player:removeItem(32594, 1) then
            kv:set("access", 2)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your sacrifice has been accepted. The sanguine master demands a second offering.")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have the required item.")
        end
        return true
    end

    -- Segundo sacrifício
    if access == 2 then
        if player:removeItem(32594, 1) then
            kv:set("access", 4)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your sacrifices have been accepted by the sanguine master of this realm. You may now access the sacred fluid.")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have the required item.")
        end
        return true
    end

    return true
end

sacrificialPlate:id(43891)
sacrificialPlate:register()
