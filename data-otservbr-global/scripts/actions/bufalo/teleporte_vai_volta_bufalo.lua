local useTeleportAction = Action()

-- Função para teletransportar o jogador
function useTeleportAction.onUse(player, item, fromPosition, target, toPosition)
    -- Verifica o Action ID do item usado
    if item:getActionId() == 33144 then
        -- Teleporta o jogador para a posição 33217, 31124, 14
        player:teleportTo(Position(32872, 32371, 8)) 
        player:getPosition():sendMagicEffect(CONST_ME_POFF) -- Efeito visual de teleporte
        player:say("You have been teleported to your destination!", TALKTYPE_MONSTER_SAY) -- Mensagem opcional

    elseif item:getActionId() == 33145 then
        -- Teleporta o jogador para a posição 33187, 31191, 7
        player:teleportTo(Position(32800, 32365, 8))
        player:getPosition():sendMagicEffect(CONST_ME_POFF) -- Efeito visual de teleporte
        player:say("You have been teleported to another destination!", TALKTYPE_MONSTER_SAY) -- Mensagem opcional
    end

    return true -- Retorna true para que o uso do item seja considerado válido
end

-- Registra os Action IDs
useTeleportAction:aid(33144)
useTeleportAction:aid(33145)

-- Registra o evento no servidor
useTeleportAction:register()
