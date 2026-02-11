--[[
    Party Management System - Final Version (Simplified Level Range Logic)
    Developed by Manus for Canary
    Version: 8.1.0 (Simplified level range logic - always remove lowest level player)
    Date: 2025-06-25

    MAJOR IMPROVEMENT:
    - Simplified level range logic: always remove the lowest level player when range is broken
    - This allows the party to gradually reconfigure itself, always respecting the highest level present
    - Much more predictable and reliable behavior

    Commands:
    !party - Show all commands (modal, any player)
    !partycheck - Modal with problematic players
    !partykick - Kick problematic players
    !partyplayers - Modal with party list (leader only)
    !partykickplayer - Kick specific player (leader only)
    !partyinfo - Show party level range (any player)
    !partyinvite on/off - Control PT invite system (leader only)
    !autokick on/off - Toggle automatic system
    !partyall - Invite all players on screen
    !partymasskick - Dissolve entire party
    !pt - Request party invite (controlled by !partyinvite)
]]--

local PartyManagement = {}

-- Configuration
local CONFIG = {
    MAX_DISTANCE = 30, -- Maximum distance in SQM
    CHECK_INTERVAL_SECONDS = 30, -- Auto check every 30 seconds
    AUTO_KICK_ENABLED = false, -- Default state for automatic kick
    MESSAGE_STATUS = 30, -- White message in console
    NO_TARGET_TIMEOUT_SECONDS = 120, -- 2 minutes without target to kick
    INVITE_RANGE = 7, -- Range to invite players for !partyall
    PT_AUTO_INVITE_RANGE = 10, -- Range for automatic PT invites
    PARTY_SHARE_RANGE_MULTIPLIER = 1.5 -- Default multiplier (can be configured in server)
}

-- Aurera Global XP System Configuration
local AURERA_XP_CONFIG = {
    ENABLED = true,
    MIN_LEVEL_FOR_FULL_BONUS = 251,
    BELOW_MIN_LEVEL_BEHAVIOR = "VOCATION_ONLY", -- Players <251 get only vocation bonus
    
    -- DEBUG SETTINGS
    DEBUG_ENABLED = false, -- Set to false to disable debug messages
    DEBUG_TO_CONSOLE = true, -- Print debug to server console
    DEBUG_TO_PLAYERS = true, -- Send debug messages to party members
    
    VOCATION_BONUS = {
        [1] = 0.20,  -- 20% for 1 vocation
        [2] = 0.30,  -- 30% for 2 vocations
        [3] = 0.60,  -- 60% for 3 vocations
        [4] = 1.00   -- 100% for 4 vocations
    },
    
    PARTY_SIZE_BONUS = {
        [4] = 1.00,  -- 100% (SWEET SPOT!)
        [5] = 0.80,  -- 80%
        [6] = 0.60,  -- 60%
        [7] = 0.40,  -- 40%
        [8] = 0.20,  -- 20%
        [9] = 0.00   -- 0% (9+ players get no size bonus)
    }
}

-- Global state
local autoKickState = {
    globalEnabled = CONFIG.AUTO_KICK_ENABLED,
    perPartyEnabled = {},
    ptInviteEnabled = {}, -- Control PT invite system per party (default OFF)
    lastSharedExpStatus = {},
    sharedExpBreakTime = {},
    checkTimer = nil,
    allParties = {},
    playerTargetHistory = {} -- player ID -> {lastTargetTime, noTargetStartTime}
}

-- Helper function to get current time in seconds
local function getCurrentTime()
    return os.time()
end

-- Simplified player validation
local function isValidPlayer(player)
    return player and player:isPlayer()
end

-- Helper function to get player's party
local function getPlayerParty(player)
    if isValidPlayer(player) then
        return player:getParty()
    end
    return nil
end

-- Function to get target status with counter system
local function getTargetStatus(player)
    if not isValidPlayer(player) then
        return {
            hasTarget = false,
            targetName = "Nenhum",
            noTargetTime = 0
        }
    end

    local playerId = player:getId()
    local currentTime = getCurrentTime()
    
    local success, target = pcall(function()
        return player:getTarget()
    end)

    local hasTarget = false
    local targetName = "Nenhum"
    
    if success and target and target:isMonster() then
        hasTarget = true
        targetName = target:getName()
    end
    
    -- Get or create player history
    if not autoKickState.playerTargetHistory[playerId] then
        autoKickState.playerTargetHistory[playerId] = {
            lastTargetTime = currentTime,
            noTargetStartTime = nil
        }
    end
    
    local history = autoKickState.playerTargetHistory[playerId]
    
    -- Update target counter
    if hasTarget then
        history.lastTargetTime = currentTime
        history.noTargetStartTime = nil -- Reset no-target timer
    else
        if not history.noTargetStartTime then
            history.noTargetStartTime = currentTime -- Start counting no-target time
        end
    end
    
    -- Calculate time without target
    local noTargetTime = 0
    if history.noTargetStartTime then
        noTargetTime = currentTime - history.noTargetStartTime
    end
    
    return {
        hasTarget = hasTarget,
        targetName = targetName,
        noTargetTime = noTargetTime
    }
end

