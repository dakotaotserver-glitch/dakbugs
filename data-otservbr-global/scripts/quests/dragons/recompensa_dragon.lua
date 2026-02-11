local requiredStorages = {65092, 65093, 65094, 65095, 65096, 65097, 65098}
local itemRewards = {
    44753, 44754, 44752, 44609, 44608, 44610, 44612, 44613, 44606, 44604,
    44603, 44622, 44607, 44751, 44624, 44743, 44750, 7430, 44621, 44623
}

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
    if item.uid ~= 33109 then
        return false
    end

    -- Verifica se o jogador possui todas as storages requeridas
    if not hasAllRequiredStorages(player) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ainda nao completou todos os requisitos para receber a recompensa")
        return true
    end

    -- Tenta dar cada item ao jogador com 10% de chance
    local receivedItems = {}
    for i = 1, #itemRewards do
        if math.random(100) <= 5 then -- 10% de chance para cada item
            player:addItem(itemRewards[i], 1)
            table.insert(receivedItems, itemRewards[i]) -- Armazena os IDs dos itens recebidos
        end
    end

    -- Exibe mensagem dos itens recebidos ou informa que nao ganhou nada
    if #receivedItems > 0 then
        local itemsString = table.concat(receivedItems, ", ")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Parabens Voce recebeu Seu Premio")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao teve sorte desta vez Tente novamente")
    end

    -- Reseta as storages do jogador apos tentar pegar a recompensa
    resetStorages(player)

    return true
end

specialRewardAction:uid(33109)
specialRewardAction:register()
