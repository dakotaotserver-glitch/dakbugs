local teleportItemEvent = MoveEvent()

local actionId = 33027
local targetPosition = Position(32687, 32719, 10)
local teleportDelay = 10000 -- tempo até teleportar (10s)
local cooldownTime = 12000 -- cooldown do piso (12s)

local playerCooldowns = {} -- armazena cooldowns por player id

local function removeCooldown(playerId)
    playerCooldowns[playerId] = nil
end

local function teleportPlayer(playerId)
    local player = Player(playerId)
    if player and player:isPlayer() then
        player:teleportTo(targetPosition)
        targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
    end
end

function teleportItemEvent.onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return true
    end

    if item:getActionId() ~= actionId then
        return true
    end

    local playerId = creature:getId()

    -- Verifica se o player está em cooldown
    if playerCooldowns[playerId] then
        -- opcional: creature:sendTextMessage(MESSAGE_STATUS_SMALL, "O piso ainda está recarregando.")
        return true
    end

    -- Aplica cooldown
    playerCooldowns[playerId] = true
    addEvent(removeCooldown, cooldownTime, playerId)

    -- Agenda o teleporte após 10 segundos
    addEvent(teleportPlayer, teleportDelay, playerId)

    return true
end

teleportItemEvent:type("stepin")
teleportItemEvent:aid(actionId)
teleportItemEvent:register()
