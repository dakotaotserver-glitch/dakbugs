local spellstealerTeleport = CreatureEvent("SpellstealerTeleport")

local teleportPosition = Position(32765, 32714, 11)
local spawnCreatures = {"The Spellstealer Red", "The Spellstealer Green"}

function spellstealerTeleport.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature:isMonster() or creature:getName():lower() ~= "the spellstealer" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Verifica se a criatura tem menos de 10% da vida máxima
    local maxHealth = creature:getMaxHealth()
    local currentHealth = creature:getHealth()
    local healthPercentage = (currentHealth / maxHealth) * 100

    if healthPercentage < 10 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if attacker and attacker:isPlayer() then
        local chance = math.random(1, 100)
        if chance <= 5 then
            local creaturePosition = creature:getPosition()
            local spawnName = spawnCreatures[math.random(1, #spawnCreatures)]
            creature:teleportTo(teleportPosition)
            -- teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            Game.createMonster(spawnName, creaturePosition)
            -- creaturePosition:sendMagicEffect(CONST_ME_TELEPORT)
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

spellstealerTeleport:register()

local spellstealerEvent = MoveEvent()

local greenActionId = 33031
local redActionId = 33032
local originalPosition = Position(32765, 32714, 11)
local targetPosition = Position(32751, 32723, 11)
local targetPosition2 = Position(32738, 32710, 11)

function spellstealerEvent.onStepIn(creature, item, position, fromPosition)
    if creature:isMonster() then
        local targetCreature = Tile(originalPosition):getTopCreature()
        if targetCreature and targetCreature:getName():lower() == "the spellstealer" then
            local maxHealth = targetCreature:getMaxHealth()
            local currentHealth = targetCreature:getHealth()
            local healthPercentage = (currentHealth / maxHealth) * 100
            
            -- Verifica se a criatura tem menos de 10% da vida máxima
            if healthPercentage >= 10 then
                if item:getActionId() == greenActionId and creature:getName():lower() == "the spellstealer green" then
                    targetCreature:teleportTo(targetPosition2)
                    creature:remove()
                elseif item:getActionId() == redActionId and creature:getName():lower() == "the spellstealer red" then
                    targetCreature:teleportTo(targetPosition)
                    creature:remove()
                end
            end
        end
    end
    return true
end

spellstealerEvent:type("stepin")
spellstealerEvent:aid(greenActionId)
spellstealerEvent:aid(redActionId)
spellstealerEvent:register()

