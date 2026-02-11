-- Sistema de Raids Aleatorias Avancado (DEBUG: ativa raids mesmo em cooldown, mas impede boss duplo unicos)

local RAID_DEBUG_MODE = false -- true ativa 1 raid por ciclo, ignorando limites, false segue configuracao normal

local RARIDADE = {
    COMUM = 1,
    INCOMUM = 2,
    RARO = 3,
    MUITO_RARO = 4,
    LENDARIO = 5,
    SAZONAL = 6
}

local CHANCE_POR_RARIDADE = {
    [RARIDADE.COMUM] = 35,
    [RARIDADE.INCOMUM] = 20,
    [RARIDADE.RARO] = 10,
    [RARIDADE.MUITO_RARO] = 5,
    [RARIDADE.LENDARIO] = 2
}

local LIMITE_POR_RARIDADE = {
    [RARIDADE.COMUM] = "diario",
    [RARIDADE.INCOMUM] = "diario",
    [RARIDADE.RARO] = "semanal",
    [RARIDADE.MUITO_RARO] = "semanal",
    [RARIDADE.LENDARIO] = "mensal",
    [RARIDADE.SAZONAL] = "sazonal"
}

local RAIDS_PROGRAMADAS = {
    "Water Buffalo",
    "WildHorses"
}

local HORARIOS_PROGRAMADOS = {1, 7, 13, 19}
local SERVER_SAVE_HOUR = 6
local MES_ATUAL = tonumber(os.date("%m"))

local raidsConfig = {
    [RARIDADE.COMUM] = {
        "Zevelon Duskbringer", "Badger", "WarWolf", "WaspBear", "Dragons", "Bonebeast",
        "Cobra", "Gargoyle", "Nomad", "Scarab", "Terramite",
        "OrcWoods", "Lions", "Minos", "Pirates", "Priestesses",
        "Undead Darashia", "GoEdron", "Orcss", "Warlock", "Beetles",
        "Gnarlhounds", "GoFemor", "Quaras", "Tigers", "Tortoise",
        "Lizards", "Sspawn", "Terror",
        "BarbaBitter", "BarbaSvar", "Barbarian", "IceGolems",
        "Cyclops", "OrcsThais", "Elves", "Hunters", "Orc Backpack",
        "Undead Army", "RatsThais"
    },
    [RARIDADE.INCOMUM] = {
        "Citizen", "Kongras"
    },
    [RARIDADE.RARO] = {
        "Dharalion", "Necropharus", "Mad Mage", "Chayenne", "Feroxa",
        "Zulazza the Corruptor", "Ocyakao", "Horned Fox", "Fernfang"
    },
    [RARIDADE.MUITO_RARO] = {
        "Zushuka", "Orshabaal", "The Abomination"
    },
    [RARIDADE.LENDARIO] = {
        "Morshabaal", "Ferumbras", "Morgaroth", "Gaz", "Omrafir", "Ghazbaran"
    },
    [RARIDADE.SAZONAL] = {
        inverno = {"IceGolems", "Ocyakao", "Zushuka"},
        verao = {"Pirates", "Priestesses"},
        outono = {"Elves", "Gaz", "Undead Army"},
        primavera = {"WaspBear", "Badger", "Chayenne"}
    }
}

local function getEstacaoAtual()
    if MES_ATUAL >= 12 or MES_ATUAL <= 2 then
        return "inverno"
    elseif MES_ATUAL >= 3 and MES_ATUAL <= 5 then
        return "primavera"
    elseif MES_ATUAL >= 6 and MES_ATUAL <= 8 then
        return "verao"
    else
        return "outono"
    end
end

local function isHighActivityTime()
    local hora = tonumber(os.date("%H"))
    return (hora >= 18 and hora < 24) or (hora >= 0 and hora < 3)
end

local function getAppropriateInterval()
    if isHighActivityTime() then
        return 2 * 60 * 60 * 1000
    else
        return 5 * 60 * 60 * 1000
    end
