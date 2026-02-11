local darkKnowledgeDeath = CreatureEvent("DarkKnowledgeDeath")
-- Função que cria o item 4842 com actionId 33028 na posição da morte do Dark Knowledge
function darkKnowledgeDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    local position = creature:getPosition()
    local creatureName = creature:getName():lower()

    if creatureName == "dark knowledge" then
        -- Adicionar um atraso de 1 segundo antes de criar o item
        addEvent(function()
            local item = Game.createItem(28488, 1, position)
            if item then
                item:setActionId(33028)
            end
        end, 50) -- 1000 milissegundos = 1 segundo
    end

    return true
end

darkKnowledgeDeath:register()