-- Function to calculate party level range
local function getPartyLevelRange(party)
    if not party then return nil end
    
    local leader = party:getLeader()
    if not isValidPlayer(leader) then return nil end
    
    local members = party:getMembers()
    table.insert(members, leader)
    
    local playerLevels = {}
    for _, member in ipairs(members) do
        if isValidPlayer(member) then
            table.insert(playerLevels, member:getLevel())
        end
    end
    
    if #playerLevels == 0 then return nil end
    
    table.sort(playerLevels)
    local lowestLevel = playerLevels[1]
    local highestLevel = playerLevels[#playerLevels]
    
    local minLevel = math.ceil(highestLevel / CONFIG.PARTY_SHARE_RANGE_MULTIPLIER)
    local maxLevel = math.floor(lowestLevel * CONFIG.PARTY_SHARE_RANGE_MULTIPLIER)
    
    return {
        minLevel = minLevel,
        maxLevel = maxLevel,
        highestLevel = highestLevel,
        lowestLevel = lowestLevel,
        totalPlayers = #playerLevels
    }
end

-- CORRECTED: Function to identify level range culprits - always remove lowest level player when anyone is outside range
local function getPartyLevelRangeCulprits(party)
    if not party then return {} end
    
    local leader = party:getLeader()
    if not isValidPlayer(leader) then return {} end
    
    local members = party:getMembers()
    table.insert(members, leader)
    
    local playerData = {}
    for _, member in ipairs(members) do
        if isValidPlayer(member) then
            table.insert(playerData, {
                player = member,
                level = member:getLevel(),
                isLeader = (member:getId() == leader:getId())
            })
        end
    end
    
    if #playerData <= 1 then return {} end
    
    -- Sort by level to understand the distribution
    table.sort(playerData, function(a, b) return a.level < b.level end)
    
    local lowestLevel = playerData[1].level
    local highestLevel = playerData[#playerData].level
    
    -- Calculate current valid range based on existing levels
    local minLevel = math.ceil(highestLevel / CONFIG.PARTY_SHARE_RANGE_MULTIPLIER)
    local maxLevel = math.floor(lowestLevel * CONFIG.PARTY_SHARE_RANGE_MULTIPLIER)
    
    local culprits = {}
    
    -- CORRECTED LOGIC: Check if ANY player is outside the valid range
    -- If so, always remove the lowest level player to allow gradual reconfiguration
    local hasPlayersOutsideRange = false
    
    for _, data in ipairs(playerData) do
        local level = data.level
        -- Check if this player is outside the calculated range
        if level < minLevel or level > maxLevel then
            hasPlayersOutsideRange = true
            break
        end
    end
    
    -- If there are players outside the range, remove the lowest level player
    if hasPlayersOutsideRange then
        -- Find the lowest level player (prefer non-leader if possible)
        local lowestLevelPlayer = nil
        local lowestLevelFound = math.huge
        
        -- First try to find lowest level non-leader
        for _, data in ipairs(playerData) do
            if data.level < lowestLevelFound and not data.isLeader then
                lowestLevelFound = data.level
                lowestLevelPlayer = data
            end
        end
        
        -- If no non-leader found or all are leaders, include leader in consideration
        if not lowestLevelPlayer then
            for _, data in ipairs(playerData) do
                if data.level < lowestLevelFound then
                    lowestLevelFound = data.level
                    lowestLevelPlayer = data
                end
            end
        end
        
        if lowestLevelPlayer then
            table.insert(culprits, {
                player = lowestLevelPlayer.player,
                reason = "LEVEL_FORA_FAIXA",
                playerLevel = lowestLevelPlayer.level,
                minLevel = minLevel,
                maxLevel = maxLevel,
                currentRange = string.format("%d-%d", minLevel, maxLevel)
            })
        end
    end
    
    return culprits
end

-- Function to get problematic players with simplified level range logic
local function getProblematicPlayers(party)
    if not party then return {} end
    
    local leader = party:getLeader()
    if not isValidPlayer(leader) then return {} end
    
    local problematicPlayers = {}
    
    for _, member in ipairs(party:getMembers()) do
        if isValidPlayer(member) and member:getId() ~= leader:getId() then
            local memberPos = member:getPosition()
            local leaderPos = leader:getPosition()
            
            local shouldKick = false
            local reason = "OK"
            
            -- Rule 1: Different Z-axis (immediate kick)
            if leaderPos.z ~= memberPos.z then
                shouldKick = true
                reason = "EIXO_Z_DIFERENTE"
            -- Rule 2: More than MAX_DISTANCE away (immediate kick)
            elseif leaderPos:getDistance(memberPos) > CONFIG.MAX_DISTANCE then
                shouldKick = true
                reason = "LONGE_MAIS_30SQM"
            else
                -- Rule 3: No target for more than 2 minutes (immediate kick)
                local targetStatus = getTargetStatus(member)
                if targetStatus.noTargetTime >= CONFIG.NO_TARGET_TIMEOUT_SECONDS then
                    shouldKick = true
                    reason = "SEM_TARGET_2MIN"
                end
            end
            
            if shouldKick then
                local targetStatus = getTargetStatus(member)
                table.insert(problematicPlayers, {
                    player = member,
                    reason = reason,
                    distance = leaderPos:getDistance(memberPos),
                    zDiff = memberPos.z - leaderPos.z,
                    noTargetTime = targetStatus.noTargetTime,
                    hasTarget = targetStatus.hasTarget,
                    targetName = targetStatus.targetName,
                    playerLevel = member:getLevel()
                })
            end
        end
    end
    
    -- Rule 4: Add level range culprits (using simplified logic)
    local levelCulprits = getPartyLevelRangeCulprits(party)
    for _, culprit in ipairs(levelCulprits) do
        -- Check if this player is not already in the problematic list for other reasons
        local alreadyAdded = false
        for _, existing in ipairs(problematicPlayers) do
            if existing.player:getId() == culprit.player:getId() then
                alreadyAdded = true
                break
            end
        end
        
        if not alreadyAdded then
            local targetStatus = getTargetStatus(culprit.player)
            local memberPos = culprit.player:getPosition()
            local leaderPos = leader:getPosition()
            
            table.insert(problematicPlayers, {
                player = culprit.player,
                reason = culprit.reason,
                distance = leaderPos:getDistance(memberPos),
                zDiff = memberPos.z - leaderPos.z,
                noTargetTime = targetStatus.noTargetTime,
                hasTarget = targetStatus.hasTarget,
                targetName = targetStatus.targetName,
                playerLevel = culprit.playerLevel,
                minLevel = culprit.minLevel,
                maxLevel = culprit.maxLevel
            })
        end
    end
    
    return problematicPlayers
end

-- Function to get party statistics with Monk support and clean leader display
local function getPartyStats(party)
    if not party then return nil end
    
    local members = party:getMembers()
    local leader = party:getLeader()
    if leader then
        table.insert(members, leader)
    end
    
    local stats = {
        totalPlayers = #members,
        vocations = {
            knight = 0,
            paladin = 0,
            sorcerer = 0,
            druid = 0,
            monk = 0 -- Added Monk support
        },
        players = {}
    }
    
    for _, member in ipairs(members) do
        if isValidPlayer(member) then
            local vocationId = member:getVocation():getId()
            local vocationName = member:getVocation():getName():lower()
            
            -- Count vocations (including Monk IDs 9 and 10)
            if vocationName:find("knight") then
                stats.vocations.knight = stats.vocations.knight + 1
            elseif vocationName:find("paladin") then
                stats.vocations.paladin = stats.vocations.paladin + 1
            elseif vocationName:find("sorcerer") then
                stats.vocations.sorcerer = stats.vocations.sorcerer + 1
            elseif vocationName:find("druid") then
                stats.vocations.druid = stats.vocations.druid + 1
            elseif vocationId == 9 or vocationId == 10 or vocationName:find("monk") then
                stats.vocations.monk = stats.vocations.monk + 1
            end
            
            -- Add player info (clean display without [LIDER])
            table.insert(stats.players, {
                name = member:getName(),
                level = member:getLevel(),
                vocation = member:getVocation():getName(),
                isLeader = (member:getId() == leader:getId())
            })
        end
    end
    
    -- Sort players by level (highest first)
    table.sort(stats.players, function(a, b)
        return a.level > b.level
    end)
    
    return stats
end

-- Function to check if auto kick is enabled for a specific party
local function isAutoKickEnabled(party)
    if not party then return false end
    local leader = party:getLeader()
    if not isValidPlayer(leader) then return false end
    
    local partyId = leader:getId()
    
    if autoKickState.perPartyEnabled[partyId] ~= nil then
        return autoKickState.perPartyEnabled[partyId]
    end
    
    return autoKickState.globalEnabled
end

-- Function to check if PT invite is enabled for a specific party
local function isPTInviteEnabled(party)
    if not party then return false end
    local leader = party:getLeader()
    if not isValidPlayer(leader) then return false end
    
    local partyId = leader:getId()
    
    -- Default is OFF (false)
    return autoKickState.ptInviteEnabled[partyId] == true
end

-- Function to register a party for auto kick monitoring
local function registerParty(party)
    if not party then return end
    local leader = party:getLeader()
    if not isValidPlayer(leader) then return end
    
    local partyId = leader:getId()
    autoKickState.allParties[partyId] = party
end

-- Function to unregister a party from auto kick monitoring
local function unregisterParty(party)
    if not party then return end
    local leader = party:getLeader()
    if not leader then return end
    
    local partyId = leader:getId()
    autoKickState.allParties[partyId] = nil
    autoKickState.perPartyEnabled[partyId] = nil
    autoKickState.ptInviteEnabled[partyId] = nil
    autoKickState.lastSharedExpStatus[partyId] = nil
    autoKickState.sharedExpBreakTime[partyId] = nil
end

-- Function to check if player would be valid for party level range
local function wouldPlayerBeValidForParty(party, newPlayer)
    if not party or not isValidPlayer(newPlayer) then
        return false, "Party ou player invalido"
    end
    
    local analysis = getPartyLevelRange(party)
    if not analysis then
        return false, "Erro ao calcular faixa da party"
    end
    
    local newPlayerLevel = newPlayer:getLevel()
    
    if newPlayerLevel < analysis.minLevel then
        return false, string.format("Level %d muito baixo (min: %d)", newPlayerLevel, analysis.minLevel)
    elseif newPlayerLevel > analysis.maxLevel then
        return false, string.format("Level %d muito alto (max: %d)", newPlayerLevel, analysis.maxLevel)
    end
    
    return true, "OK"
end

-- Function to automatically invite player to nearby party leaders with single clear message
local function autoInviteToNearbyParties(requesterName)
    local requester = Player(requesterName)
    if not requester then return false end
    
    -- Check if requester already has party
    if getPlayerParty(requester) then
        requester:sendTextMessage(CONFIG.MESSAGE_STATUS, "PT negado: Voce ja esta em uma party.")
        return false
    end
    
    local requesterPos = requester:getPosition()
    local requesterLevel = requester:getLevel()
    local spectators = Game.getSpectators(requesterPos, false, false, CONFIG.PT_AUTO_INVITE_RANGE, CONFIG.PT_AUTO_INVITE_RANGE, CONFIG.PT_AUTO_INVITE_RANGE, CONFIG.PT_AUTO_INVITE_RANGE)
    
    local nearbyParties = {}
    local ptActiveParties = {}
    
    -- Find all nearby parties and their level ranges
    for _, creature in ipairs(spectators) do
        if creature:isPlayer() then
            local party = getPlayerParty(creature)
            if party then
                local leader = party:getLeader()
                if leader and leader:getId() == creature:getId() then
                    local analysis = getPartyLevelRange(party)
                    if analysis then
                        table.insert(nearbyParties, {
                            party = party,
                            leader = leader,
                            analysis = analysis,
                            ptActive = isPTInviteEnabled(party)
                        })
                        
                        if isPTInviteEnabled(party) then
                            table.insert(ptActiveParties, {
                                party = party,
                                leader = leader,
                                analysis = analysis
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- Try to invite to PT active parties
    for _, partyData in ipairs(ptActiveParties) do
        local isValid, reason = wouldPlayerBeValidForParty(partyData.party, requester)
        if isValid then
            local success = pcall(function()
                return partyData.party:addInvite(requester)
            end)
            
            if success then
                partyData.leader:sendTextMessage(CONFIG.MESSAGE_STATUS, "Auto PT: Convite enviado para " .. requesterName .. "!")
                requester:sendTextMessage(CONFIG.MESSAGE_STATUS, "PT aceito: Convite recebido de " .. partyData.leader:getName() .. "!")
                return true
            end
        end
    end
    
    -- Single clear message with specific reason
    if #nearbyParties == 0 then
        requester:sendTextMessage(CONFIG.MESSAGE_STATUS, "PT negado: Nenhuma party encontrada nas proximidades.")
    elseif #ptActiveParties == 0 then
        requester:sendTextMessage(CONFIG.MESSAGE_STATUS, "PT negado: Nenhuma party com sistema PT ativo encontrada.")
    else
        -- Find the best range to show
        local bestRange = nil
        for _, partyData in ipairs(ptActiveParties) do
            if not bestRange or (partyData.analysis.minLevel <= requesterLevel and requesterLevel <= partyData.analysis.maxLevel) then
                bestRange = partyData.analysis
                break
            end
        end
        
        if bestRange then
            requester:sendTextMessage(CONFIG.MESSAGE_STATUS, string.format("PT negado: Level %d quebraria faixa %d-%d das parties proximas.", requesterLevel, bestRange.minLevel, bestRange.maxLevel))
        else
            requester:sendTextMessage(CONFIG.MESSAGE_STATUS, string.format("PT negado: Level %d incompativel com parties proximas.", requesterLevel))
        end
    end
    
    return false
end

--[[ TalkActions ]]--

-- !party - Show all available commands in modal (any player can use)
local partyHelpCommand = TalkAction("!party")
function partyHelpCommand.onSay(player, words, param)
    local modal = ModalWindow(1000, "Sistema de Party - Comandos", "")
    
    local message = "=== COMANDOS DISPONIVEIS ===\n\n"
    
    message = message .. "!partycheck\n"
    message = message .. "   Verifica se ha players com problemas na party\n"
    message = message .. "   Mostra em janela detalhada\n\n"
    
    message = message .. "!partyinfo\n"
    message = message .. "   Mostra informacoes da party\n"
    message = message .. "   Faixa de level para shared exp\n\n"
    
    message = message .. "!partyplayers (Lider)\n"
    message = message .. "   Lista todos os membros da party\n"
    message = message .. "   Mostra estatisticas e vocacoes\n\n"
    
    message = message .. "!partykick (Lider)\n"
    message = message .. "   Expulsa todos os players problematicos\n"
    message = message .. "   Remove quem quebra as regras\n\n"
    
    message = message .. "!partykickplayer Nome (Lider)\n"
    message = message .. "   Remove um player especifico\n"
    message = message .. "   Exemplo: !partykickplayer Fulano\n\n"
    
    message = message .. "!partyinvite on/off (Lider)\n"
    message = message .. "   Liga/desliga sistema de convites PT\n"
    message = message .. "   Controla se aceita comandos !pt\n\n"
    
    message = message .. "!autokick on/off (Lider)\n"
    message = message .. "   Liga/desliga sistema automatico\n"
    message = message .. "   Verifica a cada 30 segundos\n\n"
    
    message = message .. "!partyall\n"
    message = message .. "   Convida todos os players na tela\n"
    message = message .. "   Qualquer um pode usar\n\n"
    
    message = message .. "!pt\n"
    message = message .. "   Solicita convite automatico\n"
    message = message .. "   Funciona se lider tiver PT ativo\n\n"
    
    message = message .. "!partymasskick (Lider)\n"
    message = message .. "   Dissolve a party completamente\n"
    message = message .. "   Remove todos os membros\n\n"
    
    message = message .. "=== REGRAS DE EXPULSAO ===\n"
    message = message .. "- Eixo Z diferente do lider\n"
    message = message .. "- Distancia maior que 30 sqm\n"
    message = message .. "- Quebra a faixa de level da party\n"
    message = message .. "  (sempre remove o de menor level)\n"
    message = message .. "- Sem target por mais de 2 minutos"
    
    modal:setMessage(message)
    modal:addButton(1, "Fechar")
    modal:sendToPlayer(player)
    return false
end

partyHelpCommand:separator(" ")
partyHelpCommand:groupType("normal")
partyHelpCommand:register()

-- !partyinfo - Show party level range and information
local partyInfoCommand = TalkAction("!partyinfo")
function partyInfoCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local analysis = getPartyLevelRange(party)
    if not analysis then
        player:sendCancelMessage("Erro ao calcular informacoes da party.")
        return false
    end
    
    local leader = party:getLeader()
    local memberCount = party:getMemberCount() + 1 -- +1 for leader
    local problematicPlayers = getProblematicPlayers(party)
    
    local modal = ModalWindow(1003, "Informacoes da Party", "")
    
    local message = "=== INFORMACOES DA PARTY ===\n\n"
    
    message = message .. string.format("Lider: %s\n", leader:getName())
    message = message .. string.format("Total de membros: %d\n\n", memberCount)
    
    message = message .. "=== FAIXA DE LEVEL ATUAL ===\n"
    message = message .. string.format("Nivel minimo: %d\n", analysis.minLevel)
    message = message .. string.format("Nivel maximo: %d\n", analysis.maxLevel)
    message = message .. string.format("Share range: %d-%d\n\n", analysis.minLevel, analysis.maxLevel)
    
    message = message .. "=== NIVEIS NA PARTY ===\n"
    message = message .. string.format("Maior nivel: %d\n", analysis.highestLevel)
    message = message .. string.format("Menor nivel: %d\n\n", analysis.lowestLevel)
    
    if #problematicPlayers > 0 then
        message = message .. "=== PLAYERS PROBLEMATICOS ===\n"
        for _, data in ipairs(problematicPlayers) do
            local reasonText = data.reason
            if data.reason == "LEVEL_MUITO_ALTO" then
                reasonText = "Muito alto"
            elseif data.reason == "LEVEL_MUITO_BAIXO" then
                reasonText = "Muito baixo (sera removido)"
            elseif data.reason == "LEVEL_FORA_FAIXA" then
                reasonText = "Fora da faixa (sera removido)"
            elseif data.reason == "EIXO_Z_DIFERENTE" then
                reasonText = "Eixo Z diferente"
            elseif data.reason == "LONGE_MAIS_30SQM" then
                reasonText = "Muito longe"
            elseif data.reason == "SEM_TARGET_2MIN" then
                reasonText = "Sem target"
            end
            
            message = message .. string.format("%s (Level %d) - %s\n", 
                data.player:getName(), 
                data.playerLevel,
                reasonText
            )
        end
        message = message .. "\n"
    end
    
    message = message .. "=== STATUS DOS SISTEMAS ===\n"
    message = message .. string.format("Auto Kick: %s\n", isAutoKickEnabled(party) and "ATIVADO" or "DESATIVADO")
    message = message .. string.format("PT Invites: %s\n", isPTInviteEnabled(party) and "ATIVADO" or "DESATIVADO")
    
    modal:setMessage(message)
    modal:addButton(1, "Fechar")
    modal:sendToPlayer(player)
    return false
end

partyInfoCommand:separator(" ")
partyInfoCommand:groupType("normal")
partyInfoCommand:register()

-- !partyinvite on/off - Control PT invite system
local partyInviteCommand = TalkAction("!partyinvite")
function partyInviteCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local leader = party:getLeader()
    if not isValidPlayer(leader) or leader:getId() ~= player:getId() then
        player:sendCancelMessage("Apenas o lider da party pode controlar o sistema PT.")
        return false
    end

    local partyId = leader:getId()
    local action = string.lower(param)
    
    if action == "on" then
        autoKickState.ptInviteEnabled[partyId] = true
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Sistema PT ATIVADO para esta party.")
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Agora voce recebera e processara comandos !pt automaticamente.")
    elseif action == "off" then
        autoKickState.ptInviteEnabled[partyId] = false
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Sistema PT DESATIVADO para esta party.")
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Comandos !pt serao ignorados.")
    else
        player:sendCancelMessage("Uso correto: !partyinvite on ou !partyinvite off")
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Status atual: " .. (isPTInviteEnabled(party) and "ATIVADO" or "DESATIVADO"))
    end
    return false
end

partyInviteCommand:separator(" ")
partyInviteCommand:groupType("normal")
partyInviteCommand:register()

-- !partycheck - Show problematic players in modal
local partyCheckCommand = TalkAction("!partycheck")
function partyCheckCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local problematicPlayers = getProblematicPlayers(party)
    
    local modal = ModalWindow(1001, "Verificacao da Party", "")
    
    if #problematicPlayers == 0 then
        modal:setMessage("PARABENS!\n\nSua party esta funcionando perfeitamente!\n\nTodos os membros estao:\n- No mesmo eixo Z do lider\n- Dentro de 30 sqm de distancia\n- Dentro da faixa de level valida\n- Com target ativo ou recente\n\nContinue assim!")
        modal:addButton(1, "OK")
    else
        local message = "PLAYERS COM PROBLEMAS\n\n"
        message = message .. "Encontrados " .. #problematicPlayers .. " player(s) problematico(s):\n\n"
        
        for i, data in ipairs(problematicPlayers) do
            message = message .. string.format("%s (Level %d)\n", data.player:getName(), data.playerLevel)
            
            if data.reason == "EIXO_Z_DIFERENTE" then
                message = message .. "   Problema: Eixo Z diferente (" .. (data.zDiff > 0 and "+" or "") .. data.zDiff .. ")\n"
            elseif data.reason == "LONGE_MAIS_30SQM" then
                message = message .. "   Problema: Muito longe (" .. data.distance .. " sqm)\n"
            elseif data.reason == "LEVEL_MUITO_ALTO" then
                message = message .. "   Problema: Level muito alto (max: " .. (data.maxLevel or "N/A") .. ")\n"
            elseif data.reason == "LEVEL_MUITO_BAIXO" then
                message = message .. "   Problema: Level muito baixo (sera removido para reconfigurar party)\n"
            elseif data.reason == "LEVEL_FORA_FAIXA" then
                message = message .. "   Problema: Fora da faixa de level (sera removido para reconfigurar party)\n"
            elseif data.reason == "SEM_TARGET_2MIN" then
                message = message .. "   Problema: Sem target ha " .. math.floor(data.noTargetTime) .. " segundos\n"
            end
            
            message = message .. "   Target: " .. (data.hasTarget and data.targetName or "Nenhum") .. "\n\n"
        end
        
        modal:setMessage(message)
        modal:addButton(1, "Fechar")
        modal:addButton(2, "Expulsar Todos")
    end
    
    modal:sendToPlayer(player)
    return false
end

partyCheckCommand:separator(" ")
partyCheckCommand:groupType("normal")
partyCheckCommand:register()

-- !partykick - Kick all problematic players
local partyKickCommand = TalkAction("!partykick")
function partyKickCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local leader = party:getLeader()
    if not isValidPlayer(leader) or leader:getId() ~= player:getId() then
        player:sendCancelMessage("Apenas o lider da party pode usar este comando.")
        return false
    end

    local problematicPlayers = getProblematicPlayers(party)
    
    if #problematicPlayers == 0 then
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Nenhum player problematico encontrado.")
        return false
    end

    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Expulsando " .. #problematicPlayers .. " player(s) problematico(s)...")

    for _, data in ipairs(problematicPlayers) do
        local member = data.player
        local reason = data.reason
        
        local reasonText = reason
        if reason == "LEVEL_MUITO_ALTO" then
            reasonText = "Level muito alto para party"
        elseif reason == "LEVEL_MUITO_BAIXO" then
            reasonText = "Level muito baixo (reconfiguracao da party)"
        elseif reason == "LEVEL_FORA_FAIXA" then
            reasonText = "Fora da faixa de level (reconfiguracao da party)"
        elseif reason == "EIXO_Z_DIFERENTE" then
            reasonText = "Eixo Z diferente do lider"
        elseif reason == "LONGE_MAIS_30SQM" then
            reasonText = "Muito longe do lider"
        elseif reason == "SEM_TARGET_2MIN" then
            reasonText = "Sem target por muito tempo"
        end
        
        if party:removeMember(member) then
            player:sendTextMessage(CONFIG.MESSAGE_STATUS, member:getName() .. " expulso por: " .. reasonText)
            member:sendTextMessage(CONFIG.MESSAGE_STATUS, "Voce foi expulso da party por: " .. reasonText)
            autoKickState.playerTargetHistory[member:getId()] = nil
        else
            player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Falha ao expulsar " .. member:getName())
        end
    end
    
    return false
end

partyKickCommand:separator(" ")
partyKickCommand:groupType("normal")
partyKickCommand:register()

-- !partyplayers - Show party list in modal (leader only, clean display)
local partyPlayersCommand = TalkAction("!partyplayers")
function partyPlayersCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local leader = party:getLeader()
    if not isValidPlayer(leader) or leader:getId() ~= player:getId() then
        player:sendCancelMessage("Apenas o lider da party pode usar este comando.")
        return false
    end

    local stats = getPartyStats(party)
    if not stats then
        player:sendCancelMessage("Erro ao obter estatisticas da party.")
        return false
    end
    
    local modal = ModalWindow(1002, "Lista da Party", "")
    
    local message = string.format("TOTAL DE PLAYERS: %d\n\n", stats.totalPlayers)
    
    message = message .. "VOCACOES:\n"
    message = message .. string.format("Knights: %d\n", stats.vocations.knight)
    message = message .. string.format("Paladins: %d\n", stats.vocations.paladin)
    message = message .. string.format("Sorcerers: %d\n", stats.vocations.sorcerer)
    message = message .. string.format("Druids: %d\n", stats.vocations.druid)
    message = message .. string.format("Monks: %d\n\n", stats.vocations.monk) -- Added Monk count
    
    message = message .. "LISTA DE MEMBROS:\n"
    message = message .. "(Ordenados por level)\n\n"
    
    for i, playerData in ipairs(stats.players) do
        -- Clean display without [LIDER] - all players look the same
        message = message .. string.format("Level %d - %s\n", playerData.level, playerData.name)
    end
    
    modal:setMessage(message)
    modal:addButton(1, "Fechar")
    modal:sendToPlayer(player)
    return false
end

partyPlayersCommand:separator(" ")
partyPlayersCommand:groupType("normal")
partyPlayersCommand:register()

-- !partykickplayer - Kick specific player without checks
local partyKickPlayerCommand = TalkAction("!partykickplayer")
function partyKickPlayerCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local leader = party:getLeader()
    if not isValidPlayer(leader) or leader:getId() ~= player:getId() then
        player:sendCancelMessage("Apenas o lider da party pode usar este comando.")
        return false
    end

    if param == "" then
        player:sendCancelMessage("Uso correto: !partykickplayer NomeDoJogador")
        return false
    end

    local targetName = param:trim()
    local targetPlayer = nil
    
    -- Find the target player in party
    for _, member in ipairs(party:getMembers()) do
        if isValidPlayer(member) and member:getName():lower() == targetName:lower() then
            targetPlayer = member
            break
        end
    end
    
    if not targetPlayer then
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Player '" .. targetName .. "' nao encontrado na party.")
        return false
    end
    
    if targetPlayer:getId() == leader:getId() then
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Voce nao pode expulsar a si mesmo da party.")
        return false
    end
    
    if party:removeMember(targetPlayer) then
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, targetPlayer:getName() .. " foi expulso da party.")
        targetPlayer:sendTextMessage(CONFIG.MESSAGE_STATUS, "Voce foi expulso da party pelo lider.")
        autoKickState.playerTargetHistory[targetPlayer:getId()] = nil
    else
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Falha ao expulsar " .. targetPlayer:getName() .. ".")
    end
    
    return false
end

partyKickPlayerCommand:separator(" ")
partyKickPlayerCommand:groupType("normal")
partyKickPlayerCommand:register()

-- !autokick on/off - Toggle automatic kick system
local autoKickCommand = TalkAction("!autokick")
function autoKickCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local leader = party:getLeader()
    if not isValidPlayer(leader) or leader:getId() ~= player:getId() then
        player:sendCancelMessage("Apenas o lider da party pode controlar o auto kick.")
        return false
    end

    local partyId = leader:getId()
    local action = string.lower(param)
    
    if action == "on" then
        autoKickState.perPartyEnabled[partyId] = true
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Sistema de auto kick ATIVADO para esta party.")
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Verificacao automatica a cada 30 segundos.")
    elseif action == "off" then
        autoKickState.perPartyEnabled[partyId] = false
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Sistema de auto kick DESATIVADO para esta party.")
    else
        player:sendCancelMessage("Uso correto: !autokick on ou !autokick off")
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Status atual: " .. (isAutoKickEnabled(party) and "ATIVADO" or "DESATIVADO"))
    end
    return false
end

autoKickCommand:separator(" ")
autoKickCommand:groupType("normal")
autoKickCommand:register()

-- !partyall - Invite all players on screen
local partyAllCommand = TalkAction("!partyall")
function partyAllCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    
    -- Create party if player doesn't have one
    if not party then
        party = Party(player)
        if not party then
            player:sendCancelMessage("Falha ao criar party.")
            return false
        end
    end

    local playerPos = player:getPosition()
    local inviteCount = 0
    local totalFound = 0
    local alreadyInParty = 0
    local wouldBreakRange = 0
    
    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Procurando players para convidar...")
    
    -- Get all creatures in range (including players)
    local spectators = Game.getSpectators(playerPos, false, false, CONFIG.INVITE_RANGE, CONFIG.INVITE_RANGE, CONFIG.INVITE_RANGE, CONFIG.INVITE_RANGE)
    
    for _, creature in ipairs(spectators) do
        if creature:isPlayer() and creature:getId() ~= player:getId() then
            totalFound = totalFound + 1
            local targetParty = getPlayerParty(creature)
            if not targetParty then
                local isValid, reason = wouldPlayerBeValidForParty(party, creature)
                if isValid then
                    -- Try to invite player using correct function
                    local success = pcall(function()
                        return party:addInvite(creature)
                    end)
                    
                    if success then
                        inviteCount = inviteCount + 1
                        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Convite enviado para: " .. creature:getName())
                    else
                        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Falha ao convidar: " .. creature:getName())
                    end
                else
                    wouldBreakRange = wouldBreakRange + 1
                    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Quebraria faixa de level: " .. creature:getName())
                end
            else
                alreadyInParty = alreadyInParty + 1
            end
        end
    end
    
    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Players encontrados: " .. totalFound)
    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Ja em party: " .. alreadyInParty)
    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Quebraria faixa de level: " .. wouldBreakRange)
    if inviteCount == 0 then
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Nenhum convite foi enviado.")
    else
        player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Total de convites enviados: " .. inviteCount)
    end
    
    return false
end

partyAllCommand:separator(" ")
partyAllCommand:groupType("normal")
partyAllCommand:register()

-- !pt - Request party invite with single clear message
local ptRequestCommand = TalkAction("!pt")
function ptRequestCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if party then
        player:sendCancelMessage("Voce ja esta em uma party.")
        return false
    end

    local playerName = player:getName()
    
    -- Try to automatically invite to nearby parties (only if they have PT enabled)
    local success = autoInviteToNearbyParties(playerName)
    
    -- The function now sends a single clear message, no need for additional messages here
    
    return false
end

ptRequestCommand:separator(" ")
ptRequestCommand:groupType("normal")
ptRequestCommand:register()

-- !partymasskick - Dissolve entire party
local partyMassKickCommand = TalkAction("!partymasskick")
function partyMassKickCommand.onSay(player, words, param)
    local party = getPlayerParty(player)
    if not party then
        player:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local leader = party:getLeader()
    if not isValidPlayer(leader) or leader:getId() ~= player:getId() then
        player:sendCancelMessage("Apenas o lider da party pode dissolver a party.")
        return false
    end

    local members = party:getMembers()
    local memberCount = #members
    
    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Dissolvendo party e removendo " .. memberCount .. " membro(s)...")
    
    -- Remove all members first
    for _, member in ipairs(members) do
        if isValidPlayer(member) then
            party:removeMember(member)
            member:sendTextMessage(CONFIG.MESSAGE_STATUS, "Voce foi removido da party (dissolucao completa).")
            autoKickState.playerTargetHistory[member:getId()] = nil
        end
    end
    
    -- Disband the party
    party:disband()
    player:sendTextMessage(CONFIG.MESSAGE_STATUS, "Party dissolvida completamente.")
    
    return false
end

partyMassKickCommand:separator(" ")
partyMassKickCommand:groupType("normal")
partyMassKickCommand:register()

--[[ Party EventCallbacks ]]--

-- Party:onShareExperience - Register party and apply Aurera Global XP system
function Party:onShareExperience(exp)
    registerParty(self)
    
    local leader = self:getLeader()
    if not isValidPlayer(leader) then
        return exp
    end
    
    local partyId = leader:getId()
    autoKickState.lastSharedExpStatus[partyId] = true
    autoKickState.sharedExpBreakTime[partyId] = nil

    -- Apply Aurera Global XP System if enabled
    if AURERA_XP_CONFIG.ENABLED then
        local uniqueVocationsCount = self:getUniqueVocationsCount()
        local partySize = self:getMemberCount() + 1
        
        -- Get vocation bonus
        local vocationBonus = AURERA_XP_CONFIG.VOCATION_BONUS[uniqueVocationsCount] or 0
        
        -- Check if all players are level 251+ for full bonus
        local allPlayersHighLevel = true
        local members = self:getMembers()
        table.insert(members, leader)
        
        local playerLevels = {}
        for _, member in ipairs(members) do
            if isValidPlayer(member) then
                local level = member:getLevel()
                table.insert(playerLevels, level)
                if level < AURERA_XP_CONFIG.MIN_LEVEL_FOR_FULL_BONUS then
                    allPlayersHighLevel = false
                end
            end
        end
        
        local totalMultiplier = 1.0 + vocationBonus
        local sizeBonus = 0
        
        -- Apply party size bonus only if all players are 251+
        if allPlayersHighLevel then
            sizeBonus = AURERA_XP_CONFIG.PARTY_SIZE_BONUS[partySize] or 0
            totalMultiplier = totalMultiplier + sizeBonus
        end
        
        local finalExp = math.ceil((exp * totalMultiplier) / partySize)
        
        -- DEBUG SYSTEM
        if AURERA_XP_CONFIG.DEBUG_ENABLED then
            local debugMsg = string.format(
                "[AURERA XP DEBUG] Original: %d | Vocations: %d (%.0f%%) | Size: %d (%.0f%%) | All 251+: %s | Total Mult: %.2fx | Final: %d each",
                exp,
                uniqueVocationsCount, vocationBonus * 100,
                partySize, sizeBonus * 100,
                allPlayersHighLevel and "YES" or "NO",
                totalMultiplier,
                finalExp
            )
            
            local levelsMsg = "Levels: " .. table.concat(playerLevels, ", ")
            
            -- Debug to console
            if AURERA_XP_CONFIG.DEBUG_TO_CONSOLE then
                print(debugMsg)
                print(levelsMsg)
            end
            
            -- Debug to players
            if AURERA_XP_CONFIG.DEBUG_TO_PLAYERS then
                for _, member in ipairs(members) do
                    if isValidPlayer(member) then
                        member:sendTextMessage(CONFIG.MESSAGE_STATUS, debugMsg)
                        member:sendTextMessage(CONFIG.MESSAGE_STATUS, levelsMsg)
                    end
                end
            end
        end
        
        return finalExp
    else
        -- Fallback to original system
        local uniqueVocationsCount = self:getUniqueVocationsCount()
        local partySize = self:getMemberCount() + 1

        local sharedExperienceMultiplier = ((0.1 * (uniqueVocationsCount ^ 2)) - (0.2 * uniqueVocationsCount) + 1.3)
        sharedExperienceMultiplier = partySize < 4 and sharedExperienceMultiplier or sharedExperienceMultiplier - 0.1

        return math.ceil((exp * sharedExperienceMultiplier) / partySize)
    end
end

-- Party:onJoin - Initialize player history
function Party:onJoin(player)
    registerParty(self)
    if isValidPlayer(player) then
        local playerId = player:getId()
        autoKickState.playerTargetHistory[playerId] = {
            lastTargetTime = getCurrentTime(),
            noTargetStartTime = nil
        }
    end
    return true
end

-- Party:onLeave - Clear player history
function Party:onLeave(player)
    if player then
        autoKickState.playerTargetHistory[player:getId()] = nil
    end
    
    if self:getMemberCount() == 0 then
        unregisterParty(self)
    end
    return true
end

-- Party:onDisband - Clear all player histories
function Party:onDisband()
    local members = self:getMembers()
    local leader = self:getLeader()
    if leader then
        table.insert(members, leader)
    end
    
    for _, member in ipairs(members) do
        if member then
            autoKickState.playerTargetHistory[member:getId()] = nil
        end
    end
    unregisterParty(self)
    return true
end

-- Modal Window Handler
function onModalWindowAnswer(player, modalWindowId, buttonId, choiceId)
    if modalWindowId == 1001 then -- partycheck modal
        if buttonId == 2 then -- "Expulsar Todos" button
            -- Execute partykick logic
            local party = getPlayerParty(player)
            if party then
                local leader = party:getLeader()
                if isValidPlayer(leader) and leader:getId() == player:getId() then
                    local problematicPlayers = getProblematicPlayers(party)
                    
                    for _, data in ipairs(problematicPlayers) do
                        local member = data.player
                        local reason = data.reason
                        
                        local reasonText = reason
                        if reason == "LEVEL_MUITO_ALTO" then
                            reasonText = "Level muito alto para party"
                        elseif reason == "LEVEL_MUITO_BAIXO" then
                            reasonText = "Level muito baixo (reconfiguracao da party)"
                        elseif reason == "LEVEL_FORA_FAIXA" then
                            reasonText = "Fora da faixa de level (reconfiguracao da party)"
                        elseif reason == "EIXO_Z_DIFERENTE" then
                            reasonText = "Eixo Z diferente do lider"
                        elseif reason == "LONGE_MAIS_30SQM" then
                            reasonText = "Muito longe do lider"
                        elseif reason == "SEM_TARGET_2MIN" then
                            reasonText = "Sem target por muito tempo"
                        end
                        
                        if party:removeMember(member) then
                            player:sendTextMessage(CONFIG.MESSAGE_STATUS, member:getName() .. " expulso por: " .. reasonText)
                            member:sendTextMessage(CONFIG.MESSAGE_STATUS, "Voce foi expulso da party por: " .. reasonText)
                            autoKickState.playerTargetHistory[member:getId()] = nil
                        end
                    end
                end
            end
        end
    end
    return true
end

-- Automatic Kick System Timer (every 30 seconds)
local function checkAndKickProblematicPlayers()
    local partiesToCheck = {}
    for partyId, party in pairs(autoKickState.allParties) do
        if party then
            partiesToCheck[partyId] = party
        end
    end
    
    for partyId, party in pairs(partiesToCheck) do
        if party and isAutoKickEnabled(party) then
            local leader = party:getLeader()
            if isValidPlayer(leader) then
                local problematicPlayers = getProblematicPlayers(party)
                
                if #problematicPlayers > 0 then
                    leader:sendTextMessage(CONFIG.MESSAGE_STATUS, "Auto Kick: " .. #problematicPlayers .. " player(s) problematico(s) detectado(s)!")
                    
                    for _, data in ipairs(problematicPlayers) do
                        local member = data.player
                        local reason = data.reason
                        
                        local reasonText = reason
                        if reason == "LEVEL_MUITO_ALTO" then
                            reasonText = "Level muito alto para party"
                        elseif reason == "LEVEL_MUITO_BAIXO" then
                            reasonText = "Level muito baixo (reconfiguracao da party)"
                        elseif reason == "LEVEL_FORA_FAIXA" then
                            reasonText = "Fora da faixa de level (reconfiguracao da party)"
                        elseif reason == "EIXO_Z_DIFERENTE" then
                            reasonText = "Eixo Z diferente do lider"
                        elseif reason == "LONGE_MAIS_30SQM" then
                            reasonText = "Muito longe do lider"
                        elseif reason == "SEM_TARGET_2MIN" then
                            reasonText = "Sem target por muito tempo"
                        end
                        
                        if party:removeMember(member) then
                            leader:sendTextMessage(CONFIG.MESSAGE_STATUS, "Auto Kick: " .. member:getName() .. " expulso por " .. reasonText)
                            member:sendTextMessage(CONFIG.MESSAGE_STATUS, "Voce foi expulso da party automaticamente por: " .. reasonText)
                            autoKickState.playerTargetHistory[member:getId()] = nil
                        end
                    end
                end
            else
                autoKickState.allParties[partyId] = nil
            end
        end
    end
    
    addEvent(checkAndKickProblematicPlayers, CONFIG.CHECK_INTERVAL_SECONDS * 1000)
end

-- Start the automatic check timer on script load
addEvent(checkAndKickProblematicPlayers, CONFIG.CHECK_INTERVAL_SECONDS * 1000)

