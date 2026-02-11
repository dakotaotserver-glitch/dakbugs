local internalNpcName = "Online Token"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 471,
	lookHead = 0,
	lookBody = 57,
	lookLegs = 0,
	lookFeet = 68,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 25000,
	chance = 50,
	{ text = "Tokens online: use-os para comprar itens!" },
}

-- ID do token online
npcConfig.currency = 62218

npcConfig.currency = 62218

npcConfig.shop = {
	
	-- Durable Exercise Weapons
	{ itemName = "durable exercise rod", clientId = 35283, buy = 5, count = 1800 },
	{ itemName = "durable exercise wand", clientId = 35284, buy = 5, count = 1800 },
	{ itemName = "durable exercise axe", clientId = 35280, buy = 5, count = 1800 },
	{ itemName = "durable exercise bow", clientId = 35282, buy = 5, count = 1800 },
	{ itemName = "durable exercise club", clientId = 35281, buy = 5, count = 1800 },
	{ itemName = "durable exercise shield", clientId = 44066, buy = 5, count = 1800 },
	{ itemName = "durable exercise sword", clientId = 35279, buy = 5, count = 1800 },
	{ itemName = "durable exercise 50294", clientId = 35279, buy = 5, count = 1800 },
	
	-- Lasting Exercise Weapons
	{ itemName = "lasting exercise rod", clientId = 35289, buy = 40, count = 14400 },
	{ itemName = "lasting exercise wand", clientId = 35290, buy = 40, count = 14400 },
	{ itemName = "lasting exercise axe", clientId = 35286, buy = 40, count = 14400 },
	{ itemName = "lasting exercise bow", clientId = 35288, buy = 40, count = 14400 },
	{ itemName = "lasting exercise club", clientId = 35287, buy = 40, count = 14400 },
	{ itemName = "lasting exercise shield", clientId = 44067, buy = 40, count = 14400 },
	{ itemName = "lasting exercise sword", clientId = 35285, buy = 40, count = 14400 },
	{ itemName = "lasting exercise wraps", clientId = 50295, buy = 40, count = 14400 },
	
	-- Canivetes
	{ itemName = "whacking driller of fate", clientId = 9599, buy = 50 },
	{ itemName = "squeezing gear of girlpower", clientId = 9596, buy = 50 },
	{ itemName = "sneaky stabber of eliteness", clientId = 9594, buy = 50 },
	
	{ itemName = "axe of desctruction", clientId = 27451, buy = 200 },
	{ itemName = "blade of desctruction", clientId = 27449, buy = 200 },
	{ itemName = "bow of desctruction", clientId = 27455, buy = 200 },
	{ itemName = "chopper of desctruction", clientId = 27452, buy = 200 },
	{ itemName = "crossbow of desctruction", clientId = 27456, buy = 200 },
	{ itemName = "hammer of desctruction", clientId = 27454, buy = 200 },
	{ itemName = "mace of desctruction", clientId = 27453, buy = 200 },
	{ itemName = "rod of desctruction", clientId = 27458, buy = 200 },
	{ itemName = "slayer of desctruction", clientId = 27450, buy = 200 },
	{ itemName = "wand of desctruction", clientId = 27457, buy = 200 },
	{ itemName = "nunchaku of destruction", clientId = 50168, buy = 200 },
	
	--armos
	{ itemName = "earthheart cuirass", clientId = 22521, buy = 200 },
	{ itemName = "earthheart hauberk", clientId = 22522, buy = 200 },
	{ itemName = "earthheart platemail", clientId = 22523, buy = 200 },
	{ itemName = "earthmind raiment", clientId = 22535, buy = 200 },
	{ itemName = "earthsoul tabard", clientId = 22531, buy = 200 },
	{ itemName = "fireheart cuirass", clientId = 22518, buy = 200 },
	{ itemName = "fireheart hauberk", clientId = 22519, buy = 200 },
	{ itemName = "fireheart platemail", clientId = 22520, buy = 200 },
	{ itemName = "firemind raiment", clientId = 22534, buy = 200 },
	{ itemName = "firesoul tabard", clientId = 22530, buy = 200 },
	{ itemName = "frostheart cuirass", clientId = 22527, buy = 200 },
	{ itemName = "frostheart hauberk", clientId = 22528, buy = 200 },
	{ itemName = "frostheart platemail", clientId = 22529, buy = 200 },
	{ itemName = "frostmind raiment", clientId = 22537, buy = 200 },
	{ itemName = "frostsoul tabard", clientId = 22533, buy = 200 },
	{ itemName = "magic shield potion", clientId = 35563, buy = 5 },
	{ itemName = "thunderheart cuirass", clientId = 22524, buy = 200 },
	{ itemName = "thunderheart hauberk", clientId = 22525, buy = 200 },
	{ itemName = "thunderheart platemail", clientId = 22526, buy = 200 },
	{ itemName = "thundermind raiment", clientId = 22536, buy = 200 },
	{ itemName = "thundersoul tabard", clientId = 22532, buy = 200 },

	--armas inicials

	{ itemName = "crude umbral blade", clientId = 20064, buy = 10 },
	{ itemName = "crude umbral slayer", clientId = 20067, buy = 10 },
	{ itemName = "crude umbral axe", clientId = 20070, buy = 10 },
	{ itemName = "crude umbral chopper", clientId = 20073, buy = 10 },
	{ itemName = "crude umbral mace", clientId = 20076, buy = 10 },
	{ itemName = "crude umbral hammer", clientId = 20079, buy = 10 },
	{ itemName = "crude umbral bow", clientId = 20082, buy = 10 },
	{ itemName = "crude umbral crossbow", clientId = 20085, buy = 10 },
	{ itemName = "crude umbral spellbook", clientId = 20088, buy = 10 },
	{ itemName = "crude umbral katar", clientId = 50163, buy = 10 },

	
	 -- gemas

	 --{ itemName = "lesser guardian gem", clientId = 44602, buy = 15 },
	 --{ itemName = "guardian gem", clientId = 44603, buy = 25 },
	 --{ itemName = "greater guardian gem", clientId = 44604, buy = 45 },
	-- { itemName = "lesser marksman gem", clientId = 44605, buy = 15 },
	-- { itemName = "marksman gem", clientId = 44606, buy = 25 },
	 --{ itemName = "greater marksman gem", clientId = 44607, buy = 45 },
	-- { itemName = "lesser sage gem", clientId = 44608, buy = 15 },
	-- { itemName = "sage gem", clientId = 44609, buy = 25 },
	 --{ itemName = "greater sage gem", clientId = 44610, buy = 45 },
	 --{ itemName = "lesser mystic gem", clientId = 44611, buy = 15 },
	 --{ itemName = "mystic gem", clientId = 44612, buy = 25 },
	-- { itemName = "greater mystic gem", clientId = 44613, buy = 45 },
	
	--food especial
	{ itemName = "carrot pie", clientId = 29409, buy = 10 },
	{ itemName = "blessed steak", clientId = 9086, buy = 15 },
	{ itemName = "blueberry cupcake", clientId = 28484, buy = 15 },
	{ itemName = "carrion casserole", clientId = 29414, buy = 9 },
	{ itemName = "carrot cake", clientId = 9087, buy = 7 },
	{ itemName = "chilli con carniphila", clientId = 29412, buy = 10 },
	{ itemName = "coconut shrimp bake", clientId = 11584, buy = 8 },
	{ itemName = "consecrated beef", clientId = 29415, buy = 9 },
	{ itemName = "delicatessen salad", clientId = 29411, buy = 9 },
	{ itemName = "demonic candy ball", clientId = 11587, buy = 5 },
	{ itemName = "filled jalapeno peppers", clientId = 9085, buy = 12 },
	{ itemName = "hydra tongue salad", clientId = 9080, buy = 9 },
	{ itemName = "lemon cupcake", clientId = 28486, buy = 12 },
	{ itemName = "northern fishburger", clientId = 9088, buy = 9 },
	{ itemName = "pot of blackjack", clientId = 11586, buy = 8 },
	{ itemName = "roasted dragon wings", clientId = 9081, buy = 8 },
	{ itemName = "roasted wyvern wings", clientId = 29408, buy = 7 },
	{ itemName = "rotworm stew", clientId = 9079, buy = 8 },
	{ itemName = "strawberry cupcake", clientId = 28485, buy = 8 },
	{ itemName = "svargrond salmon filet", clientId = 29413, buy = 5 },
	{ itemName = "sweet mangonaise elixir", clientId = 11588, buy = 12 },
	{ itemName = "tropical fried terrorbird", clientId = 9082, buy = 10 },
	{ itemName = "tropical marinated tiger", clientId = 29410, buy = 9 },
	{ itemName = "moon mirror", clientId = 25975, buy = 100 },
	{ itemName = "starlight vial", clientId = 25976, buy = 100 },
	{ itemName = "sun catcher", clientId = 25977, buy = 100 },
	{ itemName = "scarab ocarina", clientId = 43740, buy = 100 },
	{ itemName = "bone fiddle", clientId = 28493, buy = 100 },
	{ itemName = "lit torch", clientId = 34016, buy = 100 },
	{ itemName = "conch shell horn", clientId = 43863, buy = 100 },
}

