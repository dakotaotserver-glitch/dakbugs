local internalNpcName = "Coco"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 1747,
    lookHead = 0,
    lookBody = 57,
    lookLegs = 0,
    lookFeet = 68,
    lookAddons = 2,
}

npcConfig.flags = {
    floorchange = false,
}

npcConfig.voices = {
    interval = 15000,
    chance = 50,
    { text = "Trading tokens! First-class equipment available!" },
}

-- Definição de moedas para cada conjunto de itens
local currencyForItems = {
    [48250] = { -- Moeda ID 48250
        45643, -- Biscuit Barrier
        48435, -- Blue Ice Cream Lamp
        48432, -- Chocolate Fountain
        45639, -- Cocoa Grimoire
        48439, -- Green Ice Cream Lamp
        48437, -- Pink Ice Cream Lamp
        48434, -- Pop Tart Painting
        45642, -- Ring of Temptation
    },
    [48249] = { -- Moeda ID 48249
        48449, -- Candy bed
        48450, -- Candy bed (2)
        48427, -- Candy cone chair
        48433, -- Candy Cushion
        49166, -- Small Gingerbread House
        48430, -- Chocolate Table
        45644, -- Candy-Coated Quiver
        45640, -- Creamy Grimoire
    }
}

-- Função para determinar qual moeda usar para um item específico
local function getCurrencyForItem(itemId)
    for currencyId, items in pairs(currencyForItems) do
        for _, id in ipairs(items) do
            if id == itemId then
                return currencyId
            end
        end
    end
    return nil
end

-- Função para verificar o peso do item e colocá-lo em uma caixa, se necessário
local function giveItemWithCheck(player, itemId, amount)
    local itemWeight = ItemType(itemId):getWeight()
    if itemWeight == 0 then
        local containerId = 23398 -- ID da caixa, como na store
        local container = player:addItem(containerId) -- Adiciona a caixa no inventário do jogador
        if container then
            container:addItem(itemId, amount) -- Coloca o item dentro da caixa
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your items were placed inside a box due to lack of space.")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to give you the item. Please make sure you have enough space.")
        end
    else
        -- Adiciona diretamente ao inventário se o peso for diferente de 0
        if player:addItem(itemId, amount) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have successfully purchased the item!")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your inventory is full.")
        end
    end
end

npcConfig.shop = {
    -- Itens do NPC "Coco" usando a moeda 48250
    { name = "Biscuit Barrier", clientId = 45643, buy = 1500 },
    { name = "Blue Ice Cream Lamp", clientId = 48435, buy = 1250 },
    { name = "Chocolate Fountain", clientId = 48432, buy = 1500 },
    { name = "Cocoa Grimoire", clientId = 45639, buy = 8000 },
    { name = "Green Ice Cream Lamp", clientId = 48439, buy = 1250 },
    { name = "Pink Ice Cream Lamp", clientId = 48437, buy = 1250 },
    { name = "Pop Tart Painting", clientId = 48434, buy = 1500 },
    { name = "Ring of Temptation", clientId = 45642, buy = 250 },
    -- Itens do NPC "Coco" usando a moeda 48249
    { name = "Candy bed", clientId = 48449, buy = 1500 },
    { name = "Candy bed", clientId = 48450, buy = 1500 },
    { name = "Candy cone chair", clientId = 48427, buy = 1500 },
    { name = "Candy Cushion", clientId = 48433, buy = 1500 },
    { name = "Small Gingerbread House", clientId = 49166, buy = 1500 },
    { name = "Chocolate Table", clientId = 48430, buy = 1500 },
    { name = "Candy-Coated Quiver", clientId = 45644, buy = 8000 },
    { name = "Creamy Grimoire", clientId = 45640, buy = 8000 },
}

-- Função de compra de item, verificando a moeda correta e garantindo que o item vá para o jogador
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
    local currency = getCurrencyForItem(itemId)
    if currency then
        local playerCurrencyCount = player:getItemCount(currency)
        if playerCurrencyCount >= totalCost then
            player:removeItem(currency, totalCost)  -- Remove apenas as moedas, sem cobrar gold.
            giveItemWithCheck(player, itemId, amount) -- Chama a função que verifica o peso e entrega o item
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have enough currency to buy this item.")
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item cannot be purchased.")
    end
end

-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Sold %ix %s for %i tokens.", amount, name, totalCost))
end

-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

local answerType = {}
local answerLevel = {}

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
    local playerId = creature:getId()
    npcHandler:setTopic(playerId, 0)
    return true
end

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    if MsgContains(message, "information") then
        npcHandler:say({ "{Tokens} are small objects made of metal or other materials. You can use them to buy superior equipment from token traders like me.", "There are several ways to obtain the tokens I'm interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items." }, npc, creature)
    elseif MsgContains(message, "worth") then
        npcHandler:say({ "Disrupt the Heart of Destruction, fell the World Devourer to prove your worth and you will be granted the power to imbue 'Powerful Strike', 'Powerful Void' and 'Powerful Vampirism'." }, npc, creature)
    elseif MsgContains(message, "tokens") then
        npc:openShopWindow(creature)
        npcHandler:say("If you have any tokens with you, let's have a look! These are my offers.", npc, creature)
    elseif MsgContains(message, "trade") then
        npcHandler:say({ "I trade tokens sail {tokens}. Make your choice, please!" }, npc, creature)
        npcHandler:setTopic(playerId, 1)
    elseif npcHandler:getTopic(playerId) == 3 then
        if MsgContains(message, "yes") then
            local neededCap = 0
            for i = 1, #products[answerType[playerId]][answerLevel[playerId]].itens do
                neededCap = neededCap + ItemType(products[answerType[playerId]][answerLevel[playerId]].itens[i].id):getWeight() * products[answerType[playerId]][answerLevel[playerId]].itens[i].amount
            end
            if player:getFreeCapacity() > neededCap then
                if player:getItemCount(npc:getCurrency()) >= products[answerType[playerId]][answerLevel[playerId]].value then
                    for i = 1, #products[answerType[playerId]][answerLevel[playerId]].itens do
                        player:addItem(products[answerType[playerId]][answerLevel[playerId]].itens[i].id, products[answerType[playerId]][answerLevel[playerId]].itens[i].amount)
                    end
                    player:removeItem(npc:getCurrency(), products[answerType[playerId]][answerLevel[playerId]].value)
                    npcHandler:say("There it is.", npc, creature)
                    npcHandler:setTopic(playerId, 0)
                else
                    npcHandler:say("I'm sorry but it seems you don't have enough tokens yet. Bring me the required amount and we'll make a trade.", npc, creature)
                end
            else
                npcHandler:say("You don't have enough capacity. You must have " .. neededCap .. " oz.", npc, creature)
            end
        elseif MsgContains(message, "no") then
            npcHandler:say("Your decision. Come back if you have changed your mind.", npc, creature)
        end
        npcHandler:setTopic(playerId, 0)
    end
    return true
end

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, false)

-- npcType registrando a configuração do NPC
npcType:register(npcConfig)
