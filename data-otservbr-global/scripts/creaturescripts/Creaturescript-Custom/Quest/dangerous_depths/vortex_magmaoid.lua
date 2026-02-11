local actionId = 33083

-- Evento acionado quando uma criatura pisa no item
local onStepInEvent = MoveEvent()

function onStepInEvent.onStepIn(creature, item, position, fromPosition)
    if item:getActionId() == actionId then
        if creature:getName() == "The Mega Magmaoid" then
            -- Efeito de fogo na posição do "The Mega Magmaoid"
            position:sendMagicEffect(CONST_ME_HITBYFIRE)
            
            -- Curar de 2000 a 5000 pontos de vida
            local healAmount = math.random(2000, 5000)
            creature:addHealth(healAmount)
        elseif creature:isPlayer() then
            -- Jogador recebe dano de 1000 a 3000 pontos de vida
            local damageAmount = math.random(1000, 3000)
            creature:addHealth(-damageAmount, true, true) -- Remove vida do jogador
            
            -- Efeito visual na posição do jogador
            position:sendMagicEffect(CONST_ME_HITBYFIRE)
        end
    end
    return true
end

onStepInEvent:type("stepin")
onStepInEvent:aid(actionId)
onStepInEvent:register()
