local teleportEvent = CreatureEvent("RandomTeleport")

local roomBounds = {
    fromPosition = Position(33704, 31532, 14), -- canto superior esquerdo da sala
    toPosition = Position(33714, 31545, 14)   -- canto inferior direito da sala
}

function teleportEvent.onThink(creature)
    if not creature:isMonster() then
        return true
    end

    local chance = math.random(1, 100)
    if chance <= 6 then -- 10% de chance de teleporte
        local newPosition = Position(
            math.random(roomBounds.fromPosition.x, roomBounds.toPosition.x),
            math.random(roomBounds.fromPosition.y, roomBounds.toPosition.y),
            roomBounds.fromPosition.z
        )
        creature:teleportTo(newPosition)
        newPosition:sendMagicEffect(CONST_ME_TELEPORT)
    end

    return true
end

teleportEvent:register()

