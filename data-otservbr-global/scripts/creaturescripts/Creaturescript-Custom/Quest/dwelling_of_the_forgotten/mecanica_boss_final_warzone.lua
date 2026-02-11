local brainstealerInvulnerability = CreatureEvent("brainstealerInvulnerability")

-- Variáveis globais para rastrear o estado do boss e as criaturas "Mental-nexus"
local mentalNexusCreated = false
local deadMentalNexusCount = 0
local brainstealerIsInvulnerable = false
local invulnerabilityApplied = false -- Variável para garantir que a invulnerabilidade seja aplicada apenas uma vez

-- Função para verificar se ambas as "Mental-nexus" estão mortas
local function areBothMentalNexusDead()
    return deadMentalNexusCount >= 2
end

-- Função principal de mudança de vida
function brainstealerInvulnerability.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
    if creature and creature:isMonster() and creature:getName() == "The Brainstealer" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()

        -- Verifica se a criatura atingiu 50% da vida e a torna invulnerável apenas uma vez
        if currentHealth <= (maxHealth * 0.50) and not invulnerabilityApplied then
            -- Apenas cria as criaturas "Mental-nexus" se elas ainda não foram criadas
            if not mentalNexusCreated then
                local position1 = Position(32498, 31119, 15)
                local position2 = Position(32498, 31129, 15)

                -- Verifica se já existe uma criatura em cada posição antes de criar
                if not Tile(position1):getTopCreature() or Tile(position1):getTopCreature():getName() ~= "Mental-nexus" then
                    Game.createMonster("Mental-nexus", position1)
                end

                if not Tile(position2):getTopCreature() or Tile(position2):getTopCreature():getName() ~= "Mental-nexus" then
                    Game.createMonster("Mental-nexus", position2)
                end

                -- Marca que as criaturas foram criadas
                mentalNexusCreated = true
            end

            -- Aplica o efeito 171 e faz a criatura dizer "invulnerável" em laranja
            creature:getPosition():sendMagicEffect(171)
            creature:say("invulnerável", TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())

            -- Marca que "The Brainstealer" está invulnerável e a invulnerabilidade foi aplicada
            brainstealerIsInvulnerable = true
            invulnerabilityApplied = true -- Garante que essa ação ocorra apenas uma vez

            -- Torna a criatura invulnerável impedindo que receba dano
            return false
        end

        -- Se ambas as "Mental-nexus" estiverem mortas, "The Brainstealer" se torna vulnerável novamente
        if areBothMentalNexusDead() and brainstealerIsInvulnerable then
            -- Aplica o efeito 171 e faz a criatura dizer "vulnerável" em laranja
            creature:getPosition():sendMagicEffect(171)
            creature:say("vulnerável", TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())

            -- Marca que o "The Brainstealer" está vulnerável
            brainstealerIsInvulnerable = false

            -- Permite que a criatura receba dano novamente
            return primaryDamage, primaryType, secondaryDamage, secondaryType
        end

        -- Se o "The Brainstealer" ainda está invulnerável, ele não pode receber dano
        if brainstealerIsInvulnerable then
            return false
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

-- Evento quando uma criatura "Mental-nexus" morre
local mentalNexusDeath = CreatureEvent("mentalNexusDeath")

function mentalNexusDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if creature:getName() == "Mental-nexus" then
        -- Aplica o efeito 216 na posição da criatura "Mental-nexus"
        creature:getPosition():sendMagicEffect(CONST_ME_GREENSMOKE)
        deadMentalNexusCount = deadMentalNexusCount + 1
    end
    return true
end

mentalNexusDeath:register()
brainstealerInvulnerability:register()

function Monster:setBrainstealerInvulnerable()
    self:registerEvent("brainstealerInvulnerability")
    return true
end

function Monster:removeBrainstealerInvulnerable()
    self:unregisterEvent("brainstealerInvulnerability")
    return true
end
