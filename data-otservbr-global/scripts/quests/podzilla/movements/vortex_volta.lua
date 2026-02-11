local teleportMove = MoveEvent()

function teleportMove.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return false
    end

    -- Se o item tiver action ID 33185 (mecanica original)
    if item:getActionId() == 33185 then
        -- Efeito 55 na posicao onde o player pisou
        position:sendMagicEffect(54)

        -- Teleporta o jogador para (32347, 32625, 7)
        local destination = Position(32347, 32625, 7)
        player:teleportTo(destination, true)

        -- Efeito 55 na posicao de destino
        destination:sendMagicEffect(54)

    -- Se o item tiver action ID 33186 (nova mecânica)
    elseif item:getActionId() == 33186 then
        -- Verifica se o jogador tem a storage Storage.U13_40.podzilla.acessopodzilla igual a 1
        local storageKey1 = Storage.U13_40.podzilla.acessopodzilla -- Defina um número único para essa storage
		local storageKey2 = Storage.U13_40.podzilla.habitantes
        if player:getStorageValue(storageKey1) == 1 then
            player:setStorageValue(storageKey1, 2) -- Atualiza para 2
			player:setStorageValue(storageKey2, 1)
        end

        -- Efeito 55 na posicao onde o player pisou
        position:sendMagicEffect(55)

        -- Teleporta o jogador para (33854, 32011, 6)
        local destination = Position(33854, 32011, 6)
        player:teleportTo(destination, true)

        -- Efeito 55 na posicao de destino
        destination:sendMagicEffect(54)
    end

    return true
end

-- Registra o MoveEvent no action ID 33185 (mecanica original)
teleportMove:aid(33185)
-- E também no action ID 33186 (nova mecanica)
teleportMove:aid(33186)

teleportMove:register()
