local config = {
    enabled = false,
    storage = Storage.VipSystem.OnlineTokensGain,
    checkDuplicateIps = false,
    -- tokenItemId = 14112, -- bar of gold
    tokenItemId = 62218, -- Online Tokens
    
   interval = 300 * 1000, -- Aumentado de 60 para 300 segundos (5 minutos)
    -- per hour | system will calculate how many tokens will be given and when
    -- put 0 in tokensPerHour.free to disable free from receiving tokens
    tokensPerHour = {
        free = 1,
        vip = 2, -- Reduzido de 1 para 0.5 (meio token por hora)
    },
    awardOn = 2, -- Mantido igual, jogadores receberão tokens a cada 10 horas online
    
    -- Depot ID para depósito
    DEPOT_ID = 1,
    
    -- Mensagens para o jogador (agora apenas para o depot)
    messages = {
        DEPOT_FORMAT = "Congratulations %s! \z You have received %d %s in your depot for being online."
    },
    
    -- Debug para identificar problemas
    debug = false
}

-- Função para logging condicional
local function debugLog(message)
    if config.debug then
        print("[DEBUG] OnlineTokens: " .. message)
    end
end

-- Função melhorada para enviar o item para o depot do jogador
local function sendToDepot(player, itemId, count)
    -- Verificar se o jogador existe
    if not player then
        debugLog("Player não existe")
        return false
    end
    
    -- Lista de funções a tentar para obter o depot
    local depotGetters = {
        function() return player:getDepotChest(config.DEPOT_ID, true) end,
        function() return player:getInbox() end,
        function() return player:getDepotBox() end
    }
    
    local inbox = nil
    -- Tenta cada método para obter o depot
    for _, getter in ipairs(depotGetters) do
        local success, result = pcall(getter)
        if success and result then
            inbox = result
            break
        end
    end
    
    if not inbox then
        debugLog("Não foi possível obter nenhum container do depot para " .. player:getName())
        return false
    end
    
    -- Alguns sistemas têm limitação ao adicionar mais de 100 itens de uma vez
    -- Vamos dividir em lotes menores se necessário
    local remaining = count
    local success = true
    
    while remaining > 0 do
        local batchSize = math.min(remaining, 100)
        local addSuccess, item = pcall(function()
            return inbox:addItem(itemId, batchSize)
        end)
        
        if not addSuccess or not item then
            debugLog("Falha ao adicionar lote ao depot")
            
            -- Tentar criar um contêiner e adicionar o item lá
            local containerAdded, container = pcall(function()
                return inbox:addItem(2854) -- Backpack
            end)
            
            if containerAdded and container then
                addSuccess, item = pcall(function()
                    return container:addItem(itemId, batchSize)
                end)
                
                if addSuccess and item then
                    debugLog("Item adicionado usando contêiner")
                else
                    -- Remove o contêiner se falhou em adicionar o item
                    pcall(function() container:remove() end)
                    success = false
                    break
                end
            else
                success = false
                break
            end  -- Corrigido: end para fechar 'if containerAdded'
        end
        
        remaining = remaining - batchSize
    end
    
    return success
end

local onlineTokensEvent = GlobalEvent("GainTokenInterval")
local runsPerHour = 3600 / (config.interval / 1000)
local function tokensPerRun(tokensPerHour)
    return tokensPerHour / runsPerHour
end

function onlineTokensEvent.onThink(interval)
    local players = Game.getPlayers()
    if #players == 0 then
        return true
    end
    local checkIp = {}
    for _, player in pairs(players) do
        if player:getGroup():getId() > GROUP_TYPE_SENIORTUTOR then
            goto continue
        end
        local ip = player:getIp()
        if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
            checkIp[ip] = true
            local remainder = math.max(0, player:getStorageValue(config.storage)) / 10000000
            local tokens = tokensPerRun(player:isVip() and config.tokensPerHour.vip or config.tokensPerHour.free) + remainder
            player:setStorageValue(config.storage, tokens * 10000000)
            if tokens >= config.awardOn then
                local tokensMath = math.floor(tokens)
                
                -- Enviar diretamente para o depot, sem tentar o inventário
                local deliverySuccess = sendToDepot(player, config.tokenItemId, tokensMath)
                
                -- Só considera entregue se o envio funcionou
                if deliverySuccess then
                    -- Enviar mensagem ao jogador
                    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, string.format(
                        config.messages.DEPOT_FORMAT, 
                        player:getName(), 
                        tokensMath, 
                        "tokens"
                    ))
                    
                    -- Atualiza o storage com a parte fracionária restante
                    player:setStorageValue(config.storage, (tokens - tokensMath) * 10000000)
                    
                    debugLog("Tokens entregues com sucesso para " .. player:getName())
                else
                    -- Se não conseguiu entregar, mantém os tokens para tentar novamente depois
                    player:setStorageValue(config.storage, tokens * 10000000)
                    debugLog("Falha ao entregar tokens para " .. player:getName())
                end
            end
        end
        ::continue::
    end
    return true
end

if config.enabled then
    onlineTokensEvent:interval(config.interval)
    onlineTokensEvent:register()
    print("Online Tokens system started (DEPOT ONLY VERSION - 1min TEST)!")
end