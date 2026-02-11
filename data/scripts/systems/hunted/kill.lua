-- Constantes de mensagem
local MESSAGE_STATUS_CONSOLE_RED = 19
local MESSAGE_STATUS_CONSOLE_BLUE = 17

-- Constantes de efeitos mágicos
local CONST_ME_FIREWORKS = CONST_ME_FIREAREA
local CONST_ME_OUTFIT_EFFECT = CONST_ME_MAGIC_BLUE

-- Modo de depuração
local DEBUG_MODE = true

-- Função de log personalizada
 local function debugLog(message)
     if DEBUG_MODE then
         --print("[DEBUG][Kill Points System] " .. message)
    end
 end

-- Lista de recompensas configurável com limites de compra
local rewards = {
    { 
        name = "Golden Helmet", 
        cost = 50, 
        type = "item", 
        value = 3365,
        purchaseLimit = 2,
        storage = 19000
    },
    { 
        name = "Golden Outfit", 
        cost = 100, 
        type = "outfit", 
        value = { male = 1210, female = 1211, addon = 1 },
        purchaseLimit = 1,
        storage = 19001
    },
    -- Buffs de Skills de Combate
    {
        name = "Sword Fighting Boost",
        cost = 200,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000, -- 1 hora
            skills = {
                [SKILL_SWORD] = 5 -- +5 de sword fighting
            }
        },
        purchaseLimit = 0,
        storage = 19002
    },
    {
        name = "Club Fighting Boost",
        cost = 200,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            skills = {
                [SKILL_CLUB] = 5
            }
        },
        purchaseLimit = 0,
        storage = 19003
    },
    {
        name = "Axe Fighting Boost",
        cost = 200,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            skills = {
                [SKILL_AXE] = 5
            }
        },
        purchaseLimit = 0,
        storage = 19004
    },
    {
        name = "Distance Fighting Boost",
        cost = 200,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            skills = {
                [SKILL_DISTANCE] = 5
            }
        },
        purchaseLimit = 0,
        storage = 19005
    },
    {
        name = "Shield Skill Boost",
        cost = 200,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            skills = {
                [SKILL_SHIELD] = 5
            }
        },
        purchaseLimit = 0,
        storage = 19006
    },
    -- Vitality Boost (HP/MP)
    {
        name = "Vitality Boost",
        cost = 350,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            stats = {
                maxHealth = 200,
                maxMana = 100
            }
        },
        purchaseLimit = 0,
        storage = 19007
    },
    -- Life Leech
    {
        name = "Life Leech Boost",
        cost = 300,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            leech = {
                lifeAmount = 100,   -- 1.00%
                lifeChance = 100    -- 100% chance
            }
        },
        purchaseLimit = 0,
        storage = 19008
    },
    -- Mana Leech
    {
        name = "Mana Leech Boost",
        cost = 300,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            leech = {
                manaAmount = 100,   -- 1.00%
                manaChance = 100    -- 100% chance
            }
        },
        purchaseLimit = 0,
        storage = 19009
    },
    -- Critical Hit
    {
        name = "Critical Hit Boost",
        cost = 400,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 3600 * 1000,
            critical = {
                chance = 100,    -- 1% chance
                damage = 150     -- 1,5% extra damage
            }
        },
        purchaseLimit = 0,
        storage = 19010
    },
    -- Ultimate Combat Boost (Todos os buffs combinados)
    {
        name = "Ultimate Combat Boost",
        cost = 1000,
        type = "buff",
        value = {
            condition = CONDITION_ATTRIBUTES,
            ticks = 1800 * 1000, -- 30 minutos
            skills = {
                [SKILL_SWORD] = 5,
                [SKILL_AXE] = 5,
                [SKILL_CLUB] = 5,
                [SKILL_DISTANCE] = 5,
                [SKILL_SHIELD] = 5
            },
            stats = {
                maxHealth = 1500,
                maxMana = 800
            },
            leech = {
                lifeAmount = 150,    -- 1.50%
                lifeChance = 100,
                manaAmount = 150,    -- 1.50%
                manaChance = 100
            },
            critical = {
                chance = 10,
                damage = 15
            }
        },
        purchaseLimit = 0,
        storage = 19011
    }
}


-- Funções de banco de dados
local function getPlayerIdByName(playerName)
    local resultId = db.storeQuery(string.format([[
        SELECT `id` FROM `players` WHERE `name` = '%s'
    ]], string.gsub(playerName, "'", "''")))
    if resultId then
        local playerId = result.getNumber(resultId, "id")
        result.free(resultId)
        return playerId
    end
    return nil
end

