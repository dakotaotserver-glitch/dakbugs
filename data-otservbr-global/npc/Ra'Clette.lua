local internalNpcName = "Ra'Clette"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 533,
	lookHead = 0,
	lookBody = 132,
	lookLegs = 76,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
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

-- Callback de saudação
local function greetCallback(npc, creature)
    local player = Player(creature)
    -- Verifica se o jogador possui a Storage necessária
    local storageValue = player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter)
    if storageValue == 6 or storageValue == 8 then
        npcHandler:setMessage(MESSAGE_GREET, "Ahoy, handsome!")
        return true
    else
        return false
    end
end

-- Callback de mensagens
local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)

    -- Verifica a Storage do jogador
    local storageValue = player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter)

    -- Caso tenha a Storage 6
    if storageValue == 6 then
        message = message:lower()
        if message == "help" then
            npcHandler:say("Yes, this pretty witch needs some help. Spiritual help. What do you say?", npc, creature)
            npcHandler:setTopic(player:getId(), 1)
        elseif message == "yes" and npcHandler:getTopic(player:getId()) == 1 then
            npcHandler:say({
                "A merchant, he annoys this pretty rat lady again and again. This witch has to teach him a lesson. Already made a nice little voodoo doll to do so. But this rat lady needs something personal. ...",
                "Something that belongs to the merchant. His name is Eustacio. Maybe you find something of use in his house. Go, bring some of his belongings, then this pretty rat will tell you more about the treasure."
            }, npc, creature)
            -- Atualiza a Storage para 7
            player:setStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter, 7)
            npcHandler:setTopic(player:getId(), 0)
        end
    end

    -- Caso tenha a Storage 8
    if storageValue == 8 then
        message = message:lower()
        if message == "help" then
            npcHandler:say("Do you have something personal from Eustacio?", npc, creature)
            npcHandler:setTopic(player:getId(), 2)
        elseif message == "yes" and npcHandler:getTopic(player:getId()) == 2 then
            npcHandler:say({
                "You did it! Thank you, this ruffian has another thing coming now! As promised, this pretty rat lady tells you what you want to know: 'You look like a donkey'. ...",
                "Yes, you do. But that's the line, understand?. Don't forget this! Little brother Queso knows another part."
            }, npc, creature)
            -- Atualiza a Storage para 9
			player:removeItem(35495, 1)
            player:setStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter, 9)
            npcHandler:setTopic(player:getId(), 0)
        elseif message == "queso" then
            npcHandler:say({
                "You helped this pretty rat lady with the merchant. So listen: Little brother Queso, he got caught smuggling. Went to jail in Thais. You find him there, the poor boy."
            }, npc, creature)
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
