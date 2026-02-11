local useTeleportAction = Action()

-- Função para teletransportar o jogador
function useTeleportAction.onUse(player, item, fromPosition, target, toPosition)
    -- Verifica o Action ID do item usado
    if item:getActionId() == 33142 then
        -- Teleporta o jogador para a posição 33217, 31124, 14
        player:teleportTo(Position(33998, 31722, 9)) 
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual de teleporte
        player:say("You have been teleported to your destination!", TALKTYPE_MONSTER_SAY) -- Mensagem opcional

    elseif item:getActionId() == 33143 then
        -- Teleporta o jogador para a posição 33187, 31191, 7
        player:teleportTo(Position(34035, 31728, 10))
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual de teleporte
        player:say("You have been teleported to another destination!", TALKTYPE_MONSTER_SAY) -- Mensagem opcional
		
	elseif item:getActionId() == 33146 then
        -- Teleporta o jogador para a posição 33187, 31191, 7
        player:teleportTo(Position(34047, 31547, 10))
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual de teleporte
    end

    return true -- Retorna true para que o uso do item seja considerado válido
end

-- Registra os Action IDs
useTeleportAction:aid(33142)
useTeleportAction:aid(33143)
useTeleportAction:aid(33146)

-- Registra o evento no servidor
useTeleportAction:register()
