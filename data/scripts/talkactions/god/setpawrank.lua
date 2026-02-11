--[[
	/setpawrank playername, rank
    Ranks disponíveis:
    -1 = Sem rank
     0 = Huntsman
     2 = Ranger (necessário para destinos restritos)
     4 = Big Game Hunter
     6 = Trophy Hunter
     7 = Elite Hunter
]]

-- Caminhos corretos das storages:
local JOIN_STOR      = Storage.Quest.U8_5.KillingInTheNameOf.Join_Stor
local POINTSSTORAGE  = Storage.Quest.U8_5.KillingInTheNameOf.PointsStorage

local printConsole = true
local setPawRank = TalkAction("/setpawrank")

function setPawRank.onSay(player, words, param)
    -- criar log
    logCommand(player, words, param)
    
    if param == "" then
        player:sendCancelMessage("Command param required. Usage: /setpawrank playername, rank")
        return true
    end
    
    local split = param:split(",")
    local name = split[1]
    local target = Player(name)
    
    if not target then
        player:sendCancelMessage("Player not found.")
        return true
    end
    
    local rankValue = tonumber(split[2])
    if not rankValue or not table.contains({-1, 0, 2, 4, 6, 7}, rankValue) then
        player:sendCancelMessage("Invalid rank value. Use: -1, 0, 2, 4, 6 or 7.")
        return true
    end
    
    -- Define pontos apropriados para o rank
    local pointsValue = 0
    if rankValue == 0 then
        pointsValue = 10      -- Huntsman
    elseif rankValue == 2 then
        pointsValue = 20      -- Ranger
    elseif rankValue == 4 then
        pointsValue = 40      -- Big Game Hunter
    elseif rankValue == 6 then
        pointsValue = 70      -- Trophy Hunter
    elseif rankValue == 7 then
        pointsValue = 100     -- Elite Hunter
    end
    
    -- Configura TODOS os storages relevantes para o sistema Paw and Fur
    
    -- 1. Registra o jogador na sociedade
    target:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.QuestLogEntry, 0)
    target:setStorageValue(JOIN_STOR, 1)
    
    -- 2. Define o rank do jogador
    target:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank, rankValue)
    
    -- 3. Define os pontos do jogador
    target:setStorageValue(POINTSSTORAGE, pointsValue)
    
    -- 4. Define os pontos de boss
    target:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossPoints, 1)
    
    -- Confirma a alteração
    local rankNames = {
        [-1] = "None",
        [0] = "Huntsman",
        [2] = "Ranger",
        [4] = "Big Game Hunter",
        [6] = "Trophy Hunter",
        [7] = "Elite Hunter"
    }
    
    target:sendTextMessage(MESSAGE_ADMINISTRATOR, "" .. player:getName() .. " has set your Paw and Fur rank to " .. rankNames[rankValue] .. ".")
    player:sendTextMessage(MESSAGE_ADMINISTRATOR, "You have successfully set " .. target:getName() .. "'s Paw and Fur rank to " .. rankNames[rankValue] .. " with " .. pointsValue .. " points.")
    
    if printConsole then
        logger.info("[setPawRank.onSay] - Player: {} has set Paw and Fur rank: {} ({}) with {} points to player: {}", 
            player:getName(), rankNames[rankValue], rankValue, pointsValue, target:getName())
    end
    
    return true
end

setPawRank:separator(" ")
setPawRank:groupType("god")
setPawRank:register()
