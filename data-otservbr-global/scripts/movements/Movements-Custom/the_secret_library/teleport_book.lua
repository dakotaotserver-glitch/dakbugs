local actionId = 33026

-- Definir as posições de destino e suas probabilidades
local destinationPositions = {
    Position(32687, 32707, 10),
    Position(32698, 32715, 10),
    Position(32693, 32729, 10),
    Position(32681, 32729, 10),
    Position(32676, 32715, 10)
}

-- Lista para manter o controle das posições disponíveis
local availablePositions = {}

-- Função para inicializar ou resetar a lista de posições disponíveis
local function resetAvailablePositions()
    availablePositions = {}
    for _, pos in ipairs(destinationPositions) do
        table.insert(availablePositions, pos)
    end
end

-- Função para escolher uma posição aleatória sem repetição
local function getRandomPosition()
    if #availablePositions == 0 then
        -- Se todas as posições foram usadas, resetar a lista
        resetAvailablePositions()
    end

    -- Escolher uma posição aleatória da lista disponível
    local randomIndex = math.random(#availablePositions)
    local selectedPosition = availablePositions[randomIndex]

    -- Remover a posição escolhida da lista
    table.remove(availablePositions, randomIndex)

    return selectedPosition
end

local teleportItemEvent = MoveEvent()

function teleportItemEvent.onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() and item:getActionId() == actionId then
        local destination = getRandomPosition()
        if destination then
            creature:teleportTo(destination)
            destination:sendMagicEffect(CONST_ME_TELEPORT)
        end
    end
    return true
end

teleportItemEvent:type("stepin")
teleportItemEvent:aid(actionId)
teleportItemEvent:register()

-- Inicializa a lista de posições disponíveis quando o script é carregado
resetAvailablePositions()
