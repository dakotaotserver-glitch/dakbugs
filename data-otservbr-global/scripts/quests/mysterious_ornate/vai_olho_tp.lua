local useTeleportAction = Action()

-- Função para teletransportar o jogador
function useTeleportAction.onUse(player, item, fromPosition, target, toPosition)
    -- Verifica o Action ID do item usado
    if item:getActionId() == 33153 then
        player:teleportTo(Position(32815, 32903, 14)) 
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) 

    end

    return true -- Retorna true para que o uso do item seja considerado válido
end

useTeleportAction:aid(33153)
useTeleportAction:register()
