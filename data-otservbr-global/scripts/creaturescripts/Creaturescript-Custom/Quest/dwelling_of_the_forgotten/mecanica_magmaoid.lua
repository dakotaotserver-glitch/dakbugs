local creatureDeathEvent = CreatureEvent("MagmaoidMassiveMagmaoidDeath")

local magmaoidDeathCount = 0
local massiveMagmaoidDeathCount = 0

local function spawnMassiveMagmaoids()
    local position1 = Position(32500, 31152, 15)
    local position2 = Position(32500, 31158, 15)
    Game.createMonster("Massive Magmaoid", position1)
    Game.createMonster("Massive Magmaoid", position2)
end

local function teleportMegaMagmaoid()
    local megaMagmaoidPosition = Position(32477, 31149, 15)
    local megaMagmaoid = Tile(megaMagmaoidPosition):getTopCreature()

    if megaMagmaoid and megaMagmaoid:getName() == "The Mega Magmaoid" then
        local teleportPosition = Position(32500, 31155, 15)
        megaMagmaoid:teleportTo(teleportPosition)
        teleportPosition:sendMagicEffect(CONST_ME_FIREAREA)
    end
end

local function createTemporaryItem(position)
    local item = Game.createItem(32416, 1, position)
    if item then
        item:setActionId(33083)
        addEvent(function()
            local tile = Tile(position)
            if tile then
                local tempItem = tile:getItemById(32416)
                if tempItem then
                    tempItem:remove()
                end
            end
        end, 10 * 60 * 1000) -- 10 minutos em milissegundos
    end
end

local function grantStorageToParticipants(creature, storageId, duration)
    local participants = creature:getDamageMap() -- Obtém os jogadores que participaram da morte
    local durationInSeconds = duration * 60 * 60 -- 20 horas convertidas para segundos
    for pid, _ in pairs(participants) do
        local player = Player(pid)
        if player then
            player:setStorageValue(storageId, 1) -- Concede a storage
            addEvent(function()
                player:setStorageValue(storageId, -1) -- Reseta a storage após o tempo
            end, durationInSeconds * 1000) -- 20 horas em milissegundos
        end
    end
end

function creatureDeathEvent.onDeath(creature, corpse, deathList)
    local creatureName = creature:getName()
    local deathPosition = creature:getPosition()

    if creatureName == "Magmaoid" then
        magmaoidDeathCount = magmaoidDeathCount + 1
        if magmaoidDeathCount >= 4 then
            spawnMassiveMagmaoids()
            magmaoidDeathCount = 0 -- Reset counter after spawning
        end
        createTemporaryItem(deathPosition)
    elseif creatureName == "Massive Magmaoid" then
        massiveMagmaoidDeathCount = massiveMagmaoidDeathCount + 1
        if massiveMagmaoidDeathCount >= 2 then
            teleportMegaMagmaoid()
            massiveMagmaoidDeathCount = 0 -- Reset counter after teleportation
        end
        createTemporaryItem(deathPosition)
    elseif creatureName == "The Mega Magmaoid" then
        grantStorageToParticipants(creature, 65071, 20) -- Concede a storage de 20 horas para os participantes
    end
    return true
end

creatureDeathEvent:register()
