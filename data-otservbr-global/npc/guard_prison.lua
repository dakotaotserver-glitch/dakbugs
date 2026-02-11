-- NPC GUARD PRISON AJUSTADO PARA CALCULAR TOKENS PENDENTES CORRETAMENTE

local internalNpcName = "Guard Prison"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 268,
	lookHead = 59,
	lookBody = 19,
	lookLegs = 95,
	lookFeet = 94,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    { text = "Aqui voce nao passa!" },
    { text = "Estou de olho em voces, prisioneiros!" },
    { text = "Talvez eu possa ajudar a encurtar sua sentenca... por um preco." },
    { text = "Dinheiro abre portas... e celas de prisao tambem." },
    { text = "Voce nao precisa minerar tudo isso... podemos chegar a um acordo." }
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

local function isInPrison(player)
	return player:getStorageValue(59999) > 0
end

local function calculateTokensRequired(player)
	local tokens = player:getStorageValue(59999)
	return tokens > 0 and tokens or 0
end

local function calculateReleasePrice(player)
	local tokensRequired = calculateTokensRequired(player)
	local playerTokens = player:getItemCount(22720)
	local tokensMissing = math.max(tokensRequired - playerTokens, 0)
	return tokensMissing * 50000
end

local function releasePlayer(player)
	local cellIndex = player:getStorageValue(59998)
	if cellIndex > 0 then
		Game.setStorageValue(60001 + cellIndex, 0)
	end
	player:removeItem(31615, 1)
	player:removeItem(22720, player:getItemCount(22720))
	player:setStorageValue(59999, 0)
	player:setStorageValue(59998, 0)
	player:teleportTo(Position(32369, 32241, 7))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been released from prison. Be careful next time!")
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "hi") then
		if isInPrison(player) then
			npcHandler:say("Hello prisoner. If you seek your {release}, just say the word.", npc, creature)
		else
			npcHandler:say("You are not a prisoner. Move along.", npc, creature)
		end
		npcHandler.topic[playerId] = 0

	elseif MsgContains(message, "release") or MsgContains(message, "freedom") then
		if isInPrison(player) then
			local tokensRequired = calculateTokensRequired(player)
			local price = calculateReleasePrice(player)
			npcHandler:say("You need " .. tokensRequired .. " tokens. Missing tokens cost " .. price .. " gold. Do you accept?", npc, creature)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("You are not a prisoner.", npc, creature)
		end

	elseif MsgContains(message, "yes") then
		if npcHandler.topic[playerId] == 1 then
			local price = calculateReleasePrice(player)
			if player:removeMoneyBank(price) then
				npcHandler:say("Payment accepted from your bank. You are free now!", npc, creature)
				releasePlayer(player)
			else
				npcHandler:say("You don't have enough money in the bank.", npc, creature)
			end
			npcHandler.topic[playerId] = 0
		end

	elseif MsgContains(message, "no") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Stay in prison then.", npc, creature)
			npcHandler.topic[playerId] = 0
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello prisoner. If you seek your {release}, just say the word.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Coward.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)