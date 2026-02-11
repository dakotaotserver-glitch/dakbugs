local brainHeadImmunity = CreatureEvent("BrainHeadImmunity")
local cerebellumDeaths = {}

function brainHeadImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:isMonster() and creature:getName():lower() == "brain head" then
        -- Se o Brain Head estiver invulnerável, bloqueia o dano
        if not cerebellumDeaths[creature:getId()] or cerebellumDeaths[creature:getId()] < 8 then
            return false
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

brainHeadImmunity:register()

local cerebellumDeath = CreatureEvent("CerebellumDeath")

function cerebellumDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if creature and creature:isMonster() and creature:getName():lower() == "cerebellum" then
        -- Busca pelo Brain Head no raio especificado
        local cerebellumPosition = creature:getPosition()
        local creaturesInRange = Game.getSpectators(cerebellumPosition, false, false, 20, 20, 20, 20)
        for _, foundCreature in ipairs(creaturesInRange) do
            if foundCreature:isMonster() and foundCreature:getName():lower() == "brain head" then
                local brainHeadId = foundCreature:getId()
                cerebellumDeaths[brainHeadId] = (cerebellumDeaths[brainHeadId] or 0) + 1
                if cerebellumDeaths[brainHeadId] >= 8 then
                    -- Torna o Brain Head vulnerável
                    foundCreature:removeInvulnerable()
                    foundCreature:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
                    -- Envia uma mensagem quando o Brain Head se tornar vulnerável
                    foundCreature:say("The Brain Head is now vulnerable!", TALKTYPE_MONSTER_SAY)
                end
                break
            end
        end
    end
    return true
end

cerebellumDeath:register()

-- Função para tornar o monstro invulnerável
function Monster:setInvulnerable()
    self:registerEvent("BrainHeadImmunity")
    return true
end

-- Função para remover a invulnerabilidade do monstro
function Monster:removeInvulnerable()
    self:unregisterEvent("BrainHeadImmunity")
    return true
end
