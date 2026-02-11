local actionId = 33147 -- Action ID que será monitorado
local poofEffect = CONST_ME_POFF -- Efeito visual a ser exibido quando a criatura for removida

-- Função chamada quando a criatura pisa no item com o Action ID
local function onCreatureStepIn(creature, item, position, fromPosition)
    -- Verifica se a criatura é um monstro e se o nome é "Atab"
    if creature:isMonster() and creature:getName():lower() == "atab" and item:getActionId() == actionId then
        -- Remove a criatura
        creature:remove()
        -- Aplica o efeito de "poff" na posição onde a criatura foi removida
        position:sendMagicEffect(poofEffect)
    end
    return true
end

-- Criação e registro do evento
local stepInEvent = MoveEvent()
stepInEvent:type("stepin") -- Tipo do evento: quando a criatura pisar no tile
stepInEvent:aid(actionId) -- Associa o evento ao Action ID definido
stepInEvent:onStepIn(onCreatureStepIn) -- Define a função a ser chamada ao pisar no item
stepInEvent:register() -- Registra o evento no sistema