local function loadPlayerPoints(playerId)
    local resultId = db.storeQuery(string.format([[
        SELECT `points`, `total_kills`, `total_deaths` 
        FROM `player_kill_points` 
        WHERE `player_id` = %d
    ]], playerId))
    if resultId then
        local points = result.getNumber(resultId, "points")
        local totalKills = result.getNumber(resultId, "total_kills")
        local totalDeaths = result.getNumber(resultId, "total_deaths")
        result.free(resultId)
        return points, totalKills, totalDeaths
    else
        local playerName = Player(playerId):getName()
        local escapedName = string.gsub(playerName, "'", "''")
        db.query(string.format([[
            INSERT INTO `player_kill_points` (`player_id`, `player_name`, `points`, `total_kills`, `total_deaths`) 
            VALUES (%d, '%s', 0, 0, 0)
        ]], playerId, escapedName))
        debugLog("Nova entrada criada para o jogador: " .. playerName)
        return 0, 0, 0
    end
end

local function savePlayerPoints(playerId, points, totalKills, totalDeaths)
    local playerName = Player(playerId):getName()
    local escapedName = string.gsub(playerName, "'", "''")
    db.query(string.format([[
        INSERT INTO `player_kill_points` (`player_id`, `player_name`, `points`, `total_kills`, `total_deaths`) 
        VALUES (%d, '%s', %d, %d, %d) 
        ON DUPLICATE KEY UPDATE 
            `points` = %d, 
            `total_kills` = %d, 
            `total_deaths` = %d
    ]], playerId, escapedName, points, totalKills, totalDeaths, points, totalKills, totalDeaths))
    debugLog("Dados salvos para o jogador: " .. playerName)
end

-- Função para verificar limite de compras
local function checkPurchaseLimit(player, reward)
    if reward.purchaseLimit == 0 then
        return true
    end

    local purchases = player:getStorageValue(reward.storage)
    if purchases < 0 then purchases = 0 end

    return purchases < reward.purchaseLimit
end

-- Função para incrementar contador de compras
local function incrementPurchaseCount(player, reward)
    local currentCount = player:getStorageValue(reward.storage)
    if currentCount < 0 then currentCount = 0 end
    player:setStorageValue(reward.storage, currentCount + 1)
end

-- Função para processar a recompensa
function processReward(player, rewardIndex)
    debugLog("Processando recompensa: " .. rewardIndex)
    
    local selectedReward = rewards[rewardIndex]
    if not selectedReward then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Invalid reward selection.")
        return false
    end

    if not checkPurchaseLimit(player, selectedReward) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, string.format("You have reached the purchase limit for %s!", selectedReward.name))
        return false
    end

    local playerId = getPlayerIdByName(player:getName())
    local currentPoints, totalKills, totalDeaths = loadPlayerPoints(playerId)

    if currentPoints < selectedReward.cost then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Not enough points.")
        return false
    end

    local rewardSuccess = false

    if selectedReward.type == "item" then
        local itemId = selectedReward.value
        local itemName = ItemType(itemId):getName() or "Unknown Item"

        if player:getFreeCapacity() >= ItemType(itemId):getWeight(1) then
            local newItem = Game.createItem(itemId, 1)
            if newItem then
                player:addItemEx(newItem)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("You received: %s", itemName))
                rewardSuccess = true
            end
        else
            local depotChest = player:getDepotChest(1, true)
            if depotChest then
                local newItem = Game.createItem(itemId, 1)
                if newItem then
                    depotChest:addItemEx(newItem)
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Item sent to depot: %s", itemName))
                    rewardSuccess = true
                end
            end
        end
        
        if rewardSuccess then
            player:getPosition():sendMagicEffect(CONST_ME_FIREWORKS)
        end

    elseif selectedReward.type == "outfit" then
        local maleId, femaleId, addon = selectedReward.value.male, selectedReward.value.female, selectedReward.value.addon
        
        if player:hasOutfit(maleId, addon) or player:hasOutfit(femaleId, addon) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "You already have this outfit!")
            return false
        end

        player:addOutfit(maleId, addon)
        player:addOutfit(femaleId, addon)
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("You received: %s", selectedReward.name))
        player:getPosition():sendMagicEffect(CONST_ME_OUTFIT_EFFECT)
        rewardSuccess = true

    elseif selectedReward.type == "buff" then
        local buffData = selectedReward.value
        local condition = Condition(buffData.condition)
        
        if condition then
            condition:setTicks(buffData.ticks)
            
            -- Aplica skills de combate
            if buffData.skills then
                for skillType, bonus in pairs(buffData.skills) do
                    if skillType == SKILL_SWORD then
                        condition:setParameter(CONDITION_PARAM_SKILL_SWORD, bonus)
                    elseif skillType == SKILL_AXE then
                        condition:setParameter(CONDITION_PARAM_SKILL_AXE, bonus)
                    elseif skillType == SKILL_CLUB then
                        condition:setParameter(CONDITION_PARAM_SKILL_CLUB, bonus)
                    elseif skillType == SKILL_DISTANCE then
                        condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, bonus)
                    elseif skillType == SKILL_SHIELD then
                        condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, bonus)
                    end
                end
            end
            
            -- Aplica stats (HP/MP)
            if buffData.stats then
                if buffData.stats.maxHealth then
                    condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTS, buffData.stats.maxHealth)
                end
                if buffData.stats.maxMana then
                    condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTS, buffData.stats.maxMana)
                end
            end
            
            -- Aplica life/mana leech
            if buffData.leech then
                if buffData.leech.lifeAmount then
                    condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, buffData.leech.lifeAmount)
                    condition:setParameter(CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE, buffData.leech.lifeChance)
                end
                if buffData.leech.manaAmount then
                    condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, buffData.leech.manaAmount)
                    condition:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE, buffData.leech.manaChance)
                end
            end
            
            -- Aplica critical hit
            if buffData.critical then
                condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, buffData.critical.chance)
                condition:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, buffData.critical.damage)
            end
            
            player:addCondition(condition)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Activated: %s", selectedReward.name))
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            rewardSuccess = true
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Failed to create buff condition.")
            return false
        end
    end

    if rewardSuccess then
        savePlayerPoints(playerId, currentPoints - selectedReward.cost, totalKills, totalDeaths)
        incrementPurchaseCount(player, selectedReward)
        return true
    end

    return false
