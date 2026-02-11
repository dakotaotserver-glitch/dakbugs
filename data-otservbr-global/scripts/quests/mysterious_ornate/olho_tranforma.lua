local itemTransform = Action()

local targetPosition = Position(32815, 32938, 14) -- Posição do item a ser transformado
local originalItemId = 24917 -- ID original do item
local transformedItemId = 24918 -- ID transformado
local transformDuration = 300 * 1000 -- Duração de 10 minutos (em milissegundos)

local creaturePosition = Position(32815, 32942, 14) -- Posição da criatura a ser removida
local teleportCreaturePosition = Position(32814, 32963, 14) -- Posição da criatura a ser teleportada
local itemRevertDuration = 300 * 1000 -- Duração de 10 minutos para reverter o item com Action ID para o estado original

-- Função principal de manipulação
function itemTransform.onUse(player, item, fromPosition, target, toPosition)
    -- Verifica se o jogador está usando o item correto (ID 23572) no item alvo com o action ID 33158
    if item.itemid == 23572 and target.actionid == 33158 then
        -- Obtém o item na posição alvo
        local targetItem = Tile(targetPosition):getItemById(originalItemId)

        if targetItem then
            -- Transforma o item na posição em um novo ID (24918)
            targetItem:transform(transformedItemId)

            -- Adiciona um efeito visual na posição do item transformado
            targetPosition:sendMagicEffect(CONST_ME_POFF)

            -- Retorna o item ao estado original após 10 minutos
            addEvent(function()
                local currentItem = Tile(targetPosition):getItemById(transformedItemId)
                if currentItem then
                    currentItem:transform(originalItemId)
                end
            end, transformDuration)
        end

        -- Remover a criatura "An Observer Eye (imune)" imediatamente ao clicar
        local creature = Tile(creaturePosition):getTopCreature()
        if creature and creature:getName() == "An Observer Eye" then
            creature:remove() -- Remove a criatura atual na posição
        end

        -- Teleportar a criatura "An Observer Eye" de outra posição
        local observerCreature = Tile(teleportCreaturePosition):getTopCreature()
        if observerCreature and observerCreature:getName() == "An Observer Eye" then
            observerCreature:teleportTo(creaturePosition) -- Teleporta para a posição alvo
            creaturePosition:sendMagicEffect(CONST_ME_TELEPORT) -- Adiciona efeito visual de teleporte na nova posição
        end

        -- Transformar o item alvo no item ID 22679 e reverter após 10 minutos
        local targetPos = target:getPosition()
        local oldItemId = target.itemid

        -- Transformar o item alvo no ID 22679
        target:transform(22679)

        -- Adiciona um efeito visual na posição do item transformado
        target:getPosition():sendMagicEffect(CONST_ME_FIREAREA)

        -- Agendar a transformação de volta ao item original após 10 minutos
        addEvent(function()
            local newItem = Tile(targetPos):getItemById(22679)
            if newItem then
                newItem:transform(oldItemId)
                newItem:setActionId(33158) -- Restaura o mesmo Action ID ao item transformado

                -- Adiciona um efeito visual na posição quando o item é revertido
                newItem:getPosition():sendMagicEffect(CONST_ME_POFF)
            end
        end, itemRevertDuration)
    end

    return true
end

-- Define a Action ID para o item alvo com Action ID 33158
itemTransform:id(23572) -- Define o ID do item que será usado (23572)
itemTransform:register()
