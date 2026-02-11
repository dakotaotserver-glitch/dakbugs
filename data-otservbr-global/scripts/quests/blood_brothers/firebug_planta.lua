local targetPositions = {
    Position(32938, 31476, 2),
    Position(32939, 31476, 2),
    Position(32940, 31476, 2),
    Position(32941, 31476, 2),
    Position(32942, 31476, 2),
    Position(32943, 31476, 2),
    Position(32944, 31476, 2)
}

local targetItemId = 6219 -- ID do item alvo
local targetActionId = 33169 -- Action ID específico do item 6219
local fireBugActionId = 33171 -- Action ID do Fire Bug original
local newFireBugActionId = 33170 -- Action ID do novo Fire Bug criado
local newItemId = 232 -- ID do item a ser criado
local transformPosition = Position(32940, 31475, 2) -- Posição do item 8325/8326
local originalItemId = 8325 -- ID original do item
local transformedItemId = 8326 -- ID transformado do item
local transformDuration = 60 -- Duração em segundos (1 minuto)
local cooldownTime = 10 * 60 * 60 -- 2 minutos em segundos

local cooldownStorage = {
    [fireBugActionId] = 65112, -- Storage para cooldown do Action ID 33171
    [newFireBugActionId] = 65113 -- Storage para cooldown do Action ID 33170
}

local additionalPositions = {
    Position(32941, 31475, 2),
    Position(32939, 31475, 2)
}

local borethRemovalPosition = Position(32940, 31478, 1) -- Posição para remoção de Boreth
local borethSpawnPosition = Position(32940, 31475, 1) -- Posição para criar Boreth
local teleportPosition = Position(32940, 31478, 1) -- Posição para teleportar o jogador

local fireBugAction = Action()

function fireBugAction.onUse(player, item, fromPosition, target, toPosition)
    local actionId = item:getActionId()

    -- Verifica se o Action ID é 33171 ou 33170
    if actionId ~= fireBugActionId and actionId ~= newFireBugActionId then
        return false
    end

    -- Verificação de cooldown para o Action ID específico
    local storageId = cooldownStorage[actionId]
    local lastUse = player:getStorageValue(storageId)
    if lastUse > os.time() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa esperar o cooldown.")
        return true
    end

    -- Verifica se há um jogador na posição 32940, 31478, 1 em um raio de 5x5x1
    local checkPosition = Position(32940, 31478, 1)
    local spectators = Game.getSpectators(checkPosition, false, true, 7, 7, 1, 1)
    for _, spec in ipairs(spectators) do
        if spec:isPlayer() then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ja tem player enfrentando o boss.")
            return true
        end
    end

    -- Se o Action ID for 33170, verifica a presença do item 8326 na posição 32940, 31475, 2
    if actionId == newFireBugActionId then
        local item8326 = Tile(transformPosition):getItemById(transformedItemId)
        if not item8326 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "use um fire bug sem encantamento.")
            return false
        end
    end

    -- Verifica se o item alvo é o item 6219 com o Action ID correto e está em uma das posições especificadas
    for _, position in ipairs(targetPositions) do
        if target:getId() == targetItemId and target:getActionId() == targetActionId and target:getPosition() == position then
            -- Verifica se já existe um item 232 na posição para evitar duplicidade
            local tile = Tile(position)
            if tile and tile:getItemById(newItemId) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "O item ja foi criado nesta posicao.")
                return false
            end

            -- Cria o novo item 232 na mesma posição sem remover o item original
            local newItem = Game.createItem(newItemId, 1, position)
            position:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual de criação

            -- Remove o item 232 após 1 minuto
            addEvent(function()
                local itemToRemove = Tile(position):getItemById(newItemId)
                if itemToRemove then
                    itemToRemove:remove()
                    position:sendMagicEffect(CONST_ME_POFF) -- Efeito visual de remoção
                end
            end, transformDuration * 1000)

            -- Se o Action ID for 33170 e o item 8326 estiver presente, cria os itens nas posições adicionais
            if actionId == newFireBugActionId then
                -- Cria itens 232 nas posições adicionais
                for _, addPos in ipairs(additionalPositions) do
                    local additionalItem = Game.createItem(newItemId, 1, addPos)
                    addPos:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual de criação

                    -- Remove os itens 232 após 1 minuto
                    addEvent(function()
                        local itemToRemove = Tile(addPos):getItemById(newItemId)
                        if itemToRemove then
                            itemToRemove:remove()
                            addPos:sendMagicEffect(CONST_ME_POFF) -- Efeito visual de remoção
                        end
                    end, transformDuration * 1000)
                end
            end

            -- Remove o item usado do inventário do jogador
            if player:removeItem(item:getId(), 1) then
                -- Adiciona um novo Fire Bug com Action ID 33170 ao jogador
                local newFireBug = player:addItem(item:getId(), 1)
                if newFireBug then
                    newFireBug:setActionId(newFireBugActionId)
                end
            end

            -- Remove o Fire Bug do chão, se existir
            local tile = Tile(item:getPosition())
            if tile then
                local groundFireBug = tile:getItemById(item:getId())
                if groundFireBug then
                    groundFireBug:remove()
                end
            end

            -- Define o cooldown para o jogador com base no Action ID específico
            player:setStorageValue(storageId, os.time() + cooldownTime)

            -- Se o Action ID for 33171, transforma o item 8325 em 8326 por 1 minuto
            if actionId == fireBugActionId then
                local transformTile = Tile(transformPosition)
                if transformTile then
                    local originalItem = transformTile:getItemById(originalItemId)
                    if originalItem then
                        originalItem:transform(transformedItemId)
                        transformPosition:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual da transformação

                        -- Reverte o item para 8325 após 1 minuto
                        addEvent(function()
                            local currentItem = Tile(transformPosition):getItemById(transformedItemId)
                            if currentItem then
                                currentItem:transform(originalItemId)
                                transformPosition:sendMagicEffect(CONST_ME_POFF) -- Efeito visual de reversão
                            end
                        end, transformDuration * 1000)
                    end
                end
            end

            -- Mecânica adicional para o Action ID 33170
            if actionId == newFireBugActionId then
                -- Remove todas as criaturas 'Boreth' na área 5x5x1 ao redor de 32940, 31478, 1
                local creatures = Game.getSpectators(borethRemovalPosition, false, false, 7, 7, 1, 1)
                for _, creature in ipairs(creatures) do
                    if creature:getName():lower() == "boreth" then
                        creature:remove()
                    end
                end

                -- Espera um pequeno intervalo para garantir a remoção antes da criação
                addEvent(function()
                    -- Teleporta o jogador para a posição 32940, 31478, 1
                    player:teleportTo(teleportPosition)
                    teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)

                    -- Remove o item com Action ID 33170 do inventário do jogador
                    player:removeItem(item:getId(), 1)

                    -- Cria uma nova criatura 'Boreth' na posição 32940, 31475, 1
                    Game.createMonster("Boreth", borethSpawnPosition)
                    borethSpawnPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
                end, 100) -- Adiciona um atraso de 100 ms para garantir a remoção completa

            end

            return true
        end
    end

    return false
end

fireBugAction:aid(fireBugActionId)
fireBugAction:aid(newFireBugActionId)
fireBugAction:register()