end

local STORAGE_BASE = {
    DIARIO = 30000,
    SEMANAL = 31000,
    MENSAL = 32000
}

local function raidExecutedInPeriod(raidName, raridade)
    local limite = LIMITE_POR_RARIDADE[raridade]
    local raidId, lastExecution, periodoAtual
    local uniqueId = (string.byte(raidName, 1) * 100) + string.len(raidName)
    if limite == "diario" then
        raidId = STORAGE_BASE.DIARIO + uniqueId
        lastExecution = Game.getStorageValue(raidId)
        periodoAtual = os.date("%Y-%m-%d")
    elseif limite == "semanal" then
        raidId = STORAGE_BASE.SEMANAL + uniqueId
        lastExecution = Game.getStorageValue(raidId)
        periodoAtual = os.date("%Y") .. "-" .. os.date("%W")
    elseif limite == "mensal" then
        raidId = STORAGE_BASE.MENSAL + uniqueId
        lastExecution = Game.getStorageValue(raidId)
        periodoAtual = os.date("%Y-%m")
    elseif limite == "sazonal" then
        local estacao = getEstacaoAtual()
        local raidsDaEstacao = raidsConfig[RARIDADE.SAZONAL][estacao]
        if raidsDaEstacao then
            local encontrado = false
            for _, r in ipairs(raidsDaEstacao) do
                if r == raidName then
                    encontrado = true
                    break
                end
            end
            if not encontrado then
                return true
            end
        end
        raidId = STORAGE_BASE.DIARIO + uniqueId
        lastExecution = Game.getStorageValue(raidId)
        periodoAtual = os.date("%Y-%m-%d")
    else
        return false
    end
    if lastExecution == -1 then
        return false
    end
    return lastExecution == periodoAtual
end

local function markRaidAsExecuted(raidName, raridade)
    local limite = LIMITE_POR_RARIDADE[raridade]
    local raidId, periodoAtual
    local uniqueId = (string.byte(raidName, 1) * 100) + string.len(raidName)
    if limite == "diario" or limite == "sazonal" then
        raidId = STORAGE_BASE.DIARIO + uniqueId
        periodoAtual = os.date("%Y-%m-%d")
    elseif limite == "semanal" then
        raidId = STORAGE_BASE.SEMANAL + uniqueId
        periodoAtual = os.date("%Y") .. "-" .. os.date("%W")
    elseif limite == "mensal" then
        raidId = STORAGE_BASE.MENSAL + uniqueId
        periodoAtual = os.date("%Y-%m")
    else
        return
    end
    Game.setStorageValue(raidId, periodoAtual)
end

local function resetStoragesForRaid(raidName)
    local uniqueId = (string.byte(raidName, 1) * 100) + string.len(raidName)
    Game.setStorageValue(STORAGE_BASE.DIARIO + uniqueId, -1)
    Game.setStorageValue(STORAGE_BASE.SEMANAL + uniqueId, -1)
    Game.setStorageValue(STORAGE_BASE.MENSAL + uniqueId, -1)
end

local function getBossNameForRaid(raidName)
    local bossMap = {
        ["The Abomination"] = "The Abomination",
        ["Ferumbras"] = "Ferumbras",
        ["Morgaroth"] = "Morgaroth",
        ["Orshabaal"] = "Orshabaal",
        ["Morshabaal"] = "Morshabaal",
        ["Gaz"] = "Gaz'Haragoth",
        ["Ghazbaran"] = "Ghazbaran",
    }
    return bossMap[raidName] or raidName
end

local function isBossActive(bossName)
    local creature = Creature(bossName)
    return creature and creature:isMonster()
end


-- Apenas bosses unicos (raros, muito raros, lendarios)
local uniqueBossRaids = {}
for _, raidName in ipairs(raidsConfig[RARIDADE.RARO]) do uniqueBossRaids[raidName] = true end
for _, raidName in ipairs(raidsConfig[RARIDADE.MUITO_RARO]) do uniqueBossRaids[raidName] = true end
for _, raidName in ipairs(raidsConfig[RARIDADE.LENDARIO]) do uniqueBossRaids[raidName] = true end

