local config = {
    requiredItemId = 61896, -- Roullete Coin
    
    -- Configurações para a tabela completa de itens
    allItems = {
        -- Itens comuns (das listas de Sorcerer, Druid e Paladin)
        
        {id = 22083, count = 10, chance = 2.0}, --moonlight crystals
        {id = 22060, count = 10, chance = 2.0}, --werewolf amulet
        {id = 22118, count = 25, chance = 1.0}, --Tibia coin
        {id = 30323, count = 1, chance = 1}, --Rainbow Necklace
        {id = 21948, count = 1, chance = 1}, -- Midnight Panther Doll
        {id = 22721, count = 18, chance = 2.5}, --gold token
        {id = 22516, count = 20, chance = 3}, --silver token
        {id = 3043, count = 60, chance = 2}, --crystal coin
        {id = 3043, count = 40, chance = 3}, --crystal coin
        {id = 3043, count = 10, chance = 5}, --crystal coin
        {id = 37110, count = 1, chance = 4}, --exalted core
        {id = 46628, count = 1, chance = 1}, --Amber Crusher (item para quebrar gemas)
        {id = 6529, count = 1, chance = 0.9}, --pair of soft boots
        {id = 3363, count = 1, chance = 1}, --dragon scale legs
        {id = 3309, count = 1, chance = 1}, --thunder hammer
        {id = 3388, count = 1, chance = 1}, --demon armor
        {id = 3288, count = 1, chance = 1}, --magic sword
        {id = 3319, count = 1, chance = 1}, -- stonecutter axe
        {id = 25700, count = 1, chance = 2}, --dream blossom staff
        {id = 34326, count = 1, chance = 0.9}, --Ferumbras' former students
        {id = 20084, count = 1, chance = 0.6}, --Umbral Master Bow
        {id = 20087, count = 1, chance = 0.6}, --Umbral Master XBow
        {id = 20090, count = 1, chance = 0.6}, --Umbral Master Spellbook
        {id = 50165, count = 1, chance = 0.6}, --Umbral Master Katar 
        {id = 36668, count = 1, chance = 0.4}, --Eldritch Wand
        {id = 36674, count = 1, chance = 0.4}, --Eldritch Rod 
        {id = 3079, count = 1, chance = 3}, --Boots of Haste
        {id = 3210, count = 1, chance = 2.8}, --Hat of the mad
        {id = 31582, count = 1, chance = 0.4, raro = true}, --galea mortis
        {id = 31577, count = 1, chance = 0.4, raro = true}, --Terra Helmet
        {id = 31578, count = 1, chance = 0.4, raro = true}, --Bear Skin
        {id = 31579, count = 1, chance = 0.6, raro = true}, --Embrace of Nature
        {id = 27647, count = 1, chance = 0.3, raro = true}, --Gnome Helmet
        {id = 27649, count = 1, chance = 0.2, raro = true}, --Gnome Legs
        {id = 50290, count = 1, chance = 1.0, raro = true}, --gnomish footwraps
        {id = 3423, count = 1, chance = 0.04, raro = true}, --Blessed Shield
        {id = 5791, count = 1, chance = 1.0, raro = true}, --stuffed dragon

        -- Itens específicos do Knight
        {id = 45640, count = 1, chance = 0.2, raro = true}, --Creamy Grimoire
        {id = 36656, count = 1, chance = 0.19, raro = true}, --Eldrtich Shield
        {id = 30363, count = 1, chance = 1}, --Tearesa (Doll amarelo)
        {id = 32620, count = 1, chance = 2.8}, --Ghost backpack
        {id = 61896, count = 2, chance = 4}, --Roullete Coin
        {id = 35577, count = 1, chance = 3.5}, --Raccoon Backpack
        {id = 39234, count = 1, chance = 0.5}, --Turtle Amulet
        {id = 45644, count = 1, chance = 0.5}, --Candy-Coated Quiver
        {id = 62217, count = 1, chance = 3.3}, --Terramorfo backpack
        {id = 645, count = 1, chance = 4}, --blue legs
        {id = 14758, count = 1, chance = 1.5}, --premium scroll
        {id = 20081, count = 1, chance = 0.6}, --Umbral Master Hammer
        {id = 20066, count = 1, chance = 0.6}, --Umbral Master Blade
        {id = 20069, count = 1, chance = 0.6}, --Umbral Master Slayer
        {id = 20072, count = 1, chance = 0.6}, --Umbral Master Axe
        {id = 20075, count = 1, chance = 0.6}, --Umbral Master Chopper
        {id = 20078, count = 1, chance = 0.6}, --Umbral Master Mace
        {id = 31583, count = 1, chance = 0.3, raro = true}, --Toga Mortis
        {id = 50260, count = 1, chance = 0.4, raro = true}, --Death Oyoroi
        {id = 27648, count = 1, chance = 0.1, raro = true}, --Gnome Armor
        {id = 27650, count = 1, chance = 0.1, raro = true}, --Gnome Shield
        {id = 32617, count = 1, chance = 0.2, raro = true}, --Fabulous legs
        {id = 5803, count = 1, chance = 1.0, raro = true}, --Arbalest
        
        -- Itens específicos store
        {id = 28791, count = 1, chance = 0.6, raro = true}, --Library Ticket (montaria do livro)
        {id = 31738, count = 1, chance = 1.0, raro = true}, --final judment (faquinha addon)
        {id = 31737, count = 1, chance = 0.7, raro = true}, --Shadow Cowl (capus addon)
        {id = 8096, count = 1, chance = 2}, --Hellforged Axe
        {id = 8102, count = 1, chance = 2}, --Emerald Sword
        {id = 8090, count = 1, chance = 2}, --Spellbook of Dark Mysteries
        {id = 8060, count = 1, chance = 2}, --Master Archer's Armor
        {id = 50261, count = 1, chance = 3}, --merudri nanbando
        {id = 8026, count = 1, chance = 2}, --warsinger bow
        {id = 61867, count = 1, chance = 1}, --Liquid Dust
        {id = 61866, count = 1, chance = 1}, --Frag Remover
        {id = 3398, count = 1, chance = 0.8}, --Dwarven Legs
        {id = 45642, count = 1, chance = 1}, --Ring of Temptation
        {id = 61957, count = 1, chance = 0.8}, --infernatus backpack
        {id = 61937, count = 1, chance = 0.5}, --Ticket Forge
        {id = 61616, count = 1, chance = 3}, --Bless scroll
        {id = 62147, count = 1, chance = 1}, --open forge
        {id = 62218, count = 2, chance = 1}, --online token
        {id = 62218, count = 4, chance = 1}, --online token
        {id = 16244, count = 1, chance = 0.7}, --music box
        {id = 5899, count = 10, chance = 1}, --turtle shells


        -- Charms e amplificações
        {id = 36728, count = 1, chance = 2}, --bestiary betterment
        {id = 36725, count = 1, chance = 2}, --stamina extension
        {id = 36727, count = 1, chance = 2}, --wealth duplex
        {id = 36724, count = 1, chance = 2}, --strike enhancement
        {id = 36741, count = 1, chance = 2.1}, --death amplification
        {id = 36734, count = 1, chance = 2.2}, --death resilience
        {id = 36738, count = 1, chance = 2.3}, --earth amplification
        {id = 36731, count = 1, chance = 2.4}, --earth resilience
        {id = 36739, count = 1, chance = 2.5}, --energy amplification
        {id = 36732, count = 1, chance = 2.5}, --energy resilience
        {id = 36736, count = 1, chance = 2.4}, --fire amplification
        {id = 36729, count = 1, chance = 2.3}, --fire resilience
        {id = 36740, count = 1, chance = 2.2}, --holy amplification
        {id = 36733, count = 1, chance = 2.1}, --holy resilience
        {id = 36737, count = 1, chance = 2}, --ice amplification
        {id = 36730, count = 1, chance = 2}, --ice resilience
        {id = 36723, count = 1, chance = 2.1}, --kooldown-aid
        {id = 36742, count = 1, chance = 2.2}, --physical amplification
        {id = 36735, count = 1, chance = 2.3}, --physical resilience
        {id = 51444, count = 1, chance = 1.4}, --powerful bash scroll
        {id = 51445, count = 1, chance = 1.7}, --powerful blockade scroll
        {id = 51446, count = 1, chance = 1.6}, --powerful chop scroll
        {id = 51452, count = 1, chance = 1.3}, --powerful featherweight scroll
        {id = 51454, count = 1, chance = 1.8}, --powerful lich shroud scroll
        {id = 51455, count = 1, chance = 1.4}, --powerful precision scroll
        {id = 51456, count = 1, chance = 1.3}, --powerful punch scroll
        {id = 51460, count = 1, chance = 1.4}, --powerful slash scroll
        {id = 51462, count = 1, chance = 1.5}, --powerful strike scroll
        {id = 51463, count = 1, chance = 1.9}, --powerful swiftness scroll
        {id = 51464, count = 1, chance = 1.5}, --powerful vampirism scroll
        {id = 51466, count = 1, chance = 1.6}, --powerful vibrancy scroll
        {id = 51467, count = 1, chance = 1.7}, --powerful void scroll
        {id = 51451, count = 1, chance = 1.7}, --powerful epiphany scroll

        -- Itens diversos
        {id = 30345, count = 1, chance = 1.1}, --Enchanted Pendulet
        {id = 31267, count = 1, chance = 1.2}, --Loremaster Doll
        {id = 61958,count = 1, chance = 1.3}, --Celestius backpack
        {id = 9596, count = 1, chance = 2.1}, --squeezing gear of girlpower (canivete rosa)
        {id = 9594, count = 1, chance = 2.1}, --sneaky stabber of eliteness (canivete vermelho)
        {id = 9598, count = 1, chance = 1.6}, --whacking driller of fate (canivete azul)
        {id = 3366, count = 1, chance = 2.5}, --Magic Plate Armor
        {id = 3414, count = 1, chance = 2.7}, --Mastermind Shield
        {id = 5919, count = 1, chance = 1}, --dragon claw
        {id = 5804, count = 1, chance = 1}, --Nose Ring
         {id = 5809, count = 1, chance = 1}, --soul stone
        {id = 5958, count = 1, chance = 1}, --winning lottery ticket
        {id = 896, count = 1, chance = 1.5}, --firlefanz
        {id = 4100, count = 1, chance = 2.1}, --Gamemaster Doll
        {id = 5942, count = 1, chance = 1.7}, --Blessed Wooden Stake
        {id = 9079, count = 1, chance = 4}, --rotworm stew
        {id = 9084, count = 1, chance = 3.6}, --veggie casserole
        {id = 9082, count = 1, chance = 4.2}, --tropical friend chicken
        {id = 9085, count = 1, chance = 4.3}, --filled jalapeno peppers
        {id = 12548, count = 1, chance = 4}, --bag of apple slices
        {id = 12802, count = 30, chance = 3.3}, --sugar oat
        {id = 12601, count = 4, chance = 3.8}, --slime mould
        {id = 16129, count = 5, chance = 4}, --major crystalline token
        {id = 16129, count = 8, chance = 3}, --major crystalline token
        {id = 16128, count = 8, chance = 4}, --minor crystalline token
        {id = 16128, count = 15, chance = 3}, --minor crystalline token
        {id = 12599, count = 15, chance = 0.1, raro = true}, --mages cap
        {id = 12803, count = 15, chance = 0.1, raro = true}, --elemental spikes
        {id = 34109, count = 15, chance = 0.32, raro = true}, --bag you desire
        {id = 39546, count = 15, chance = 0.4, raro = true}, --primal bag
        {id = 5903, count = 1, chance = 0.05, raro = true}, --Ferumbras Hat
        {id = 5890, count = 10, chance = 1.2, raro = true}, --chicken feather
        {id = 5883, count = 10, chance = 1.2, raro = true}, --ape fur
        {id = 5886, count = 10, chance = 1.1, raro = true}, --spool of yarn

    },
    
    -- Configurações das roletas
    roulettes = {
        [18562] = { -- Sorcerer
            positions = {
                {x = 1224, y = 793, z = 7},
                {x = 1225, y = 793, z = 7},
                {x = 1226, y = 793, z = 7},
                {x = 1227, y = 793, z = 7},
                {x = 1228, y = 793, z = 7}, -- Posição central
                {x = 1229, y = 793, z = 7},
                {x = 1230, y = 793, z = 7},
                {x = 1231, y = 793, z = 7},
                {x = 1232, y = 793, z = 7}
            },
            playerPosition = Position(1228, 797, 7)
        },
        [18563] = { -- Druid
            positions = {
                {x = 1291, y = 795, z = 7},
                {x = 1292, y = 795, z = 7},
                {x = 1293, y = 795, z = 7},
                {x = 1294, y = 795, z = 7},
                {x = 1295, y = 795, z = 7}, -- Posição central
                {x = 1296, y = 795, z = 7},
                {x = 1297, y = 795, z = 7},
                {x = 1298, y = 795, z = 7},
                {x = 1299, y = 795, z = 7}
            },
            playerPosition = Position(1295, 799, 7)
        },
        [18564] = { -- Paladin
            positions = {
                {x = 1284, y = 853, z = 7},
                {x = 1285, y = 853, z = 7},
                {x = 1286, y = 853, z = 7},
                {x = 1287, y = 853, z = 7},
                {x = 1288, y = 853, z = 7}, -- Posição central
                {x = 1289, y = 853, z = 7},
                {x = 1290, y = 853, z = 7},
                {x = 1291, y = 853, z = 7},
                {x = 1292, y = 853, z = 7}
            },
            playerPosition = Position(1288, 857, 7)
        },
        [18565] = { -- Knight
            positions = {
                {x = 1221, y = 853, z = 7},
                {x = 1222, y = 853, z = 7},
                {x = 1223, y = 853, z = 7},
                {x = 1224, y = 853, z = 7},
                {x = 1225, y = 853, z = 7}, -- Posição central
                {x = 1226, y = 853, z = 7},
                {x = 1227, y = 853, z = 7},
                {x = 1228, y = 853, z = 7},
                {x = 1229, y = 853, z = 7}
            },
            playerPosition = Position(1225, 857, 7)
        }
    },
    
    -- Sistema de jackpot
    jackpot = {
        enabled = true,
        minValue = 100,
        increment = 5,
        triggerChance = 0.02,
        maxValue = 2000,
        prize = 3043, -- crystal coin
        directBankDeposit = 1
    },
    
    -- Configurações de velocidade para múltiplas roladas
    speedSettings = {
        [1] = {baseInterval = 100, intervalIncrement = 50, steps = {min = 10, max = 15}, pauseBetweenSpins = 0}, -- Normal
        [5] = {baseInterval = 60, intervalIncrement = 30, steps = {min = 8, max = 12}, pauseBetweenSpins = 1500}, -- Rápido
        [10] = {baseInterval = 40, intervalIncrement = 20, steps = {min = 8, max = 12}, pauseBetweenSpins = 1200}, -- Muito rápido
        [100] = {baseInterval = 30, intervalIncrement = 15, steps = {min = 5, max = 10}, pauseBetweenSpins = 500} -- Ultra rápido com mais steps
    },
    
    -- Lista de itens de casa que precisam de tratamento especial
    houseItems = {
        [50041] = true, [48574] = true, [50035] = true, [50039] = true,
        [50037] = true, [49743] = true, [49926] = true, [49712] = true,
        [49924] = true, [49710] = true, [49708] = true, [49706] = true
    },
    
    -- Valor de conversão de crystal coin para gold coins
    crystalToCoinRate = 10000,
    
    -- Configurações para entrega de itens no depot
    depot = {
        enabled = true,
        depotId = 1
    },
    
    -- Configurações de mensagens
    messages = {
        COLOR_NORMAL = MESSAGE_EVENT_ADVANCE, -- Itens normais
        COLOR_SPECIAL = MESSAGE_LOOK, -- Itens raros e jackpot
        
        -- Prefixos de mensagem
        PREFIX = {
            JACKPOT = "[JACKPOT]",
            RARO = "[ITEM RARO]",
            ROLETA = "[ROLETA]"
        },
        
        -- Templates de mensagem
        DEPOT_DELIVERY = "O item %s foi enviado para o seu depot!"
    }
}

