local elderBloodjawAgony = MoveEvent()

local actionId = 33125
local centralPosition = Position(33043, 32335, 15) -- posição central fixa
local searchRadius = {x = 10, y = 10, z = 10}
local firstDelay = 6000
local secondDelay = 12000
local lastDamageTime = 0

local BOSS_NAME = "elderbloodjaw"

local function applyAgonyDamage(player)
    if player and player:isPlayer() then
        local damage = math.random(1000, 2000)
        player:addHealth(-damage, COMBAT_PHYSICALDAMAGE) -- Troque para COMBAT_AGONYDAMAGE se desejar
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce foi atingido pelo Agony!")
    end
end

local function normalizeName(name)
    return name:lower():gsub("%s+", "")
end

local function triggerAgony(creature)
    if not creature then
        return
    end

    local creatureName = creature:getName()
    if not creature:isMonster() then
        return
    end

    if normalizeName(creatureName) ~= BOSS_NAME then
        return
    end

    local currentTime = os.time()
    if currentTime - lastDamageTime < 12 then
        return
    end

    local playersInRange = Game.getSpectators(
        centralPosition, false, true,
        searchRadius.x, searchRadius.x,
        searchRadius.y, searchRadius.y,
        searchRadius.z, searchRadius.z
    )

    for _, player in pairs(playersInRange) do
        if player:isPlayer() and (player:getVocation():getId() == 4 or player:getVocation():getId() == 8) then
            lastDamageTime = currentTime

            addEvent(function()
                applyAgonyDamage(player)
            end, firstDelay)

            addEvent(function()
                applyAgonyDamage(player)
            end, secondDelay)

            break -- Apenas o primeiro Knight/Elite Knight recebe (remova para afetar todos)
        end
    end
end

function elderBloodjawAgony.onStepIn(creature, item, position, fromPosition)
    if item:getActionId() == actionId then
        triggerAgony(creature)
    end
    return true
end

elderBloodjawAgony:type("stepin")
elderBloodjawAgony:aid(actionId)
elderBloodjawAgony:register()

_G.triggerElderBloodjawAgony = triggerAgony
