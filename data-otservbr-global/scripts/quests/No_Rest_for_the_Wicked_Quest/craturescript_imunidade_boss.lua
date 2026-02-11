local arbazilothImmunityEvent = CreatureEvent("ArbazilothImmunityEvent")

local bossName = "arbaziloth"
local immunityHealthCheckpoints = {80, 60, 40, 20 }
local immunityStorage = 65144
local checkpointTriggered = {}

local spawnFrom = Position(34029, 32326, 14)
local spawnTo = Position(34037, 32338, 14)
local itemId = 49362
local spawnInterval = 10 * 1000 -- 10 segundos

local activeImmunity = {} -- [creatureId] = { eventId, lastItemPos = Position }

-- Função utilitária para criar uma posição aleatória entre from/to
local function randomPositionInArea(fromPos, toPos)
    local x = math.random(fromPos.x, toPos.x)
    local y = math.random(fromPos.y, toPos.y)
    local z = fromPos.z
    return Position(x, y, z)
end

-- Remove o item anterior 1949 na última posição, se existir
local function removeLastItemAtPosition(pos)
    if pos then
        local tile = Tile(pos)
        if tile then
            local item = tile:getItemById(itemId)
            if item then
                item:remove()
            end
        end
    end
end

-- Função para remover imunidade e limpar item remanescente
local function removeArbazilothImmunity(creature)
    local cid = creature:getId()
    if activeImmunity[cid] then
        if activeImmunity[cid].eventId then
            stopEvent(activeImmunity[cid].eventId)
        end
        if activeImmunity[cid].lastItemPos then
            removeLastItemAtPosition(activeImmunity[cid].lastItemPos)
        end
        activeImmunity[cid] = nil
    end
    creature:setStorageValue(immunityStorage, -1)
    creature:immune(false)
    creature:say("Arbaziloth is no longer immune!", TALKTYPE_MONSTER_SAY)
end

-- Função de ciclo de spawn de item
local function startItemCycle(creatureId)
    local creature = Creature(creatureId)
    if not creature or not creature:isMonster() or creature:getName():lower() ~= bossName then
        return
    end

    -- Remove o item anterior na última posição salva
    if activeImmunity[creatureId] and activeImmunity[creatureId].lastItemPos then
        removeLastItemAtPosition(activeImmunity[creatureId].lastItemPos)
        activeImmunity[creatureId].lastItemPos = nil
    end

    -- Cria item novo em posição aleatória
    local pos = randomPositionInArea(spawnFrom, spawnTo)
    Game.createItem(itemId, 1, pos)
    pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    -- Salva a última posição para remover no próximo ciclo
    activeImmunity[creatureId].lastItemPos = pos

    -- Marca para repetir ciclo se ainda estiver imune
    if creature:getStorageValue(immunityStorage) == 1 then
        activeImmunity[creatureId].eventId = addEvent(startItemCycle, spawnInterval, creatureId)
    end
end

-- Evento principal de monitoramento de vida
function arbazilothImmunityEvent.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= bossName then
        return true
    end

    local cid = creature:getId()
    local percent = math.floor((creature:getHealth() / creature:getMaxHealth()) * 100)

    if not checkpointTriggered[cid] then checkpointTriggered[cid] = {} end
    for _, v in ipairs(immunityHealthCheckpoints) do
        if percent <= v and not checkpointTriggered[cid][v] and creature:getStorageValue(immunityStorage) ~= 1 then
            checkpointTriggered[cid][v] = true

            creature:setStorageValue(immunityStorage, 1)
            creature:immune(true) -- ajuste para sua base se necessário

            activeImmunity[cid] = activeImmunity[cid] or {}
            startItemCycle(cid)

            creature:say("Arbaziloth becomes immune to all attacks!", TALKTYPE_MONSTER_SAY)
            break
        end
    end

    return true
end

arbazilothImmunityEvent:register()

-- Evento para remover imunidade quando Arbaziloth pisa no item
local arbazilothStepEvent = MoveEvent()
arbazilothStepEvent:type("stepin")
arbazilothStepEvent:id(itemId)

function arbazilothStepEvent.onStepIn(creature, item, position, fromPosition)
    if not creature:isMonster() or creature:getName():lower() ~= bossName then
        return true
    end
    if creature:getStorageValue(immunityStorage) ~= 1 then
        return true
    end
    local tile = Tile(position)
    if tile and tile:getItemById(itemId) then
        removeArbazilothImmunity(creature)
        position:sendMagicEffect(CONST_ME_POFF)
    end
    return true
end

arbazilothStepEvent:register()
