local requiredStorages = {65107}
local itemRewards = {8896, 8899, 2995, 15698, 3043}  -- Itens de recompensa
local rewardBagId = 2853  -- ID da bag onde os itens serão colocados

-- Verifica se o jogador possui todas as storages requeridas com valor 1
local function hasAllRequiredStorages(player)
    for i = 1, #requiredStorages do
        if player:getStorageValue(requiredStorages[i]) ~= 1 then
            return false
        end
    end
    return true
end

-- Reseta todas as storages definidas para o jogador
local function resetStorages(player)
    for i = 1, #requiredStorages do
        player:setStorageValue(requiredStorages[i], 0)
    end
end

local specialRewardAction = Action()

function specialRewardAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o baú possui o unique ID correto
    if item.uid ~= 33110 then
        return false
    end

    -- Verifica se o jogador possui todas as storages requeridas
    if not hasAllRequiredStorages(player) then
       player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ate A Proxima Vez")
        return true
    end

    -- Cria a bag para armazenar os itens
    local rewardBag = player:addItem(rewardBagId, 1)
    if not rewardBag then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nao ha espaco suficiente para a bag de recompensa.")
        return true
    end

    -- Tenta dar cada item ao jogador com 10% de chance, colocando-os dentro da bag
    local receivedItems = {}
    for i = 1, #itemRewards do
        if math.random(100) <= 100 then -- 10% de chance para cada item
            rewardBag:addItem(itemRewards[i], 1)
            table.insert(receivedItems, itemRewards[i]) -- Armazena os IDs dos itens recebidos
        end
    end



    -- Reseta as storages do jogador após tentar pegar a recompensa
    resetStorages(player)

    return true
end

specialRewardAction:uid(33110)
specialRewardAction:register()