local function sendPreAnnouncement(raidName, raridade, delayMinutes)
    if raridade >= RARIDADE.RARO then
        local messageType = MESSAGE_STATUS_WARNING
        local mensagem = ""
        if raridade == RARIDADE.RARO then
            mensagem = "Rumores indicam que " .. raidName .. " vai aparecer em breve!"
        elseif raridade == RARIDADE.MUITO_RARO then
            mensagem = "Aviso: " .. raidName .. " esta se preparando para atacar em breve!"
        elseif raridade == RARIDADE.LENDARIO then
            mensagem = "ALERTA MAXIMO! O lendario " .. raidName .. " esta prestes a surgir! Prepare-se!"
            Game.broadcastMessage("O chao treme com a aproximacao de uma forca poderosa...", MESSAGE_EVENT_ADVANCE)
        end
        if raridade == RARIDADE.LENDARIO then
            Game.broadcastMessage(mensagem, messageType)
            addEvent(function()
                Game.broadcastMessage("O poder de " .. raidName .. " esta cada vez mais proximo! Faltam apenas " .. math.floor(delayMinutes/2) .. " minutos!", messageType)
            end, delayMinutes * 60 * 1000 / 2)
        else
            Game.broadcastMessage(mensagem, messageType)
        end
    end
end

local function checkScheduledRaids()
    local horaAtual = tonumber(os.date("%H"))
    local minutoAtual = tonumber(os.date("%M"))
    if minutoAtual > 5 then return false end
    local horasDesdeServerSave = (horaAtual - SERVER_SAVE_HOUR)
    if horasDesdeServerSave < 0 then
        horasDesdeServerSave = horasDesdeServerSave + 24
    end
    local horaCorrespondeAgendamento = false
    for _, offset in ipairs(HORARIOS_PROGRAMADOS) do
        local horaProgramada = (SERVER_SAVE_HOUR + offset) % 24
        if horaAtual == horaProgramada then
            horaCorrespondeAgendamento = true
            break
        end
    end
    if horaCorrespondeAgendamento then
        local raidIndex = math.random(1, #RAIDS_PROGRAMADAS)
        local raidName = RAIDS_PROGRAMADAS[raidIndex]
        Game.startRaid(raidName)
        Game.broadcastMessage("Uma manada foi avistada! " .. raidName .. " apareceu!", MESSAGE_STATUS_WARNING)
        return true
    end
    return false
end

local function executeRandomRaid()
    if math.random(1, 100) <= 5 then
        local estacao = getEstacaoAtual()
        local raidsSazonais = raidsConfig[RARIDADE.SAZONAL][estacao]
        if raidsSazonais and #raidsSazonais > 0 then
            local randomIndex = math.random(1, #raidsSazonais)
            local selectedRaid = raidsSazonais[randomIndex]
            if not raidExecutedInPeriod(selectedRaid, RARIDADE.SAZONAL) then
                sendPreAnnouncement(selectedRaid, RARIDADE.RARO, 10)
                addEvent(function()
                    Game.startRaid(selectedRaid)
                    markRaidAsExecuted(selectedRaid, RARIDADE.SAZONAL)
                    Game.broadcastMessage("Raid sazonal ativada! Prepare-se para " .. selectedRaid .. "!", MESSAGE_STATUS_WARNING)
                end, 10 * 60 * 1000)
                return true
            end
        end
    end
    for raridade, chance in pairs(CHANCE_POR_RARIDADE) do
        local randomValue = math.random(1, 1000)
        local chanceValue = chance * 10
        if randomValue <= chanceValue then
            local raidList = raidsConfig[raridade]
            if raidList and #raidList > 0 then
                local randomIndex = math.random(1, #raidList)
                local selectedRaid = raidList[randomIndex]
                if not raidExecutedInPeriod(selectedRaid, raridade) then
                    local delayMinutes = 0
                    if raridade >= RARIDADE.RARO then
                        if raridade == RARIDADE.RARO then
                            delayMinutes = 5
                        elseif raridade == RARIDADE.MUITO_RARO then
                            delayMinutes = 15
                        elseif raridade == RARIDADE.LENDARIO then
                            delayMinutes = 30
                        end
                        sendPreAnnouncement(selectedRaid, raridade, delayMinutes)
                    end
                    addEvent(function()
                        Game.startRaid(selectedRaid)
                        markRaidAsExecuted(selectedRaid, raridade)
                        Game.broadcastMessage("Raid aleatoria ativada! Prepare-se para " .. selectedRaid .. "!", MESSAGE_STATUS_WARNING)
                    end, delayMinutes * 60 * 1000)
                    return true
                end
            end
        end
    end
    return false
end

local function getAllUniqueRaids()
    local allRaids, added = {}, {}
    for _, raidName in ipairs(RAIDS_PROGRAMADAS) do
        if not added[raidName] then
            table.insert(allRaids, raidName)
            added[raidName] = true
        end
    end
    for raridade, lista in pairs(raidsConfig) do
        if type(lista) == "table" then
            if raridade == RARIDADE.SAZONAL then
                for _, raidsEstacao in pairs(lista) do
                    for _, raidName in ipairs(raidsEstacao) do
                        if not added[raidName] then
                            table.insert(allRaids, raidName)
                            added[raidName] = true
                        end
                    end
                end
            else
                for _, raidName in ipairs(lista) do
                    if not added[raidName] then
                        table.insert(allRaids, raidName)
                        added[raidName] = true
                    end
                end
            end
        end
    end
    return allRaids
end

local allDebugRaids = getAllUniqueRaids()
local currentDebugRaid = 1

local function activateNextRaidDebug()
    if currentDebugRaid > #allDebugRaids then
        print("[RandomRaidSystem] DEBUG: Todas as raids da lista ja foram ativadas. Reiniciando lista.")
        currentDebugRaid = 1
    end
    local raidName = allDebugRaids[currentDebugRaid]
    local bossName = getBossNameForRaid(raidName)
    if (not uniqueBossRaids[raidName]) or (not isBossActive(bossName)) then
        resetStoragesForRaid(raidName)
        local result = Game.startRaid(raidName)
        if result == RETURNVALUE_NOERROR then
            print("[RandomRaidSystem] DEBUG: Raid '" .. raidName .. "' ativada com sucesso.")
            Game.broadcastMessage("[RandomRaidSystem] DEBUG: Raid '" .. raidName .. "' ativada com sucesso.", MESSAGE_EVENT_ADVANCE)
        else
            print("[RandomRaidSystem] DEBUG: Falha ao ativar raid '" .. raidName .. "' (".. tostring(result) .. ")")
        end
    else
        print("[RandomRaidSystem] DEBUG: Raid '" .. raidName .. "' NAO ativada pois ja existe boss unico ativo no mapa.")
    end
    currentDebugRaid = currentDebugRaid + 1
end

local g_raidEvent = GlobalEvent("RandomRaidEvent")

function g_raidEvent.onTime()
    if RAID_DEBUG_MODE then
        activateNextRaidDebug()
        return true
    end
    if checkScheduledRaids() then
        return true
    end
    executeRandomRaid()
    local newInterval = getAppropriateInterval()
    g_raidEvent:interval(newInterval)
    return true
end

if RAID_DEBUG_MODE then
    g_raidEvent:interval(60 * 1000)
else
    g_raidEvent:interval(getAppropriateInterval())
end
g_raidEvent:register()

print("[RandomRaidSystem] Sistema de raids aleatorias iniciado com sucesso.")
logger.info("[RandomRaidSystem] Sistema de raids aleatorias iniciado com sucesso.")
