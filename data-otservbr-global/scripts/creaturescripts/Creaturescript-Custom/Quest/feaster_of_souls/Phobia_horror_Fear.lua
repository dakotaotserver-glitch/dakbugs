local transformEvent = CreatureEvent("TransformOnDeath")

function transformEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    local position = creature:getPosition()
    local creatureName = creature:getName():lower()
    
    if creatureName == "phobia" then
        -- Transformar "phobia" em "horror"
        Game.createMonster("Horror", position)
    elseif creatureName == "horror" then
        -- Transformar "horror" em "fear"
        Game.createMonster("Fear", position)
    elseif creatureName == "fear" then
        -- Transformar "fear" em "phobia"
        Game.createMonster("Phobia", position)
    end
    return true
end

transformEvent:register()