-- Constantes
local ITEM_DECORATION_KIT = 23398
local DELAY = {
    SHORT = 200,
    MEDIUM = 500,
    LONG = 700
}
local CENTRAL_POSITION = 5 -- Índice da posição central no array de posições

-- Controle das roletas e cache de jackpot
local isRouletteRunning = {}
local jackpotCache = {}
-- Cache para armazenar os itens sorteados por roleta
local rouletteItemCache = {}
-- Cache para armazenar sessões de múltiplas roladas
local multiSpinSessions = {}

-- Inicializar status das roletas
for actionId in pairs(config.roulettes) do
    isRouletteRunning[actionId] = false
    rouletteItemCache[actionId] = {}
end

-- Funções auxiliares
local function formatNumber(num)
    local formatted = tostring(num)
    local k = 3
    while k < #formatted do
        formatted = formatted:sub(1, #formatted - k) .. "," .. formatted:sub(#formatted - k + 1)
        k = k + 4
    end
    return formatted
end

local function highlightPlayerName(name)
    return "<<" .. name .. ">>"
end

-- Funções de banco de dados para o jackpot
local function getJackpotValue(actionId)
    if jackpotCache[actionId] then
        return jackpotCache[actionId]
    end
    
    local resultId = db.storeQuery("SELECT `value` FROM `jackpot_values` WHERE `action_id` = " .. actionId)
    if resultId ~= false then
        local value = result.getNumber(resultId, "value")
        result.free(resultId)
        jackpotCache[actionId] = value
        return value
    end
    
    db.query("INSERT INTO `jackpot_values` (`action_id`, `value`) VALUES (" .. actionId .. ", " .. config.jackpot.minValue .. ")")
    jackpotCache[actionId] = config.jackpot.minValue
    return config.jackpot.minValue
end

local function saveJackpotValue(actionId, value)
    jackpotCache[actionId] = value
    db.query("UPDATE `jackpot_values` SET `value` = " .. value .. " WHERE `action_id` = " .. actionId)
end

-- Função para enviar mensagens ao jogador com tipo específico
local function sendMessage(player, prefix, message, broadcast, isSpecial)
    local fullMessage = prefix and (prefix .. " " .. message) or message
    local messageType = isSpecial and config.messages.COLOR_SPECIAL or config.messages.COLOR_NORMAL
    
    player:sendTextMessage(messageType, fullMessage)
    
    if broadcast then
        Game.broadcastMessage(fullMessage, messageType)
    end
end

-- Funções de manipulação de itens
local function sendToDepot(player, itemId, count)
    if not player then return false end
    
    local inbox = player:getDepotChest(config.depot.depotId, true)
    if not inbox then return false end
    
    local item = inbox:addItem(itemId, count)
    return item ~= nil
end

-- ABORDAGEM MAIS SIMPLES: SEMPRE DEPOT PRIMEIRO
local function deliverItemToPlayer(player, itemId, count)
    -- Sempre enviar para depot primeiro para garantir que não caia no chão
    if config.depot.enabled and sendToDepot(player, itemId, count) then
        return true, "depot"
    else
        -- Se falhou no depot também, algo está muito errado
        return false, "erro critico"
    end
end

-- Função para verificar jackpot
local function checkJackpot(player, actionId)
    if not config.jackpot.enabled then return false end
    
    local jackpotValue = getJackpotValue(actionId)
    
    if math.random() <= config.jackpot.triggerChance then
        -- Processamento do jackpot ganho
        if jackpotValue > config.jackpot.directBankDeposit then
            local totalGoldCoins = jackpotValue * config.crystalToCoinRate
            
            if Bank.deposit(player, totalGoldCoins) then
                addEvent(function()
                    sendMessage(player, config.messages.PREFIX.JACKPOT, 
                        string.format("Voce ganhou o JACKPOT de %s crystal coins! O valor foi depositado diretamente em sua conta bancaria.", 
                        formatNumber(jackpotValue)), false, true) -- Usar MESSAGE_LOOK para jackpot
                end, DELAY.SHORT)
            else
                -- Enviar para depot
                local success, destination = deliverItemToPlayer(player, config.jackpot.prize, jackpotValue)
                
                if success then
                    addEvent(function()
                        sendMessage(player, config.messages.PREFIX.JACKPOT,
                            string.format("Voce ganhou o JACKPOT de %s crystal coins! O premio foi enviado para seu depot.", 
                            formatNumber(jackpotValue)), false, true) -- Usar MESSAGE_LOOK para jackpot
                    end, DELAY.SHORT)
                else
                    -- Falha na entrega
                    addEvent(function()
                        sendMessage(player, config.messages.PREFIX.JACKPOT,
                            string.format("Voce ganhou o JACKPOT de %s crystal coins, mas nao foi possivel entregar. Por favor, contate um administrador.", 
                            formatNumber(jackpotValue)), false, true) -- Usar MESSAGE_LOOK para jackpot
                    end, DELAY.SHORT)
                end
            end
        else
            -- Para valores menores, enviar para depot
            local success, destination = deliverItemToPlayer(player, config.jackpot.prize, jackpotValue)
            
            if success then
                addEvent(function()
                    sendMessage(player, config.messages.PREFIX.JACKPOT, 
                        string.format("Voce ganhou o JACKPOT de %s crystal coins! O premio foi enviado para seu depot.", 
                        formatNumber(jackpotValue)), false, true) -- Usar MESSAGE_LOOK para jackpot
                end, DELAY.SHORT)
            else
                -- Falha na entrega
                addEvent(function()
                    sendMessage(player, config.messages.PREFIX.JACKPOT,
                        string.format("Voce ganhou o JACKPOT de %s crystal coins, mas nao foi possivel entregar. Por favor, contate um administrador.", 
                        formatNumber(jackpotValue)), false, true) -- Usar MESSAGE_LOOK para jackpot
                end, DELAY.SHORT)
            end
        end
        
        -- Anúncio global
        local playerName = player:getName()
        local highlightedName = highlightPlayerName(playerName)
        
        addEvent(function()
            Game.broadcastMessage(
                string.format("%s %s ganhou o JACKPOT de %s crystal coins na roleta!", 
                config.messages.PREFIX.JACKPOT, highlightedName, formatNumber(jackpotValue)),
                config.messages.COLOR_SPECIAL)
        end, DELAY.MEDIUM)
        
        -- Efeitos visuais
        addEvent(function()
            for i = 1, 10 do
                addEvent(function()
                    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                end, i * 100)
            end
        end, DELAY.LONG)
        
        -- Resetar jackpot
        saveJackpotValue(actionId, config.jackpot.minValue)
        return true
    else
        -- Incrementar jackpot se não ganhou
        local newValue = math.min(jackpotValue + config.jackpot.increment, config.jackpot.maxValue)
        saveJackpotValue(actionId, newValue)
        return false
    end
end

-- Função para lidar com itens de casa
local function handleHouseItem(player, itemId, itemName)
    -- Verificar se o jogador está em uma casa
    local position = player:getPosition()
    local house = position:getTile():getHouse()
    
    if house and house:getOwnerGuid() == player:getGuid() then
        -- Jogador está em sua própria casa, criar o item diretamente
        local houseItem = Game.createItem(itemId, 1, position)
        if houseItem then
            sendMessage(player, config.messages.PREFIX.ROLETA, 
                string.format("Legal! Ganhou um %s! Foi colocado em sua casa.", itemName))
            position:sendMagicEffect(CONST_ME_GIFT_WRAPS)
            return true
        end
    end
    
    -- Tentar enviar para o depot
    if config.depot.enabled then
        local inbox = player:getDepotChest(config.depot.depotId, true)
        if inbox then
            local decoKit = inbox:addItem(ITEM_DECORATION_KIT, 1)
            if decoKit then
                decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. itemName .. ">.")
                decoKit:setCustomAttribute("unWrapId", itemId)
                
                sendMessage(player, config.messages.PREFIX.ROLETA, 
                    string.format(config.messages.DEPOT_DELIVERY, itemName))
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
                return true
            end
        end
    end
    
    -- Último recurso: criar no chão
    local position = player:getPosition()
    local houseItem = Game.createItem(ITEM_DECORATION_KIT, 1, position)
    if houseItem then
        houseItem:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. itemName .. ">.")
        houseItem:setCustomAttribute("unWrapId", itemId)
        
        sendMessage(player, config.messages.PREFIX.ROLETA, 
                            string.format("Legal! Ganhou um %s! Foi colocado aos seus pes.", itemName))
        position:sendMagicEffect(CONST_ME_GIFT_WRAPS)
        return true
    end
    
    sendMessage(player, config.messages.PREFIX.ROLETA, 
        string.format("Voce ganhou um %s, mas nao foi possível entregar. Por favor, contate um administrador.", 
        itemName))
    return false
