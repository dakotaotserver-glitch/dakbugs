local ACTION_ID_33155 = 33155
local ACTION_ID_33154 = 33154
local teleportPosition = Position(32761, 32908, 14)

local function isPlayerOnActionId(actionId)
    for _, player in ipairs(Game.getPlayers()) do
        local playerPosition = player:getPosition()
        local tile = Tile(playerPosition)
        if tile then
            for _, item in ipairs(tile:getItems() or {}) do
                if item:getActionId() == actionId then
                    return true
                end
            end
        end
    end
    return false
end

local function tryTeleportPlayerOnActionId(actionId, teleportPos)
    for _, player in ipairs(Game.getPlayers()) do
        local playerPosition = player:getPosition()
        local tile = Tile(playerPosition)
        if tile then
            for _, item in ipairs(tile:getItems() or {}) do
                if item:getActionId() == actionId then
                    playerPosition:sendMagicEffect(54)
                    player:teleportTo(teleportPos)
                    
                    -- Garante o efeito 54 na posição de destino após o teleporte
                    teleportPos:sendMagicEffect(54)

                    return true
                end
            end
        end
    end
    return false
end

local function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return true
    end

    if not isPlayerOnActionId(ACTION_ID_33154) then
        local playerPosition = creature:getPosition()
        playerPosition:sendMagicEffect(54)
        creature:teleportTo(teleportPosition)
        
        -- Garante o efeito 54 na posição de destino após o teleporte
        teleportPosition:sendMagicEffect(54)
    end

    return true
end

local function onStepOut(creature, item, position, toPosition)
    if not creature:isPlayer() then
        return true
    end

    tryTeleportPlayerOnActionId(ACTION_ID_33155, teleportPosition)
    return true
end

local moveEvent = MoveEvent()
moveEvent:aid(ACTION_ID_33155)
moveEvent.onStepIn = onStepIn
moveEvent:register()

local stepOutEvent = MoveEvent()
stepOutEvent:aid(ACTION_ID_33154)
stepOutEvent.onStepOut = onStepOut
stepOutEvent:register()
