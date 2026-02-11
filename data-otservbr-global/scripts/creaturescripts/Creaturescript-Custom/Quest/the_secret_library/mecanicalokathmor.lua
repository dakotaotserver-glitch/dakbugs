local lokathmorThink = CreatureEvent("LokathmorThink")

local teleportPosition = Position(32778, 32685, 10)
local stuckPosition = Position(32751, 32689, 10)
local darkKnowledgePosition = Position(32751, 32682, 10) -- Posição para criar Dark Knowledge
local forceFieldPositions = {
    Position(32749, 32686, 10), Position(32750, 32686, 10), Position(32751, 32686, 10),
    Position(32752, 32686, 10), Position(32753, 32686, 10), Position(32754, 32687, 10),
    Position(32754, 32688, 10), Position(32754, 32689, 10), Position(32754, 32690, 10),
    Position(32754, 32691, 10), Position(32753, 32692, 10), Position(32752, 32692, 10),
    Position(32751, 32692, 10), Position(32750, 32692, 10), Position(32749, 32692, 10),
    Position(32748, 32691, 10), Position(32748, 32690, 10), Position(32748, 32689, 10),
    Position(32748, 32688, 10), Position(32748, 32687, 10)
}
local mechanicsExecuted = {
    [0.80] = false,
    [0.60] = false,
    [0.40] = false,
    [0.20] = false
}

local areaFromPosition = Position(32742, 32681, 10)
local playerTeleportPosition = Position(32751, 32691, 10) -- Posição para onde os jogadores serão teleportados

local function teleportPlayersToPosition()
    local playersInRoom = Game.getSpectators(areaFromPosition, false, true, 20, 20, 20, 20)
    for _, player in ipairs(playersInRoom) do
        player:teleportTo(playerTeleportPosition)
        playerTeleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
    end
end

local function removeCreaturesInRoomExceptLokathmor()
    local creaturesInRoom = Game.getSpectators(areaFromPosition, false, false, 20, 20, 20, 20)
    for _, creature in ipairs(creaturesInRoom) do
        if creature:isMonster() and creature:getName() ~= "Lokathmor" and creature:getName() ~= "Lokathmor Stuck" then
            creature:remove()
        end
    end
end

local function createForceFields()
    removeCreaturesInRoomExceptLokathmor() -- Remove todas as criaturas exceto Lokathmor e Lokathmor Stuck
    for _, position in ipairs(forceFieldPositions) do
        Game.createMonster("Force Field", position)
        position:sendMagicEffect(CONST_ME_TELEPORT)
    end
    -- Criar Dark Knowledge após a criação das Force Fields
    Game.createMonster("Dark Knowledge", darkKnowledgePosition)
    darkKnowledgePosition:sendMagicEffect(CONST_ME_TELEPORT)
end

function lokathmorThink.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName() == "Lokathmor" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()
        
        if currentHealth <= maxHealth * 0.20 and not mechanicsExecuted[0.20] then
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            Game.createMonster("Lokathmor Stuck", stuckPosition)
            createForceFields()
            teleportPlayersToPosition()
            mechanicsExecuted[0.20] = true
        elseif currentHealth <= maxHealth * 0.40 and not mechanicsExecuted[0.40] then
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            Game.createMonster("Lokathmor Stuck", stuckPosition)
            createForceFields()
            teleportPlayersToPosition()
            mechanicsExecuted[0.40] = true
        elseif currentHealth <= maxHealth * 0.60 and not mechanicsExecuted[0.60] then
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            Game.createMonster("Lokathmor Stuck", stuckPosition)
            createForceFields()
            teleportPlayersToPosition()
            mechanicsExecuted[0.60] = true
        elseif currentHealth <= maxHealth * 0.80 and not mechanicsExecuted[0.80] then
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            Game.createMonster("Lokathmor Stuck", stuckPosition)
            createForceFields()
            teleportPlayersToPosition()
            mechanicsExecuted[0.80] = true
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

lokathmorThink:register()
