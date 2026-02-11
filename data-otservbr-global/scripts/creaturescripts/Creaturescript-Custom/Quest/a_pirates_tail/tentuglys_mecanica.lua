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
    Position(33716, 31183, 6)
}

local itemIDsToRemove = {35110, 35120, 35107}

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

local mechanicsExecuted = {
    ["Tentugly's Head"] = false
}

function creatureThinkEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local creatureName = creature:getName()

    if creatureName == "Tentugly's Head" and not mechanicsExecuted[creatureName] then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()

        -- Checa se a vida está em 90% ou menos
        if currentHealth <= maxHealth * 0.50 then
            -- Salva a posição atual antes do teleporte
            local previousPosition = creature:getPosition()

            -- Teleporta a criatura para a posição específica
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_WATERSPLASH)

            -- Aplica o efeito na posição anterior ao teleporte
            previousPosition:sendMagicEffect(CONST_ME_WATERSPLASH)

            -- Aplica o efeito splash na posição específica
            splashEffectPosition:sendMagicEffect(CONST_ME_WATERSPLASH)

            -- Remove os itens específicos das posições especificadas
            for _, pos in ipairs(itemRemovePositions) do
                for _, itemId in ipairs(itemIDsToRemove) do
                    local itemToRemove = Tile(pos):getItemById(itemId)
                    while itemToRemove do
                        itemToRemove:remove()
                        itemToRemove = Tile(pos):getItemById(itemId)
                    end
                end
            end

            -- Cria os novos itens nas posições especificadas
            for _, data in ipairs(itemCreationData) do
                local position = data[1]
                local itemId = data[2]
                Game.createItem(itemId, 1, position)
                position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end

            -- Cria as criaturas Tentugly nas posições especificadas
            for _, position in ipairs(tentuglySpawnPositions) do
                Game.createMonster("Tentugly", position)
                position:sendMagicEffect(CONST_ME_TELEPORT)
            end

            -- Cria as criaturas Tentugli nas posições especificadas
            for _, position in ipairs(tentugliSpawnPositions) do
                Game.createMonster("Tentugli", position)
                position:sendMagicEffect(CONST_ME_TELEPORT)
            end

            -- Cria a criatura Tentuglis na posição especificada
            for _, position in ipairs(tentuglisSpawnPositions) do
                Game.createMonster("Tentuglis", position)
                position:sendMagicEffect(CONST_ME_TELEPORT)
            end

            -- Teleporta jogadores que estejam nas posições de criação de itens ou criaturas
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

            -- Marca a mecânica como executada para evitar repetições
            mechanicsExecuted[creatureName] = true
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureThinkEvent:register()
