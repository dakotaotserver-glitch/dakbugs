local teleportEvent = MoveEvent()

function teleportEvent.onStepIn(creature, item, position, fromPosition)
    if not creature or not creature:isMonster() then
        return true
    end

    local creatureName = creature:getName():lower()

    -- Caso Izcandar Champion Of Winter pise no item com actionID 33060
    if creatureName == "izcandar champion of winter" and item:getActionId() == 33060 then
        local targetPositionWinter = Position(32208, 32027, 15)
        local targetPositionSummer = Position(32213, 32027, 15)
        local summerNewPosition = Position(32204, 32045, 14)

        -- Teleporta Izcandar Champion Of Winter
        creature:teleportTo(targetPositionWinter)
        targetPositionWinter:sendMagicEffect(CONST_ME_TELEPORT)

        -- Encontra e teleporta Izcandar Champion Of Summer
        local summerCreature = Tile(targetPositionSummer):getTopCreature()
        if summerCreature and summerCreature:getName():lower() == "izcandar champion of summer" then
            summerCreature:teleportTo(summerNewPosition)
            summerNewPosition:sendMagicEffect(CONST_ME_TELEPORT)
        end

    -- Caso Izcandar Champion Of Summer pise no item com actionID 33059
    elseif creatureName == "izcandar champion of summer" and item:getActionId() == 33059 then
        local targetPositionSummer = Position(32213, 32027, 15)
        local targetPositionWinter = Position(32208, 32027, 15)
        local winterNewPosition = Position(32212, 32046, 14)

        -- Teleporta Izcandar Champion Of Summer
        creature:teleportTo(targetPositionSummer)
        targetPositionSummer:sendMagicEffect(CONST_ME_TELEPORT)

        -- Encontra e teleporta Izcandar Champion Of Winter
        local winterCreature = Tile(targetPositionWinter):getTopCreature()
        if winterCreature and winterCreature:getName():lower() == "izcandar champion of winter" then
            winterCreature:teleportTo(winterNewPosition)
            winterNewPosition:sendMagicEffect(CONST_ME_TELEPORT)
        end
    end

    return true
end

-- Registro dos eventos de movimento
teleportEvent:type("stepin")
teleportEvent:aid(33060) -- Action ID para Izcandar Champion Of Winter
teleportEvent:aid(33059) -- Action ID para Izcandar Champion Of Summer
teleportEvent:register()
