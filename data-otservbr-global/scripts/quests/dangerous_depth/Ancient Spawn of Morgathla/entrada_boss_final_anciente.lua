local useTeleportAction = Action()

-- Função para teletransportar o jogador
function useTeleportAction.onUse(player, item, fromPosition, target, toPosition)
    -- Verifica o Action ID do item usado
    if item:getActionId() == 33159 then
        -- Verifica se o jogador possui todas as storages necessárias
        if player:getStorageValue(65104) == 1 and player:getStorageValue(65105) == 1 and player:getStorageValue(65106) == 1 then
            -- Teleporta o jogador para a posição especificada
            player:teleportTo(Position(33681, 32382, 15))
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual de teleporte
        else
            -- Mensagem caso o jogador não tenha as storages necessárias
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa matar os boss da warzones 4, 5 e 6 para poder passar para a luta final!")
        end
    end

    return true -- Retorna true para que o uso do item seja considerado válido
end

-- Registra o Action ID associado à ação
useTeleportAction:aid(33159)
useTeleportAction:register()
