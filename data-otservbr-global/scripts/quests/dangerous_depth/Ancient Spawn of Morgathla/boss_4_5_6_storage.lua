local deathEvent = CreatureEvent("MonsterKillStoragebosswar")

function deathEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    -- Verifica se a criatura é uma das que devem dar storage ao morrer
    local creatureName = creature:getName():lower()

    -- IDs das storages e as criaturas associadas
    local storages = {
        ["the count of the core"] = 65104,
        ["the duke of the depths"] = 65105,
        ["the baron from below"] = 65106,

    }

    -- Verifica se o nome da criatura está no dicionário de storages
    if not storages[creatureName] then
        return true
    end

    local currentTime = os.time() -- Obtém o tempo atual em segundos
    local resetTime = 30 * 60 -- 30 minutos em segundos (1800 segundos)

    -- Nome da storage de tempo associada à criatura
    local timeStorage = storages[creatureName] + 100000 -- Storage associada para o tempo

    -- Posição da criatura morta
    local creaturePosition = creature:getPosition()

    -- Definir raio de 15 tiles em todas as direções
    local radiusX, radiusY, radiusZ = 20, 20, 20

    -- Encontra todos os jogadores no raio de 15 tiles em todas as direções ao redor da posição da criatura morta
    local spectators = Game.getSpectators(creaturePosition, false, true, radiusX, radiusX, radiusY, radiusY, -radiusZ, radiusZ)

    -- Para cada jogador encontrado, aplicar a lógica de dar a storage
    for _, spectator in ipairs(spectators) do
        if spectator:isPlayer() then
            local player = spectator

            -- Verifica se o jogador já matou a criatura nos últimos 30 minutos
            local lastKillTime = player:getStorageValue(timeStorage)

            if lastKillTime <= 0 or currentTime >= lastKillTime + resetTime then
                -- Define a storage da criatura
                player:setStorageValue(storages[creatureName], 1)

                -- Define o tempo atual na storage de tempo
                player:setStorageValue(timeStorage, currentTime)

                -- Atualiza o Quest Log
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Quest Log atualizado: Voce derrotou " .. creatureName .. ".")
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce avancou na quest ao derrotar " .. creatureName .. ".")

                -- Atualiza o quest log (substitua 12345 e 67890 pelos IDs reais da quest e da missão)
               -- player:updateQuestLog(12345, 67890) -- Exemplo de função que pode variar conforme o sistema de quest
            end
        end
    end

    return true
end

deathEvent:register()
