local actionTeleport = Action()

function actionTeleport.onUse(player, item, fromPosition, target, toPosition)
    -- Obtém a posição atual do jogador
    local playerPosition = player:getPosition()

    -- Se o item tiver action ID 33189 (nova mecânica com lógica de posição)
    if item:getActionId() == 33189 then
        -- Verifica se o jogador está nas posições de origem (33848, 31995, 10), (33847, 31995, 10), (33849, 31995, 10)
        if (playerPosition.x == 33848 and playerPosition.y == 31995 and playerPosition.z == 10) or
           (playerPosition.x == 33847 and playerPosition.y == 31995 and playerPosition.z == 10) or
           (playerPosition.x == 33849 and playerPosition.y == 31995 and playerPosition.z == 10) then
            -- Teleporta o jogador para (33847, 31993, 10)
            local destination = Position(33847, 31993, 10)
            player:teleportTo(destination, true)

            -- Efeito de teletransporte na posição de destino
            destination:sendMagicEffect(54)

        -- Verifica se o jogador está nas posições (33847, 31993, 10), (33848, 31993, 10), (33849, 31993, 10)
        elseif (playerPosition.x == 33847 and playerPosition.y == 31993 and playerPosition.z == 10) or
               (playerPosition.x == 33848 and playerPosition.y == 31993 and playerPosition.z == 10) or
               (playerPosition.x == 33849 and playerPosition.y == 31993 and playerPosition.z == 10) then
            -- Teleporta o jogador para (33848, 31995, 10)
            local destination = Position(33848, 31995, 10)
            player:teleportTo(destination, true)

            -- Efeito de teletransporte na posição de destino
            destination:sendMagicEffect(54)
        else
            -- Caso o jogador não esteja em nenhuma posição válida
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você não está em uma posição válida para usar este teletransporte.")
        end

    -- Se o item tiver action ID 33190 (nova mecânica para outro teletransporte)
    elseif item:getActionId() == 33190 then
        -- Teleporta o jogador para a posição 33883, 31973, 10
        local destination = Position(33883, 31973, 10)
        player:teleportTo(destination, true)

        -- Efeito de teletransporte na posição de destino
        destination:sendMagicEffect(54)

    -- Se o item tiver action ID 33191 (nova funcionalidade)
    elseif item:getActionId() == 33191 then
        -- Verifica se o jogador está na posição específica (33861, 32012, 5)
        if playerPosition.x == 33861 and playerPosition.y == 32012 and playerPosition.z == 5 then
            -- Teleporta o jogador para (33919, 32010, 6)
            local destination = Position(33919, 32010, 6)
            player:teleportTo(destination, true)

            -- Efeito de teletransporte na posição de destino
            destination:sendMagicEffect(54)
        else
            -- Caso o jogador não esteja na posição esperada
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você precisa estar na posição correta para usar este teletransporte.")
        end
    end

    return true
end

-- Registra a ação para o Action ID 33189 (com a lógica de posições)
actionTeleport:aid(33189)
-- Registra a ação para o Action ID 33190 (teletransporte para a nova posição)
actionTeleport:aid(33190)
-- Registra a ação para o Action ID 33191 (nova funcionalidade)
actionTeleport:aid(33191)

actionTeleport:register()
