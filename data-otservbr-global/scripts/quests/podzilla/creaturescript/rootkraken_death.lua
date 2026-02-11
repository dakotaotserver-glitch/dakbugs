local function removeCreaturesAroundRootkraken(creature)
    -- Verifica se a criatura é "The Rootkraken"
    if creature:getName():lower() == "the rootkraken" then
        local position = creature:getPosition()

        -- Obtém todas as criaturas em um raio de 15x15x15
        local creaturesInRange = Game.getSpectators(position, false, false, 15, 15, 15, 15)

        for _, target in ipairs(creaturesInRange) do
            -- Verifica se a criatura é um monstro (e não um jogador)
            if target:isMonster() then
                target:remove()  -- Remove a criatura
            end
        end
    end
end

-- Evento acionado quando uma criatura morre
local deathEvent = CreatureEvent("RootkrakenDeath")

-- Definição do comportamento do evento onDeath
deathEvent.onDeath = function(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    removeCreaturesAroundRootkraken(creature)
    return true
end

deathEvent:register()
