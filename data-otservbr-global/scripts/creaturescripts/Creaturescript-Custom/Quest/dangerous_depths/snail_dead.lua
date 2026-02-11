local snailDeathEffect = CreatureEvent("SnailDeathEffect")

function snailDeathEffect.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if not creature:isMonster() or creature:getName():lower() ~= "snail slime" then
        return true
    end

    local position = creature:getPosition()

    -- Cria o efeito de fogo em área 2x2 na posição da criatura Snail Slime
    for x = -1, 1 do
        for y = -1, 1 do
            local targetPos = Position(position.x + x, position.y + y, position.z)
            targetPos:sendMagicEffect(CONST_ME_HITBYFIRE)
        end
    end

    -- Verifica se "The Count of the Core" está próximo e aplica a cura
    local spectators = Game.getSpectators(position, false, false, 1, 1, 1, 1)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and spectator:getName():lower() == "the count of the core" then
            -- Cura "The Count of the Core" com uma quantidade aleatória entre 0 e 2000 pontos de vida
            local healAmount = math.random(0, 5000)
            spectator:addHealth(healAmount)
            break
        end
    end

    return true
end

snailDeathEffect:register()
