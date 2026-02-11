local internalNpcName = "Gunther"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "A Gunther"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 128,
    lookHead = 59,
    lookBody = 79,
    lookLegs = 104,
    lookFeet = 106,
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

local function greetCallback(npc, creature)
    local player = Player(creature)
    
    -- Verifica se o jogador já tem a storage da quest
    if player:getStorageValue(Storage.U13_40.podzilla.QuestLine) > 0 then
        return false -- Se já tiver, o NPC não fala nada
    end
    
    npcHandler:say("Greetings adventurer! {podizilla} ?", npc, creature)
    npcHandler:setTopic(player:getId(), 0)
    return true
end

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()
    
    -- Verifica se o jogador já tem a storage da quest
    if player:getStorageValue(Storage.U13_40.podzilla.QuestLine) > 0 then
        return false -- Se já tiver, o NPC não fala nada
    end
    
    local topic = npcHandler:getTopic(playerId)
    local formattedMessage = "{" .. message .. "}"
    
    if topic == 0 and MsgContains(message, "adventurer") then
        npcHandler:say("I hoped to meet an  such as you! No one is listening to me, they claim I am mad, but I am not!! {mad}.", npc, creature)
        npcHandler:setTopic(playerId, 1)
    elseif topic == 1 and MsgContains(message, "mad") then
        npcHandler:say("Yes, YES! I've seen IT! ! {seen}.", npc, creature)
        npcHandler:setTopic(playerId, 2)
    elseif topic == 2 and MsgContains(message, "seen") then
        npcHandler:say("It was a plant! On open seas!!! I swear! And it was humongous! ! {humongous}.", npc, creature)
        npcHandler:setTopic(playerId, 3)
    elseif topic == 3 and MsgContains(message, "humongous") then
        npcHandler:say("It was as big as a castle! And that was only the part I could see over water! And it moved!!! ! {moved}.", npc, creature)
        npcHandler:setTopic(playerId, 4)
    elseif topic == 4 and MsgContains(message, "moved") then
        npcHandler:say("Yes it was slowly but steadily heading straight for the mainland. ! {mainland}.", npc, creature)
        npcHandler:setTopic(playerId, 5)
    elseif topic == 5 and MsgContains(message, "mainland") then
        npcHandler:say("I can't tell where or when it arrives at the shores. But somewhere at some point it will! And it will be a disaster! ! {disaster}.", npc, creature)
        npcHandler:setTopic(playerId, 6)
    elseif topic == 6 and MsgContains(message, "disaster") then
        npcHandler:say("Can you imagine the damage a gigantic walking plant will cause? It will raze cities, stomp out armies! It has to be stopped! ! {stopped}.", npc, creature)
        npcHandler:setTopic(playerId, 7)
    elseif topic == 7 and MsgContains(message, "stopped") then
        npcHandler:say("I called in a few favours from the adventurer's guild and the explorer society to fund an expedition to seek out that monster. ! {souls}.", npc, creature)
        npcHandler:setTopic(playerId, 8)
    elseif topic == 8 and MsgContains(message, "souls") then
        npcHandler:say("Say, will you be one of the heroes to save the day? {yes} or {no}?", npc, creature)
        npcHandler:setTopic(playerId, 9)
    elseif topic == 9 and MsgContains(message, "yes") then
        npcHandler:say("I knew you had it in you! Please hurry, talk to the captain and tell him Gunther sent you!", npc, creature)
        npcHandler:setTopic(playerId, 0)
        
        -- Verifica se o jogador tem level 300+ e atribui a storage
        if player:getLevel() >= 300 then
            player:setStorageValue(Storage.U13_40.podzilla.QuestLine, 1)
			player:setStorageValue(Storage.U13_40.podzilla.acessopodzilla, 1)
        else
            npcHandler:say("You are not strong enough for this journey. You need to be at least level 300 to proceed!", npc, creature)
            return true
            
        end
    else
        npcHandler:say("Let's start over from the beginning! Say {adventurer} to start again.", npc, creature)
        npcHandler:setTopic(playerId, 0)
    end
    return true
end
npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! How can I help you today? {podzilla} ?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
