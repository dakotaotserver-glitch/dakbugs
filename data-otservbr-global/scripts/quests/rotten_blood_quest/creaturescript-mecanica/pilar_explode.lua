local DAMAGE_STORAGE = 65088 -- ID de storage temporária para verificar se o jogador já está recebendo o dano

local function resetDamageStorage(playerId)
    local player = Player(playerId)
    if player then
        player:setStorageValue(DAMAGE_STORAGE, -1) -- Reseta a storage após 30 segundos
    end
end

local function applyTurnDamage(playerId, remainingTurns)
    local player = Player(playerId)
    if player and remainingTurns > 0 and player:getHealth() > 0 then
        -- Aplica dano de 300 a 600 pontos
        local damage = math.random(0, 1000)
        player:addHealth(-damage)

        -- Aplica o efeito visual na posição do jogador
        player:getPosition():sendMagicEffect(177)

        -- Reduz o número de turnos restantes
        remainingTurns = remainingTurns - 1

        -- Se houver mais turnos restantes, agenda o próximo dano para 3 segundos depois
        if remainingTurns > 0 then
            addEvent(applyTurnDamage, 3000, playerId, remainingTurns)
        else
            -- Remove a flag de dano após todos os turnos serem concluídos
            player:setStorageValue(DAMAGE_STORAGE, -1)
        end
    end
end

local function applyDamageAndRemovePillar(pillarPosition)
    -- Encontra os jogadores dentro de um raio de 2x2 ao redor do Pillar Of Dark Energy
    local nearbyPlayers = Game.getSpectators(pillarPosition, false, true, 2, 2, 2, 2)

    -- Aplica o efeito de CONST_ME_BIGCLOUDS na posição do pilar uma vez
    pillarPosition:sendMagicEffect(CONST_ME_BIGCLOUDS)

    -- Remove a criatura Pillar Of Dark Energy
    local pillar = Tile(pillarPosition):getTopCreature()
    if pillar and pillar:getName():lower() == "pillar of dark energy" then
        pillar:remove()
    end

    -- Se houver algum jogador no raio de 2x2, inicia o ciclo de dano de 300 a 600 pontos por 10 turnos, uma única vez
    for _, player in ipairs(nearbyPlayers) do
        if player:isPlayer() then
            -- Verifica se o jogador já está recebendo o dano (para evitar múltiplas aplicações)
            if player:getStorageValue(DAMAGE_STORAGE) ~= 1 then
                -- Marca o jogador como "recebendo dano"
                player:setStorageValue(DAMAGE_STORAGE, 1)
                
                -- Aplica o efeito uma vez na posição do Pillar
                pillarPosition:sendMagicEffect(CONST_ME_BIGCLOUDS)

                -- Inicia o ciclo de dano, 10 turnos, um a cada 3 segundos
                applyTurnDamage(player:getId(), 10)

                -- Garante que a storage seja resetada após 30 segundos, caso o ciclo não complete
                addEvent(resetDamageStorage, 30000, player:getId())
            end
        end
    end
end

local pillarEffect = CreatureEvent("PillarOfDarkEnergyEffect")
function pillarEffect.onThink(creature)
    if creature:getName():lower() ~= "pillar of dark energy" then
        return true
    end

    -- Verifica se há jogadores num raio de 10x10
    local spectators = Game.getSpectators(creature:getPosition(), false, true, 10, 10, 10, 10)
    for _, player in ipairs(spectators) do
        if player:isPlayer() then
            -- Agenda a remoção do Pillar e a aplicação do efeito após 5 segundos
            addEvent(applyDamageAndRemovePillar, 5000, creature:getPosition())
            break
        end
    end

    return true
end

pillarEffect:register()