end

-- Função para entregar item ao jogador com mensagem detalhada
local function addItemToPlayerWithMessage(player, item, actionId, spinNumber, totalSpins)
    if not item or not item.id then return false end
    
    -- Obter informações do item
    local itemType = ItemType(item.id)
    local itemName = itemType:getName()
    local success = false
    local destination = ""
    local isSpecial = item.raro -- Usar MESSAGE_LOOK para itens raros
    
    -- Verificar se é um item de casa
    if config.houseItems[item.id] then
        return handleHouseItem(player, item.id, itemName)
    end
    
    -- SEMPRE ENVIAR PARA DEPOT
    local deliverySuccess, deliveryDestination = deliverItemToPlayer(player, item.id, item.count)
    
    if deliverySuccess then
        success = true
        destination = deliveryDestination
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("Giro %d/%d: Ganhou %s! (Enviado para o depot)", 
            spinNumber, totalSpins, itemName), false, isSpecial)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    else
        -- Notificar falha
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("Giro %d/%d: Ganhou %s, mas nao foi possivel entregar. Contate um administrador.", 
            spinNumber, totalSpins, itemName), false, isSpecial)
        return false
    end
    
    -- Broadcast para itens raros
    if item.raro then
        local playerName = player:getName()
        local highlightedName = highlightPlayerName(playerName)
        
        addEvent(function()
            Game.broadcastMessage(
                string.format("%s %s ganhou um item raro: %s na roleta!", 
                config.messages.PREFIX.RARO, highlightedName, itemName),
                config.messages.COLOR_SPECIAL)
        end, DELAY.LONG)
        
        -- Aumentar o jackpot para itens raros
        if config.jackpot.enabled then
            local jackpotValue = getJackpotValue(actionId)
            jackpotValue = math.min(jackpotValue + config.jackpot.increment * 2, config.jackpot.maxValue)
            saveJackpotValue(actionId, jackpotValue)
        end
    end
    
    return true
