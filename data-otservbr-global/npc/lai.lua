local internalNpcName = "Lai"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = 100
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
    lookType = 1817, -- Ajuste se quiser outro visual para o NPC Lai
    lookHead = 79,
    lookBody = 19,
    lookLegs = 94,
    lookFeet = 79,
    lookAddons = 79,
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

-- Storages e outfits
local STORAGE_RECEIVED = 65148
local STORAGE_BOSSKILL = 65149
local OUTFIT_MALE = 1809
local OUTFIT_FEMALE = 1808

local function greetCallback(npc, creature, message)
    local player = Player(creature)
    if not MsgContains(message, "hi") then
        npcHandler:unGreet(npc, creature)
        return false
    end
    npcHandler:say("Be greeted, seeker of knowledge! We should talk about your {mission}.", npc, creature)
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

    if (talkState == 1 or talkState == 0) and msg == "mission" then
        if player:getStorageValue(STORAGE_RECEIVED) == 1 then
            npcHandler:say("You already possess the outfit I have to offer!", npc, creature)
            npcHandler:setTopic(pid, 0)
            return true
        end
        if player:getStorageValue(STORAGE_BOSSKILL) >= 1 then
            npcHandler:say("You killed the prince. I have little to reward you, but take this set of armor that I found in the ruins as a token of my gratitude! May this outfit serve you well.", npc, creature)
            -- Dá a outfit correta conforme sexo
            if player:getSex() == PLAYERSEX_MALE then
                player:addOutfit(OUTFIT_MALE, 0)
            else
                player:addOutfit(OUTFIT_FEMALE, 0)
            end
            player:setStorageValue(STORAGE_RECEIVED, 1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a special outfit!")
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        else
            npcHandler:say("You still have to prove yourself. Return after you have defeated the prince.", npc, creature)
        end
        npcHandler:setTopic(pid, 0)
        return true
    end

    -- Sai educadamente
    if msg == "bye" or msg == "goodbye" then
        npcHandler:say("Farewell, seeker!", npc, creature)
        npcHandler:unGreet(npc, creature)
        npcHandler:setTopic(pid, 0)
        return true
    end
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcHandler:setMessage(MESSAGE_GREET, "Be greeted, seeker of knowledge! We should talk about your {mission}.")

npcType:register(npcConfig)
