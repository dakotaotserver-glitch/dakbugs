local internalNpcName = "Enpa-Deia Pema"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 150
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1825,
	lookHead = 59,
	lookBody = 24,
	lookLegs = 24,
	lookFeet = 63,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}



-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Armaduras e armas forjadas com tecnicas ancestrais dos monges. Precos justos para todos!" },
	{ text = "Equipamentos especiais para monges! Fortalecendo corpo e espirito." },
	{ text = "O caminho do guerreiro comeca com o equipamento adequado. Visite minha humilde loja." },
	{ text = "Que a sabedoria o guie ate minha loja. Oferecemos os melhores equipamentos de Blue Valley." },
	{ text = "Paz e protecao atraves de nossas armaduras sagradas. Precos que trazem harmonia ao espirito!" },
}


npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

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
	npcHandler:onCloseChannel(npc, creature)
end

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Saudacoes, |PLAYERNAME|. Os espiritos guiaram voce ate minha humilde loja. Ofereco armaduras e armas abencoadas pelos monges de Blue Valley. Diga-me em que posso ajudar {trade}.")
	return true
end

npcConfig.shop = {
	
	{ itemName = "boots of enlightenment", clientId = 50267, buy = 8000, sell = 80 },
	{ itemName = "coned Hat of enlightenment", clientId = 50274, buy = 70000, sell = 700 },
	{ itemName = "fists of enlightenment", clientId = 50271, buy = 20000, sell = 200 },
	{ itemName = "harmony amulet", clientId = 50195, buy = 1000 },
	{ itemName = "jo staff", clientId = 50171, buy = 500 },
	{ itemName = "plain monk robe", clientId = 50257, buy = 450 },
	{ itemName = "legs of enlightenment", clientId = 50269, buy = 40000, sell = 400 },
	{ itemName = "nunchaku of enlightenment", clientId = 50273, buy = 50000, sell = 500 },
	{ itemName = "robe of enlightenment", clientId = 50268, buy = 150000, sell = 150 },
	{ itemName = "sai of enlightenment", clientId = 50272, buy = 100000, sell = 100 },
	{ itemName = "simple jo staff", clientId = 51119, buy = 10 },
	
}


npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_SENDTRADE, "Browse my wares. What category are you interested in?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Thank you for trading! Come back anytime.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Another time, then.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
