local transformEvent = CreatureEvent("TransformOnDeathbook")

function transformEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    local position = creature:getPosition()
    local creatureName = creature:getName():lower()
    
    if creatureName == "the book of death" then
        -- Adicionar um atraso de 1 segundo antes de criar a nova criatura
        addEvent(function()
            Game.createMonster("concentrated death", position)
        end, 100) -- 1000 milissegundos = 1 segundo
    end 
    
    return true
end

transformEvent:register()



