local chagorzHealMove = MoveEvent()

-- Definição de variáveis
local actionId1 = 33122 -- Action ID do item 1
local actionId2 = 33123 -- Action ID do item 2
local minHeal1 = 200 -- Cura mínima para Vemiath no item 1
local maxHeal1 = 500 -- Cura máxima para Vemiath no item 1
local minDamage1 = 100 -- Dano mínimo para jogadores no item 1
local maxDamage1 = 300 -- Dano máximo para jogadores no item 1
local minDamage2 = 200 -- Dano mínimo para jogadores no item 2
local maxDamage2 = 600 -- Dano máximo para jogadores no item 2
local minHeal2 = 500 -- Cura mínima para Vemiath no item 2
local maxHeal2 = 1000 -- Cura máxima para Vemiath no item 2

function chagorzHealMove.onStepIn(creature, item, position, fromPosition)
    if creature then
        -- Verifica se é a criatura Vemiath
        if creature:isMonster() and creature:getName():lower() == "vemiath" then
            -- Ação quando Vemiath pisa em item com actionId 33122
            if item:getActionId() == actionId1 then
                local healAmount = math.random(minHeal1, maxHeal1)
                local currentHealth = creature:getHealth()
                local maxHealth = creature:getMaxHealth()
                local newHealth = math.min(currentHealth + healAmount, maxHealth)
                creature:addHealth(newHealth - currentHealth)

                -- Aplica efeito de cura verde
                position:sendMagicEffect(CONST_ME_MAGIC_GREEN)

            -- Ação quando Vemiath pisa em item com actionId 33123
            elseif item:getActionId() == actionId2 then
                local healAmount = math.random(minHeal2, maxHeal2)
                local currentHealth = creature:getHealth()
                local maxHealth = creature:getMaxHealth()
                local newHealth = math.min(currentHealth + healAmount, maxHealth)
                creature:addHealth(newHealth - currentHealth)

                -- Aplica efeito de cura verde
                position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
            end

        -- Verifica se é um jogador
        elseif creature:isPlayer() then
            -- Ação quando jogador pisa em item com actionId 33122
            if item:getActionId() == actionId1 then
                local damage = math.random(minDamage1, maxDamage1)
                creature:addHealth(-damage, COMBAT_AGONYDAMAGE) -- Aplica o dano ao jogador

            -- Ação quando jogador pisa em item com actionId 33123
            elseif item:getActionId() == actionId2 then
                local damage = math.random(minDamage2, maxDamage2)
                creature:addHealth(-damage, COMBAT_AGONYDAMAGE) -- Aplica o dano ao jogador
            end
        end
    end
    return true
end

-- Configurações do MoveEvent para "stepin" e registro dos Action IDs
chagorzHealMove:type("stepin")
chagorzHealMove:aid(actionId1) -- Usa o action ID 33122
chagorzHealMove:aid(actionId2) -- Usa o action ID 33123
chagorzHealMove:register()
