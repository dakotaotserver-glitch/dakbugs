local agonyEvent = MoveEvent()

-- Configurações gerais
local actionId = 33105 -- Action ID do item original
local actionIdAlt = 33106 -- Novo Action ID
local damageMin = 100 -- Dano mínimo para o item 33105
local damageMax = 250 -- Dano máximo para o item 33105
local healMin = 500 -- Cura mínima para o item 33105
local healMax = 1000 -- Cura máxima para o item 33105
local damageMinAlt = 1000 -- Dano mínimo para o item 33106
local damageMaxAlt = 2500 -- Dano máximo para o item 33106
local healMinAlt = 1000 -- Cura mínima para o item 33106
local healMaxAlt = 2500 -- Cura máxima para o item 33106
local duration = 3 -- Número de vezes que o dano será aplicado (5 segundos para o item 33105)
local durationAlt = 10 -- Número de vezes que o dano será aplicado (20 segundos para o item 33106)
local attributeReductionDuration = 5000 -- Duração da redução de atributos (5 segundos para o item 33105)
local attributeReductionDurationAlt = 15000 -- Duração da redução de atributos (10 segundos para o item 33106)

-- Tabela para rastrear jogadores sob efeito de Agony
local playersUnderAgony = {}

-- Função para aplicar dano de Agony
function applyAgonyDamage(playerId, position, remainingTicks, damageMin, damageMax)
    local player = Player(playerId)
    if player and remainingTicks > 0 and player:getHealth() > 0 then
        -- Aplica dano de Agony
        local damage = math.random(damageMin, damageMax) * -1
        doTargetCombatHealth(0, player, COMBAT_AGONYDAMAGE, damage, damage, CONST_ME_NONE)

        -- Aplica um efeito visual de dano
        position:sendMagicEffect(CONST_ME_MORTAREA)

        -- Chama novamente a função após 2 segundos, até que o número de ticks restantes seja 0
        addEvent(applyAgonyDamage, 2000, playerId, position, remainingTicks - 1, damageMin, damageMax)
    end
end

-- Função para curar Ichgahal
function ichgahalHeal(creature, position, healMin, healMax)
    -- Cura Ichgahal
    local heal = math.random(healMin, healMax)
    creature:addHealth(heal)

    -- Aplica um efeito visual de cura
    position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
end

-- Função para aplicar a redução de atributos no jogador
function applyAttributeReduction(player, skillReduction, duration)
    if not player then return end
    
    local condition = Condition(CONDITION_ATTRIBUTES)
    condition:setParameter(CONDITION_PARAM_TICKS, duration) -- Define a duração da redução de atributos
    condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, skillReduction) -- Reduz a habilidade de distância
    condition:setParameter(CONDITION_PARAM_SKILL_DEFENSE, skillReduction) -- Reduz a habilidade de defesa
    condition:setParameter(CONDITION_PARAM_SKILL_MELEE, skillReduction) -- Reduz a habilidade de combate corpo a corpo
    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, skillReduction)

    -- Aplica a condição de redução de atributos no jogador
    player:addCondition(condition)
end

-- Função para liberar o jogador da tabela após o ciclo completo
function releasePlayerFromAgony(playerId)
    playersUnderAgony[playerId] = nil
end

-- Evento principal ativado ao pisar no item
function agonyEvent.onStepIn(creature, item, position, fromPosition)
    if creature then
        -- Verifica se é um jogador
        if creature:isPlayer() then
            local playerId = creature:getId()

            -- Verifica se o jogador já está sob efeito de Agony
            if playersUnderAgony[playerId] then
                
                return true
            end

            -- Marca o jogador como sob efeito de Agony
            playersUnderAgony[playerId] = true

            if item:getActionId() == actionId then
                -- Aplica o dano por 5 segundos (3 vezes com intervalo de 2 segundos)
                applyAgonyDamage(playerId, position, duration, damageMin, damageMax)
                -- Aplica a redução de atributos por 5 segundos
                applyAttributeReduction(creature, -20, attributeReductionDuration)

                -- Libera o jogador após o ciclo de dano
                addEvent(releasePlayerFromAgony, duration * 2000, playerId)

            elseif item:getActionId() == actionIdAlt then
                -- Aplica o dano por 20 segundos (10 vezes com intervalo de 2 segundos)
                applyAgonyDamage(playerId, position, durationAlt, damageMinAlt, damageMaxAlt)
                -- Aplica a redução de atributos por 10 segundos
                applyAttributeReduction(creature, -100, attributeReductionDurationAlt)

                -- Libera o jogador após o ciclo de dano
                addEvent(releasePlayerFromAgony, durationAlt * 2000, playerId)
            end

        -- Verifica se é a criatura Ichgahal
        elseif creature:isMonster() and creature:getName():lower() == "ichgahal" then
            if item:getActionId() == actionId then
                -- Cura Ichgahal uma vez (item 33105)
                ichgahalHeal(creature, position, healMin, healMax)
            elseif item:getActionId() == actionIdAlt then
                -- Cura Ichgahal uma vez (item 33106)
                ichgahalHeal(creature, position, healMinAlt, healMaxAlt)
            end
        end
    end
    return true
end

-- Configuração e registro do evento
agonyEvent:type("stepin")
agonyEvent:aid(actionId) -- Usa o Action ID 33105
agonyEvent:aid(actionIdAlt) -- Usa o Action ID 33106
agonyEvent:register()
