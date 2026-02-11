local femalePlayerTransform = MoveEvent()

local actionId = 33167
local itemPosition = Position(32940, 31457, 2) -- Posicao do item a ser transformado
local newItemPosition = Position(32940, 31458, 2) -- Posicao do novo item a ser criado
local originalItemId = 8325
local transformedItemId = 8326
local newItemId = 2696
local recreatedItemId = 8695 -- Novo item que sera recriado apos o tempo
local transformDuration = 60 * 1000 -- 1 minuto (em milissegundos)

-- Novas posicoes para remocao de itens e criacao de criaturas
local positionsToRemove = {
    Position(32941, 31457, 2),
    Position(32939, 31457, 2)
}
local creatureName = "Lady Vampire Bride"
local itemToRecreate = 8323 -- ID do item a ser recriado

-- Posicoes para criar e remover o item 2693
local extraItemPositions = {
    Position(32941, 31456, 2),
    Position(32939, 31456, 2)
}
local extraItemId = 2693 -- ID do novo item a ser criado e removido

-- Posicao de verificacao e raio
local checkPosition = Position(32940, 31460, 1)
local checkRadius = {x = 5, y = 5, z = 1} -- Raio de verificacao

-- Storage para cooldown e duracao do cooldown
local stepCooldownStorage = 65109 -- Storage para o cooldown de "stepin"
local clickCooldownStorage = 65110 -- Storage para o cooldown de clique
local cooldownDuration = 10 * 60 * 60 * 1000 -- 2 minutos em milissegundos

-- Funcao para formatar o tempo restante em horas, minutos e segundos
local function formatTimeRemaining(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    local timeString = ""

    if hours > 0 then
        timeString = timeString .. hours .. " horas, "
    end
    if minutes > 0 or hours > 0 then
        timeString = timeString .. minutes .. " minutos, "
    end
    timeString = timeString .. seconds .. " segundos"
    
    return timeString
end

function femalePlayerTransform.onStepIn(player, item, position, fromPosition)
    -- Verifica se o jogador esta em cooldown para o "stepin"
    local lastUse = player:getStorageValue(stepCooldownStorage)
    if lastUse > os.time() then
        local remainingTime = lastUse - os.time()
        local formattedTime = formatTimeRemaining(remainingTime)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa esperar " .. formattedTime .. " para sangrar novamente.")
        return true
    end

    -- Verifica se ha algum jogador no raio de 5x5x1 em torno da posicao de verificacao
    local spectators = Game.getSpectators(checkPosition, false, true, checkRadius.x, checkRadius.x, checkRadius.y, checkRadius.y, checkRadius.z, checkRadius.z)
    if #spectators > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ja tem um time enfrentando o boss.")
        return true
    end

    -- Verifica se quem pisou e um jogador e se e do sexo feminino
    if player:isPlayer() and player:getSex() == PLAYERSEX_FEMALE then
        -- Verifica se o item na posicao alvo e o ID 8325
        local tile = Tile(itemPosition)
        if tile then
            local targetItem = tile:getItemById(originalItemId)
            if targetItem then
                -- Transforma o item em 8326
                targetItem:transform(transformedItemId)
                itemPosition:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual de transformacao

                -- Cria o novo item 2696 na posicao {32940, 31458, 2}
                local newItemTile = Tile(newItemPosition)
                if newItemTile then
                    local newItem = Game.createItem(newItemId, 1, newItemPosition)
                    if newItem then
                        newItem:setActionId(actionId)
                        newItemPosition:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual da criacao do item
                    end
                end

                -- Define o cooldown de 2 minutos para o "stepin"
                player:setStorageValue(stepCooldownStorage, os.time() + cooldownDuration / 1000)

                -- Funcao para reverter a transformacao apos 1 minuto
                addEvent(function()
                    -- Reverte o item transformado de volta para o original
                    local revertedItem = Tile(itemPosition):getItemById(transformedItemId)
                    if revertedItem then
                        revertedItem:transform(originalItemId)
                        itemPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Efeito visual ao retornar
                    end

                    -- Remove o item 2696 e recria o item 8695 com o actionId original
                    local itemToRemove = Tile(newItemPosition):getItemById(newItemId)
                    if itemToRemove then
                        itemToRemove:remove()
                        -- Cria o item 8695 com o actionId anterior
                        local recreatedItem = Game.createItem(recreatedItemId, 1, newItemPosition)
                        if recreatedItem then
                            recreatedItem:setActionId(actionId)
                            newItemPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Efeito visual ao recriar o item
                        end
                    end
                end, transformDuration)
            end
        end
    end
    return true
end

local itemAction = Action()

function itemAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o jogador esta em cooldown para o clique
    local lastUse = player:getStorageValue(clickCooldownStorage)
    if lastUse > os.time() then
        local remainingTime = lastUse - os.time()
        local formattedTime = formatTimeRemaining(remainingTime)
       -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa esperar " .. formattedTime .. " para envocar as lady novamente.")
        return true
    end

    -- Verifica se ha algum jogador no raio de 5x5x1 em torno da posicao de verificacao
    local spectators = Game.getSpectators(checkPosition, false, true, checkRadius.x, checkRadius.x, checkRadius.y, checkRadius.y, checkRadius.z, checkRadius.z)
    if #spectators > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ja tem um time enfrentando o boss.")
        return true
    end

    -- Verifica se o item transformado esta na posicao correta
    local tile = Tile(itemPosition)
    if tile then
        local transformedItem = tile:getItemById(transformedItemId)
        if transformedItem then
            -- Remove os itens 8323 nas posicoes especificadas e cria as criaturas
            for _, pos in ipairs(positionsToRemove) do
                local removeTile = Tile(pos)
                if removeTile then
                    local itemToRemove = removeTile:getItemById(itemToRecreate)
                    if itemToRemove then
                        itemToRemove:remove()
                        Game.createMonster(creatureName, pos)
                        pos:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual ao criar a criatura

                        -- Recria o item apos 1 minuto
                        addEvent(function()
                            local recreateTile = Tile(pos)
                            if recreateTile and not recreateTile:getItemById(itemToRecreate) then
                                Game.createItem(itemToRecreate, 1, pos)
                                pos:sendMagicEffect(CONST_ME_MAGIC_GREEN) -- Efeito visual ao recriar o item
                            end
                        end, transformDuration)
                    end
                end
            end

            -- Cria itens 2693 nas posicoes adicionais e remove apos 1 minuto
            for _, pos in ipairs(extraItemPositions) do
                Game.createItem(extraItemId, 1, pos)
                pos:sendMagicEffect(CONST_ME_MAGIC_GREEN) -- Efeito visual ao criar o item

                -- Remove os itens 2693 apos 1 minuto
                addEvent(function()
                    local extraTile = Tile(pos)
                    local extraItem = extraTile and extraTile:getItemById(extraItemId)
                    if extraItem then
                        extraItem:remove()
                        pos:sendMagicEffect(CONST_ME_POFF) -- Efeito visual ao remover o item
                    end
                end, transformDuration)
            end

            -- Define o cooldown de 2 minutos para o clique
            player:setStorageValue(clickCooldownStorage, os.time() + cooldownDuration / 1000)
        end
    end
    return true
end

femalePlayerTransform:type("stepin")
femalePlayerTransform:aid(actionId)
femalePlayerTransform:register()

itemAction:aid(actionId)
itemAction:register()
