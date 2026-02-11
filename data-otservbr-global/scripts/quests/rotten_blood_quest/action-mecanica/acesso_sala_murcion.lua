local actionIds = {33090, 33091, 33092, 33093, 33094, 33095} -- Lista de Action IDs válidos
local storageIdBase = 65080 -- Storage base para rastrear o uso de cada Action ID
local storageReward = 65079 -- Storage que o jogador recebe ao usar todos os itens
local resetDuration = 60 * 60 * 1000 -- 3 minutos para resetar o progresso

local useAction = Action()

-- Função para resetar as storages após 3 minutos
local function resetPlayerStorages(player)
    if player and player:isPlayer() then
        -- Reseta as storages de todos os itens usados
        for _, actionId in ipairs(actionIds) do
            player:setStorageValue(storageIdBase + actionId, -1)
        end
        player:setStorageValue(storageReward, -1) -- Reseta a storage de recompensa
    end
end

-- Evento onUse para os itens com Action ID especificados
function useAction.onUse(player, item, fromPosition, target, toPosition)
    local itemActionId = item:getActionId()
    local playerPosition = player:getPosition()

    -- Verifica se o item tem um dos Action IDs válidos
    if table.contains(actionIds, itemActionId) then
        -- Verifica se o jogador já usou esse item antes
        if player:getStorageValue(storageIdBase + itemActionId) == 1 then
           
            return true
        end

        player:setStorageValue(storageIdBase + itemActionId, 1)
        playerPosition:sendMagicEffect(241)

        -- Contador para ver quantos itens já foram usados
        local itemsUsed = 0
        for _, actionId in ipairs(actionIds) do
            if player:getStorageValue(storageIdBase + actionId) == 1 then
                itemsUsed = itemsUsed + 1
            end
        end

        -- Enviar mensagem em laranja sobre o progresso
        player:say("Nivel " .. itemsUsed .. " de 6 contaminacoes, faltam " ..
            (6 - itemsUsed) .. " para entrar no covil de murcion.", TALKTYPE_MONSTER_SAY)

        -- Se o jogador usou todos os Action IDs, dá a storage de recompensa
        if itemsUsed == #actionIds then
            player:setStorageValue(storageReward, 1)

            addEvent(function() resetPlayerStorages(player) end, resetDuration)
        end

        return true
    end
    return false
end

useAction:aid(33090, 33091, 33092, 33093, 33094, 33095)
useAction:register()
