local config = {
    creatureName = "Murcion",  -- Nome da criatura original
    ichgahalName = "Ichgahal", -- Nome da nova criatura
    bakragoreName = "Bakragore", -- Nome da criatura adicional
    targetItemIds = {42852, 12083, 12351, 12349, 12350, 12352}, -- IDs dos itens que podem acionar a lógica
    createdItemId = 42851,     -- ID do item que será criado quando Murcion ou Bakragore pisar
    ichgahalCreatedItemId = 43294, -- ID do item que será criado quando Ichgahal pisar
    ichgahalTransformedItemId = 43295, -- ID do item que o item de Ichgahal será transformado
    actionId = 33097,          -- Action ID que será atribuída ao item criado por Murcion
    ichgahalActionId = 33105,  -- Action ID que será atribuída ao item criado por Ichgahal
    ichgahalTransformedActionId = 33106,  -- Action ID que será atribuída ao item transformado por Ichgahal
    bakragoreActionId = 33126, -- Action ID atribuída ao item criado por Bakragore
    playerItemId = 43367,      -- ID do item que será criado quando o player pisar no item alvo
    playerActionId = 33127,    -- Action ID atribuída ao item criado por um player
    removeTime = 14 * 1000,    -- Tempo para remover o item criado por Murcion ou Bakragore (em milissegundos)
    transformTime = 4 * 1000,  -- Tempo em milissegundos para transformar o item de Ichgahal (4 segundos)
    removeTransformedTime = 6 * 1000,  -- Tempo para remover o item transformado (6 segundos após a transformação)
    playerRemoveTime = 5 * 1000, -- Tempo para remover o item criado por um player (em milissegundos)
    positionFrom = Position(33032, 32387, 15), -- Posição inicial da área
    positionTo = Position(33054, 32411, 15) -- Posição final da área
}

-- Função para verificar se o item que a criatura pisou é um dos targetItemIds
local function isTargetItem(itemId)
    for _, targetId in ipairs(config.targetItemIds) do
        if itemId == targetId then
            return true
        end
    end
    return false
end

-- Função chamada quando uma criatura (ou player) pisa no item alvo
function onStepIn(creature, item, position, fromPosition)
    -- Verifica se a entidade é uma criatura
    if creature:isCreature() then
        local creatureName = creature:getName():lower()

        -- Se o item é um dos targetItemIds
        if isTargetItem(item:getId()) then
            -- Se a criatura for "Murcion"
            if creatureName == config.creatureName:lower() then
                -- Cria o item correspondente para "Murcion"
                local createdItem = Game.createItem(config.createdItemId, 1, fromPosition)
                if createdItem then
                    -- Atribui a action ID ao item criado
                    createdItem:setActionId(config.actionId)
                end

                -- Remove o item após 14 segundos
                addEvent(function()
                    local tile = Tile(fromPosition)
                    if tile then
                        local itemToRemove = tile:getItemById(config.createdItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end, config.removeTime)

            -- Se a criatura for "Ichgahal"
            elseif creatureName == config.ichgahalName:lower() then
                -- Cria o item correspondente para "Ichgahal"
                local createdItem = Game.createItem(config.ichgahalCreatedItemId, 1, fromPosition)
                if createdItem then
                    -- Atribui a action ID ao item criado
                    createdItem:setActionId(config.ichgahalActionId)
                end

                -- Após 4 segundos, transforma o item criado em outro item
                addEvent(function()
                    local tile = Tile(fromPosition)
                    if tile then
                        local itemToTransform = tile:getItemById(config.ichgahalCreatedItemId)
                        if itemToTransform then
                            itemToTransform:transform(config.ichgahalTransformedItemId)
                            -- Atribui a nova action ID após a transformação
                            itemToTransform:setActionId(config.ichgahalTransformedActionId)
                        end
                    end
                end, config.transformTime)

                -- Remove o item transformado após 6 segundos da transformação
                addEvent(function()
                    local tile = Tile(fromPosition)
                    if tile then
                        local itemToRemove = tile:getItemById(config.ichgahalTransformedItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end, config.transformTime + config.removeTransformedTime)

            -- Se a criatura for "Bakragore"
            elseif creatureName == config.bakragoreName:lower() then
                -- Cria o item correspondente para "Bakragore"
                local createdItem = Game.createItem(config.createdItemId, 1, fromPosition)
                if createdItem then
                    -- Atribui a action ID ao item criado
                    createdItem:setActionId(config.bakragoreActionId)
                end

                -- Remove o item após 14 segundos
                addEvent(function()
                    local tile = Tile(fromPosition)
                    if tile then
                        local itemToRemove = tile:getItemById(config.createdItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end, config.removeTime)

            -- Se for um jogador e ele estiver dentro da área
            elseif creature:isPlayer() and position:isInRange(config.positionFrom, config.positionTo) then
                -- Cria o item correspondente para o player
                local createdItem = Game.createItem(config.playerItemId, 1, fromPosition)
                if createdItem then
                    -- Atribui a action ID ao item criado
                    createdItem:setActionId(config.playerActionId)
                end

                -- Remove o item após 5 segundos
                addEvent(function()
                    local tile = Tile(fromPosition)
                    if tile then
                        local itemToRemove = tile:getItemById(config.playerItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end, config.playerRemoveTime)
            end
        end
    end
    return true
end

-- Registro do script para o evento de entrar no item
local stepInAction = MoveEvent()

function stepInAction.onStepIn(creature, item, position, fromPosition)
    return onStepIn(creature, item, position, fromPosition)
end

-- Registra a ação para os itens alvo (IDs: 42852, 12083, 12351, 12349, 12350, 12352)
for _, targetId in ipairs(config.targetItemIds) do
    stepInAction:id(targetId)
end
stepInAction:register()
