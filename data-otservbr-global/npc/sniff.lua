local internalNpcName = "Sniff"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1346,
	lookHead = 2,
	lookBody = 57,
	lookLegs = 78,
	lookFeet = 96,
	lookAddons = 1,
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
    if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter) >= 3 then
        npcHandler:setMessage(MESSAGE_GREET, "Ahoy, matey!")
        return true
    else
        -- Não interage se a Storage não tiver o valor esperado
        return false
    end
end

-- Callback de mensagens
local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)

    -- Verifica se o jogador possui a Storage necessária
    local storageValue = player:getStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter)

    if storageValue < 3 then
        return false -- Não responde se o jogador não tiver a Storage necessária
    end

    message = message:lower()

    if storageValue == 3 then
        -- Conversação inicial
        if message == "help" then
            npcHandler:say("Yes, there something. Some small problem me has right now. Want to help?", npc, creature)
            npcHandler:setTopic(player:getId(), 1)
        elseif message == "yes" and npcHandler:getTopic(player:getId()) == 1 then
            npcHandler:say({
                "Good choice, you! Listen: Me has bad luck lately. Me had small boat, but heavy storm came ... boat sinks. And with it my goods. Me a merchant, you know. Rich and important corym merchant. ...",
                "Without my goods, me will be poor and miserable merchant. You get back my goods, me tells you line. Boat sank on southern coast of Plains of Havoc. Small bay there. ...",
                "Goods are in barrel between wreckage, me seen them from the shore! But many sharks in the water! Me not brave enough to swim there. But you look brave. You can do! ...",
                "Be careful. Can't swim everywhere without being attacked by sharks. Some spots safe, others not."
            }, npc, creature)
            player:setStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter, 4) -- Atualiza a Storage para 4
            npcHandler:setTopic(player:getId(), 0)
        end
    elseif storageValue == 5 then
        -- Conversação com a Storage 5
        if message == "help" then
            npcHandler:say("Found my precious goods?", npc, creature)
            npcHandler:setTopic(player:getId(), 2)
        elseif message == "yes" and npcHandler:getTopic(player:getId()) == 2 then
            npcHandler:say({
                "There they are, precious goods! Thank you! As promised, I tell you line now: 'Mould is blue!' Don't forget! Ra'Clette knows third part."
            }, npc, creature)
			player:removeItem(35479, 1)
			player:setStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter, 6)
            npcHandler:setTopic(player:getId(), 0)
        elseif message == "ra'clette" then
            npcHandler:say({
                "You brought back my goods. Perhaps me can trust you now. Listen, oldest sister, she a powerful witch. Works together with the charlatans now, the little ones. You find her above their camp."
            }, npc, creature)
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
