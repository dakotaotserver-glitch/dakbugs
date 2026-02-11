local actionId = 33025
local damage = 1200

-- Evento acionado quando o jogador pisa no item
local damageOnStepIn = MoveEvent()

function damageOnStepIn.onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() and item:getActionId() == actionId then
        -- Aplicar o dano ao jogador
        creature:addHealth(-damage, true, true) -- Remove vida do jogador

        -- Enviar um efeito sagrado na posição onde o jogador pisou
        position:sendMagicEffect(CONST_ME_HOLYDAMAGE)
    end
    return true
end

damageOnStepIn:type("stepin")
damageOnStepIn:aid(actionId)
damageOnStepIn:register()