-- Função para obter tokens do banco de dados
local function getPlayerTokens(player)
    local playerId = player:getGuid()
    local resultId = db.storeQuery("SELECT `amount` FROM `player_online_tokens` WHERE `player_id` = " .. playerId)
    
    if resultId then
        local amount = result.getNumber(resultId, "amount")
        result.free(resultId)
        return amount
    end
    
    return 0
end

-- Função para reduzir tokens do jogador
local function removePlayerTokens(player, amount)
    local playerId = player:getGuid()
    local currentTokens = getPlayerTokens(player)
    
    if currentTokens < amount then
        return false
    end
    
    local newAmount = currentTokens - amount
    db.query("UPDATE `player_online_tokens` SET `amount` = " .. newAmount .. " WHERE `player_id` = " .. playerId)
    return true
end

-- Sistema híbrido: Adicionar temporariamente tokens físicos ao jogador antes de abrir a loja
local function addTemporaryTokens(player)
    local dbTokens = getPlayerTokens(player)
    
    if dbTokens > 0 then
        -- Armazenar quantos tokens serão adicionados temporariamente
        player:setStorageValue(10095, dbTokens)
        
        -- Zerar os tokens no banco de dados
        local playerId = player:getGuid()
        db.query("UPDATE `player_online_tokens` SET `amount` = 0 WHERE `player_id` = " .. playerId)
        
        -- Adicionar os tokens temporariamente ao inventário
        player:addItem(npcConfig.currency, dbTokens)
    end
