local activeNpcRefs = {}

local npcSpawns = {
    {
        name = "Ghostly Wolf",
        spawnPeriod = LIGHT_STATE_SUNSET,
        despawnPeriod = LIGHT_STATE_SUNRISE,
        position = Position(33332, 32052, 7),
    },
    {
        name = "Talila",
        spawnPeriod = LIGHT_STATE_SUNSET,
        despawnPeriod = LIGHT_STATE_SUNRISE,
        position = Position(33504, 32222, 7),
    },
    {
        name = "Valindara",
        spawnPeriod = LIGHT_STATE_SUNRISE,
        despawnPeriod = LIGHT_STATE_SUNSET,
        position = Position(33504, 32222, 7),
    },
}

function getTibiaTimerDayOrNight()
    local min = tonumber(os.date("%M"))
    if min >= 45 or min < 15 then
        return "night"
    else
        return "day"
    end
end

local function npcExistsOnMap(name)
    local creature = Creature(name)
    return creature and creature:isNpc()
end

local function tryCreateNpc(entry, attempt)
    attempt = attempt or 1
    if npcExistsOnMap(entry.data.name) then
        return
    end
    local tile = Tile(entry.data.position)
    if tile then
        for _, thing in ipairs(tile:getCreatures() or {}) do
            if thing:isNpc() and thing:getName() == entry.data.name then
                thing:remove()
            end
        end
    end
    local npc = Game.createNpc(entry.data.name, entry.data.position)
    if npc then
        npc:setMasterPos(entry.data.position)
        npc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        activeNpcRefs[entry.index] = npc:getId()
    else
        if attempt < 3 then
            addEvent(function()
                tryCreateNpc(entry, attempt + 1)
            end, 60000)
        end
    end
end

local function spawnNpcListWithCooldown(npcsToAdd, index)
    index = index or 1
    if index > #npcsToAdd then return end
    local entry = npcsToAdd[index]
    tryCreateNpc(entry)
    addEvent(function()
        spawnNpcListWithCooldown(npcsToAdd, index + 1)
    end, 2000)
end

local function onPeriodChange(period)
    local npcsToRemove = {}
    local npcsToAdd = {}
    for i, npcData in ipairs(npcSpawns) do
        if npcData.despawnPeriod == period and activeNpcRefs[i] then
            table.insert(npcsToRemove, {
                index = i,
                data = npcData,
            })
        elseif npcData.spawnPeriod == period and not activeNpcRefs[i] then
            table.insert(npcsToAdd, {
                index = i,
                data = npcData,
            })
        end
    end
    for _, entry in ipairs(npcsToRemove) do
        local npc = Creature(activeNpcRefs[entry.index])
        if npc and npc:isNpc() then
            npc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            npc:remove()
        end
        activeNpcRefs[entry.index] = nil
        local tile = Tile(entry.data.position)
        if tile then
            for _, thing in ipairs(tile:getCreatures() or {}) do
                if thing:isNpc() and thing:getName() == entry.data.name then
                    thing:remove()
                end
            end
        end
    end
    if #npcsToAdd > 0 then
        addEvent(function()
            spawnNpcListWithCooldown(npcsToAdd, 1)
        end, 100000)
    end
    return true
end

local lastTibiaPeriod = nil

local npcCycleChecker = GlobalEvent("NpcByTimeCycleChecker")
function npcCycleChecker.onThink()
    local mode = getTibiaTimerDayOrNight()
    local currentPeriod = (mode == "night") and LIGHT_STATE_SUNSET or LIGHT_STATE_SUNRISE
    if lastTibiaPeriod ~= currentPeriod then
        onPeriodChange(currentPeriod)
        lastTibiaPeriod = currentPeriod
    end
    return true
end
npcCycleChecker:interval(60 * 1000)
npcCycleChecker:register()

local spawnsNpcBySpawn = GlobalEvent("SpawnsNpcBySpawn")
function spawnsNpcBySpawn.onStartup()
    local mode = getTibiaTimerDayOrNight()
    local currentPeriod = (mode == "night") and LIGHT_STATE_SUNSET or LIGHT_STATE_SUNRISE
    lastTibiaPeriod = currentPeriod
    for i, npcData in ipairs(npcSpawns) do
        local npc = Creature(activeNpcRefs[i])
        if npc and npc:isNpc() then
            npc:remove()
            activeNpcRefs[i] = nil
        end
        local tile = Tile(npcData.position)
        if tile then
            for _, thing in ipairs(tile:getCreatures() or {}) do
                if thing:isNpc() and thing:getName() == npcData.name then
                    thing:remove()
                end
            end
        end
    end
    local npcsToAdd = {}
    for i, npcData in ipairs(npcSpawns) do
        if npcData.spawnPeriod == currentPeriod then
            table.insert(npcsToAdd, {
                index = i,
                data = npcData,
            })
        end
    end
    if #npcsToAdd > 0 then
        addEvent(function()
            spawnNpcListWithCooldown(npcsToAdd, 1)
        end, 5000)
    end
    return true
end
spawnsNpcBySpawn:register()
