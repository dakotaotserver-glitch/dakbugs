local scourgeEvent = CreatureEvent("ScourgeEvent")

-- Posições usadas no script
local teleportPosition = Position(32725, 32709, 11)

-- Função para criar uma criatura aleatória e removê-la após 10 segundos
local function createRandomScourge(position)
    local creatures = {"The Scourge of Oblivion blue", "The Scourge of Oblivion red"}
    local randomIndex = math.random(#creatures)
    local creatureName = creatures[randomIndex]
    
    -- Cria a criatura aleatória na posição especificada
    local monster = Game.createMonster(creatureName, position)
    
    if monster then
        -- Agendar a remoção da criatura após 10 segundos (10000 ms)
        addEvent(function()
            if monster then
                -- Armazena a posição atual da criatura antes de removê-la
                local monsterPosition = monster:getPosition()
                monster:remove()
                
                -- Verifica se a criatura "The Scourge of Oblivion" está na posição de teleporte
                local scourge = Tile(teleportPosition):getTopCreature()
                if scourge and scourge:getName() == "The Scourge of Oblivion" then
                    -- Teleporta "The Scourge of Oblivion" para a posição onde a criatura removida estava
                    scourge:teleportTo(monsterPosition)
                    -- monsterPosition:sendMagicEffect(CONST_ME_TELEPORT)
                end
            end
        end, 8000)
    end
end

function scourgeEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName() == "The Scourge of Oblivion" and attacker then  -- Verifica se foi atacada
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()
        
        -- Verifica se a vida está acima de 5% antes de teleportar para a posição fixa
        if currentHealth > maxHealth * 0.05 then
            -- Verifica se deve ocorrer o teleporte (20% de chance)
            if math.random() <= 0.03 then
                local currentPosition = creature:getPosition()
                
                -- Teleporta a criatura para a nova posição
                creature:teleportTo(teleportPosition, true)  -- A flag 'true' garante que a criatura será teleportada
                -- teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
                
                -- Cria uma criatura aleatória na posição original da criatura
                createRandomScourge(currentPosition)
            end
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

scourgeEvent:register()
