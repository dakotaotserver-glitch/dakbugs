-- Script para teleporte automático ao passar sobre o item (Action ID 33148)
local stepTeleportAction = MoveEvent()

function stepTeleportAction.onStepIn(creature, item, position, fromPosition)
    -- Verifica se é um jogador e se o Action ID é 33148
    if creature:isPlayer() and item:getActionId() == 33148 then
        -- Teleporta para a posição 34071, 31441, 11
        local destination = Position(34071, 31441, 11)
        creature:teleportTo(destination)
        destination:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte na nova posição
        creature:say("You have been teleported!", TALKTYPE_MONSTER_SAY)
    end
    return true
end

-- Registra o evento para o Action ID 33148
stepTeleportAction:aid(33148)
stepTeleportAction:register()

-- Script para teleporte ao clicar no item (Action ID 33149)
local useTeleportAction = Action()

function useTeleportAction.onUse(player, item, fromPosition, target, toPosition)
    -- Verifica se o Action ID é 33149
    if item:getActionId() == 33149 then
        -- Teleporta para a posição 34071, 31446, 11
        local destination = Position(34071, 31446, 11)
        player:teleportTo(destination)
        destination:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte na nova posição
        player:say("You have been teleported to your destination!", TALKTYPE_MONSTER_SAY)
    end
    return true
end

-- Registra o Action ID 33149 para a ação de uso
useTeleportAction:aid(33149)
useTeleportAction:register()
