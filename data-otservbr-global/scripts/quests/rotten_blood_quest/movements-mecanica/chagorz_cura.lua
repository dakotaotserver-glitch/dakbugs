local chagorzHealMove = MoveEvent()

local actionId = 33118 -- Action ID do item
local minHeal = 300 -- Cura mínima para Chagorz
local maxHeal = 1200 -- Cura máxima para Chagorz
local minDamage = 100 -- Dano mínimo para jogadores
local maxDamage = 500 -- Dano máximo para jogadores

function chagorzHealMove.onStepIn(creature, item, position, fromPosition)
    if creature then
        -- Verifica se é a criatura Chagorz
        if creature:isMonster() and creature:getName():lower() == "chagorz" then
            if item:getActionId() == actionId then
                -- Cura entre 300 e 1200 pontos de vida
                local healAmount = math.random(minHeal, maxHeal)
                local currentHealth = creature:getHealth()
                local maxHealth = creature:getMaxHealth()
                local newHealth = math.min(currentHealth + healAmount, maxHealth) -- Garante que a vida não exceda o máximo
                creature:addHealth(newHealth - currentHealth)

                -- Aplica efeito de cura verde
                position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
            end
        -- Verifica se é um jogador
        elseif creature:isPlayer() then
            if item:getActionId() == actionId then
                -- Dano aleatório entre 100 e 500 pontos
                local damage = math.random(minDamage, maxDamage)
                creature:addHealth(-damage, COMBAT_AGONYDAMAGE) -- Aplica o dano ao jogador

            end
        end
    end
    return true
end

chagorzHealMove:type("stepin")
chagorzHealMove:aid(actionId) -- Usa action ID ao invés de item ID
chagorzHealMove:register()
