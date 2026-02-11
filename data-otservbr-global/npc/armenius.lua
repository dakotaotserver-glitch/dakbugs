local internalNpcName = "Armenius"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 114,
	lookBody = 78,
	lookLegs = 113,
	lookFeet = 115,
	lookAddons = 0,
	lookMount = 0,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- Variáveis globais para controlar o evento
local lastFightBossPlayer = nil
local lastFightBossDay = tonumber(getGlobalStorageValue(90000)) or -1 -- Armazenar o último dia em storage global

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

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	local currentTime = os.date("*t")
	local bossPosition = Position(32856, 31323, 8)

	if message == "cookie" then
		if player:getStorageValue(BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(BloodBrothers.Cookies.Armenius) < 0 then
			npcHandler:say("What kind of strange offer is this? You're actually offering me a cookie?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("It'd be better for you to leave now.", npc, creature)
		end
	elseif message == "yes" then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Errrkss - coughcough - what the - heck did you put in there? Get out of my sight!", npc, creature)
			player:setStorageValue(BloodBrothers.Cookies.Armenius, 1)
			npcHandler:setTopic(playerId, 0)
		end
		elseif message:lower() == "alori mort" and player:getStorageValue(BloodBrothers.Mission03) == 1 then
		if npcHandler:getTopic(playerId) == 2 then
			local rand = math.random(2)
			local randMessage = { "Oh, the nerve. Go to the rats which raised you.", "Oh, the nerve. Sod off." }
			npcHandler:setMessage(MESSAGE_WALKAWAY, randMessage[rand])
			player:teleportTo(Position(32759, 31241, 9))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(BloodBrothers.Mission03, 2)
		else
			npcHandler:say({
				"...... ...... ....",
				"HAHAHAHAHA! What the... HAHAHAHA! Come on, say it again, just because it's so funny - and then I'll get rid of you, little mouse!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif message:lower() == "vampiro" and currentTime.hour == 0 and currentTime.min == 0 then
		-- Checa se é o primeiro jogador do dia
		if lastFightBossDay ~= currentTime.yday then
			npcHandler:say("Prepare yourself for a fight!", npc, creature)
			
			-- Remover todas as criaturas dentro do raio de 5x5
			local spectators = Game.getSpectators(bossPosition, false, false, 5, 5, 5, 5) -- Raio de 5x5 ao redor
			for _, spectator in ipairs(spectators) do
				if spectator:isMonster() or spectator:isNpc() then
					spectator:remove()
				end
			end
			
			-- Teleporta o jogador e cria o boss
			player:teleportTo(bossPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster("Armenius (Creature)", Position(32861, 31323, 8))
			
			-- Atualiza o registro para impedir outro evento no mesmo dia
			lastFightBossPlayer = player:getId()
			lastFightBossDay = currentTime.yday
			setGlobalStorageValue(90000, lastFightBossDay)
		else
			npcHandler:say("Someone has already fought the boss today. Try again tomorrow at midnight.", npc, creature)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Ah, um aventureiro. Seja bem-vindo e sente-se. Como posso servi-lo? Quer saber sobre a lenda de um {vampiro}? volte meia noite")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 3 },
	{ itemName = "cheese", clientId = 3607, buy = 5 },
	{ itemName = "egg", clientId = 3606, buy = 2 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "mug of beer", clientId = 2880, buy = 3, count = 3 },
	{ itemName = "mug of rum", clientId = 2880, buy = 10, count = 13 },
	{ itemName = "mug of wine", clientId = 2880, buy = 4, count = 2 },
	{ itemName = "tomato", clientId = 3596, buy = 3 },
}

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
