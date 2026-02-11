local config = {
    bossName = {
        ["Monday"] = "Plagueroot",
        ["Tuesday"] = "Malofur Mangrinder",
        ["Wednesday"] = "Maxxenius",
        ["Thursday"] = "Alptramun",
        ["Friday"] = "Izcandar Champion Of Summer",
        ["Saturday"] = "Maxxenius",
        ["Sunday"] = "Alptramun",
    },
    requiredLevel = 250,
    timeToFightAgain = 20,
    timeToDefeat = 30, -- Em minutos
    playerPositions = {
        { pos = Position(32208, 32021, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(32208, 32022, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(32208, 32023, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(32208, 32024, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(32208, 32025, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
    },
    bossPosition = Position(32207, 32051, 14),
    specPos = {
        from = Position(32199, 32039, 14),
        to = Position(32229, 32055, 14),
    },
    exit = Position(32210, 32035, 13),
    generatorPositions = {
        Position(32210, 32045, 14),
        Position(32210, 32051, 14),
        Position(32205, 32048, 14),
    },
    creatureCycle = {
        ["Unpleasant Dream"] = "Horrible Dream",
        ["Horrible Dream"] = "Nightmarish Dream",
        ["Nightmarish Dream"] = "Mind-Wrecking Dream",
        ["Mind-Wrecking Dream"] = "Unpleasant Dream"
    },
    spawnPositionsAroundBoss = {
        Position(32207, 32050, 14),
        Position(32206, 32052, 14),
        Position(32208, 32052, 14),
        Position(32206, 32050, 14),
        Position(32208, 32050, 14)
    },
    plantAttendantPositions = {
        Position(32206, 32050, 14),
        Position(32208, 32050, 14),
        Position(32206, 32052, 14),
        Position(32208, 32052, 14)
    },
    coldWinterPositions = { -- Posições ao redor de Izcandar Champion Of Summer
        Position(32206, 32049, 14),
        Position(32208, 32049, 14),
        Position(32206, 32053, 14),
        Position(32208, 32053, 14)
    },
    heatSummerPositions = {
        Position(32205, 32050, 14),
        Position(32209, 32050, 14),
        Position(32205, 32052, 14),
        Position(32209, 32052, 14)
    }
}

local bossToday = config.bossName[os.date("%A")]

local function spawnNextCreature(position, nextCreatureName)
    addEvent(function()
        local nextCreature = Game.createMonster(nextCreatureName, position, true, true)
        if nextCreature then
            nextCreature:registerEvent("dreamCycle")
        end
    end, 10000)
end

local function respawnCreature(creatureName, position)
    addEvent(function()
        local creature = Game.createMonster(creatureName, position, true, true)
        if creature then
            creature:registerEvent("creatureRespawn")
        end
    end, 15000)
end


local dreamCourtsLever = Action()
function dreamCourtsLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if config.playerPositions[1].pos ~= player:getPosition() then
        return false
    end
    local spec = Spectators()
    spec:setOnlyPlayer(false)
    spec:setRemoveDestination(config.exit)
    spec:setCheckPosition(config.specPos)
    spec:check()
    if spec:getPlayers() > 0 then
        player:say("There's someone fighting with " .. bossToday .. ".", TALKTYPE_MONSTER_SAY)
        return true
    end
    local lever = Lever()
    lever:setPositions(config.playerPositions)
    lever:setCondition(function(creature)
        if not creature or not creature:isPlayer() then
            return true
        end
        if creature:getLevel() < config.requiredLevel then
            creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. config.requiredLevel .. " or higher.")
            return false
        end
        if not lever:canUseLever(player, bossToday, config.timeToFightAgain) then
            return false
        end
        return true
    end)
    lever:checkPositions()
    if lever:checkConditions() then
        spec:removeMonsters()
        local monster = Game.createMonster(bossToday, config.bossPosition, true, true)
        if not monster then
            return true
        end

        -- Adição de Izcandar Champion Of Winter e suas criaturas ao redor quando Izcandar Champion Of Summer nascer
        if bossToday == "Izcandar Champion Of Summer" then
            local winterPosition = Position(32208, 32027, 15)
            local winterCreature = Game.createMonster("Izcandar Champion Of Winter", winterPosition, true, true)
            if winterCreature then
                winterCreature:registerEvent("someEventIfNeeded")
            end

            -- Criação das criaturas ao redor de Izcandar Champion Of Summer
            for _, pos in ipairs(config.coldWinterPositions) do
                local coldWinter = Game.createMonster("The Cold of Winter", pos, true, true)
                if coldWinter then
                    coldWinter:registerEvent("creatureRespawn")
                end
            end
            for _, pos in ipairs(config.heatSummerPositions) do
                local heatSummer = Game.createMonster("The Heat of Summer", pos, true, true)
                if heatSummer then
                    heatSummer:registerEvent("creatureRespawn")
                end
            end
        end

        -- Criação dos Unpleasant Dream ao redor de Alptramun
        if bossToday == "Alptramun" then
            for _, pos in ipairs(config.spawnPositionsAroundBoss) do
                local unpleasantDream = Game.createMonster("Unpleasant Dream", pos, true, true)
                if unpleasantDream then
                    unpleasantDream:registerEvent("dreamCycle")
                end
            end
        end
        
        -- Criação dos Generators se o chefe for Maxxenius
        if bossToday == "Maxxenius" then
            for _, pos in ipairs(config.generatorPositions) do
                Game.createMonster("Generator", pos, true, true)
            end
        end

        -- Criação dos Plant Attendants ao redor de Plagueroot
       if bossToday == "Plagueroot" then
    for _, pos in ipairs(config.plantAttendantPositions) do
        Game.createMonster("Plant Attendant", pos, true, true)
    end
end

        -- Criação dos Whirling Blades ao redor de Malofur Mangrinder
        if bossToday == "Malofur Mangrinder" then
            local whirlingBladePositions = {
                Position(32200, 32046, 14),
                Position(32202, 32051, 14),
                Position(32202, 32049, 14),
                Position(32205, 32055, 14),
                Position(32205, 32048, 14),
                Position(32205, 32043, 14),
                Position(32206, 32040, 14),
                Position(32206, 32051, 14),
                Position(32207, 32048, 14),
                Position(32207, 32043, 14),
                Position(32208, 32040, 14),
                Position(32208, 32051, 14),
                Position(32209, 32055, 14),
                Position(32209, 32048, 14),
                Position(32211, 32042, 14),
                Position(32211, 32044, 14),
                Position(32211, 32046, 14),
                Position(32213, 32052, 14),
                Position(32214, 32043, 14),
                Position(32214, 32047, 14),
                Position(32214, 32049, 14),
				Position(32200, 32050, 14),
				Position(32210, 32051, 14),
            }
            
            for _, pos in ipairs(whirlingBladePositions) do
                local whirlingBlade = Game.createMonster("Whirling Blades", pos, true, true)
                if whirlingBlade then
                    whirlingBlade:registerEvent("creatureRespawn")
                end
            end
        end
        
        lever:teleportPlayers()
        lever:setCooldownAllPlayers(bossToday, os.time() + config.timeToFightAgain * 3600)
        addEvent(function()
            local old_players = lever:getInfoPositions()
            spec:clearCreaturesCache()
            spec:setOnlyPlayer(true)
            spec:check()
            local player_remove = {}
            for i, v in pairs(spec:getCreatureDetect()) do
                for _, v_old in pairs(old_players) do
                    if v_old.creature == nil or v_old.creature:isMonster() then
                        break
                    end
                    if v:getName() == v_old.creature:getName() then
                        table.insert(player_remove, v_old.creature)
                        break
                    end
                end
            end
            spec:removePlayers(player_remove)
        end, config.timeToDefeat * 60 * 1000)
    end
end

-- Evento para gerenciar o ciclo de criaturas
local dreamCycle = CreatureEvent("dreamCycle")
function dreamCycle.onDeath(creature)
    local nextCreatureName = config.creatureCycle[creature:getName()]
    if nextCreatureName then
        spawnNextCreature(creature:getPosition(), nextCreatureName)
    end
    return true
end
dreamCycle:register()

-- Evento para gerenciar o re-spawn de "The Cold of Winter" e "The Heat of Summer"
local creatureRespawn = CreatureEvent("creatureRespawn")
function creatureRespawn.onDeath(creature)
    local position = creature:getPosition()
    local creatureName = creature:getName()
    respawnCreature(creatureName, position)
    return true
end
creatureRespawn:register()


dreamCourtsLever:position({ x = 32208, y = 32020, z = 13 })
dreamCourtsLever:register()