end

-- Remover tokens temporários após fechar a loja e devolver os não gastos para o banco de dados
local function removeTemporaryTokens(player)
    local tempTokens = player:getStorageValue(10095)
    
    if tempTokens > 0 then
        local inventoryTokens = player:getItemCount(npcConfig.currency)
        
        -- Devolver os tokens não gastos para o banco de dados
        if inventoryTokens > 0 then
            local playerId = player:getGuid()
            db.query("UPDATE `player_online_tokens` SET `amount` = amount + " .. inventoryTokens .. " WHERE `player_id` = " .. playerId)
        end
        
        -- Remover todos os tokens do inventário
        if inventoryTokens > 0 then
            player:removeItem(npcConfig.currency, inventoryTokens)
        end
        
        -- Resetar o storage
        player:setStorageValue(10095, 0)
    end
end

-- ✅ CORREÇÃO: Declarar keywordHandler e npcHandler ANTES de usar
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
    -- Entregar o item (os tokens já foram transferidos para o inventário)
    npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
    
    -- Mensagem
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
        string.format("Você gastou %d tokens e adquiriu seu item.", totalCost))
    
    return true
end

-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
    local itemType = ItemType(clientId)
    local itemName = itemType:getName()
    local itemCost = 0
    
    -- Encontrar o custo do item
    for _, item in ipairs(npcConfig.shop) do
        if item.clientId == clientId then
            itemCost = item.buy
            break
        end
    end
    
    local tokens = getPlayerTokens(player)
    
    if tokens >= itemCost then
        npcHandler:say("Este " .. itemName .. " custa " .. itemCost .. " tokens. Você tem " .. tokens .. " tokens em sua conta, então pode comprá-lo!", npc, player)
    else
        npcHandler:say("Este " .. itemName .. " custa " .. itemCost .. " tokens. Você tem apenas " .. tokens .. " tokens em sua conta, então precisa de mais " .. (itemCost - tokens) .. " tokens.", npc, player)
    end
end

npcType.onThink = function(npc, interval)
    npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
    npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
    npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
    npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
    npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
    local player = Player(creature)
    if player then
        removeTemporaryTokens(player)
    end
    npcHandler:onCloseChannel(npc, creature)
end

local function greetCallback(npc, creature)
    local player = Player(creature)
    local playerId = player:getId()
    
    -- Mostrar tokens ao cumprimentar
    local tokens = getPlayerTokens(player)
    npcHandler:say("Bem-vindo! Você tem " .. tokens .. " tokens em sua conta. Diga {trade} para ver minhas ofertas.", npc, creature)
    
    -- Adicionar tokens temporários antes de abrir a loja
    addTemporaryTokens(player)
    
    -- Abre a janela da loja diretamente quando o jogador cumprimenta o NPC
    npc:openShopWindow(creature)
    
    npcHandler:setTopic(playerId, 0)
    return true
end

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    if MsgContains(message, "information") then
        npcHandler:say({ "{Tokens} são pequenos objetos utilizados para compras especiais. Você pode acumulá-los e usá-los para obter equipamentos superiores de comerciantes como eu.", "Há várias maneiras de obter tokens." }, npc, creature)
    elseif MsgContains(message, "balance") or MsgContains(message, "tokens") then
        local tokens = getPlayerTokens(player)
        npcHandler:say("Você tem " .. tokens .. " tokens em sua conta.", npc, creature)
    elseif MsgContains(message, "trade") then
        -- Adicionar tokens temporários antes de abrir a loja
        addTemporaryTokens(player)
        
        npc:openShopWindow(creature)
        npcHandler:say("Aqui estão minhas ofertas. Você tem " .. getPlayerTokens(player) .. " tokens disponíveis.", npc, creature)
    end
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, false)

npcType:register(npcConfig)