end

-- Função para entregar item ao jogador (versão normal para 1x)
local function addItemToPlayer(player, item, actionId)
    if not item or not item.id then return false end
    
    -- Obter informações do item
    local itemType = ItemType(item.id)
    local itemName = itemType:getName()
    local success = false
    local isSpecial = item.raro -- Usar MESSAGE_LOOK para itens raros
    
    -- Verificar se é um item de casa
    if config.houseItems[item.id] then
        return handleHouseItem(player, item.id, itemName)
    end
    
    -- SEMPRE ENVIAR PARA DEPOT
    local deliverySuccess, deliveryDestination = deliverItemToPlayer(player, item.id, item.count)
    
    if deliverySuccess then
        success = true
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("Legal! Ganhou um %s! (Enviado para o depot)", itemName), false, isSpecial)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    else
        -- Notificar falha
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("Voce ganhou um %s, mas nao foi possivel entregar. Por favor, contate um administrador.", 
            itemName), false, isSpecial)
        return false
    end
    
    -- Broadcast para itens raros
    if item.raro then
        local playerName = player:getName()
        local highlightedName = highlightPlayerName(playerName)
        
        addEvent(function()
            Game.broadcastMessage(
                string.format("%s %s ganhou um item raro: %s na roleta!", 
                config.messages.PREFIX.RARO, highlightedName, itemName),
                config.messages.COLOR_SPECIAL)
        end, DELAY.LONG)
        
        -- Aumentar o jackpot para itens raros
        if config.jackpot.enabled then
            local jackpotValue = getJackpotValue(actionId)
            jackpotValue = math.min(jackpotValue + config.jackpot.increment * 2, config.jackpot.maxValue)
            saveJackpotValue(actionId, jackpotValue)
        end
    end
    
    return true
