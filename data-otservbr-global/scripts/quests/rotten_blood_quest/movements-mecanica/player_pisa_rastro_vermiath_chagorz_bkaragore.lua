local config1 = {
    fromPosition = Position(33032, 32356, 15), -- Posição inicial do intervalo
    toPosition = Position(33054, 32376, 15),   -- Posição final do intervalo
    itemIdRange = {43358, 43366},              -- Intervalo de IDs dos pisos
    createdItemId = 43297,                     -- ID do item que será criado
    actionId = 33118,                          -- Action ID que será atribuído ao item criado
    removeTime = 5 * 1000                      -- Tempo para remover o item criado (5 segundos)
}

local config2 = {
    fromPosition = Position(33032, 32325, 15), -- Posição inicial do intervalo
    toPosition = Position(33056, 32346, 15),   -- Posição final do intervalo
    itemIdRange = {43358, 43366},              -- Intervalo de IDs dos pisos
    createdItemId = 43589,                     -- ID do item que será criado
    actionId = 33122,                          -- Action ID que será atribuído ao item criado
    transformedItemId = 43625,                 -- ID do item para o qual o item será transformado
    transformedActionId = 33123,               -- Action ID do item transformado
    transformTime = 4 * 1000,                  -- Tempo para transformar o item (4 segundos)
    removeTimeAfterTransform = 3 * 1000        -- Tempo para remover o item transformado (3 segundos)
}

local config3 = {
    fromPosition = Position(33032, 32387, 15), -- Posição inicial do intervalo
    toPosition = Position(33054, 32411, 15),   -- Posição final do intervalo
    itemIdRange = {43358, 43366},              -- Intervalo de IDs dos pisos
    createdItemId = 43297,                     -- ID do item que será criado
    actionId = 33128,                          -- Action ID que será atribuído ao item criado
    removeTime = 5 * 1000                      -- Tempo para remover o item criado (5 segundos)
}

local configBakragore = {
    fromPosition = Position(33032, 32387, 15), -- Posição inicial do intervalo
    toPosition = Position(33054, 32411, 15),   -- Posição final do intervalo
    itemIdRange = {43358, 43366},              -- Intervalo de IDs dos pisos
    createdItemId = 42851,                     -- ID do item que será criado
    actionId = 33129,                          -- Action ID que será atribuído ao item criado
    removeTime = 14 * 1000                     -- Tempo para remover o item criado (14 segundos)
}

-- Função chamada quando o jogador ou criatura sai de um piso específico
function onStepOut(creature, item, position, fromPosition)
    -- Verifica se é a criatura Bakragore
    if creature:getName() == "Bakragore" then
        local creaturePos = creature:getPosition()

        -- Verifica se a posição da criatura está dentro da área (configBakragore)
        if creaturePos:isInRange(configBakragore.fromPosition, configBakragore.toPosition) and
           item:getId() >= configBakragore.itemIdRange[1] and item:getId() <= configBakragore.itemIdRange[2] then
            
            -- Cria o item na posição de onde Bakragore saiu (configBakragore)
            local createdItem = Game.createItem(configBakragore.createdItemId, 1, position)

            if createdItem then
                -- Atribui o action ID ao item criado (configBakragore)
                createdItem:setActionId(configBakragore.actionId)
            end

            -- Remove o item após 14 segundos (configBakragore)
            addEvent(function()
                if createdItem then
                    local tile = Tile(position)
                    if tile then
                        local itemToRemove = tile:getItemById(configBakragore.createdItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end
            end, configBakragore.removeTime)
        end
        return true
    end

    -- Verifica se a entidade é um jogador
    if creature:isPlayer() then
        local playerPos = creature:getPosition()

        -- Verifica para o primeiro conjunto de configurações (config1)
        if playerPos:isInRange(config1.fromPosition, config1.toPosition) and 
           item:getId() >= config1.itemIdRange[1] and item:getId() <= config1.itemIdRange[2] then
           
            -- Cria o item na posição de onde o jogador saiu (config1)
            local createdItem = Game.createItem(config1.createdItemId, 1, position)
            
            if createdItem then
                -- Atribui o action ID ao item criado (config1)
                createdItem:setActionId(config1.actionId)
            end

            -- Remove o item após 5 segundos (config1)
            addEvent(function()
                if createdItem then
                    local tile = Tile(position)
                    if tile then
                        local itemToRemove = tile:getItemById(config1.createdItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end
            end, config1.removeTime)

        -- Verifica para o segundo conjunto de configurações (config2)
        elseif playerPos:isInRange(config2.fromPosition, config2.toPosition) and 
           item:getId() >= config2.itemIdRange[1] and item:getId() <= config2.itemIdRange[2] then

            -- Cria o item na posição de onde o jogador saiu (config2)
            local createdItem = Game.createItem(config2.createdItemId, 1, position)

            if createdItem then
                -- Atribui o action ID ao item criado (config2)
                createdItem:setActionId(config2.actionId)
            end

            -- Transforma o item após 4 segundos (config2)
            addEvent(function()
                if createdItem then
                    local tile = Tile(position)
                    if tile then
                        local itemToTransform = tile:getItemById(config2.createdItemId)
                        if itemToTransform then
                            -- Remove o item antigo
                            itemToTransform:remove()
                            -- Cria o novo item transformado
                            local transformedItem = Game.createItem(config2.transformedItemId, 1, position)
                            if transformedItem then
                                transformedItem:setActionId(config2.transformedActionId)
                            end

                            -- Remove o item transformado após 2 segundos
                            addEvent(function()
                                if transformedItem then
                                    local tileAfterTransform = Tile(position)
                                    if tileAfterTransform then
                                        local itemToRemove = tileAfterTransform:getItemById(config2.transformedItemId)
                                        if itemToRemove then
                                            itemToRemove:remove()
                                        end
                                    end
                                end
                            end, config2.removeTimeAfterTransform)
                        end
                    end
                end
            end, config2.transformTime)

        -- Verifica para o terceiro conjunto de configurações (config3)
        elseif playerPos:isInRange(config3.fromPosition, config3.toPosition) and 
           item:getId() >= config3.itemIdRange[1] and item:getId() <= config3.itemIdRange[2] then

            -- Cria o item na posição de onde o jogador saiu (config3)
            local createdItem = Game.createItem(config3.createdItemId, 1, position)

            if createdItem then
                -- Atribui o action ID ao item criado (config3)
                createdItem:setActionId(config3.actionId)
            end

            -- Remove o item após 5 segundos (config3)
            addEvent(function()
                if createdItem then
                    local tile = Tile(position)
                    if tile then
                        local itemToRemove = tile:getItemById(config3.createdItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                        end
                    end
                end
            end, config3.removeTime)
        end
    end

    return true
end

-- Registro do script para o evento de sair do piso
local stepOutAction = MoveEvent()

function stepOutAction.onStepOut(creature, item, position, fromPosition)
    return onStepOut(creature, item, position, fromPosition)
end

-- Registra a ação para os pisos no intervalo de IDs (43358 a 43366)
for i = config1.itemIdRange[1], config1.itemIdRange[2] do
    stepOutAction:id(i)
end

stepOutAction:register()
