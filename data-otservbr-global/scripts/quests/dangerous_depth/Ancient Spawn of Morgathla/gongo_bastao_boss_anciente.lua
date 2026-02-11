local transformAction = Action()

-- IDs dos itens
local rewardItemId = 27523 -- ID do item de recompensa
local rewardActionId = 33160 -- Action ID para o item de recompensa

-- IDs e posições para a nova funcionalidade
local transformPosition = Position(33692, 32385, 15) -- Posição do item alvo para a transformação
local changeItemPosition = Position(33693, 32385, 15) -- Posição do item que será alterado temporariamente
local targetTransformItem = 25768 -- ID do item alvo para a transformação
local temporaryTransformItemId = 1949 -- ID temporário
local originalItemId = 10580 -- ID original do item
local temporaryActionId = 33161 -- Action ID para o item transformado temporariamente
local transformDuration = 30 * 1000 -- Duração da transformação temporária (20 segundos)

-- Área de verificação e remoção de criaturas
local areaFromPosition = Position(33703, 32325, 15)
local areaToPosition = Position(33800, 32387, 15)

-- Cooldown settings
local cooldownStorage = 65108 -- Storage para rastrear o cooldown
local cooldownTime = 20 * 60 -- Tempo de cooldown em segundos (20 hr minuto)

-- Função para verificar jogadores na área especificada
local function isPlayerInArea(fromPos, toPos)
    for _, player in ipairs(Game.getPlayers()) do
        if player:getPosition():isInRange(fromPos, toPos) then
            return true
        end
    end
    return false
end

-- Função para remover todas as criaturas (monstros) da área especificada
local function removeCreaturesInArea(fromPos, toPos, player)
    local creaturesRemoved = 0 -- Contador para saber quantas criaturas foram removidas
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            local tile = Tile(Position(x, y, fromPos.z))
            if tile then
                local creatures = tile:getCreatures()
                for _, creature in ipairs(creatures) do
                    if creature:isMonster() then
                        creature:remove() -- Remove a criatura
                        creaturesRemoved = creaturesRemoved + 1
                    end
                end
            end
        end
    end
end

-- Verifica se o jogador está em cooldown
local function isInCooldown(player)
    local lastUsed = player:getStorageValue(cooldownStorage)
    if lastUsed > os.time() then
        return true
    end
    return false
end

-- Define o cooldown para o jogador
local function setCooldown(player)
    player:setStorageValue(cooldownStorage, os.time() + cooldownTime)
end

-- Função chamada quando o jogador usa o item
function transformAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o jogador está em cooldown
    if isInCooldown(player) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce deve esperar 20 minutos antes de usar este item novamente.")
        return true
    end

    -- Verifica se há jogadores na área do boss
    if isPlayerInArea(areaFromPosition, areaToPosition) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ja tem um time enfrentando o boss.")
        return true
    end

    -- Verifica se o item usado é o item de recompensa com Action ID 33160
    if item.actionid == rewardActionId then
        -- Verifica se o item está sendo usado na posição especificada (33692, 32385, 15) e no item correto
        if target.itemid == targetTransformItem and toPosition.x == transformPosition.x and toPosition.y == transformPosition.y and toPosition.z == transformPosition.z then
            -- Remove o item de recompensa
            player:removeItem(rewardItemId, 0)

            -- Verifica se o item a ser transformado temporariamente existe na posição especificada
            local tile = Tile(changeItemPosition)
            if tile then
                local itemToChange = tile:getItemById(originalItemId)
                if itemToChange then
                    -- Transforma o item temporariamente no item 1949 e atribui o Action ID 33161
                    itemToChange:getPosition():sendMagicEffect(CONST_ME_FIREAREA)
                    itemToChange:transform(temporaryTransformItemId)
                    itemToChange:setActionId(temporaryActionId)

                    -- Remove todas as criaturas na área específica entre as posições definidas
                    removeCreaturesInArea(areaFromPosition, areaToPosition, player)

                    -- Reverte a transformação após 20 segundos
                    addEvent(function()
                        local revertTile = Tile(changeItemPosition)
                        if revertTile then
                            local tempItem = revertTile:getItemById(temporaryTransformItemId)
                            if tempItem then
                                tempItem:transform(originalItemId)
                                tempItem:setActionId(0) -- Remove o actionID atribuído
                            end
                        end
                    end, transformDuration)

                    -- Define o cooldown para o jogador
                    setCooldown(player)
                else
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "O item para transformar nao foi encontrado.")
                end
            end
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use este item no alvo correto.")
        end
    end
    return true
end

-- Configura o ID do item de recompensa que será usado para acionar a ação
transformAction:id(rewardItemId)
transformAction:register()