end

-- Função para obter um item aleatório
local function getRandomItem()
    local items = config.allItems
    local totalWeight = 0
    
    for _, item in ipairs(items) do
        totalWeight = totalWeight + item.chance
    end

    local randomWeight = math.random() * totalWeight
    local cumulativeWeight = 0
    
    for _, item in ipairs(items) do
        cumulativeWeight = cumulativeWeight + item.chance
        if randomWeight <= cumulativeWeight then
            -- CORREÇÃO CRÍTICA: Retornar uma CÓPIA do item, não a referência
            return {
                id = item.id,
                count = item.count,
                chance = item.chance,
                raro = item.raro
            }
        end
    end
    
    return nil
end

-- Função para armazenar item sorteado no cache da roleta
local function storeRouletteItem(actionId, position, item)
    if not rouletteItemCache[actionId] then
        rouletteItemCache[actionId] = {}
    end
    
    local posKey = string.format("%d_%d_%d", position.x, position.y, position.z)
    rouletteItemCache[actionId][posKey] = {
        id = item.id,
        count = item.count,
        chance = item.chance,
        raro = item.raro
    }
end

-- Função para recuperar item sorteado do cache da roleta
local function getRouletteItem(actionId, position)
    if not rouletteItemCache[actionId] then
        return nil
    end
    
    local posKey = string.format("%d_%d_%d", position.x, position.y, position.z)
    return rouletteItemCache[actionId][posKey]
