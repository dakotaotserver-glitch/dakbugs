local areaFromPosition = Position(32716, 32713, 10)
local areaToPosition = Position(32732, 32728, 10)
local teleportPosition = Position(32724, 32720, 10)
local actionId = 33030
local damage = 24000
local effectDelay = 5000 -- 5 segundos em milissegundos
local exemptLookType = 1065 -- LookType que não deve receber o dano

-- Função para aplicar efeito e dano
local function applyEffectAndDamage()
    -- Aplica um efeito de energia na área
    for x = areaFromPosition.x, areaToPosition.x do
        for y = areaFromPosition.y, areaToPosition.y do
            local position = Position(x, y, areaFromPosition.z)
            position:sendMagicEffect(CONST_ME_ENERGYAREA)
        end
    end

    -- Aplica dano a todos os jogadores na área, exceto os com lookType 1065
    local playersInArea = Game.getSpectators(areaFromPosition, false, true, 20, 20, 20, 20)
    for _, player in ipairs(playersInArea) do
        if player:isPlayer() then
            local outfit = player:getOutfit()
            local currentLookType = outfit.lookType
            if currentLookType ~= exemptLookType then
                -- Remove saúde do jogador
                player:addHealth(-damage) -- Supondo que addHealth subtrai saúde
            end
        end
    end
end

local function teleportCreature(creature)
    if creature and creature:isMonster() and creature:getName() == "Mazzinor" then
        creature:teleportTo(teleportPosition)
    end
end

-- Função chamada quando uma criatura pisa no item
local function onCreatureStepIn(creature, item, position, fromPosition)
    if creature:isMonster() and creature:getName() == "Mazzinor" and item:getActionId() == actionId then
        -- Adiciona um evento para aplicar o efeito e o dano após o atraso
        addEvent(applyEffectAndDamage, effectDelay)
        -- Adiciona um evento para teleportar a criatura após o atraso, passando a própria criatura como argumento
        addEvent(function() teleportCreature(creature) end, effectDelay)
    end
    return true
end

local stepInEvent = MoveEvent()
stepInEvent:type("stepin")
stepInEvent:aid(actionId)
stepInEvent:onStepIn(onCreatureStepIn)
stepInEvent:register()
