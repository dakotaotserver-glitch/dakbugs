local internalNpcName = "Buddel"
local npcType = Game.createNpcType("Buddel (Tyrsung)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 143,
    lookHead = 19,
    lookBody = 57,
    lookLegs = 22,
    lookFeet = 20,
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

-- Travel: sem requisitos, qualquer player pode viajar
local function addTravelKeyword(keyword, text, destination)
    local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = text })
    travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "You shouldn't miss the experience.", reset = true })
    travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = 0, destination = destination })
end

addTravelKeyword("svargrond", "You know a town nicer than this? NICER DICER! Apropos, don't play dice when you are drunk ...", Position(32255, 31197, 7))
addTravelKeyword("okolnir", "It's nice there. Except of the ice dragons which are not very companionable.", Position(32225, 31381, 7))
addTravelKeyword("helheim", "T'at is a small island to the east.", Position(32462, 31174, 7))
addTravelKeyword("camp", "Both of you look like you could defend yourself! If you want to go there, ask me for a passage.", Position(32021, 31294, 7))

-- Kick
keywordHandler:addKeyword({ "kick" }, StdModule.kick, {
    npcHandler = npcHandler,
    text = "Get out o' here!*HICKS*",
    destination = { Position(32332, 31232, 7) }
})

keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?" })
keywordHandler:addAliasKeyword({ "trip" })
keywordHandler:addAliasKeyword({ "go" })
keywordHandler:addAliasKeyword({ "sail" })

npcHandler:setMessage(MESSAGE_GREET, "Where are we at the moment? Is this {Svargrond} {okolnir}, {helheim}, {tyrsung}, {camp} ? NO,*HICKS* it's Tyrsung! Anyway, where do you want to go?")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
    { itemName = "compass", clientId = 10302, sell = 45 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
    npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
    player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
