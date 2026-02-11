local itemsToTransform = {
    {position = Position(32965, 31457, 2), originalId = 8667, newId = 8721, actionId = 33168},
    {position = Position(32966, 31456, 2), originalId = 8667, newId = 8721, actionId = 33168},
    {position = Position(32968, 31456, 2), originalId = 8667, newId = 8721, actionId = 33168}
}

local extraTransformPosition = Position(32967, 31457, 2) -- Posicao do item extra a ser transformado
local extraOriginalId = 8325 -- ID original do item extra
local extraNewId = 8326 -- Novo ID do item extra

local transformDuration = 2 * 60 * 1000 -- 2 minutos em milissegundos
local cooldownDuration = 10 * 60 * 60 -- 10 horas em segundos
local cooldownStorage = 65111 -- Storage para armazenar o cooldown
local teleportPosition = Position(32967, 31460, 1) -- Posicao de teleporte
local lersatioPosition = Position(32967, 31457, 1) -- Posicao para criar Lersatio
local transformedItemsCount = {} -- Armazena os IDs transformados
local extraTransformed = false -- Variavel para rastrear a transformacao do item extra
local checkRadius = {x = 5, y = 5, z = 1} -- Raio para verificacao de jogadores e criaturas

-- Funcao para formatar o tempo restante em horas, minutos e segundos
local function formatTimeRemaining(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d horas, %02d minutos e %02d segundos", hours, minutes, secs)
end

local itemAction = Action()

function itemAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o jogador esta em cooldown
    local lastUse = player:getStorageValue(cooldownStorage)
    if lastUse > os.time() then
        local remainingTime = lastUse - os.time()
        local formattedTime = formatTimeRemaining(remainingTime)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa esperar " .. formattedTime .. " para usar este item novamente.")
        return true -- Impede o uso do item
    end

    -- Verifica se ha jogadores na area 5x5x1 ao redor da posicao de teleporte
    local spectators = Game.getSpectators(teleportPosition, false, true, checkRadius.x, checkRadius.x, checkRadius.y, checkRadius.y, checkRadius.z, checkRadius.z)
    if #spectators > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ja tem alguem enfrentando o Lersatio.")
        return true -- Impede a transformacao
    end

    for index, itemInfo in ipairs(itemsToTransform) do
        -- Verifica se o item clicado esta na posicao correta, possui o ID original e Action ID correto
        if item:getPosition() == itemInfo.position and item:getId() == itemInfo.originalId and item:getActionId() == itemInfo.actionId then
            -- Transforma o item no novo ID (8721)
            item:transform(itemInfo.newId)
            itemInfo.position:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual de transformacao

            -- Transforma o item extra (8325 para 8326) ao clicar no primeiro espelho, independentemente da ordem
            if not extraTransformed then
                local extraTile = Tile(extraTransformPosition)
                if extraTile then
                    local extraItem = extraTile:getItemById(extraOriginalId)
                    if extraItem then
                        extraItem:transform(extraNewId)
                        extraTransformPosition:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual de transformacao do item extra
                        extraTransformed = true -- Marca o item extra como transformado

                        -- Reverte o item extra para o ID original apos 2 minutos
                        addEvent(function()
                            local revertExtraTile = Tile(extraTransformPosition)
                            if revertExtraTile then
                                local transformedExtraItem = revertExtraTile:getItemById(extraNewId)
                                if transformedExtraItem then
                                    transformedExtraItem:transform(extraOriginalId)
                                    extraTransformPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Efeito visual de reversao
                                    extraTransformed = false -- Reseta o estado de transformacao do item extra
                                end
                            end
                        end, transformDuration)
                    end
                end
            end

            -- Marca o item como transformado
            transformedItemsCount[index] = true

            -- Verifica se todos os itens foram transformados
            if #transformedItemsCount == #itemsToTransform then
                -- Remove todas as criaturas 'Lersatio' na area 5x5x1 ao redor da posicao de teleporte
                local creatures = Game.getSpectators(teleportPosition, false, false, checkRadius.x, checkRadius.x, checkRadius.y, checkRadius.y, checkRadius.z, checkRadius.z)
                for _, creature in ipairs(creatures) do
                    if creature:getName():lower() == "lersatio" then
                        creature:remove() -- Remove a criatura 'Lersatio' existente
                    end
                end

                -- Teleporta o jogador para a posicao especificada
                player:teleportTo(teleportPosition)
                teleportPosition:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual de teleporte

                -- Cria a nova criatura 'Lersatio' na posicao especificada
                Game.createMonster("Lersatio", lersatioPosition)
                lersatioPosition:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual ao criar a criatura

                -- Reseta a contagem de itens transformados
                transformedItemsCount = {}

                -- Define o cooldown de 10 horas para o jogador
                player:setStorageValue(cooldownStorage, os.time() + cooldownDuration)
            end

            -- Reverte o item para o ID original apos 2 minutos
            addEvent(function()
                local revertTile = Tile(itemInfo.position)
                if revertTile then
                    local transformedItem = revertTile:getItemById(itemInfo.newId)
                    if transformedItem then
                        transformedItem:transform(itemInfo.originalId)
                        itemInfo.position:sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Efeito visual de reversao
                        -- Remove o item da contagem se for revertido
                        transformedItemsCount[index] = nil
                    end
                end
            end, transformDuration)

            return true -- Encerra o uso, pois ja transformou o item
        end
    end

    return false -- Retorna falso se nao houve transformacao
end

itemAction:aid(33168)
itemAction:register()
