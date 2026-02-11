local internalNpcName = "A Fading Memory"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = 100
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 138,
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

-- Storage para cooldown do item (24h)
local SOUVENIR_COOLDOWN = 65199
local SOUVENIR_ITEM_ID = 8746
local COOLDOWN_SECONDS = 24 * 60 * 60

-- Greeting only on "hi"
local function greetCallback(npc, creature, message)
    local player = Player(creature)
    local pid = player:getId()
    if not MsgContains(message, "hi") then
        npcHandler:unGreet(npc, creature)
        return false
    end
    npcHandler:say("Ohh... {kala} ", npc, creature)
    npcHandler:setInteraction(npc, creature)
    npcHandler:setTopic(pid, 1)
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

    if talkState == 1 and msg == "kala" then
        npcHandler:say("... yes! That's my name... how come you know that? {diary}", npc, creature)
        npcHandler:setTopic(pid, 2)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {diary}")
        return true
    end

    if talkState == 2 and msg == "diary" then
        npcHandler:say("... you... read Marziel's diary and know our story...? {yes} ", npc, creature)
        npcHandler:setTopic(pid, 3)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {yes}")
        return true
    end

    if talkState == 3 and msg == "yes" then
        npcHandler:say("... then... tell me... I'm so sad... was it my fault? Why did he leave me... Arthei..? {vampire} ", npc, creature)
        npcHandler:setTopic(pid, 4)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {vampire}")
        return true
    end

    if talkState == 4 and msg == "vampire" then
        npcHandler:say("... so there is nothing I could have done...? He's a vampire now... what can we do... {free soul} ", npc, creature)
        npcHandler:setTopic(pid, 5)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {free soul}")
        return true
    end

    if talkState == 5 and msg == "free soul" then
        npcHandler:say("... he can't be freed from his curse that easily... he must be awaken first... {awaken} ", npc, creature)
        npcHandler:setTopic(pid, 6)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {awaken}")
        return true
    end

    if talkState == 6 and msg == "awaken" then
        -- Checa cooldown
        local now = os.time()
        local lastTime = player:getStorageValue(SOUVENIR_COOLDOWN)
        if lastTime > now then
            local left = lastTime - now
            local hours = math.floor(left / 3600)
            local minutes = math.floor((left % 3600) / 60)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait " .. hours .. " hours and " .. minutes .. " minutes before receiving another souvenir.")
            npcHandler:say("... I'm sorry... but I already gave you everything I could...", npc, creature)
        else
            player:addItem(SOUVENIR_ITEM_ID, 1)
            player:setStorageValue(SOUVENIR_COOLDOWN, now + COOLDOWN_SECONDS)
            npcHandler:say("... to awake him... I don't know but... he once truly loved me... maybe there is still something left... somewhere... here... take this from me....and thank you for listening...", npc, creature)
        end
        npcHandler:setTopic(pid, 0)
        return true
    end

    -- Se o player disser "bye", encerrar conversa
    if msg == "bye" or msg == "goodbye" then
        npcHandler:say("Farewell...", npc, creature)
        npcHandler:unGreet(npc, creature)
        npcHandler:setTopic(pid, 0)
        return true
    end

    -- Dicas de palavra (azul) se o player errar
    if talkState == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {kala}")
    elseif talkState == 2 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {diary}")
    elseif talkState == 3 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {yes}")
    elseif talkState == 4 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {vampire}")
    elseif talkState == 5 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {free soul}")
    elseif talkState == 6 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Try saying: {awaken}")
    end
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcHandler:setMessage(MESSAGE_GREET, "Ohh... {kala} ")

npcType:register(npcConfig)
