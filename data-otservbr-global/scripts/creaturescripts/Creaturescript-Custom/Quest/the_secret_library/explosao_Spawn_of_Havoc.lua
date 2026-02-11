local spawnOfHavocDeath = CreatureEvent("SpawnOfHavocDeath")

function spawnOfHavocDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if creature:getName():lower() == "spawn of havoc" then
        local deathPosition = creature:getPosition() -- Posição onde a criatura morreu
        local damageAmount = 1228 -- Dano a ser aplicado
        local effect = CONST_ME_HITBYFIRE -- Efeito visual de fogo

        -- Define a área de 2x2 ao redor da posição da morte
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

        local damagedPlayers = {} -- Tabela para armazenar jogadores que já receberam dano

        -- Aplica o dano e o efeito em cada posição na área de 2x2
        for _, pos in ipairs(positions) do
            local spectators = Game.getSpectators(pos, false, true, 0, 0, 0, 0)
            for _, spectator in ipairs(spectators) do
                if spectator:isPlayer() and not damagedPlayers[spectator:getId()] then
                    spectator:addHealth(-damageAmount) -- Aplica o dano
                    damagedPlayers[spectator:getId()] = true -- Marca o jogador como já danificado
                end
            end
            pos:sendMagicEffect(effect) -- Aplica o efeito visual de fogo
        end
    end
    return true
end

spawnOfHavocDeath:register()
