local config = {
    monsterName = "Arachir the Ancient One",
    spawnPosition = Position(32961, 32388, 12),
}

local function spawnArachir()
    local arachir = Game.createMonster(config.monsterName, config.spawnPosition)
    if arachir then
        arachir:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        logger.info("Arachir the Ancient One has appeared at the designated position at midnight.")
    else
        logger.warn("Failed to spawn Arachir the Ancient One.")
    end
end

local dailySpawn = GlobalEvent("arachir_spawn")

function dailySpawn.onTime(interval)
    spawnArachir()
    return true
end

dailySpawn:time("16:12") -- Define para o evento ocorrer à meia-noite
dailySpawn:register()
