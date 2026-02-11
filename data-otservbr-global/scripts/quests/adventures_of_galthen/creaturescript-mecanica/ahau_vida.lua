local ahauHeal = CreatureEvent("ahau.heal")

function ahauHeal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
    if not creature or creature:getName() ~= "Ahau" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Recupera o número de curas restantes da criatura
    local healCount = creature:getStorageValue(65114)
    if healCount == -1 then
        healCount = 3 -- Inicializa com 3 curas disponíveis
    end

    -- Calcula a porcentagem de vida restante
    local maxHealth = creature:getMaxHealth()
    local currentHealth = creature:getHealth() - primaryDamage - secondaryDamage
    local healthPercent = (currentHealth / maxHealth) * 100

    -- Verifica se a saúde da criatura caiu para 20% ou menos e se ainda pode se curar
    if healthPercent <= 50 and healCount > 0 then
        creature:addHealth(32000) -- Cura a criatura em 32.000 pontos de vida
        creature:say("Ahau se cura!", TALKTYPE_MONSTER_SAY)
        healCount = healCount - 1 -- Diminui o contador de curas

        -- Armazena o novo valor de cura restante
        creature:setStorageValue(65114, healCount)
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ahauHeal:register()
