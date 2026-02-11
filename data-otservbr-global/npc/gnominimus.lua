local internalNpcName = "Gnominimus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 58,
	lookBody = 82,
	lookLegs = 58,
	lookFeet = 95,
	lookAddons = 0,
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

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()
	local playerName = player:getName()

	if message:lower() == "hi" then
		npcHandler:say("Ola " .. playerName .. " sou otimo em {montar} itens valiosos o que voce tem pra mim?", npc, creature)
		npcHandler:setInteraction(npc, creature)
		return true
	end

	return false
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if message:lower() == "montar" then
		npcHandler:say("Vejo que voce chegou ate aqui e nao esta de maos abanando entao voce quer que eu monte algo?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif message:lower() == "yes" then
		if npcHandler:getTopic(playerId) == 1 then
			-- Verifica se o jogador tem os itens necessarios na mochila
			if player:getItemCount(27525) >= 1 and player:getItemCount(27524) >= 1 and player:getItemCount(27526) >= 1 then
				-- Remove os itens
				player:removeItem(27525, 1)
				player:removeItem(27524, 1)
				player:removeItem(27526, 1)
				
				-- Adiciona o item montado com actionId 33160
				local newItem = player:addItem(27523, 1)
				if newItem then
					newItem:setActionId(33160)
					npcHandler:say("Excelente Aqui esta o item que eu montei para voce", npc, creature)
				else
					npcHandler:say("Parece que voce nao tem espaco para receber o item", npc, creature)
				end
			else
				npcHandler:say("Voce nao tem os itens necessarios para que eu monte algo para voce, seriam esses: Mallet Handle, Mallet Head e Mallet Pommel, quando estier esses itens volte que eu montarei", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end

	return true
end

-- Saudacao personalizada
keywordHandler:addCustomGreetKeyword({ "hi" }, greetCallback, { npcHandler = npcHandler })

-- Configuracao de mensagens padrao do NPC
npcHandler:setMessage(MESSAGE_FAREWELL, "Adeus |PLAYERNAME| Espero que voce volte com mais itens")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Ate mais espero velo em breve")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Vamos negociar de uma olhada nos meus itens")

-- Definir callback para conversas
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Configuracao de comercio do NPC
npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 4 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
}

-- Funcoes de compra e venda
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Vendeu %ix %s por %i gold", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
