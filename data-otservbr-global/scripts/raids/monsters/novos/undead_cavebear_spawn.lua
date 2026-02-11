-- Undead Cavebear Respawn System (versão silenciosa)

local undeadCavebearConfig = {
    name = "Undead Cavebear",
    positions = {
        Position(31961, 32587, 10),
        Position(31981, 32559, 10),
        Position(31913, 32561, 10),
    },
    storageNextSpawn = 950001,
    storageStartCycle = 950002,
    storageWave = 950003,

    debugMode = false,
    debugCooldown = {min = 30, max = 90},

    waveInterval = 5 * 60 * 60,
    fullCycle = 3 * 24 * 60 * 60
}

local function canSpawnHere(pos)
    local tile = Tile(pos)
    if not tile then return true end
    for _, creature in ipairs(tile:getCreatures() or {}) do
        if creature:isMonster() and creature:getName():lower() == undeadCavebearConfig.name:lower() then
            return false
        end
    end
    return true
end

local function spawnUndeadCavebear()
    for _, pos in ipairs(undeadCavebearConfig.positions) do
        if canSpawnHere(pos) then
            local monster = Game.createMonster(undeadCavebearConfig.name, pos)
            if monster then
                pos:sendMagicEffect(CONST_ME_TELEPORT)
                return true
            end
        end
    end
    return false
end

local function checkUndeadCavebear()
    local cfg = undeadCavebearConfig
    local now = os.time()

    if cfg.debugMode then
        if spawnUndeadCavebear() then
            setGlobalStorageValue(cfg.storageWave, 0)
            setGlobalStorageValue(cfg.storageStartCycle, now)
        end
        setGlobalStorageValue(cfg.storageNextSpawn, now + math.random(cfg.debugCooldown.min, cfg.debugCooldown.max))
        return
    end

    local wave = getGlobalStorageValue(cfg.storageWave) or 0
    local startCycle = getGlobalStorageValue(cfg.storageStartCycle) or -1

    if startCycle == -1 then
        if spawnUndeadCavebear() then
            setGlobalStorageValue(cfg.storageWave, 1)
            setGlobalStorageValue(cfg.storageStartCycle, now)
            setGlobalStorageValue(cfg.storageNextSpawn, now + cfg.waveInterval)
        end
    else
        local nextSpawn = getGlobalStorageValue(cfg.storageNextSpawn) or 0

        if wave == 1 and now >= nextSpawn then
            if spawnUndeadCavebear() then
                setGlobalStorageValue(cfg.storageWave, 2)
                setGlobalStorageValue(cfg.storageNextSpawn, startCycle + cfg.waveInterval * 2)
            end
        elseif wave == 2 and now >= nextSpawn then
            if spawnUndeadCavebear() then
                setGlobalStorageValue(cfg.storageWave, 3)
                setGlobalStorageValue(cfg.storageNextSpawn, startCycle + cfg.fullCycle)
            end
        elseif wave == 3 and now >= nextSpawn then
            setGlobalStorageValue(cfg.storageWave, 0)
            setGlobalStorageValue(cfg.storageStartCycle, -1)
            setGlobalStorageValue(cfg.storageNextSpawn, -1)
        end
    end
end

local function scheduleUndeadCavebearLoop()
    local function loop()
        checkUndeadCavebear()
        addEvent(loop, 60 * 1000)
    end
    loop()
end

local undeadCavebearEvent = GlobalEvent("UndeadCavebearSpawn")
function undeadCavebearEvent.onStartup()
    scheduleUndeadCavebearLoop()
    return true
end
undeadCavebearEvent:register()
