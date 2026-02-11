local itemAction = Action()

-- Define as posições específicas onde as criaturas "Force Field" devem ser removidas
local forceFieldPositions = {
    Position(32749, 32686, 10),
    Position(32750, 32686, 10),
    Position(32751, 32686, 10),
    Position(32752, 32686, 10),
    Position(32753, 32686, 10),
    Position(32754, 32687, 10),
    Position(32754, 32688, 10),
    Position(32754, 32689, 10),
    Position(32754, 32690, 10),
    Position(32754, 32691, 10),
    Position(32753, 32692, 10),
    Position(32752, 32692, 10),
    Position(32751, 32692, 10),
    Position(32750, 32692, 10),
    Position(32749, 32692, 10),
    Position(32748, 32691, 10),
    Position(32748, 32690, 10),
    Position(32748, 32689, 10),
    Position(32748, 32688, 10),
    Position(32748, 32687, 10)
}

-- Posição da criatura "Lokathmor Stuck"
local lokathmorPosition = Position(32751, 32689, 10)

-- Posição de destino para teletransporte
local lokathmorTeleportPosition = Position(32751, 32689, 10)

-- Função que remove criaturas "Force Field" e "Lokathmor Stuck"
local function removeCreatures()
    -- Remove criaturas "Force Field" nas posições especificadas
    for _, pos in ipairs(forceFieldPositions) do
        local creaturesInPosition = Game.getSpectators(pos, false, false, 0, 0, 0, 0)
        for _, creature in ipairs(creaturesInPosition) do
            if creature:isMonster() and creature:getName() == "Force Field" then
                creature:remove()
            end
        end
    end

    -- Remove a criatura "Lokathmor Stuck" na posição especificada
    local creaturesInLokathmorPosition = Game.getSpectators(lokathmorPosition, false, false, 0, 0, 0, 0)
    for _, creature in ipairs(creaturesInLokathmorPosition) do
        if creature:isMonster() and creature:getName() == "Lokathmor Stuck" then
            creature:remove()
        end
    end
end

-- Função para teleportar a criatura "Lokathmor"
local function teleportLokathmor()
    local lokathmorOriginalPosition = Position(32778, 32685, 10)
    local lokathmor = Game.getSpectators(lokathmorOriginalPosition, false, false, 1, 1, 1, 1)
    for _, creature in ipairs(lokathmor) do
        if creature:getName() == "Lokathmor" then
            creature:teleportTo(lokathmorTeleportPosition)
           -- lokathmorTeleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            break
        end
    end
end

-- Função que é chamada quando um item é usado
function itemAction.onUse(player, item, fromPosition, itemEx, toPosition, target, isHotkey)
    if item:getId() == 28488 and item:getActionId() == 33028 and itemEx:getId() == 27881 then
        -- Remover o item com actionId 33028
        item:remove(1)

        -- Fazer o efeito de cura azul na posição onde o item foi jogado
        toPosition:sendMagicEffect(CONST_ME_SOUND_RED)

        -- Remover todas as criaturas na área especificada
        removeCreatures()

        -- Teleportar a criatura "Lokathmor" após remover as outras criaturas
        teleportLokathmor()

        return true
    end

    return false
end

itemAction:aid(33028)
itemAction:register()
