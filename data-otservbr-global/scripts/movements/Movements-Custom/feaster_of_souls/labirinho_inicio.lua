local teleportWithItemCheck = MoveEvent()

function teleportWithItemCheck.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- Verifica se o item tem o actionid correto
    if item:getActionId() == 33010 then
        -- Conta quantos itens com o ID 32703 o jogador tem
        local itemCount = player:getItemCount(32703)
        
        if itemCount >= 2 then
            -- Teleporta o jogador para a nova posição
            local destination = Position(33776, 31505, 13)
            player:teleportTo(destination)
            fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
            destination:sendMagicEffect(CONST_ME_TELEPORT)
            
            -- Remove 2 itens com o ID 32703 do jogador
           -- local itemToRemove = ItemType(32703)
           -- local countToRemove = 2
            player:removeItem(32703, 2)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa de pelo menos 2 death tolls para ser teletransportado.")
        end
    end
    return true
end

teleportWithItemCheck:type("stepin")
teleportWithItemCheck:aid(33010)
teleportWithItemCheck:register()
