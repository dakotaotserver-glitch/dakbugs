local countOfTheCoreEvent = CreatureEvent("CountOfTheCoreEvent")

local spawnInterval = 15000 -- Intervalo de 30 segundos
local spawnCount = 3 -- Número de criaturas "Snail Slime" a serem criadas
local maxHealthPercentage = 0.60 -- Percentual de saúde para ativar a mecânica
local countOfTheCoreSpawned = {} -- Tabela para armazenar se o spawn já foi iniciado para uma criatura

local function spawnSnailSlime(position)
    for i = 1, spawnCount do
        local spawnPosition = Position(position.x + math.random(-2, 2), position.y + math.random(-2, 2), position.z)
        Game.createMonster("Snail Slime", spawnPosition)
    end
end

function countOfTheCoreEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName():lower() == "the count of the core" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()
        local creatureId = creature:getId()

        -- Verificar se a saúde atual está em 50% ou menos e se o spawn já não foi iniciado
        if currentHealth <= maxHealth * maxHealthPercentage and not countOfTheCoreSpawned[creatureId] then
            countOfTheCoreSpawned[creatureId] = true -- Marca o spawn como iniciado

            -- Cria um evento que spawnará as criaturas de 30 em 30 segundos
            local function startSpawning()
                if creature:isRemoved() or creature:getHealth() > maxHealth * maxHealthPercentage then
                    return -- Se a criatura foi removida ou sua vida aumentou, interrompe o spawn
                end

                -- Spawna as criaturas "Snail Slime"
                spawnSnailSlime(creature:getPosition())

                -- Reagendar o spawn a cada 30 segundos
                addEvent(startSpawning, spawnInterval)
            end

            -- Inicia o spawn de "Snail Slime" a cada 30 segundos
            startSpawning()
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

countOfTheCoreEvent:register()
