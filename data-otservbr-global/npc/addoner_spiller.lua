local internalNpcName = "Addoner"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 130,
    lookHead = 115,
    lookBody = 39,
    lookLegs = 96,
    lookFeet = 118,
    lookAddons = 3
}

npcConfig.flags = {
    floorchange = false
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    {text = 'Come see my Addons bro!'}
}

-- Base Storage ID para addons (começando em 50000 para evitar conflitos)
local BASE_STORAGE = 50000

-- Storage específico para Barbarian para evitar conflitos
local BARBARIAN_FIRST_STORAGE = 70001
local BARBARIAN_SECOND_STORAGE = 70002

-- Sistema de addons com Storage IDs fixos
local addoninfo = {
    ['first citizen addon'] = {cost = 0, items = {{5878,100}}, outfit_female = 136, outfit_male = 128, addon = 1, storageID = BASE_STORAGE + 1},
    ['second citizen addon'] = {cost = 0, items = {{5890,50}, {5902,25}, {3374,1}}, outfit_female = 136, outfit_male = 128, addon = 2, storageID = BASE_STORAGE + 2},
    
    ['first hunter addon'] = {cost = 0, items = {{5876,100}, {5948,100}, {5891,5}, {5887,1}, {5889,1}, {5888,1}}, outfit_female = 137, outfit_male = 129, addon = 1, storageID = BASE_STORAGE + 3},
    ['second hunter addon'] = {cost = 0, items = {{5875,1}}, outfit_female = 137, outfit_male = 129, addon = 2, storageID = BASE_STORAGE + 4},
    
    ['first knight addon'] = {cost = 0, items = {{5880,100}, {5892,1}}, outfit_female = 139, outfit_male = 131, addon = 1, storageID = BASE_STORAGE + 5},
    ['second knight addon'] = {cost = 0, items = {{5893,100}, {5924,1}, {5885,1}, {5887,1}}, outfit_female = 139, outfit_male = 131, addon = 2, storageID = BASE_STORAGE + 6},
    
    ['first mage addon'] = {cost = 0, items = {{3074,1}, {3075,1}, {3072,1}, {3073,1}, {3071,1}, {3066,1}, {3070,1}, {3069,1}, {3065,1}, {3067,1}, {5904,10}, {3077,20}, {5809,1}}, outfit_female = 138, outfit_male = 130, addon = 1, storageID = BASE_STORAGE + 7},
    ['second mage addon'] = {cost = 0, items = {{5903,1}}, outfit_female = 138, outfit_male = 130, addon = 2, storageID = BASE_STORAGE + 8},
    
    ['first summoner addon'] = {cost = 0, items = {{5958,1}}, outfit_female = 141, outfit_male = 133, addon = 1, storageID = BASE_STORAGE + 9},
    ['second summoner addon'] = {cost = 0, items = {{5894,70}, {5911,20}, {5883,40}, {5922,35}, {5886,10}, {5881,60}, {5882,40}, {5904,15}, {5905,30}}, outfit_female = 141, outfit_male = 133, addon = 2, storageID = BASE_STORAGE + 10},
    
    ['first barbarian addon'] = {cost = 0, items = {{5880,100}, {5892,1}, {5893,50}, {5876,50}}, outfit_female = 147, outfit_male = 143, addon = 1, storageID = BARBARIAN_FIRST_STORAGE},
    ['second barbarian addon'] = {cost = 0, items = {{5884,1}, {5885,1}, {5910,50}, {5911,50}, {5886,10}}, outfit_female = 147, outfit_male = 143, addon = 2, storageID = BARBARIAN_SECOND_STORAGE},
    
    ['first druid addon'] = {cost = 0, items = {{5896,50}, {5897,50}}, outfit_female = 148, outfit_male = 144, addon = 1, storageID = BASE_STORAGE + 13},
    ['second druid addon'] = {cost = 0, items = {{5906,100}}, outfit_female = 148, outfit_male = 144, addon = 2, storageID = BASE_STORAGE + 14},
    
    ['first nobleman addon'] = {cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 1, storageID = BASE_STORAGE + 15},
    ['second nobleman addon'] = {cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 2, storageID = BASE_STORAGE + 16},
    
    ['first oriental addon'] = {cost = 0, items = {{5945,1}}, outfit_female = 150, outfit_male = 146, addon = 1, storageID = BASE_STORAGE + 17},
    ['second oriental addon'] = {cost = 0, items = {{5883,100}, {5895,100}, {5891,2}, {5912,100}}, outfit_female = 150, outfit_male = 146, addon = 2, storageID = BASE_STORAGE + 18},
    
    ['first warrior addon'] = {cost = 0, items = {{5925,100}, {5899,100}, {5884,1}, {5919,1}}, outfit_female = 142, outfit_male = 134, addon = 1, storageID = BASE_STORAGE + 19},
    ['second warrior addon'] = {cost = 0, items = {{5880,100}, {5887,1}}, outfit_female = 142, outfit_male = 134, addon = 2, storageID = BASE_STORAGE + 20},
    
    ['first wizard addon'] = {cost = 0, items = {{5922,50}}, outfit_female = 149, outfit_male = 145, addon = 1, storageID = BASE_STORAGE + 21},
    ['second wizard addon'] = {cost = 0, items = {{3436,1}, {3386,1}, {3382,1}, {3006,1}}, outfit_female = 149, outfit_male = 145, addon = 2, storageID = BASE_STORAGE + 22},
    
    ['first assassin addon'] = {cost = 0, items = {{5912,50}, {5910,50}, {5911,50}, {5913,50}, {5914,50}, {5909,50}, {5886,10}}, outfit_female = 156, outfit_male = 152, addon = 1, storageID = BASE_STORAGE + 23},
    ['second assassin addon'] = {cost = 0, items = {{5804,1}, {5930,1}}, outfit_female = 156, outfit_male = 152, addon = 2, storageID = BASE_STORAGE + 24},
    
    ['first beggar addon'] = {cost = 0, items = {{5878,50}, {5921,30}, {5913,20}, {5894,10}, {5883,100}}, outfit_female = 157, outfit_male = 153, addon = 1, storageID = BASE_STORAGE + 25},
    ['second beggar addon'] = {cost = 0, items = {{6107,1}}, outfit_female = 157, outfit_male = 153, addon = 2, storageID = BASE_STORAGE + 26},
    
    ['first pirate addon'] = {cost = 0, items = {{6098,100}, {6126,100}, {6097,100}}, outfit_female = 155, outfit_male = 151, addon = 1, storageID = BASE_STORAGE + 27},
    ['second pirate addon'] = {cost = 0, items = {{6101,1}, {6102,1}, {6100,1}, {6099,1}}, outfit_female = 155, outfit_male = 151, addon = 2, storageID = BASE_STORAGE + 28},
    
    ['first shaman addon'] = {cost = 0, items = {{3348,5}, {3403,5}}, outfit_female = 158, outfit_male = 154, addon = 1, storageID = BASE_STORAGE + 29},
    ['second shaman addon'] = {cost = 0, items = {{5014,1}, {3002,5}}, outfit_female = 158, outfit_male = 154, addon = 2, storageID = BASE_STORAGE + 30},
    
    ['first norseman addon'] = {cost = 0, items = {{7290,5}}, outfit_female = 252, outfit_male = 251, addon = 1, storageID = BASE_STORAGE + 31},
    ['second norseman addon'] = {cost = 0, items = {{7290,10}}, outfit_female = 252, outfit_male = 251, addon = 2, storageID = BASE_STORAGE + 32}
}

