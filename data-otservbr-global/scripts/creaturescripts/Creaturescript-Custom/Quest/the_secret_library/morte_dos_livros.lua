local gorzindelImmunity = CreatureEvent("GorzindelImmunity")
local knowledgeDeaths = {}

function gorzindelImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature or not creature:isMonster() or creature:getName():lower() ~= "gorzindel" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    
    -- Se Gorzindel estiver invulnerável, bloqueia o dano
    local creatureId = creature:getId()
    if not knowledgeDeaths[creatureId] or knowledgeDeaths[creatureId] < 5 then
        return false
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

gorzindelImmunity:register()

local knowledgeDeath = CreatureEvent("KnowledgeDeath")

function knowledgeDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if not creature or not creature:isMonster() then
        return true
    end

    local creatureName = creature:getName():lower()
    if creatureName == "stolen knowledge of armor" or 
       creatureName == "stolen knowledge of healing" or 
       creatureName == "stolen knowledge of lifesteal" or 
       creatureName == "stolen knowledge of spells" or 
       creatureName == "stolen knowledge of summoning" then
       
        local creaturesInRange = Game.getSpectators(Position(32687, 32715, 10), false, false, 30, 30, 30, 30)
        for _, foundCreature in ipairs(creaturesInRange) do
            if foundCreature:isMonster() and foundCreature:getName():lower() == "gorzindel" then
                local gorzindelId = foundCreature:getId()
                knowledgeDeaths[gorzindelId] = (knowledgeDeaths[gorzindelId] or 0) + 1
                if knowledgeDeaths[gorzindelId] >= 5 then
                    -- Torna Gorzindel vulnerável
                    foundCreature:removeInvulnerable()
                    foundCreature:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
                    -- Envia uma mensagem quando Gorzindel se tornar vulnerável
                    foundCreature:say("Gorzindel is now vulnerable!", TALKTYPE_MONSTER_SAY)
                end
                break
            end
        end
    end
    return true
end

knowledgeDeath:register()


-- Função para tornar o monstro invulnerável
function Monster:setInvulnerable()
    self:registerEvent("GorzindelImmunity")
    self:addCondition(Condition(CONDITION_INVULNERABLE))
    return true
end

-- Função para remover a invulnerabilidade do monstro
function Monster:removeInvulnerable()
    self:unregisterEvent("GorzindelImmunity")
    self:removeCondition(CONDITION_INVULNERABLE)
    return true
end
