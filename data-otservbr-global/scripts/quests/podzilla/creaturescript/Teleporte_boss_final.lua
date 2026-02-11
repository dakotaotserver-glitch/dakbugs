local teleportEvent = CreatureEvent("rooktrkrakenTeleport")

local roomBounds = {
    fromPosition = Position(33957, 32035, 11), -- canto superior esquerdo da sala
    toPosition = Position(33973, 32047, 11)   -- canto inferior direito da sala
}

-- Tabela para armazenar o último movimento da criatura
local creaturePositions = {}

function teleportEvent.onThink(creature)
    if not creature:isMonster() then
        return true
    end

    local creatureId = creature:getId()
    local currentPosition = creature:getPosition()
    local currentTime = os.time()

    -- Inicializa os dados da criatura, se ainda não estiverem armazenados
    if not creaturePositions[creatureId] then
        creaturePositions[creatureId] = { lastPosition = currentPosition, lastMoveTime = currentTime }
    end

    -- Verifica se a criatura ficou parada por 10 segundos
    local lastData = creaturePositions[creatureId]
    if lastData.lastPosition == currentPosition then
        if currentTime - lastData.lastMoveTime >= 15 then
            -- Teleporta a criatura por inatividade
            local newPosition = Position(
                math.random(roomBounds.fromPosition.x, roomBounds.toPosition.x),
                math.random(roomBounds.fromPosition.y, roomBounds.toPosition.y),
                roomBounds.fromPosition.z
            )
            creature:teleportTo(newPosition)
            newPosition:sendMagicEffect(46)

            -- Atualiza o tempo do último movimento para evitar teleportes seguidos
            creaturePositions[creatureId].lastMoveTime = currentTime
        end
    else
        -- Atualiza os dados se a criatura se moveu
        creaturePositions[creatureId].lastPosition = currentPosition
        creaturePositions[creatureId].lastMoveTime = currentTime
    end

    -- Verifica a chance de teleporte normal (2%)
    local chance = math.random(1, 100)
    if chance <= 0 then
        local newPosition = Position(
            math.random(roomBounds.fromPosition.x, roomBounds.toPosition.x),
            math.random(roomBounds.fromPosition.y, roomBounds.toPosition.y),
            roomBounds.fromPosition.z
        )
        creature:teleportTo(newPosition)
        newPosition:sendMagicEffect(46)
    end

    return true
end

teleportEvent:register()
