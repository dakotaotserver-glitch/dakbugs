local config = {
    { position = { x = 32941, y = 32030, z = 7 }, destination = { x = 33774, y = 31347, z = 7 } },
    { position = { x = 33774, y = 31348, z = 7 }, destination = { x = 32941, y = 32031, z = 7 } },
}

local rascacoonShortcut = Action()

function rascacoonShortcut.onUse(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return false
    end

    -- Apenas jogadores normais (grupo 1) tem a restrição de level
    if player:getGroup():getId() == 1 and player:getLevel() < 140 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 140 to enter.")
        player:teleportTo(fromPosition, true)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return false
    end

    for _, v in pairs(config) do
        if Position(v.position) == item:getPosition() then
            player:teleportTo(Position(v.destination))
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            return true
        end
    end
    return false
end

for _, v in pairs(config) do
    rascacoonShortcut:position(v.position)
end
rascacoonShortcut:register()
