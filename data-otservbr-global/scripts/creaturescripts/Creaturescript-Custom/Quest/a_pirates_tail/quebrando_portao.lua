local rumBarrelDeath = CreatureEvent("RumBarrelDeath")

function rumBarrelDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local deathPosition = creature:getPosition()
    local damageToWeakSpot = 12500
    local playerDamage = 2000
    local radius = 1
    local effect = CONST_ME_HITBYFIRE
    local fireEffect = CONST_ME_HITBYFIRE

    -- Função para encontrar a criatura 'Weak Spot' a EXATAMENTE 1 SQM de distância
    local function findNearbyWeakSpot(position, radius)
        local nearbyCreatures = Game.getSpectators(position, false, false, radius, radius, radius, radius)
        for _, target in ipairs(nearbyCreatures) do
            if target:isMonster() and target:getName():lower() == "weak spot" then
                local dx = math.abs(position.x - target:getPosition().x)
                local dy = math.abs(position.y - target:getPosition().y)
                if math.max(dx, dy) == 1 then
                    return target
                end
            end
        end
        return nil
    end

    -- Aplicar dano à criatura 'Weak Spot' se estiver EXATAMENTE a 1 sqm de distância
    local weakSpot = findNearbyWeakSpot(deathPosition, radius)
    if weakSpot then
        weakSpot:addHealth(-damageToWeakSpot)
        weakSpot:getPosition():sendMagicEffect(effect)
    end

    -- Aplicar dano aos jogadores ao redor da posição da morte de 'Rum Barrel'
    local nearbyPlayers = Game.getSpectators(deathPosition, false, true, radius, radius, radius, radius)
    for _, player in ipairs(nearbyPlayers) do
        if player:isPlayer() then
            player:addHealth(-playerDamage)
            player:getPosition():sendMagicEffect(effect)
        end
    end

    -- Criar o efeito de fogo em uma área de 2x2 ao redor da posição da morte
    local positions = {
        Position(deathPosition.x - 1, deathPosition.y - 1, deathPosition.z),
        Position(deathPosition.x, deathPosition.y - 1, deathPosition.z),
        Position(deathPosition.x + 1, deathPosition.y - 1, deathPosition.z),
        Position(deathPosition.x - 1, deathPosition.y, deathPosition.z),
        Position(deathPosition.x + 1, deathPosition.y, deathPosition.z),
        Position(deathPosition.x - 1, deathPosition.y + 1, deathPosition.z),
        Position(deathPosition.x, deathPosition.y + 1, deathPosition.z),
        Position(deathPosition.x + 1, deathPosition.y + 1, deathPosition.z)
    }

    for _, pos in ipairs(positions) do
        pos:sendMagicEffect(fireEffect)
    end

    return true
end

rumBarrelDeath:register()
