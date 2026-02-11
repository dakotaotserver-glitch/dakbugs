local actionIds = {33194, 33195, 33196, 33197} -- Lista de Action IDs válidos
local transformDuration = 60 * 1000 -- 30 segundos de transformação (em milissegundos)
local transformedItemId = 39949 -- ID do item transformado

local itemTransform = Action()

-- Função para reverter o item ao seu estado original
local function revertItem(itemPosition, originalItemId, actionId)
    local item = Tile(itemPosition):getItemById(transformedItemId) -- Encontrar o item transformado na posição
    if item then
        item:transform(originalItemId) -- Reverte o item para o ID original
        item:setActionId(actionId) -- Mantém o Action ID original
        itemPosition:sendMagicEffect(224) -- Exibir efeito de puff na posição ao reverter
    end
end

function itemTransform.onUse(player, item, fromPosition, target, toPosition)
    local itemActionId = item:getActionId()
    local originalItemId = item:getId() -- Armazena o ID original do item
    local itemPosition = item:getPosition() -- Posição do item

    -- Verifica se o item tem um dos Action IDs válidos
    if table.contains(actionIds, itemActionId) then
        -- Exibir efeito de puff na posição do item
        itemPosition:sendMagicEffect(4)
        
        -- Transformar o item temporariamente
        item:transform(transformedItemId)
        
        -- Agendar a reversão do item após 30 segundos
        addEvent(revertItem, transformDuration, itemPosition, originalItemId, itemActionId)
        
        return true
    end
    return false
end

itemTransform:aid(33194, 33195, 33196, 33197)
itemTransform:register()