local availableOutfits = {
    'citizen', 'hunter', 'knight', 'mage', 'nobleman', 'summoner', 'warrior', 
    'barbarian', 'druid', 'wizard', 'oriental', 'pirate', 'assassin', 'beggar', 
    'shaman', 'norseman'
}

-- Sistema anti-spam e estado da conversa
local lastRequest = {}
local playerRequests = {}
local playerConversationStage = {}

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

-- Função para verificar se o player já possui o addon
local function playerHasAddon(player, outfitMale, outfitFemale, addon)
    -- Verifica se o player tem o addon em qualquer uma das versões (masculina ou feminina)
    return (player:hasOutfit(outfitMale) and player:hasOutfit(outfitMale, addon)) or
           (player:hasOutfit(outfitFemale) and player:hasOutfit(outfitFemale, addon))
end

-- Função para inicializar storages
local function initializeStorages(player)
    -- Inicializa storages normais
    for _, outfit in ipairs(availableOutfits) do
        local firstAddonKey = 'first ' .. outfit .. ' addon'
        local secondAddonKey = 'second ' .. outfit .. ' addon'
        
        if addoninfo[firstAddonKey] then
            player:setStorageValue(addoninfo[firstAddonKey].storageID, -1)
        end
        if addoninfo[secondAddonKey] then
            player:setStorageValue(addoninfo[secondAddonKey].storageID, -1)
        end
    end
    
    -- Inicializa storages específicos do bárbaro
    player:setStorageValue(BARBARIAN_FIRST_STORAGE, -1)
    player:setStorageValue(BARBARIAN_SECOND_STORAGE, -1)
end

