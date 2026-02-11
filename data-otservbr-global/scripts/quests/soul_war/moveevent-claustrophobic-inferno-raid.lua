local spawnMonsterName = "Brachiodemon"

-- Para cada raid configurada
for raidNumber, raid in ipairs(SoulWarQuest.claustrophobicInfernoRaids) do
    -- Nome para o Encounter
    local raidName = string.format("Claustrophobic Inferno Raid %d", raidNumber)
    -- Cria Encounter na zona correta
    local encounter = Encounter(raidName, {
        zone = raid.getZone(),
        timeToSpawnMonsters = "10s",
    })

    -- Calcula quantas waves (quantos ciclos de spawn)
    local spawnTimes = math.floor(SoulWarQuest.claustrophobicInfernoRaids.suriviveTime / SoulWarQuest.claustrophobicInfernoRaids.spawnTime)

    -- Adiciona os spawns programados (um monstro em cada posição, por wave)
    for i = 1, spawnTimes do
        encounter
            :addSpawnMonsters({
                {
                    name = spawnMonsterName,
                    positions = raid.spawns, -- Um monstro por posição listada
                },
            })
            :autoAdvance(SoulWarQuest.claustrophobicInfernoRaids.spawnTime * 1000)
    end

    -- Limpa tudo quando acabar o tempo
    function encounter:onReset(position)
        encounter:removeMonsters()
        addEvent(function(zone)
            zone:refresh()
            zone:removePlayers()
        end, SoulWarQuest.claustrophobicInfernoRaids.timeToKick * 1000, raid.getZone())
        logger.debug("{} has ended", raidName)
    end

    encounter:register()

    -- Evento para iniciar o Encounter quando o player pisa nos sand timers
    local raidMoveEvent = MoveEvent()

    function raidMoveEvent.onStepIn(creature, item, position, fromPosition)
        local player = creature:getPlayer()
        if not player then
            return true
        end
        -- Evita iniciar a raid vindo da própria zona (pode customizar)
        if fromPosition.y == position.y - (raidNumber % 2 ~= 0 and -1 or 1) then
            return
        end
        logger.debug("{} has started", raidName)
        encounter:start()
        return true
    end

    -- Registra o evento nas posições dos sand timers
    for _, pos in pairs(raid.sandTimerPositions) do
        raidMoveEvent:position(pos)
    end

    raidMoveEvent:register()
end
