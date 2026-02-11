local internalNpcName = "Lorek"
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
    lookHead = 19,
    lookBody = 10,
    lookLegs = 38,
    lookFeet = 95,
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

-- Função de saudação simples
local function greetCallback(npc, creature)
    npcHandler:setMessage(MESSAGE_GREET, "Welcome, traveler! Say {passage} or {sail} if you seek transportation to various destinations.")
    return true
end
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

-- Função para verificar o rank do Paw and Fur
local function hasRequiredRank(player)
    -- Verificar se o jogador tem pelo menos o rank 3 (Ranger - valor 2 na storage)
    -- De acordo com o código do Grizzly Adams, o rank Ranger é representado pelo valor 2
    return player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank) >= 2
end

-- Travel - Versão modificada para verificar rank
local function addTravelKeyword(keyword, text, cost, destination, requiresRank)
    if requiresRank then
        -- Para destinos restritos que necessitam de verificação de rank
        local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {
            npcHandler = npcHandler,
            text = "Do you seek a passage to " .. (text or keyword:titleCase()) .. " for " .. cost .. " gold?",
            cost = cost
        }, function(player) return hasRequiredRank(player) end)
        
        travelKeyword:addChildKeyword({"yes"}, StdModule.travel, {
            npcHandler = npcHandler,
            premium = false,
            cost = cost,
            destination = destination
        })
        
        travelKeyword:addChildKeyword({"no"}, StdModule.say, {
            npcHandler = npcHandler,
            text = "Maybe another time.",
            reset = true
        })
        
        -- Resposta para jogadores sem o rank necessário
        keywordHandler:addKeyword({keyword}, StdModule.say, {
            npcHandler = npcHandler,
            text = "I'm sorry, but you need to be at least a Ranger in the Paw and Fur society to travel there. Ask Grizzly Adams in Port Hope about a promotion."
        }, function(player) return not hasRequiredRank(player) end)
    else
        -- Para destinos normais sem requisitos
        local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {
            npcHandler = npcHandler,
            text = "Do you seek a passage to " .. (text or keyword:titleCase()) .. " for " .. cost .. " gold?",
            cost = cost
        })
        
        travelKeyword:addChildKeyword({"yes"}, StdModule.travel, {
            npcHandler = npcHandler,
            premium = false,
            cost = cost,
            destination = destination
        })
        
        travelKeyword:addChildKeyword({"no"}, StdModule.say, {
            npcHandler = npcHandler,
            text = "Maybe another time.",
            reset = true
        })
    end
end

-- Definição de destinos
addTravelKeyword("west", "the west end of Port Hope", 7, Position(32558, 32780, 7))
addTravelKeyword("centre", "the centre of Port Hope", 7, Position(32628, 32771, 7))
addTravelKeyword("darama", nil, 30, Position(32987, 32729, 7))
addTravelKeyword("center", "the centre of Port Hope", 0, Position(32628, 32771, 7))
addTravelKeyword("chor", nil, 30, Position(32968, 32799, 7), true)
addTravelKeyword("banuta", nil, 30, Position(32826, 32631, 7), true)
addTravelKeyword("mountain", nil, 30, Position(32987, 32729, 7), true)
addTravelKeyword("mountain pass", nil, 30, Position(32987, 32729, 7), true)

-- Basic
keywordHandler:addKeyword({"ferumbras"}, StdModule.say, {npcHandler = npcHandler, text = "I heard he is some scary magician or so."})

-- Adicionando informações sobre passagens
keywordHandler:addKeyword({"passage"}, StdModule.say, {
    npcHandler = npcHandler,
    text = "I can take you to {west} or {centre} of Port Hope, {darama}, or {center} without cost. I can also sail to {chor}, {banuta}, and {mountain} pass, but these require Ranger rank or higher in the Paw and Fur society."
})

-- Adicionando informações sobre passagens (sinônimo)
keywordHandler:addKeyword({"sail"}, StdModule.say, {
    npcHandler = npcHandler,
    text = "I can take you to {west} or {centre} of Port Hope, {darama}, or {center} without cost. I can also sail to {chor}, {banuta}, and {mountain} pass, but these require Ranger rank or higher in the Paw and Fur society."
})

-- Módulo de foco
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Registro do NPC
npcType:register(npcConfig)