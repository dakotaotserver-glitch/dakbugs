local ghuloshThink = CreatureEvent("GhuloshThinkok")

local teleportPosition = Position(32778, 32717, 10)
local previousPosition = nil

-- Tabela para rastrear a execução das mecânicas
local mechanicsExecuted = {
    [0.70] = false,
    [0.40] = false,
    [0.10] = false
}

function ghuloshThink.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName() == "Ghulosh" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()
        
        -- Verificar se a saúde atual está em 70%, 40% ou 10% e se a mecânica correspondente ainda não foi executada
        if currentHealth <= maxHealth * 0.10 and not mechanicsExecuted[0.10] then
            previousPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            addEvent(function() 
                Game.createMonster("Ghulosh' Deathgaze", previousPosition)
            end, 1000) -- Cria Ghulosh' Deathgaze após 1 segundo
            mechanicsExecuted[0.10] = true
        elseif currentHealth <= maxHealth * 0.40 and not mechanicsExecuted[0.40] then
            previousPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            addEvent(function() 
                Game.createMonster("Ghulosh' Deathgaze", previousPosition)
            end, 1000) -- Cria Ghulosh' Deathgaze após 1 segundo
            mechanicsExecuted[0.40] = true
        elseif currentHealth <= maxHealth * 0.70 and not mechanicsExecuted[0.70] then
            previousPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            addEvent(function() 
                Game.createMonster("Ghulosh' Deathgaze", previousPosition)
            end, 50) -- Cria Ghulosh' Deathgaze após 1 segundo
            mechanicsExecuted[0.70] = true
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ghuloshThink:register()
