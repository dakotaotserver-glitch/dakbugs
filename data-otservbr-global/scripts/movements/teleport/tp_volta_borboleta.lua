-- Script para teleporte automático ao passar sobre o item (Action ID 33148)
local stepTeleportAction = MoveEvent()

function stepTeleportAction.onStepIn(creature, item, position, fromPosition)
    -- Verifica se é um jogador e se o Action ID é 33148
    if creature:isPlayer() and item:getActionId() == 33172 then
        -- Teleporta para a posição 34071, 31441, 11
        local destination = Position(32630, 32329, 7) 
        creature:teleportTo(destination)
        destination:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte na nova posição
        --creature:say("You have been teleported!", TALKTYPE_MONSTER_SAY)
    end
    return true
end

-- Registra o evento para o Action ID 33148
stepTeleportAction:aid(33172)
stepTeleportAction:register()