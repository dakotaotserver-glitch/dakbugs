-- Burster - Spawn aleatório diário + modo DEBUG

local bursterConfig = {
    name = "Burster",
    position = Position(32450, 32417, 10),

    storageDayChecked = 962100,
    storageHasSpawnedToday = 962101,
    storageDespawnTime = 962102,
    storageRandomHour = 962103,

    debugMode = false,
    debugDayDuration = 10 * 60, -- 10 minutos = 1 dia
    debugSpawnCheckInterval = 60, -- a cada 1 min checa
    debugDespawnAfter = 60, -- desaparece após 60s

    chancePercent = 30,
    despawnAfter = 2 * 60 * 60 -- 2h
}

local function isBursterAlive()
    local tile = Tile(bursterConfig.position)
    if not tile then return false end
    for _, creature in ipairs(tile:getCreatures() or {}) do
        if creature:isMonster() and creature:getName():lower() == bursterConfig.name:lower() then
            return true
        end
    end
    return false
end

local function spawnBurster()
    if isBursterAlive() then return false end
    local m = Game.createMonster(bursterConfig.name, bursterConfig.position)
    if m then
        bursterConfig.position:sendMagicEffect(CONST_ME_TELEPORT)
        -- print("[BursterDebug] Burster spawnado!")
        return true
    end
    return false
end

local function removeBurster()
    local tile = Tile(bursterConfig.position)
    if not tile then return end
    for _, creature in ipairs(tile:getCreatures() or {}) do
        if creature:isMonster() and creature:getName():lower() == bursterConfig.name:lower() then
            creature:remove()
        end
    end
    bursterConfig.position:sendMagicEffect(CONST_ME_POFF)
end

local function getCurrentDebugDay()
    local now = os.time()
    return math.floor(now / bursterConfig.debugDayDuration)
end

local function checkBurster()
    local now = os.time()

    if bursterConfig.debugMode then
        local currentDebugDay = getCurrentDebugDay()
        local lastDayChecked = getGlobalStorageValue(bursterConfig.storageDayChecked)
        local hasSpawned = getGlobalStorageValue(bursterConfig.storageHasSpawnedToday)
        local despawnAt = getGlobalStorageValue(bursterConfig.storageDespawnTime)

        if isBursterAlive() and despawnAt ~= -1 and now >= despawnAt then
            removeBurster()
            setGlobalStorageValue(bursterConfig.storageDespawnTime, -1)
            setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, currentDebugDay)
            return
        end

        if lastDayChecked ~= currentDebugDay then
            setGlobalStorageValue(bursterConfig.storageDayChecked, currentDebugDay)
            setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, -1)
            setGlobalStorageValue(bursterConfig.storageDespawnTime, -1)
        end

        if hasSpawned == currentDebugDay then return end

        if math.random(1, 100) <= bursterConfig.chancePercent then
            if spawnBurster() then
                setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, currentDebugDay)
                setGlobalStorageValue(bursterConfig.storageDespawnTime, now + bursterConfig.debugDespawnAfter)
            end
        else
            setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, currentDebugDay)
        end
        return
    end

    -- MODO NORMAL (tempo real)
    local currentDay = os.date("*t").yday
    local lastChecked = getGlobalStorageValue(bursterConfig.storageDayChecked)
    local hasSpawned = getGlobalStorageValue(bursterConfig.storageHasSpawnedToday)
    local despawnAt = getGlobalStorageValue(bursterConfig.storageDespawnTime)
    local randomHour = getGlobalStorageValue(bursterConfig.storageRandomHour)

    if lastChecked ~= currentDay then
        setGlobalStorageValue(bursterConfig.storageDayChecked, currentDay)
        setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, -1)
        setGlobalStorageValue(bursterConfig.storageDespawnTime, -1)
        randomHour = math.random(1, 23)
        setGlobalStorageValue(bursterConfig.storageRandomHour, randomHour)
        -- print("[Burster] Novo dia iniciado. Spawn configurado para " .. randomHour .. ":00h.")
    end

    if hasSpawned == currentDay then return end

    local currentHour = os.date("*t").hour
    if currentHour >= randomHour then
        if spawnBurster() then
            setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, currentDay)
            setGlobalStorageValue(bursterConfig.storageDespawnTime, now + bursterConfig.despawnAfter)
        else
            setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, currentDay)
        end
    end

    if isBursterAlive() and despawnAt ~= -1 and now >= despawnAt then
        removeBurster()
        setGlobalStorageValue(bursterConfig.storageDespawnTime, -1)
        setGlobalStorageValue(bursterConfig.storageHasSpawnedToday, currentDay)
    end
end

local function scheduleBursterLoop()
    local function loop()
        checkBurster()
        addEvent(loop, bursterConfig.debugSpawnCheckInterval * 1000)
    end
    loop()
end

local event = GlobalEvent("BursterDailyCycle")
function event.onStartup()
    math.randomseed(os.time())
    scheduleBursterLoop()
    return true
end
event:register()
