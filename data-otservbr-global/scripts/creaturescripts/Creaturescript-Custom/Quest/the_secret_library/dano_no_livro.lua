-- Define o evento de dano
local damageOnApproach = CreatureEvent("DamageOnApproach")
local damageCooldown = 3000 -- tempo em milissegundos (3 segundos)
local lastDamage = {} -- tabela para armazenar o tempo do último dano por criatura

-- Função chamada periodicamente para aplicar dano
function damageOnApproach.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= "war servant" then
        return true
    end

    local currentTime = os.time() * 1000 -- tempo atual em milissegundos
    local creatureId = creature:getId()

    if not lastDamage[creatureId] then
        lastDamage[creatureId] = 0 -- inicializa o tempo do último dano se não existir
    end

    if currentTime - lastDamage[creatureId] < damageCooldown then
        return true -- se ainda não passou o cooldown, não faz nada
    end

    lastDamage[creatureId] = currentTime -- atualiza o tempo do último dano

    local creaturePosition = creature:getPosition()
    local spectators = Game.getSpectators(creaturePosition, false, false, 1, 1, 1, 1)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and spectator:getName():lower() == "the book of secrets" then
            spectator:addHealth(-1200) -- Corrigido: adiciona dano usando addHealth com valor negativo
        end
    end

    -- Envia o efeito em uma área 2x2 ao redor da posição do "War Servant"
    for x = -1, 1 do
        for y = -1, 1 do
            local effectPosition = Position(creaturePosition.x + x, creaturePosition.y + y, creaturePosition.z)
            effectPosition:sendMagicEffect(CONST_ME_HOLYDAMAGE)
        end
    end

    return true
end

-- Função para verificar e curar a criatura "The Devourer of Secrets"
local function checkAndHealDevourer()
    local positionToCheck = Position(32706, 32716, 11)
    local radius = 10
    local devourer = Game.getSpectators(positionToCheck, false, false, radius, radius, radius, radius)

    for _, creature in ipairs(devourer) do
        if creature:isMonster() and creature:getName():lower() == "the devourer of secrets" then
            creature:addHealth(50000) -- Cura a criatura em 50000 pontos de vida
        end
    end
end

-- Define o evento de morte da criatura "The Book of Secrets"
local bookOfSecretsDeath = CreatureEvent("BookOfSecretsDeath")

function bookOfSecretsDeath.onDeath(creature)
    if creature:getName():lower() == "the book of secrets" then
        checkAndHealDevourer() -- Verifica e cura a criatura "The Devourer of Secrets"
    end

    return true
end

-- Registra os eventos
damageOnApproach:register()
bookOfSecretsDeath:register()
