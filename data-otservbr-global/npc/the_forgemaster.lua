local internalNpcName = "The Forgemaster"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = 100
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
    lookType = 247,
    lookHead = 0,
    lookBody = 0,
    lookLegs = 0,
    lookFeet = 0,
    lookAddons = 0,
}

npcConfig.flags = { floorchange = false }

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval) npcHandler:onThink(npc, interval) end
npcType.onAppear = function(npc, creature) npcHandler:onAppear(npc, creature) end
npcType.onDisappear = function(npc, creature) npcHandler:onDisappear(npc, creature) end
npcType.onMove = function(npc, creature, fromPosition, toPosition) npcHandler:onMove(npc, creature, fromPosition, toPosition) end
npcType.onSay = function(npc, creature, type, message) npcHandler:onSay(npc, creature, type, message) end
npcType.onCloseChannel = function(npc, creature) npcHandler:onCloseChannel(npc, creature) end

local STORAGE_KILLS = 65145
local STORAGE_GOT_KEY = 65146

local function MsgContains(str, txt)
    return str:lower():find(txt:lower(), 1, true)
end

local function greetCallback(npc, creature, message)
    local player = Player(creature)
    if not MsgContains(message, "hi") then
        npcHandler:unGreet(npc, creature)
        return false
    end

    npcHandler:say("What brings you here this time, do you want to craft a weapon in the forge? {key} ?", npc, creature)
    npcHandler:setInteraction(npc, creature)
    npcHandler:setTopic(player:getId(), 1)
    return true
end

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local pid = player:getId()
    local msg = message:lower()
    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end
    local talkState = npcHandler:getTopic(pid) or 0

    if talkState == 1 and msg == "key" then
        if player:getStorageValue(STORAGE_KILLS) >= 10 then
            -- JÁ FEZ 10 KILLS
            npcHandler:say("I better warn you about my former master's magical wards. You can pick only one of my early prototypes from Arbaziloth's private weapon chamber each thousand years. So choose wisely, ok? Here's the key.", npc, creature)
            npcHandler:say("Of course you still might want to craft a weapon?", npc, creature)
            player:setStorageValue(STORAGE_GOT_KEY, 1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received the Lost Key to Arbaziloth's private weapon chamber!")
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        else
            -- MENOS DE 10 KILLS
            npcHandler:say("Yes, yes, I understand you are interested in Arbaziloth's private weapon collection. ....", npc, creature)
            npcHandler:say("I ... uh ... just need some more time to retrieve the key. Perhaps after some more visits here, I'll be able to find it, oh slayer of many.", npc, creature)
            npcHandler:say("Your battle prowess is truly frightening. But ... imagine, I JUST recovered the lost key to Arbaziloth's private weapon chamber.", npc, creature)
        end
        npcHandler:setTopic(pid, 0)
        return true
    end

    if msg == "bye" or msg == "goodbye" then
        npcHandler:say("Stay safe near the forge, adventurer.", npc, creature)
        npcHandler:unGreet(npc, creature)
        npcHandler:setTopic(pid, 0)
        return true
    end
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcHandler:setMessage(MESSAGE_GREET, "What brings you here this time, do you want to craft a weapon in the forge? {key} ?")

npcType:register(npcConfig)
