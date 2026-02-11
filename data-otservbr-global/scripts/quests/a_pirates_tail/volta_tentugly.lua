local creatureDeathEvent = CreatureEvent("TentuglyTentugliTentuglisDeath")

local bossSearchFrom = Position(33710, 31140, 7)
local bossSearchTo = Position(33725, 31160, 7)

local STORAGE_TENTUGLY  = 65131
local STORAGE_TENTUGLI  = 65132
local STORAGE_TENTUGLIS = 65133

local REQUIRED_TENTUGLY  = 17
local REQUIRED_TENTUGLI  = 10
local REQUIRED_TENTUGLIS = 4

-- NOVO: função para remover itens
local function removeBossItemsInArea()
    local fromPos = Position(33690, 31149, 6)
    local toPos   = Position(33736, 31190, 7)
    local itemIDs = {35110, 35120, 35107, 35600, 35109, 35112, 35126}

    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            for z = fromPos.z, toPos.z do
                local tile = Tile(Position(x, y, z))
                if tile then
                    for _, itemId in ipairs(itemIDs) do
                        local item = tile:getItemById(itemId)
                        while item do
                            item:remove()
                            item = tile:getItemById(itemId) -- caso haja mais de um item igual no mesmo tile
                        end
                    end
                end
            end
        end
    end
end

local function findBossInArea(fromPos, toPos)
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            for z = fromPos.z, toPos.z do
                local tile = Tile(Position(x, y, z))
                if tile then
                    local creature = tile:getTopCreature()
                    if creature and creature:getName() == "Tentugly's Head" then
                        return creature
                    end
                end
            end
        end
    end
    return nil
end

function creatureDeathEvent.onDeath(creature, corpse, deathList)
    local creatureName = creature:getName()

    local tentacleStorageIDs = {
        ["Tentugly"] = STORAGE_TENTUGLY,
        ["Tentugli"] = STORAGE_TENTUGLI,
        ["Tentuglis"] = STORAGE_TENTUGLIS,
    }
    local storageId = tentacleStorageIDs[creatureName]
    if not storageId then
        return true -- ignorar outros monstros
    end

    local boss = findBossInArea(bossSearchFrom, bossSearchTo)
    if not boss then
        return true
    end

    local count = boss:getStorageValue(storageId)
    if count < 0 then count = 0 end
    boss:setStorageValue(storageId, count + 1)

    local tentuglyCount = boss:getStorageValue(STORAGE_TENTUGLY)
    local tentugliCount = boss:getStorageValue(STORAGE_TENTUGLI)
    local tentuglisCount = boss:getStorageValue(STORAGE_TENTUGLIS)

    if tentuglyCount >= REQUIRED_TENTUGLY and tentugliCount >= REQUIRED_TENTUGLI and tentuglisCount >= REQUIRED_TENTUGLIS then
        -- Teleporta o boss!
        local teleportPosition = Position(33722, 31182, 7)
        boss:teleportTo(teleportPosition)
        teleportPosition:sendMagicEffect(CONST_ME_WATERSPLASH)

        -- REMOVE ITENS NA ÁREA:
        removeBossItemsInArea()

        -- Reseta os storages
        boss:setStorageValue(STORAGE_TENTUGLY, 0)
        boss:setStorageValue(STORAGE_TENTUGLI, 0)
        boss:setStorageValue(STORAGE_TENTUGLIS, 0)

       -- print("[Tentugly Event] Tentugly's Head teleportado após mortes de tentáculos! Itens removidos da área.")
    end

    return true
end

creatureDeathEvent:register()
