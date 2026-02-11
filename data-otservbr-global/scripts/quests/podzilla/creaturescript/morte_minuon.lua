-- Script para criar "Rotten Plant Thing" 1 minuto após a morte de "Frenzied Plant Thing", "Angry Plant Thing" ou "Rotten Plant Thing"

local function respawnRottenPlant(creature)
    if not creature or not creature:isMonster() then
        return
    end

    local creatureName = creature:getName():lower()
    local validNames = {
        ["frenzied plant thing"] = true,
        ["angry plant thing"] = true,
        ["rotten plant thing"] = true
    }

    if not validNames[creatureName] then
        return
    end

    local position = creature:getPosition()

    -- Agendamento para criar "Rotten Plant Thing" após 1 minuto
    addEvent(function()
        local tile = Tile(position)
        if tile and not tile:getTopCreature() then
            Game.createMonster("Rotten Plant Thing", position)
        end
    end, 60000) -- 1 minuto (60.000 milissegundos)
end

-- Evento acionado quando uma criatura morre
function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    respawnRottenPlant(creature)
    return true
end

local deathEvent = CreatureEvent("PlantThingDeath")
deathEvent.onDeath = onDeath
deathEvent:register()

