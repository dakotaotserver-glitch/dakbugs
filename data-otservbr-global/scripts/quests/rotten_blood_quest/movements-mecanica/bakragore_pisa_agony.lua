local bakragoreHealMove = MoveEvent()

-- Definição de variáveis
local actionId1 = 33128 -- Action ID do item 1
local actionId2 = 33129 -- Action ID do item 2
local minHeal = 1000 -- Cura mínima para Bakragore
local maxHeal = 2000 -- Cura máxima para Bakragore
local minDamage = 500 -- Dano mínimo para jogadores
local maxDamage = 1000 -- Dano máximo para jogadores

function bakragoreHealMove.onStepIn(creature, item, position, fromPosition)
    if creature then
        -- Verifica se é a criatura Bakragore
        if creature:isMonster() and creature:getName():lower() == "bakragore" then
            -- Ação quando Bakragore pisa em item com actionId 33128 ou 33129
            if item:getActionId() == actionId1 or item:getActionId() == actionId2 then
                local healAmount = math.random(minHeal, maxHeal)
                local currentHealth = creature:getHealth()
                local maxHealth = creature:getMaxHealth()
                local newHealth = math.min(currentHealth + healAmount, maxHealth)
                creature:addHealth(newHealth - currentHealth)

                -- Aplica efeito de cura verde
                position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
            end

        -- Verifica se é um jogador
        elseif creature:isPlayer() then
            -- Ação quando jogador pisa em item com actionId 33128 ou 33129
            if item:getActionId() == actionId1 or item:getActionId() == actionId2 then
                local damage = math.random(minDamage, maxDamage)
                creature:addHealth(-damage, COMBAT_AGONYDAMAGE) -- Aplica o dano ao jogador
            end
        end
    end
    return true
end

-- Configurações do MoveEvent para "stepin" e registro dos Action IDs
bakragoreHealMove:type("stepin")
bakragoreHealMove:aid(actionId1) -- Usa o action ID 33128
bakragoreHealMove:aid(actionId2) -- Usa o action ID 33129
bakragoreHealMove:register()
