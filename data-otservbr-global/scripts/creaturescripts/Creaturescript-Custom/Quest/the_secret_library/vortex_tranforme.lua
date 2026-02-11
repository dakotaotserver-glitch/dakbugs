local wildKnowledgeDeath = CreatureEvent("WildKnowledgeDeath")

function wildKnowledgeDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    local position = creature:getPosition()
    local creatureName = creature:getName():lower()

    if creatureName == "wild knowledge" then
        local item = Game.createItem(21500, 1, position)
        if item then
            item:setActionId(33029)
            -- Remove o item após 15 segundos
            addEvent(function()
                if item and item:getPosition() == position then
                    item:remove()
                end
            end, 15 * 1000) -- 15 segundos em milissegundos
        end
    end

    return true
end

wildKnowledgeDeath:register()

local transformEvent = MoveEvent()

local actionId = 33029
local transformLookType = 1065
local transformDuration = 8 * 1000 -- 8 segundos em milissegundos
local storageId = 65027 -- ID da storage para marcar o jogador transformado

function transformEvent.onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() and item:getActionId() == actionId then
        local player = creature:getPlayer()
        if not player then
            return true
        end

        -- Verifica se o jogador já está transformado
        if player:getStorageValue(storageId) == 1 then
            return true
        end

        -- Salva o outfit original do jogador
        local originalOutfit = player:getOutfit()

        -- Muda o lookType do jogador para a criatura especificada
        player:setOutfit({lookType = transformLookType})
        
        -- Adiciona uma verificação antes de enviar o efeito mágico
        if CONST_ME_ICEATTACK then
            player:getPosition():sendMagicEffect(CONST_ME_ICEATTACK)
        else
            print("Error: CONST_ME_ICEATTACK is not defined or invalid.")
        end

        -- Define a storage para marcar o jogador como transformado
        if player:setStorageValue(storageId, 1) then
            print("Storage value set successfully.")
        else
            print("Error: Failed to set storage value.")
        end

        -- Remove o item com actionId 33029
        item:remove()

        -- Reverte o outfit do jogador após 8 segundos e limpa a storage
        addEvent(function()
            if player then
                player:setOutfit(originalOutfit)
                player:setStorageValue(storageId, -1) -- Limpa a storage para permitir futuras transformações
            end
        end, transformDuration)
    end
    return true
end

transformEvent:type("stepin")
transformEvent:aid(actionId)
transformEvent:register()
