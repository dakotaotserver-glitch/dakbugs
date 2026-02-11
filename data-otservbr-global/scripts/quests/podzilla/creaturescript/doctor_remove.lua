local creatureThinkEvent = CreatureEvent("DoctorMarrowRemoval")

-- Definições das posições limite
local fromPosition = Position(33945, 32026, 11)
local toPosition = Position(33982, 32055, 11)

-- Controle para verificar se a ação já foi executada
local hasActionExecuted = {}

function creatureThinkEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    -- Verifica se a criatura é "Doctor Marrow"
    if creature:getName() == "Doctor Marrow" then
        -- Obtém a posição e verifica se está dentro do intervalo
        local position = creature:getPosition()
        if position:isInRange(fromPosition, toPosition) then
            -- Calcula o percentual de vida restante
            local maxHealth = creature:getMaxHealth()
            local currentHealth = creature:getHealth()

            if currentHealth <= maxHealth * 0.20 and (creature:getId() and not hasActionExecuted[creature:getId()]) then
                -- Efeito visual antes de remover a criatura
                position:sendMagicEffect(46)

                -- Remove a criatura
                creature:remove()

            end
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureThinkEvent:register()
