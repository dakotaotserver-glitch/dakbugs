GlobalStorage = GlobalStorage or {}
GlobalStorage.Hunted = GlobalStorage.Hunted or {
    One = 65150,
    Two = 65151,
    Three = 65152
}

local interval = 0.5 -- minutos

local positions = {
    top1 = Position({x = 32373, y = 32211, z = 7}),
    top2 = Position({x = 32375, y = 32211, z = 7}),
    top3 = Position({x = 32377, y = 32211, z = 7})
}
local mirroredPositions = {
    top1 = Position({x = 32199, y = 32306, z = 5}),
    top2 = Position({x = 32201, y = 32306, z = 5}),
    top3 = Position({x = 32203, y = 32306, z = 5})
}
local hiddenPosition = Position({x = 32376, y = 32208, z = 15})
local teleportDelay = 5000

local huntedPlayers = {}
local previousTopPlayers = {"", "", ""}

local function getTopHunted()
    local topPlayersQuery = db.storeQuery(
        "SELECT bl.target_name, " ..
        "COALESCE(p.lookbody, 0) as lookbody, COALESCE(p.lookfeet, 0) as lookfeet, " ..
        "COALESCE(p.lookhead, 0) as lookhead, COALESCE(p.looklegs, 0) as looklegs, " ..
        "COALESCE(p.looktype, 128) as looktype, COALESCE(p.lookaddons, 0) as lookaddons, " ..
        "bl.total_bounty, bl.time " ..
        "FROM bounty_list bl " ..
        "LEFT JOIN players p ON bl.target_name = p.name " ..
        "WHERE bl.total_bounty > 0 " ..
        "ORDER BY bl.total_bounty DESC, bl.time ASC"
    )
    huntedPlayers = {}
    if topPlayersQuery then
        local index = 1
        repeat
            local name = result.getString(topPlayersQuery, "target_name")
            if name and name ~= "" then
                huntedPlayers[index] = {
                    name = name,
                    bounty = result.getNumber(topPlayersQuery, "total_bounty"),
                    entryTime = result.getNumber(topPlayersQuery, "time"),
                    outfit = {
                        lookType = result.getNumber(topPlayersQuery, "looktype"),
                        lookHead = result.getNumber(topPlayersQuery, "lookhead"),
                        lookBody = result.getNumber(topPlayersQuery, "lookbody"),
                        lookLegs = result.getNumber(topPlayersQuery, "looklegs"),
                        lookFeet = result.getNumber(topPlayersQuery, "lookfeet"),
                        lookAddons = result.getNumber(topPlayersQuery, "lookaddons")
                    }
                }
            end
            index = index + 1
        until not result.next(topPlayersQuery)
        result.free(topPlayersQuery)
    end
    if #huntedPlayers > 3 then
        table.remove(huntedPlayers, 4)
    end
end

local function getNpcAtTile(pos)
    local tile = Tile(pos)
    if tile then
        local creature = tile:getTopCreature()
        if creature and creature:isNpc() then
            return creature
        end
    end
    return nil
end

local function updateNpcs()
    getTopHunted()

    local currentTop = {}
    for i = 1, 3 do
        if huntedPlayers[i] then
            currentTop[i] = huntedPlayers[i].name
        else
            currentTop[i] = ""
        end
    end

    local changed = false
    for i = 1, 3 do
        if currentTop[i] ~= previousTopPlayers[i] then
            changed = true
            break
        end
    end

    if not changed then
        for idx, pos in ipairs({positions.top1, positions.top2, positions.top3}) do
            local hunted = huntedPlayers[idx]
            if hunted then
                local npc = getNpcAtTile(pos)
                if npc and npc:isNpc() then
                    npc:setOutfit(hunted.outfit)
                end
                local mirroredNpc = getNpcAtTile(mirroredPositions["top"..idx])
                if mirroredNpc and mirroredNpc:isNpc() then
                    mirroredNpc:setOutfit(hunted.outfit)
                end
            end
        end
        return
    end

    for _, pos in pairs(positions) do
        local npc = getNpcAtTile(pos)
        if npc then npc:remove() end
    end
    for _, pos in pairs(mirroredPositions) do
        local npc = getNpcAtTile(pos)
        if npc then npc:remove() end
    end

    local function createNpc(index, position, mirroredPosition, storageKey, npcDefaultName)
        local hunted = huntedPlayers[index]
        if hunted then
            local npcName = hunted.name
            local tempNpc = Game.createNpc(npcDefaultName, hiddenPosition)
            if tempNpc then
                tempNpc:setName(npcName)
                tempNpc:setOutfit(hunted.outfit)
                tempNpc:setMasterPos(position)
                tempNpc:setDirection(DIRECTION_SOUTH)
                Game.setStorageValue(storageKey, npcName)
                addEvent(function()
                    if tempNpc then
                        tempNpc:teleportTo(position)
                        tempNpc:setDirection(DIRECTION_SOUTH)
                    end
                end, teleportDelay)
            end

            local mirroredNpc = Game.createNpc(npcDefaultName, hiddenPosition)
            if mirroredNpc then
                mirroredNpc:setName(npcName)
                mirroredNpc:setOutfit(hunted.outfit)
                mirroredNpc:setMasterPos(mirroredPosition)
                mirroredNpc:setDirection(DIRECTION_SOUTH)
                addEvent(function()
                    if mirroredNpc then
                        mirroredNpc:teleportTo(mirroredPosition)
                        mirroredNpc:setDirection(DIRECTION_SOUTH)
                    end
                end, teleportDelay)
            end
        else
            Game.setStorageValue(storageKey, "")
        end
    end

    createNpc(1, positions.top1, mirroredPositions.top1, GlobalStorage.Hunted.One, "top One")
    createNpc(2, positions.top2, mirroredPositions.top2, GlobalStorage.Hunted.Two, "top Two")
    createNpc(3, positions.top3, mirroredPositions.top3, GlobalStorage.Hunted.Three, "top Three")

    previousTopPlayers = currentTop
end

-- Inicialização com delay de 10 segundos
local initializeHuntedAltar = GlobalEvent("initializeHuntedAltar")
function initializeHuntedAltar.onStartup()
    addEvent(function()
        updateNpcs()
    end, 10000) -- 10 segundos (10000 ms)
end
initializeHuntedAltar:register()

-- Atualização periódica
local huntedAltar = GlobalEvent("huntedAltar")
function huntedAltar.onThink(interval)
    updateNpcs()
    return true
end
huntedAltar:interval(interval * 60000)
huntedAltar:register()
