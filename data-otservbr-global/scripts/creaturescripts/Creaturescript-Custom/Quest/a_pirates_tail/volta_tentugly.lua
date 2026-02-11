local creatureDeathEvent = CreatureEvent("TentuglyTentugliTentuglisDeath")

local tentuglyDeathCount = 0
local tentugliDeathCount = 0
local tentuglisDeathCount = 0

local function checkAndTeleportTentuglyHead()
    if tentuglyDeathCount >= 17 and tentugliDeathCount >= 10 and tentuglisDeathCount >= 4 then
        local tentuglysHeadPosition = Position(33716, 31149, 7)
        local tentuglysHead = Tile(tentuglysHeadPosition):getTopCreature()

        if tentuglysHead and tentuglysHead:getName() == "Tentugly's Head" then
            local teleportPosition = Position(33722, 31182, 7)
            tentuglysHead:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
        end

        -- Reset the counters after teleportation
        tentuglyDeathCount = 0
        tentugliDeathCount = 0
        tentuglisDeathCount = 0
    end
end

function creatureDeathEvent.onDeath(creature, corpse, deathList)
    local creatureName = creature:getName()

    if creatureName == "Tentugly" then
        tentuglyDeathCount = tentuglyDeathCount + 1
    elseif creatureName == "Tentugli" then
        tentugliDeathCount = tentugliDeathCount + 1
    elseif creatureName == "Tentuglis" then
        tentuglisDeathCount = tentuglisDeathCount + 1
    end

    checkAndTeleportTentuglyHead()
    return true
end

creatureDeathEvent:register()
