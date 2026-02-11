local elderBloodjawTeleport = MoveEvent()

local actionId = 33119
local teleportPosition1 = Position(33092, 32362, 15)
local returnPosition1 = Position(33043, 32367, 15)
local teleportPosition2 = Position(33093, 32364, 15)
local returnPosition2 = Position(33043, 32367, 15)
local teleportDelay1 = 15 -- seconds
local teleportDelay2 = 15 -- seconds

-- Função para teleportar de volta a criatura
local function teleportBack(creature, returnPosition, delay)
    addEvent(function()
        if creature:isRemoved() then return end
        creature:teleportTo(returnPosition)
        returnPosition:sendMagicEffect(223) -- Efeito de teleporte vermelho
    end, delay * 1000)
end

function elderBloodjawTeleport.onStepIn(creature, item, position, fromPosition)
    if not creature:isMonster() or creature:getName():lower() ~= "elder bloodjaw" then
        return true
    end

    local currentPosition = creature:getPosition()

    -- Verifica se a criatura passou por cima de um item com Action ID específico
    if item:getActionId() == actionId then
        position:sendMagicEffect(223) -- Efeito de teleporte vermelho na posição do item
    end

    -- Teleporta a criatura para a primeira posição com efeito vermelho
    if currentPosition == returnPosition1 then
        creature:teleportTo(teleportPosition1)
        teleportPosition1:sendMagicEffect(223) -- Efeito de teleporte vermelho
        teleportBack(creature, returnPosition1, teleportDelay1)

    -- Teleporta a criatura para a segunda posição com efeito vermelho
    elseif currentPosition == returnPosition2 then
        creature:teleportTo(teleportPosition2)
        teleportPosition2:sendMagicEffect(223) -- Efeito de teleporte vermelho
        teleportBack(creature, returnPosition2, teleportDelay2)

    -- Caso contrário, teleporta para a primeira posição e aplica o efeito vermelho
    else
        creature:teleportTo(teleportPosition1)
        teleportPosition1:sendMagicEffect(223) -- Efeito de teleporte vermelho
        teleportBack(creature, returnPosition1, teleportDelay1)
    end

    return true
end

elderBloodjawTeleport:type("stepin")
elderBloodjawTeleport:aid(actionId)
elderBloodjawTeleport:register()
