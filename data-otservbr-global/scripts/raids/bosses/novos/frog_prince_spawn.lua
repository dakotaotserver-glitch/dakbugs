
-- The Frog Prince - Modo DEBUG com ciclo de 10 minutos simulando 1 dia

local frogConfig = {
    name = "The Frog Prince",
    position = Position(32382, 32129, 7),

    extraFrogs = {
        Position(32380, 32128, 7),
        Position(32383, 32127, 7),
        Position(32385, 32131, 7),
        Position(32382, 32131, 7)
    },

    storageDayChecked = 960100,
    storageHasSpawnedToday = 960101,
    storageDespawnTime = 960102,
    storageRandomHour = 960103,

    debugMode = false,
    debugDayDuration = 10 * 60, -- 10 minutos simulando 1 dia
    debugSpawnCheckInterval = 60, -- a cada 1 minuto faz uma tentativa
    debugDespawnAfter = 60, -- boss desaparece em 60s

    chancePercent = 30,
    despawnAfter = 2 * 60 * 60
}

local function isFrogAlive()
    local tile = Tile(frogConfig.position)
    if not tile then return false end
    for _, creature in ipairs(tile:getCreatures() or {}) do
        if creature:isMonster() and creature:getName():lower() == frogConfig.name:lower() then
            return true
        end
    end
    return false
end

local function spawnExtraFrogs()
    for _, pos in ipairs(frogConfig.extraFrogs) do
        if not Tile(pos):getCreatures() or #Tile(pos):getCreatures() == 0 then
            Game.createMonster("Green Frog", pos)
            pos:sendMagicEffect(CONST_ME_TELEPORT)
        end
    end
end

local function spawnFrog()
    if isFrogAlive() then return false end
    local m = Game.createMonster(frogConfig.name, frogConfig.position)
    if m then
        frogConfig.position:sendMagicEffect(CONST_ME_TELEPORT)
        spawnExtraFrogs()
        return true
    end
    return false
end

local function removeFrog()
    local tile = Tile(frogConfig.position)
    if not tile then return end
    for _, creature in ipairs(tile:getCreatures() or {}) do
        if creature:isMonster() and creature:getName():lower() == frogConfig.name:lower() then
            creature:remove()
        end
    end
    Position(32382, 32129, 7):sendMagicEffect(CONST_ME_POFF)
end

-- usado apenas no modo debug
local function getCurrentDebugDay()
    local now = os.time()
    return math.floor(now / frogConfig.debugDayDuration)
end

local function checkFrogPrince()
    local now = os.time()

    if frogConfig.debugMode then
        local currentDebugDay = getCurrentDebugDay()
        local lastDayChecked = getGlobalStorageValue(frogConfig.storageDayChecked)
        local hasSpawned = getGlobalStorageValue(frogConfig.storageHasSpawnedToday)
        local despawnAt = getGlobalStorageValue(frogConfig.storageDespawnTime)

        -- Despawn automático
        if isFrogAlive() and despawnAt ~= -1 and now >= despawnAt then
            removeFrog()
            setGlobalStorageValue(frogConfig.storageDespawnTime, -1)
            setGlobalStorageValue(frogConfig.storageHasSpawnedToday, currentDebugDay)
            return
        end

        -- Novo "dia"
        if lastDayChecked ~= currentDebugDay then
            setGlobalStorageValue(frogConfig.storageDayChecked, currentDebugDay)
            setGlobalStorageValue(frogConfig.storageHasSpawnedToday, -1)
            setGlobalStorageValue(frogConfig.storageDespawnTime, -1)
        end

        if hasSpawned == currentDebugDay then return end

        -- Tentativa de spawn
        if math.random(1, 100) <= frogConfig.chancePercent then
            if spawnFrog() then
                setGlobalStorageValue(frogConfig.storageHasSpawnedToday, currentDebugDay)
                setGlobalStorageValue(frogConfig.storageDespawnTime, now + frogConfig.debugDespawnAfter)
            end
        else
            setGlobalStorageValue(frogConfig.storageHasSpawnedToday, currentDebugDay)
        end
        return
    end

    -- MODO NORMAL aqui...
end

local function scheduleFrogLoop()
    local function loop()
        checkFrogPrince()
        addEvent(loop, frogConfig.debugSpawnCheckInterval * 1000)
    end
    loop()
end

local frogEvent = GlobalEvent("FrogPrinceDebugDayCycle")
function frogEvent.onStartup()
    math.randomseed(os.time())
    scheduleFrogLoop()
    return true
end
frogEvent:register()

-- Morte
local deathFrog = CreatureEvent("FrogPrinceDeath")
function deathFrog.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if creature:getName():lower() == frogConfig.name:lower() then
        local currentDebugDay = getCurrentDebugDay()
        setGlobalStorageValue(frogConfig.storageDespawnTime, -1)
        setGlobalStorageValue(frogConfig.storageHasSpawnedToday, currentDebugDay)
        print("[🐸 DEBUG] The Frog Prince foi morto. Marcação atualizada.")
    end
    return true
end
deathFrog:register()
