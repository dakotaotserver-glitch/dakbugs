local healOnApproach = CreatureEvent("maxxenius")
local healCooldown = 2000 -- time in milliseconds (2 seconds)
local lastHeal = {} -- table to store the last heal time per creature

-- Definition of the area effect pattern
local areaEffectPositions = {
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0},
}

function healOnApproach.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= "generator" then
        return true
    end

    local currentTime = os.time() * 1000 -- current time in milliseconds
    local creatureId = creature:getId()

    if not lastHeal[creatureId] then
        lastHeal[creatureId] = 0 -- initialize the last heal time if it doesn't exist
    end

    if currentTime - lastHeal[creatureId] < healCooldown then
        return true -- if the cooldown hasn't passed yet, do nothing
    end

    lastHeal[creatureId] = currentTime -- update the last heal time

    local spectators = Game.getSpectators(creature:getPosition(), false, false, 2, 2, 2, 2)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and spectator:getName():lower() == "maxxenius" then
            local healAmount = math.random(1000, 3000) -- Generate a heal between 1000 and 3000 health points
            spectator:addHealth(healAmount)
            spectator:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

            -- Create the effect based on the pattern defined in areaEffectPositions
            local generatorPosition = creature:getPosition()
            local centerX = math.floor(#areaEffectPositions / 2) + 1
            local centerY = math.floor(#areaEffectPositions[1] / 2) + 1

            for x = 1, #areaEffectPositions do
                for y = 1, #areaEffectPositions[x] do
                    if areaEffectPositions[x][y] > 0 then
                        local effectPosition = Position(
                            generatorPosition.x + (x - centerX),
                            generatorPosition.y + (y - centerY),
                            generatorPosition.z
                        )
                        effectPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
                    end
                end
            end
        end
    end

    return true
end

healOnApproach:register()