end

-- Função para limpar cache da roleta
local function clearRouletteCache(actionId)
    if rouletteItemCache[actionId] then
        rouletteItemCache[actionId] = {}
    end
end

-- Funções para manipulação da roleta
local function moveItems(positions, actionId)
    for i = #positions, 2, -1 do
        local fromTile = Tile(positions[i - 1])
        local item = fromTile and fromTile:getTopDownItem()
        if item then
            -- Recuperar dados do item do cache antes de mover
            local itemData = getRouletteItem(actionId, Position(positions[i - 1]))
            
            item:moveTo(positions[i])
            Position(positions[i]):sendMagicEffect(CONST_ME_MAGIC_GREEN)
            
            -- Armazenar dados do item na nova posição
            if itemData then
                storeRouletteItem(actionId, Position(positions[i]), itemData)
            end
        end
    end
end

local function clearItems(positions, actionId)
    for _, pos in ipairs(positions) do
        local tile = Tile(Position(pos))
        if tile then
            local item = tile:getTopDownItem()
            while item do
                item:remove()
                item = tile:getTopDownItem()
            end
        end
    end
    -- Limpar cache da roleta
    clearRouletteCache(actionId)
end

local function createItemWithEffect(position, item, actionId, showEffect)
    Game.createItem(item.id, item.count, Position(position))
    if showEffect ~= false then
        Position(position):sendMagicEffect(CONST_ME_MAGIC_BLUE)
    end
    
    -- Armazenar dados do item no cache
    storeRouletteItem(actionId, Position(position), item)