-- Callback principal
local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    message = message:lower()
    
    -- Initialize storages when starting conversation
    if message == "hi" or message == "hello" then
        initializeStorages(player)
    end
    
    -- Conversation stage management
    local stage = playerConversationStage[playerId] or 0

    -- Main addon selection flow
    if message == 'addons' then
        npcHandler:say('Would you like the {first addon} or the {second addon}?', npc, creature)
        playerConversationStage[playerId] = 1
        return true
    
    elseif stage == 1 and (message == 'first addon' or message == 'second addon') then
        local addonType = message == 'first addon' and 'first' or 'second'
        
        local availableAddonsList = {}
        for _, outfit in ipairs(availableOutfits) do
            table.insert(availableAddonsList, addonType .. ' ' .. outfit .. ' addon')
        end
        
        npcHandler:say('Choose from these available addons: {' .. table.concat(availableAddonsList, '}, {') .. '}', npc, creature)
        playerConversationStage[playerId] = 2
        playerRequests[playerId] = addonType
        return true
    
    elseif stage == 2 then
        local addonType = playerRequests[playerId]
        
        local matchedAddon = nil
        for _, outfit in ipairs(availableOutfits) do
            local fullAddonKey = addonType .. ' ' .. outfit .. ' addon'
            if message == fullAddonKey or message == outfit .. ' addon' then
                matchedAddon = addoninfo[fullAddonKey]
                playerRequests[playerId] = fullAddonKey
                break
            end
        end
        
        if matchedAddon then
            -- Verifica se já possui o addon usando a nova função
            if playerHasAddon(player, matchedAddon.outfit_male, matchedAddon.outfit_female, matchedAddon.addon) then
                npcHandler:say('You already have this addon!', npc, creature)
                playerConversationStage[playerId] = 0
                return true
            end

            -- Construir lista de requisitos
            local itemsList = ''
            for i, item in ipairs(matchedAddon.items) do
                itemsList = itemsList .. item[2] .. ' ' .. ItemType(item[1]):getName()
                if i ~= #matchedAddon.items then
                    itemsList = itemsList .. ', '
                end
            end

            local requirements = itemsList
            if matchedAddon.cost > 0 then
                if itemsList ~= '' then
                    requirements = requirements .. ' and '
                end
                requirements = requirements .. matchedAddon.cost .. ' gold coins'
            end

            local fullAddonKey = playerRequests[playerId]
            npcHandler:setTopic(playerId, 1)
            npcHandler:say('For ' .. fullAddonKey .. ' you will need ' .. requirements .. '. Do you have it all with you?', npc, creature)
            playerConversationStage[playerId] = 3
            return true
        else
            npcHandler:say('Invalid addon selection. Try again or type {addons} to start over.', npc, creature)
            playerConversationStage[playerId] = 1
            return true
        end
    
    elseif stage == 3 and npcHandler:getTopic(playerId) == 1 then
        if MsgContains(message, 'yes') then
            local requestedAddonKey = playerRequests[playerId]
            if not requestedAddonKey then
                npcHandler:say('First tell me which addon you would like!', npc, creature)
                playerConversationStage[playerId] = 0
                return true
            end

            local requestedAddon = addoninfo[requestedAddonKey]
            
            -- Verifica novamente se já possui o addon
            if playerHasAddon(player, requestedAddon.outfit_male, requestedAddon.outfit_female, requestedAddon.addon) then
                npcHandler:say('You already have this addon!', npc, creature)
                playerConversationStage[playerId] = 0
                return true
            end

            -- Verificar items e gold
            local hasItems = true
            for _, item in ipairs(requestedAddon.items) do
                if player:getItemCount(item[1]) < item[2] then
                    hasItems = false
                    break
                end
            end

            if player:getMoney() < requestedAddon.cost or not hasItems then
                npcHandler:say('You don\'t have all the required items or gold!', npc, creature)
                playerConversationStage[playerId] = 0
                return true
            end

            -- Remover items e gold
            for _, item in ipairs(requestedAddon.items) do
                player:removeItem(item[1], item[2])
            end
            if requestedAddon.cost > 0 then
                player:removeMoney(requestedAddon.cost)
            end

            -- Adicionar addon
            player:addOutfit(requestedAddon.outfit_male, requestedAddon.addon)
            player:addOutfit(requestedAddon.outfit_female, requestedAddon.addon)
            player:setStorageValue(requestedAddon.storageID, 1)

            npcHandler:say('Here you are! Enjoy your new addon!', npc, creature)
            playerRequests[playerId] = nil
            playerConversationStage[playerId] = 0
            npcHandler:setTopic(playerId, 0)
        else
            npcHandler:say('Come back when you have all the required items!', npc, creature)
            playerConversationStage[playerId] = 0
        end
        return true
    
    elseif message == 'help' then
        npcHandler:say('To get an addon, first type {addons}, then choose between {first addon} or {second addon}, and then select the specific outfit addon you want.', npc, creature)
        return true
    end

    return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|! Looking for some cool addons? Just ask about my {addons}, or if you need {help} with the commands!')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)