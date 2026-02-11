local skillReduction = -30 -- Quantidade de redução nos atributos para Greedok, Crultor e Vilear
local desporReduction = -50 -- Quantidade de redução nos atributos para Despor
local duration = 60000 -- Duração da condição em milissegundos (60 segundos)

-- Definindo a área onde a condição será aplicada
local fromPosition = Position(33194, 30935, 13) -- Posição inicial da área
local toPosition = Position(33224, 30978, 13)   -- Posição final da área

-- Função que aplica a condição de redução de atributos em um jogador
local function applyAttributeReduction(player, reductionValue)
    if not player or not player:isPlayer() then
        return
    end

    local condition = Condition(CONDITION_ATTRIBUTES)
    condition:setParameter(CONDITION_PARAM_TICKS, duration) -- Define a duração da condição
    condition:setParameter(CONDITION_PARAM_SKILL_MELEE, reductionValue) -- Reduz força de ataque corpo a corpo
    condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, reductionValue) -- Reduz habilidade de ataque à distância
    condition:setParameter(CONDITION_PARAM_SKILL_FIST, reductionValue) -- Reduz habilidade de ataque com os punhos
    condition:setParameter(CONDITION_PARAM_SKILL_SWORD, reductionValue) -- Reduz habilidade de ataque com espada
    condition:setParameter(CONDITION_PARAM_SKILL_AXE, reductionValue) -- Reduz habilidade de ataque com machado
    condition:setParameter(CONDITION_PARAM_SKILL_CLUB, reductionValue) -- Reduz habilidade de ataque com clava
    condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, reductionValue) -- Reduz habilidade de defesa
    condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, reductionValue) -- Reduz pontos de magia

    -- Aplica a condição ao jogador
    player:addCondition(condition)
end

-- Função chamada quando a criatura sofre alteração na saúde (evento onHealthChange)
local function onHealthChange(creature, attacker, damage, flags, damageType)
    -- Verifica se a criatura é uma das especificadas (Greedok, Crultor, Despor, Vilear) e sofreu dano
    if creature and creature:isMonster() and (creature:getName():lower() == "greedok" or creature:getName():lower() == "crultor" or creature:getName():lower() == "despor" or creature:getName():lower() == "vilear") and damage > 0 then
        -- Define a redução com base na criatura
        local reductionValue = skillReduction -- Valor padrão
        if creature:getName():lower() == "despor" then
            reductionValue = desporReduction -- Valor específico para Despor
        end

        -- Busca todos os jogadores dentro da área especificada
        local spectators = Game.getPlayers() -- Obtém todos os jogadores no servidor
        for _, player in ipairs(spectators) do
            -- Verifica se o jogador está dentro da área especificada e no mesmo andar (z)
            local playerPosition = player:getPosition()
            if playerPosition.z == fromPosition.z and playerPosition:isInRange(fromPosition, toPosition) then
                applyAttributeReduction(player, reductionValue)
            end
        end
    end
    return damage
end

-- Cria o evento e define a função associada
local greedokHealthChangeEvent = CreatureEvent("GreedokHealthChange")
greedokHealthChangeEvent.onHealthChange = onHealthChange

-- Registra o evento no servidor
greedokHealthChangeEvent:register()
