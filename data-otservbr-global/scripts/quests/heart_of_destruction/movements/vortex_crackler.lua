local vortexCrackler = MoveEvent()
local activePlayers = {}
local bossSpawnPos = Position(32210, 31330, 14) -- Altere se quiser

local function verifyPlayerOnItem(playerId)
    local player = Player(playerId)
    if not player then
        return
    end

    local playerPosition = player:getPosition()
    local tile = Tile(playerPosition)
    if not tile or not tile:getItemById(23471) then
        setGlobalStorageValue(65103, 0)
        activePlayers[playerId] = nil
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The polarizing energy dissipates as the vortex vanishes.")
    else
        addEvent(verifyPlayerOnItem, 1000, playerId)
    end
end

vortexCrackler.onStepIn = function(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if item.itemid == 23471 then
        if getGlobalStorageValue(65103) == 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is already polarizing the vortex!")
            return true
        end

        setGlobalStorageValue(65103, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your presence begins to polarize the area!")
        player:getPosition():sendMagicEffect(48)
        activePlayers[player:getId()] = true

        -- Spawn do boss
        local bossName = "Polarizing Crackler" -- Altere para o nome real do boss!
        local boss = Game.createMonster(bossName, bossSpawnPos)
        if boss then
            boss:say("I am born from the energy you released!", TALKTYPE_MONSTER_YELL)
            bossSpawnPos:sendMagicEffect(CONST_ME_TELEPORT)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to create boss, check name and position!")
        end

        addEvent(verifyPlayerOnItem, 1000, player:getId())
    end
    return true
end

vortexCrackler:type("stepin")
vortexCrackler:id(23471)
vortexCrackler:register()

local vortexCracklerOut = MoveEvent()
vortexCracklerOut.onStepOut = function(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then return true end

    setGlobalStorageValue(65103, 0)
    activePlayers[player:getId()] = nil
    return true
end

vortexCracklerOut:type("stepout")
vortexCracklerOut:id(23471)
vortexCracklerOut:register()