end

-- Função para enviar a janela de recompensas
function sendRewardModalWindow(player, points)
    local window = ModalWindow{
        title = "Reward Selection",
        message = "Choose your reward:"
    }

    for i, reward in ipairs(rewards) do
        local purchases = player:getStorageValue(reward.storage)
        if purchases < 0 then purchases = 0 end
        
        local displayText = string.format("%s (Cost: %d points)", reward.name, reward.cost)
        
        if reward.purchaseLimit > 0 then
            displayText = displayText .. string.format(" [%d/%d]", purchases, reward.purchaseLimit)
        end
        
        if reward.cost > points then
            displayText = displayText .. " [INSUFFICIENT POINTS]"
        elseif reward.purchaseLimit > 0 and purchases >= reward.purchaseLimit then
            displayText = displayText .. " [LIMIT REACHED]"
        end
        
        window:addChoice(displayText)
    end

    local function confirmCallback(player, button, choice)
        processReward(player, choice.id)
    end

    window:addButton("Select", confirmCallback)
    window:addButton("Cancel")
    
    window:sendToPlayer(player)
end

-- Função para enviar a janela principal
function sendKillModalWindow(player, points, totalKills, totalDeaths)
    local window = ModalWindow{
        title = "Kill Points System",
        message = "Your current statistics:"
    }

    window:addChoice(string.format("Points: %d", points))
    window:addChoice(string.format("Total Kills: %d", totalKills))
    window:addChoice(string.format("Total Deaths: %d", totalDeaths))

    local function rewardCallback(player)
        sendRewardModalWindow(player, points)
    end

    window:addButton("Claim Reward", rewardCallback)
    window:addButton("Voltar", function(player)
    if _G.openMultiFunctionModal then
        _G.openMultiFunctionModal(player)
    end
end)
    window:addButton("Exit")

    window:sendToPlayer(player)
end

-- Comando !kill
local killTalkAction = TalkAction("!kill-desativado102030")
function killTalkAction.onSay(player, words, param)
    debugLog("Comando !kill iniciado por: " .. player:getName())
    
    local playerId = getPlayerIdByName(player:getName())
    if not playerId then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Failed to retrieve player ID.")
        return false
    end

    local points, totalKills, totalDeaths = loadPlayerPoints(playerId)
    sendKillModalWindow(player, points, totalKills, totalDeaths)

    player:getPosition():sendMagicEffect(CONST_ME_TREASURE_MAP)
    player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_PHYSICAL_RANGE_MISS, player:isInGhostMode() and nil or player)
    return true
end

killTalkAction:groupType("normal")
killTalkAction:register()

_G.getPlayerIdByName = getPlayerIdByName
_G.loadPlayerPoints = loadPlayerPoints
_G.sendKillModalWindow = sendKillModalWindow