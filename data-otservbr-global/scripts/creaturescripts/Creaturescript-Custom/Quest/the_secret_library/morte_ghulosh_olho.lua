local teleportEvent = CreatureEvent("GhuloshDeathgazeDeath")

function teleportEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    local position = creature:getPosition()
    local creatureName = creature:getName():lower()
    
    if creatureName == "ghulosh' deathgaze" then
        -- Defina a posição original de Ghulosh
        local ghuloshOriginalPosition = Position(32778, 32717, 10)
        
        -- Função para teleportar Ghulosh
        local function teleportGhulosh()
            local ghulosh = Tile(ghuloshOriginalPosition):getTopCreature()
            if ghulosh and ghulosh:getName():lower() == "ghulosh" then
                ghulosh:teleportTo(position)
                position:sendMagicEffect(CONST_ME_TELEPORT)
                ghulosh:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            end
        end
        
        -- Adiciona um atraso de 1 segundo (1000 milissegundos) antes de teleportar Ghulosh
        addEvent(teleportGhulosh, 50)
    end
    return true
end

teleportEvent:register()



