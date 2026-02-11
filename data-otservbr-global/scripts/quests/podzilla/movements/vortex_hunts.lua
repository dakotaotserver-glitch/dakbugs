local teleportMove = MoveEvent()

function teleportMove.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return false
    end

    -- Teleportes existentes
    if item:getActionId() == 33187 then
        position:sendMagicEffect(54)
        local destination = Position(33826, 32000, 8)
        player:teleportTo(destination, true)
        destination:sendMagicEffect(54)

    elseif item:getActionId() == 33188 then
        position:sendMagicEffect(54)
        local destination = Position(33829, 32024, 7)
        player:teleportTo(destination, true)
        destination:sendMagicEffect(54)

    elseif item:getActionId() == 33192 then
        position:sendMagicEffect(55)
        local destination = Position(33858, 32068, 8)
        player:teleportTo(destination, true)
        destination:sendMagicEffect(54)

    elseif item:getActionId() == 33193 then
        position:sendMagicEffect(55)
        local destination = Position(33848, 32059, 8)
        player:teleportTo(destination, true)
        destination:sendMagicEffect(54)

    -- ✅ Nova funcionalidade para o Action ID 33198
    elseif item:getActionId() == 33198 then
        local storageValue = player:getStorageValue(Storage.U13_40.podzilla.salaboss)

        -- Se a storage for maior ou igual a 1, teleportar para 33964, 32000, 11
        if storageValue >= 1 then
            local destination = Position(33964, 32000, 11)
            player:teleportTo(destination, true)
            destination:sendMagicEffect(224)
        else
            -- Se nao tiver storage ou for menor que 1, teleportar para 33853, 31984, 11
            local destination = Position(33853, 31984, 11)
            player:teleportTo(destination, true)
            destination:sendMagicEffect(224)
        end
    end

    return true
end

-- Registra os MoveEvents
teleportMove:aid(33187)
teleportMove:aid(33188)
teleportMove:aid(33192)
teleportMove:aid(33193)
teleportMove:aid(33198) -- ✅ Novo Action ID registrado

teleportMove:register()
