local itemTransform = Action()

local targetPosition = Position(32953, 31440, 2) -- Posição do item que será transformado
local originalItemId = 8325 -- ID original do item
local transformedItemId = 8326 -- ID transformado
local transformDuration = 60 * 1000 -- Duração de 1 minuto (em milissegundos)
local cooldownDuration = 36 * 1000 * 1000 -- Cooldown de 10 horas (em milissegundos)

local teleportPosition = Position(32953, 31443, 1) -- Posição para onde o jogador será teleportado
local creatureSpawnPosition = Position(32953, 31440, 1) -- Posição onde a criatura será criada
local checkRadius = 5 -- Raio de 5x5 ao redor da posição para verificação

local cooldowns = {} -- Tabela para armazenar os cooldowns

-- Função para verificar se há jogadores na área definida
local function isPlayerInRange(position, radius)
    local spectators = Game.getSpectators(position, false, false, radius, radius, radius, radius)
    for _, spectator in ipairs(spectators) do
        if spectator:isPlayer() then
            return true -- Encontrou um jogador
        end
    end
    return false
end

-- Função para remover todas as criaturas de nome "Arthei" na área
local function removeCreaturesInRange(position, radius, creatureName)
    local spectators = Game.getSpectators(position, false, false, radius, radius, radius, radius)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and spectator:getName() == creatureName then
            spectator:remove() -- Remove a criatura
        end
    end
end

-- Função para remover o item ID 8746 da mochila do jogador e do chão
local function removeItemFromPlayerAndGround(player, itemId)
    -- Remover o item da mochila do jogador
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if backpack then
        local itemsToRemove = backpack:getItems()
        for _, item in ipairs(itemsToRemove) do
            if item:getId() == itemId then
                item:remove(1)
                break -- Remova apenas um item
            end
        end
    end

    -- Remover o item do chão ao redor do jogador
    local tile = Tile(player:getPosition())
    if tile then
        local groundItem = tile:getItemById(itemId)
        if groundItem then
            groundItem:remove()
        end
    end
end

-- Função principal de manipulação
function itemTransform.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerId = player:getId() -- Obter o ID único do jogador
    local currentTime = os.time() * 1000 -- Tempo atual em milissegundos

    -- Verifica se o jogador está usando o item correto (ID 8746) no item alvo com ID 8325 na posição correta
    if item.itemid == 8746 and target:getPosition() == targetPosition then
        if target.itemid == originalItemId then
            -- Verifica se há jogadores no raio de 5x5 da posição {x = 32953, y = 31443, z = 1}
            if isPlayerInRange(teleportPosition, checkRadius) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ha jogadores enfrentando o boss.")
                return true
            end

            -- Verifica o cooldown para o jogador
            if cooldowns[playerId] and currentTime < cooldowns[playerId] then
                local remainingTime = math.ceil((cooldowns[playerId] - currentTime) / 1000)
                local hours = math.floor(remainingTime / 3600)
                local minutes = math.floor((remainingTime % 3600) / 60)
                local seconds = remainingTime % 60
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Voce precisa esperar %02d:%02d:%02d antes de invocar o Lord Arthen novamente.", hours, minutes, seconds))
                return true
            end

            -- Define o novo cooldown para o jogador
            cooldowns[playerId] = currentTime + cooldownDuration

            -- Transforma o item na posição em um novo ID (8326)
            target:transform(transformedItemId)

            -- Adiciona um efeito visual na posição do item transformado
            targetPosition:sendMagicEffect(CONST_ME_FIREATTACK)

            -- Retorna o item ao estado original após 1 minuto
            addEvent(function()
                local currentItem = Tile(targetPosition):getItemById(transformedItemId)
                if currentItem then
                    currentItem:transform(originalItemId)
                    -- Adiciona um efeito visual na posição quando o item reverte
                    targetPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                end
            end, transformDuration)

        elseif target.itemid == transformedItemId then
            -- Remover todas as criaturas "Arthei" num raio de 5x5 da posição {x = 32953, y = 31443, z = 1}
            removeCreaturesInRange(teleportPosition, checkRadius, "Arthei")

            -- Teleporta o jogador para a posição definida
            player:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)

            -- Remover o item ID 8746 da mochila e do chão
            removeItemFromPlayerAndGround(player, 8746)

            -- Cria uma criatura de nome "Arthei" na posição definida
            Game.createMonster("Arthei", creatureSpawnPosition)
            creatureSpawnPosition:sendMagicEffect(CONST_ME_TELEPORT)

            -- Transforma o item de volta para o ID original (8325)
            target:transform(originalItemId)

            -- Adiciona um efeito visual na posição do item transformado
            targetPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end
    return true
end

-- Define a Action ID para o item que será usado
itemTransform:id(8746) -- Define o ID do item que será usado (8746)
itemTransform:register()
