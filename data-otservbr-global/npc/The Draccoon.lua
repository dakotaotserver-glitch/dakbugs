local internalNpcName = "The Draccoon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "A mysterious draccoon that seems to be up to something."

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 1703,   -- Modelo do NPC (olha-se como um 'draccoon')
    lookHead = 0,
    lookBody = 0,
    lookLegs = 0,
    lookFeet = 0,
    lookAddons = 0,
}

npcConfig.flags = {
    floorchange = false,  -- Impede o NPC de mudar de andar, se necessário
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

-- Função de resposta aos comandos do jogador
local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    -- Verificando se o jogador está em interação com o NPC
    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    -- Respostas baseadas nas mensagens do jogador

    if MsgContains(message, "hi") then
        npcHandler:say("Hello, " .. player:getName() .. "! I am glad to see you!", npc, creature)
        npcHandler:setTopic(playerId, 1)
    elseif MsgContains(message, "mission") then
        npcHandler:say("The Titano Dragon is slain and the world safe, thanks to you! ...", npc, creature)
        npcHandler:say("Well a bit more safe at least. In Nimmersatt's breeding grounds there is still this dangerous breed awaiting his call for war. ...", npc, creature)
        npcHandler:say("If you are interested, you can from now on access the secret entrance to these lairs by using one of our secret entrances. Just look for one of our trusted trash cans in one of Zao's little palaces. ...", npc, creature)
        npcHandler:say("I guess his breeds will put up some challenge and you might even want to face his champions, but that's for you to decide.", npc, creature)
        npcHandler:setTopic(playerId, 2)
    elseif MsgContains(message, "decide") then
        npcHandler:say("Well, you have done a lot for me and will want to mind your own business again. Still let me express my gratitude!", npc, creature)
        npcHandler:setTopic(playerId, 3)
    elseif MsgContains(message, "gratitude") then
        npcHandler:say("My friend your help has been invaluable! There are still loose ends and things to do, but that's for me and my other buddies to handle. ...", npc, creature)
        npcHandler:say("For you though, I have another, very special appointment! I hereby name you my herald! Go and tell the world: the Draccoon is back! ...", npc, creature)
        npcHandler:say("Wear the herald's outfit with pride. And who knows, I might have some other tasks for you eventually, be it even in, say, 5 or even 10 years! Who knows? ...", npc, creature)
        npcHandler:say("Oh and I managed to find a way for you to extract Ratha from your mind again. Just use the vial in that shelf over there. This time absolutely nothing bad can happen. {OUTFIT}", npc, creature)
      elseif MsgContains(message, "outfit") then
		npcHandler:say("Parabens voce recebeu a {Draccoon Herald} outfit", npc, creature)
        npcHandler:setTopic(playerId, 4)
		player:addOutfit(1722, 0)
		player:addOutfit(1723, 0)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		npcHandler:setTopic(playerId, 0)
		
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Registrando o NPC
npcType:register(npcConfig)
