local config = {
    debugMode = false,
    checkInterval = 30, -- segundos
    minCooldown = 10 * 60,
    maxCooldown = 20 * 60,
    bosses = {
        {
            name = "Chopper",
            position = Position(33526, 31261, 8),
            storageNextSpawn = 974001,
            storageHasSpawned = 974101
        },
        {
            name = "Maw",
            position = Position(33506, 31247, 8),
            storageNextSpawn = 974002,
            storageHasSpawned = 974102
        },
        {
            name = "Shadowstalker",
            position = Position(33482, 31238, 8),
            storageNextSpawn = 974003,
            storageHasSpawned = 974103
        },
        {
            name = "Rotspit",
            position = Position(33452, 31241, 8),
            storageNextSpawn = 974004,
            storageHasSpawned = 974104
        },
        {
            name = "Mindmasher",
            position = Position(33449, 31219, 8),
            storageNextSpawn = 974005,
            storageHasSpawned = 974105
        },
        {
            name = "Fleshslicer",
            position = Position(33427, 31267, 8),
            storageNextSpawn = 974006,
            storageHasSpawned = 974106
        }
    }
}

local function isAlive(pos, name)
    local tile = Tile(pos)
    if not tile then return false end
    for _, c in ipairs(tile:getCreatures() or {}) do
        if c:isMonster() and c:getName():lower() == name:lower() then
            return true
        end
    end
    return false
end

local function spawnBoss(boss)
    local m = Game.createMonster(boss.name, boss.position)
    if m then
        boss.position:sendMagicEffect(CONST_ME_TELEPORT)
        setGlobalStorageValue(boss.storageHasSpawned, 1)
    end
end

local function loop()
    local now = os.time()

    for _, boss in ipairs(config.bosses) do
        local hasSpawned = getGlobalStorageValue(boss.storageHasSpawned)
        local nextSpawn = getGlobalStorageValue(boss.storageNextSpawn)
        local alive = isAlive(boss.position, boss.name)

        if alive then goto continue end

        if hasSpawned ~= 1 then
            spawnBoss(boss)
            goto continue
        end

        if nextSpawn == -1 then
            local delay = math.random(config.minCooldown, config.maxCooldown)
            local when = now + delay
            setGlobalStorageValue(boss.storageNextSpawn, when)
            goto continue
        end

        if now >= nextSpawn then
            spawnBoss(boss)
            setGlobalStorageValue(boss.storageNextSpawn, -1)
        end

        ::continue::
    end

    addEvent(loop, config.checkInterval * 1000)
end

local global = GlobalEvent("HiveBossesAutoSpawn")
function global.onStartup()
    math.randomseed(os.time())
    loop()
    return true
end
global:register()
