local actionId = 33150 -- Action ID que será monitorado
local poofEffect = CONST_ME_POFF -- Efeito visual a ser exibido quando a criatura for removida

-- Função chamada quando a criatura pisa no item com o Action ID
local function onCreatureStepIn(creature, item, position, fromPosition)
    -- Verifica se a criatura é um monstro e se o nome é "Atab"
    if creature:isMonster() and creature:getName():lower() == "rum barrel" and item:getActionId() == actionId then
       if not creature:hasCondition(CONDITION_PARALYZE) then
        -- Cria a condição de paralisia
        local condition = Condition(CONDITION_PARALYZE)
        condition:setParameter(CONDITION_PARAM_TICKS, -1) -- Define a duração como infinita
        condition:setFormula(-1.0, 0, -1.0, 0) -- Fórmula de velocidade zero
        creature:addCondition(condition) -- Aplica a condição ao monstro
        
        -- Redefine a velocidade diretamente para zero
        creature:changeSpeed(-creature:getSpeed()) -- Redefine a veloc
    end
    return true
end
end
-- Criação e registro do evento
local stepInEvent = MoveEvent()
stepInEvent:type("stepin") -- Tipo do evento: quando a criatura pisar no tile
stepInEvent:aid(actionId) -- Associa o evento ao Action ID definido
stepInEvent:onStepIn(onCreatureStepIn) -- Define a função a ser chamada ao pisar no item
stepInEvent:register() -- Registra o evento no sistema