end

-- Função principal da roleta (versão única)
local function singleRouletteAction(player, actionId, callback)
    local rouletteConfig = config.roulettes[actionId]
    if not rouletteConfig then return end
    
    local positions = rouletteConfig.positions
    local speedConfig = config.speedSettings[1] -- Velocidade normal
    
    local steps = math.random(speedConfig.steps.min, speedConfig.steps.max)
    local interval = speedConfig.baseInterval
    local currentItem = getRandomItem()
    
    if not currentItem then
        if callback then callback() end
        return
    end
    
    createItemWithEffect(positions[1], currentItem, actionId)

    for i = 1, steps do
        addEvent(function()
            moveItems(positions, actionId)
            
            if i == steps then
                -- CORREÇÃO CRÍTICA: Usar o cache ao invés de buscar por ID
                local centralPosition = Position(positions[CENTRAL_POSITION])
                local winningItemData = getRouletteItem(actionId, centralPosition)
                
                if winningItemData then
                    clearItems(positions, actionId)
                    for _, pos in ipairs(positions) do
                        createItemWithEffect(pos, winningItemData, actionId)
                    end

                    -- Primeiro verificar jackpot
                    local wonJackpot = checkJackpot(player, actionId)
                    
                    -- Depois entregar o prêmio normal com atraso
                    addEvent(function()
                        addItemToPlayer(player, winningItemData, actionId)
                        if callback then callback() end
                    end, 1000)
                else
                    if callback then callback() end
                end
            else
                -- Remover o último item e adicionar um novo no início
                local lastPositionTile = Tile(Position(positions[#positions]))
                if lastPositionTile then
                    local lastItem = lastPositionTile:getTopDownItem()
                    if lastItem then
                        lastItem:remove()
                        Position(positions[#positions]):sendMagicEffect(CONST_ME_POFF)
                    end
                end
                
                currentItem = getRandomItem()
                if currentItem then
                    createItemWithEffect(positions[1], currentItem, actionId)
                end
            end
        end, i * interval)

        interval = interval + speedConfig.intervalIncrement
    end
end

-- Função principal da roleta (versão múltipla com pausas e mensagens)
local function multiRouletteAction(player, actionId, spinCount, callback)
    local rouletteConfig = config.roulettes[actionId]
    if not rouletteConfig then 
        if callback then callback() end
        return 
    end
    
    local positions = rouletteConfig.positions
    local speedConfig = config.speedSettings[spinCount] or config.speedSettings[100]
    
    local completedSpins = 0
    
    local function processSingleSpin()
        if completedSpins >= spinCount then
            -- Todas as roladas completadas
            sendMessage(player, config.messages.PREFIX.ROLETA, 
                string.format("Todas as %d roladas foram completadas! Verifique suas mensagens acima para ver todos os itens recebidos.", spinCount))
            
            if callback then callback() end
            return
        end
        
        completedSpins = completedSpins + 1
        
        -- Processar rolada atual
        local steps = math.random(speedConfig.steps.min, speedConfig.steps.max)
        local interval = speedConfig.baseInterval
        local currentItem = getRandomItem()
        
        if not currentItem then
            addEvent(processSingleSpin, speedConfig.pauseBetweenSpins)
            return
        end
        
        createItemWithEffect(positions[1], currentItem, actionId, false) -- Sem efeito visual para velocidade

        for i = 1, steps do
            addEvent(function()
                moveItems(positions, actionId)
                
                if i == steps then
                    -- Usar o cache ao invés de buscar por ID
                    local centralPosition = Position(positions[CENTRAL_POSITION])
                    local winningItemData = getRouletteItem(actionId, centralPosition)
                    
                    if winningItemData then
                        -- Mostrar item ganho na roleta por um momento
                        clearItems(positions, actionId)
                        for _, pos in ipairs(positions) do
                            createItemWithEffect(pos, winningItemData, actionId, true) -- Com efeito para mostrar o resultado
                        end
                        
                        -- Verificar jackpot para cada rolada
                        checkJackpot(player, actionId)
                        
                        -- Entregar item com mensagem detalhada após pequena pausa
                        addEvent(function()
                            addItemToPlayerWithMessage(player, winningItemData, actionId, completedSpins, spinCount)
                            
                            -- Limpar itens e continuar para próxima rolada após pausa
                            addEvent(function()
                                clearItems(positions, actionId)
                                processSingleSpin()
                            end, speedConfig.pauseBetweenSpins)
                        end, 500) -- Pausa para mostrar o item ganho
                    else
                        -- Se não conseguiu obter item, continuar
                        addEvent(processSingleSpin, speedConfig.pauseBetweenSpins)
                    end
                else
                    -- Remover o último item e adicionar um novo no início
                    local lastPositionTile = Tile(Position(positions[#positions]))
                    if lastPositionTile then
                        local lastItem = lastPositionTile:getTopDownItem()
                        if lastItem then
                            lastItem:remove()
                        end
                    end
                    
                    currentItem = getRandomItem()
                    if currentItem then
                        createItemWithEffect(positions[1], currentItem, actionId, false)
                    end
                end
            end, i * interval)

            interval = interval + speedConfig.intervalIncrement
        end
    end
    
    -- Iniciar primeira rolada
    processSingleSpin()
end

-- Função para processar escolha do modal
local function processModalChoice(player, actionId, spinCount)
    local requiredCoins = spinCount
    
    -- Verificar se o jogador tem moedas suficientes
    if player:getItemCount(config.requiredItemId) < requiredCoins then
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("Voce precisa de %d Roulette Coins para %dx giros.", requiredCoins, spinCount))
        return false
    end
    
    -- Verificar se a roleta está em execução
    if isRouletteRunning[actionId] then
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            "A roleta ja esta em funcionamento. Por favor, aguarde.")
        return false
    end
    
    -- Remover as moedas
    if not player:removeItem(config.requiredItemId, requiredCoins) then
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            "Erro ao remover as moedas. Tente novamente.")
        return false
    end
    
    isRouletteRunning[actionId] = true
    
    -- Mostrar informações do jackpot
    if config.jackpot.enabled then
        local jackpotValue = getJackpotValue(actionId)
        sendMessage(player, config.messages.PREFIX.JACKPOT, 
            string.format("Jackpot atual: %s crystal coins!", formatNumber(jackpotValue)), false, true) -- Usar MESSAGE_LOOK para jackpot
    end
    
    local rouletteConfig = config.roulettes[actionId]
    clearItems(rouletteConfig.positions, actionId)
    
    if spinCount == 1 then
        -- Rolada única com animação completa
        singleRouletteAction(player, actionId, function()
            isRouletteRunning[actionId] = false
        end)
    else
        -- Múltiplas roladas com pausas e mensagens
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("Iniciando %dx giros com pausas para visualizacao...", spinCount))
        
        multiRouletteAction(player, actionId, spinCount, function()
            isRouletteRunning[actionId] = false
        end)
    end
    
    return true
end

-- Função para mostrar modal de seleção
local function showSpinSelectionModal(player, actionId)
    local modal = ModalWindow(1000, "Roleta - Selecione a quantidade", "Escolha quantas vezes deseja girar a roleta:")
    
    modal:addButton(1, "1x (1 coin)")
    modal:addButton(5, "5x (5 coins)")
    modal:addButton(10, "10x (10 coins)")
    modal:addButton(100, "100x (100 coins)")
    modal:addButton(255, "Cancelar")
    
    modal:setDefaultEnterButton(1)
    modal:setDefaultEscapeButton(255)
    
    -- Armazenar dados da sessão
    multiSpinSessions[player:getId()] = {
        actionId = actionId,
        timestamp = os.time()
    }
    
    modal:sendToPlayer(player)
end

-- Callback do modal - VERSÃO CORRIGIDA
local function onModalWindow(player, modalWindowId, buttonId, choiceId)
    if modalWindowId ~= 1000 then return false end
    
    local playerId = player:getId()
    local session = multiSpinSessions[playerId]
    
    if not session then
        sendMessage(player, config.messages.PREFIX.ROLETA, "Sessao expirada. Tente novamente.")
        return true
    end
    
    -- Limpar sessão
    multiSpinSessions[playerId] = nil
    
    if buttonId == 255 then -- Cancelar
        return true
    end
    
    local actionId = session.actionId
    local spinCount = buttonId
    
    processModalChoice(player, actionId, spinCount)
    
    return true
end

-- Registrar callback do modal
local modalCallback = CreatureEvent("RouletteModalCallback")
modalCallback.onModalWindow = onModalWindow
modalCallback:register()

-- Action para a alavanca da roleta
local rouletteLever = Action()

function rouletteLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local actionId = item.actionid
    
    -- Verificar se é uma roleta válida
    local rouletteConfig = config.roulettes[actionId]
    if not rouletteConfig then
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            string.format("ActionID nao configurado: %d", actionId))
        return false
    end
    
    -- Verificar posição do jogador
    if player:getPosition() ~= rouletteConfig.playerPosition then
        return false
    end

    -- Verificar se a roleta está em execução
    if isRouletteRunning[actionId] then
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            "A roleta ja esta em funcionamento. Por favor, aguarde.")
        return false
    end
    
    -- Verificar se o jogador tem pelo menos 1 moeda
    if player:getItemCount(config.requiredItemId) < 1 then
        sendMessage(player, config.messages.PREFIX.ROLETA, 
            "Voce precisa de pelo menos 1 Roulette Coin para usar a roleta.")
        return false
    end

    -- Registrar callback do modal para este jogador
    player:registerEvent("RouletteModalCallback")
    
    -- CORREÇÃO CRÍTICA: Mostrar modal ao invés de executar roleta diretamente
    showSpinSelectionModal(player, actionId)
    return true
end

-- Registrar as roletas
rouletteLever:aid(18562) -- Sorcerer
rouletteLever:aid(18563) -- Druid
rouletteLever:aid(18564) -- Paladin
rouletteLever:aid(18565) -- Knight
rouletteLever:register()

-- Limpeza de sessões expiradas (executar a cada 5 minutos)
addEvent(function()
    local function cleanupSessions()
        local currentTime = os.time()
        for playerId, session in pairs(multiSpinSessions) do
            if currentTime - session.timestamp > 300 then -- 5 minutos
                multiSpinSessions[playerId] = nil
            end
        end
        
        -- Reagendar limpeza
        addEvent(cleanupSessions, 300000) -- 5 minutos
    end
    
    cleanupSessions()
end, 300000)

