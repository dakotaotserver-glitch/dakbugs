local actionIds = {33107, 33108, 33109, 33110, 33111} -- Lista de Action IDs válidos
local storageIdBase = 65086 -- Storage base para rastrear o uso de cada Action ID
local storageReward = 65087 -- Storage que o jogador recebe ao usar todos os itens
local resetDuration = 60 * 60 * 1000 -- 1 hora para resetar o progresso (em milissegundos)
local transformDuration = 2 * 60 * 1000 -- 2 minutos de transformação para o item (em milissegundos)
local transformedItemId = 43795 -- ID do item transformado
local cooldownDuration = 2 * 60 -- 2 minutos de cooldown antes de o item poder ser usado novamente (em segundos)

-- Tabela global para rastrear cooldowns dos itens
local itemCooldowns = {}

local useAction = Action()

-- Função para resetar as storages após 1 hora
local function resetPlayerStorages(player)
    if player and player:isPlayer() then
        -- Reseta as storages de todos os itens usados
        for _, actionId in ipairs(actionIds) do
            player:setStorageValue(storageIdBase + actionId, -1)
        end
        player:setStorageValue(storageReward, -1) -- Reseta a storage de recompensa
    end
end

-- Função para reverter o item ao seu ID original
local function revertItem(itemPosition, originalItemId, actionId)
    local item = Tile(itemPosition):getItemById(transformedItemId) -- Encontrar o item transformado na posição
    if item then
        item:transform(originalItemId) -- Reverte o item para o ID original
        item:setActionId(actionId) -- Mantém o Action ID original
    end
end

-- Função para verificar cooldown
local function isItemOnCooldown(itemPosition)
    local positionString = itemPosition.x .. "," .. itemPosition.y .. "," .. itemPosition.z
    local cooldownTime = itemCooldowns[positionString]
    if cooldownTime then
        local currentTime = os.time() -- Usa os.time() para obter o tempo atual em segundos
        if currentTime < cooldownTime then
            return true -- Item ainda está em cooldown
        end
    end
    return false -- Item não está em cooldown
end

-- Função para definir cooldown
local function setItemCooldown(itemPosition)
    local positionString = itemPosition.x .. "," .. itemPosition.y .. "," .. itemPosition.z
    local cooldownTime = os.time() + cooldownDuration -- Adiciona o cooldown em segundos
    itemCooldowns[positionString] = cooldownTime
end

-- Função para aplicar dano de energia ao jogador
local function applyEnergyDamage(player)
    local minDamage = 1000
    local maxDamage = 2500
    local damage = math.random(minDamage, maxDamage) -- Gera um valor aleatório entre 1000 e 2500
    player:addHealth(-damage, CONST_ME_ENERGYHIT, COMBAT_ENERGYDAMAGE) -- Aplica dano de energia ao jogador
end

-- Evento onUse para os itens com Action ID especificados
function useAction.onUse(player, item, fromPosition, target, toPosition)
    local itemActionId = item:getActionId()
    local originalItemId = item:getId() -- Armazena o ID original do item
    local itemPosition = item:getPosition() -- Posição do item
    local playerPosition = player:getPosition()

    -- Verifica se o item tem um dos Action IDs válidos
    if table.contains(actionIds, itemActionId) then
        -- Verifica se o item está em cooldown
        if isItemOnCooldown(itemPosition) then
            player:sendCancelMessage("Espere o Cristal se Regenerar")
            return true
        end

        -- Verifica se o jogador já usou esse item antes
        if player:getStorageValue(storageIdBase + itemActionId) == 1 then
            return true
        end

        -- Marca o item como usado pelo jogador
        player:setStorageValue(storageIdBase + itemActionId, 1)
        itemPosition:sendMagicEffect(CONST_ME_HITAREA)

        -- Transforma o item no item ID 43795 por 2 minutos
        item:transform(transformedItemId)
        addEvent(revertItem, transformDuration, itemPosition, originalItemId, itemActionId)

        -- Define o cooldown para este item
        setItemCooldown(itemPosition)

        -- Contador para ver quantos itens já foram usados
        local itemsUsed = 0
        for _, actionId in ipairs(actionIds) do
            if player:getStorageValue(storageIdBase + actionId) == 1 then
                itemsUsed = itemsUsed + 1
            end
        end

        -- Enviar mensagem em laranja sobre o progresso
        player:say("Nivel " .. itemsUsed .. " de 5 radiacoes, faltam " .. (5 - itemsUsed) .. " para entrar no covil de Vemiath.", TALKTYPE_MONSTER_SAY)

        -- Se o jogador usou todos os Action IDs, dá a storage de recompensa e aplica o dano
        if itemsUsed == #actionIds then
            player:setStorageValue(storageReward, 1)

            -- Aplica o dano de energia entre 1000 a 2500 ao jogador
            applyEnergyDamage(player)

            -- Agendar o reset das storages após o tempo de reset
            addEvent(function() resetPlayerStorages(player) end, resetDuration)
        end

        return true
    end
    return false
end

useAction:aid(33107, 33108, 33109, 33110, 33111)
useAction:register()
