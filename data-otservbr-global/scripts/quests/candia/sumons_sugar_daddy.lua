local sugarDaddyThink = CreatureEvent("SugarDaddyThink")

-- Agora cada boss terá sua própria tabela de fases executadas e invocações
local bossData = {} -- [sugarDaddyId] = { phases = {...}, summons = {...} }

local function summonCreatures(creature, creatureName, count)
    local position = creature:getPosition()
    local radiusX, radiusY = 3, 3
    local sugarDaddyId = creature:getId()
    bossData[sugarDaddyId].summons = {}

    for _ = 1, count do
        local newPosX = position.x + math.random(-radiusX, radiusX)
        local newPosY = position.y + math.random(-radiusY, radiusY)
        local newPosition = Position(newPosX, newPosY, position.z)

        local summoned = Game.createMonster(creatureName, newPosition)
        if summoned then
            table.insert(bossData[sugarDaddyId].summons, summoned:getId())
            summoned:registerEvent("SugarDaddySummonDeath")
        end
    end

    if #bossData[sugarDaddyId].summons > 0 then
        creature:registerEvent("SugarDaddyImmunity")
        creature:say("I am invulnerable until my minions are defeated!", TALKTYPE_MONSTER_SAY)
    end
end

function sugarDaddyThink.onThink(creature)
    if creature and creature:isMonster() and creature:getName() == "Sugar Daddy" then
        local id = creature:getId()
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()

        -- Inicializa as tabelas de fases e summons por boss se necessário
        if not bossData[id] then
            bossData[id] = {
                phases = { [90] = false, [60] = false, [30] = false },
                summons = {}
            }
        end

        -- Sempre remove imunidade ao pensar, só ativa ao invocar minions
        creature:unregisterEvent("SugarDaddyImmunity")

        -- Fases de invocação (agora por boss!)
        if currentHealth <= maxHealth * 0.90 and not bossData[id].phases[90] then
            summonCreatures(creature, "Sugar Cube", 5)
            bossData[id].phases[90] = true
        end
        if currentHealth <= maxHealth * 0.60 and not bossData[id].phases[60] then
            summonCreatures(creature, "Fruit Drop", 5)
            bossData[id].phases[60] = true
        end
        if currentHealth <= maxHealth * 0.30 and not bossData[id].phases[30] then
            summonCreatures(creature, "Truffle Worker", 5)
            bossData[id].phases[30] = true
        end
    end

    return true
end

sugarDaddyThink:register()

-- Evento para controlar a invulnerabilidade com base na morte das criaturas invocadas
local sugarDaddyDeath = CreatureEvent("SugarDaddySummonDeath")

function sugarDaddyDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    -- Procura em todos os Sugar Daddy ativos
    for sugarDaddyId, data in pairs(bossData) do
        local summons = data.summons
        for index, summonId in ipairs(summons) do
            if summonId == creature:getId() then
                table.remove(summons, index)
                break
            end
        end

        -- Se não há mais invocações, o Sugar Daddy fica vulnerável
        if #summons == 0 then
            local sugarDaddy = Creature(sugarDaddyId)
            if sugarDaddy and sugarDaddy:isMonster() and sugarDaddy:getName() == "Sugar Daddy" then
                sugarDaddy:unregisterEvent("SugarDaddyImmunity")
                sugarDaddy:say("I am vulnerable again!", TALKTYPE_MONSTER_SAY)
            end
        end
    end
    return true
end

sugarDaddyDeath:register()

-- Evento de imunidade do Sugar Daddy
local sugarDaddyImmunity = CreatureEvent("SugarDaddyImmunity")

function sugarDaddyImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:isMonster() and creature:getName() == "Sugar Daddy" then
        return false -- Bloqueia todo o dano enquanto estiver invulnerável
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

sugarDaddyImmunity:register()

-- (Opcional) Limpa os dados do boss após a morte dele
local sugarDaddyFinalDeath = CreatureEvent("SugarDaddyFinalDeath")

function sugarDaddyFinalDeath.onDeath(creature, corpse, killer, mostDamageKiller)
    if creature and creature:isMonster() and creature:getName() == "Sugar Daddy" then
        bossData[creature:getId()] = nil -- Limpa as tabelas daquele boss
    end
    return true
end

sugarDaddyFinalDeath:register()
