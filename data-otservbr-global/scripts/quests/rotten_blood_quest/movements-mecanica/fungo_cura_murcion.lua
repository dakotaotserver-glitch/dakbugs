local murcionHealMove = MoveEvent()

local actionId = 33097 -- Action ID do item
local healAmount = 15000 -- Quantidade de cura para Murcion
local damagePercent = 12.5 -- Percentual de dano baseado na vida atual para jogadores

function murcionHealMove.onStepIn(creature, item, position, fromPosition)
    if creature then
        -- Verifica se é a criatura Murcion
        if creature:isMonster() and creature:getName():lower() == "murcion" then
            if item:getActionId() == actionId then
                -- Cura 15000 pontos de vida
                local currentHealth = creature:getHealth()
                local maxHealth = creature:getMaxHealth()
                local newHealth = math.min(currentHealth + healAmount, maxHealth) -- Garante que a vida não exceda o máximo
                creature:addHealth(newHealth - currentHealth)

                -- Aplica efeito de cura vermelha
                position:sendMagicEffect(CONST_ME_MAGIC_RED)

                -- Remove o item do chão
                item:remove()
            end
        -- Verifica se é um jogador
        elseif creature:isPlayer() then
            if item:getActionId() == actionId then
                -- Calcula o dano com base em 12,5% da vida atual do jogador
                local player = creature
                local currentHealth = player:getHealth()
                local damage = math.floor(currentHealth * (damagePercent / 100)) -- Dano de 12,5% da vida atual

                -- Aplica o dano ao jogador
                player:addHealth(-damage)

                -- Aplica um efeito visual indicando o dano
                position:sendMagicEffect(CONST_ME_DRAWBLOOD)

                -- Remove o item do chão
                item:remove()
            end
        end
    end
    return true
end

murcionHealMove:type("stepin")
murcionHealMove:aid(actionId) -- Usa action ID ao invés de item ID
murcionHealMove:register()
