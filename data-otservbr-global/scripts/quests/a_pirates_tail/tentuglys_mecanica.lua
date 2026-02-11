local creatureThinkEvent = CreatureEvent("TentuglyTeleportEvent")

local teleportPosition = Position(33716, 31149, 7)
local splashEffectPosition = Position(33722, 31182, 7)
local playerTeleportPosition = Position(33799, 31356, 7)

local itemRemovePositions = {
    Position(33723, 31191, 7),
    Position(33727, 31186, 7),
    Position(33726, 31180, 7),
    Position(33718, 31176, 7),
    Position(33718, 31191, 6),
    Position(33716, 31183, 6),
    Position(33722, 31182, 7) -- <-- Nova posição para remover o itemId 35600
}

local itemIDsToRemove = {35110, 35120, 35107, 35600}

local itemCreationData = {
    {Position(33723, 31191, 7), 35109},
    {Position(33723, 31190, 7), 35112},
    {Position(33723, 31189, 7), 35112},
    {Position(33723, 31188, 7), 35112},
    {Position(33723, 31187, 7), 35112},
    {Position(33723, 31186, 7), 35112},
    {Position(33723, 31185, 7), 35112},
    {Position(33727, 31186, 7), 35109},
    {Position(33727, 31185, 7), 35112},
    {Position(33727, 31184, 7), 35112},
    {Position(33726, 31180, 7), 35119},
    {Position(33725, 31180, 7), 35126},
    {Position(33724, 31180, 7), 35126},
    {Position(33723, 31180, 7), 35126},
    {Position(33722, 31180, 7), 35126},
    {Position(33718, 31177, 7), 35112},
    {Position(33718, 31178, 7), 35112},
    {Position(33718, 31179, 7), 35112},
    {Position(33718, 31180, 7), 35112},
    {Position(33736, 31179, 7), 35119},
    {Position(33735, 31179, 7), 35126},
    {Position(33734, 31179, 7), 35126},
    {Position(33733, 31179, 7), 35126},
    {Position(33732, 31179, 7), 35126},
    {Position(33716, 31183, 6), 35109},
    {Position(33718, 31191, 6), 35109},
    {Position(33718, 31190, 6), 35112},
    {Position(33718, 31189, 6), 35112},
    {Position(33718, 31188, 6), 35112},
    {Position(33718, 31187, 6), 35112},
    {Position(33716, 31182, 6), 35112},
    {Position(33716, 31181, 6), 35112}
}

local tentuglySpawnPositions = {
    Position(33723, 31184, 7),
    Position(33727, 31183, 7),
    Position(33718, 31186, 6),
    Position(33716, 31180, 6)
}

local tentugliSpawnPositions = {
    Position(33721, 31180, 7),
    Position(33731, 31179, 7)
}

local tentuglisSpawnPositions = {
    Position(33718, 31181, 7)
}

function creatureThinkEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
    local creatureName = creature:getName()
    local storageKey = 65129 -- Controle de execução da mecânica
    local tentacleKillStorage = 65130 -- <-- Storage única por boss para contar tentáculos mortos

    if creatureName == "Tentugly's Head" and creature:getStorageValue(storageKey) ~= 1 then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()

        if currentHealth <= maxHealth * 0.50 then
            local previousPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
            previousPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
            splashEffectPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
			

            for _, pos in ipairs(itemRemovePositions) do
                for _, itemId in ipairs(itemIDsToRemove) do
                    local itemToRemove = Tile(pos):getItemById(itemId)
                    while itemToRemove do
                        itemToRemove:remove()
                        itemToRemove = Tile(pos):getItemById(itemId)
                    end
                end
            end

            for _, data in ipairs(itemCreationData) do
                local position = data[1]
                local itemId = data[2]
                local tile = Tile(position)
                if tile then
                    local existingItem = tile:getItemById(itemId)
                    if existingItem then
                        existingItem:remove()
                    end
                end
                Game.createItem(itemId, 1, position)
                position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end

            for _, position in ipairs(tentuglySpawnPositions) do
                local tentacle = Game.createMonster("Tentugly", position)
                if tentacle then
                    tentacle:setStorageValue(tentacleKillStorage, 0) -- inicia com 0 mortes
                end
                position:sendMagicEffect(CONST_ME_TELEPORT)
            end

            for _, position in ipairs(tentugliSpawnPositions) do
                local tentacle = Game.createMonster("Tentugli", position)
                if tentacle then
                    tentacle:setStorageValue(tentacleKillStorage, 0)
                end
                position:sendMagicEffect(CONST_ME_TELEPORT)
            end

            for _, position in ipairs(tentuglisSpawnPositions) do
                local tentacle = Game.createMonster("Tentuglis", position)
                if tentacle then
                    tentacle:setStorageValue(tentacleKillStorage, 0)
                end
                position:sendMagicEffect(CONST_ME_TELEPORT)
            end

            local allPositions = {}
            for _, data in ipairs(itemCreationData) do
                table.insert(allPositions, data[1])
            end
            for _, position in ipairs(tentuglySpawnPositions) do
                table.insert(allPositions, position)
            end
            for _, position in ipairs(tentugliSpawnPositions) do
                table.insert(allPositions, position)
            end
            for _, position in ipairs(tentuglisSpawnPositions) do
                table.insert(allPositions, position)
            end

            for _, position in ipairs(allPositions) do
                local tile = Tile(position)
                if tile then
                    for _, thing in ipairs(tile:getCreatures()) do
                        if thing:isPlayer() then
                            thing:teleportTo(playerTeleportPosition)
                            playerTeleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
                        end
                    end
                end
            end

            creature:setStorageValue(storageKey, 1)
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureThinkEvent:register()
