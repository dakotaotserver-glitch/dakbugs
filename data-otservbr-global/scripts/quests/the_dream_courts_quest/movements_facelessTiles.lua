local tilePositions = {
    Position(33615, 32567, 13), Position(33613, 32567, 13),
    Position(33611, 32563, 13), Position(33610, 32561, 13),
    Position(33611, 32558, 13), Position(33614, 32557, 13),
    Position(33617, 32558, 13), Position(33620, 32557, 13),
    Position(33623, 32558, 13), Position(33624, 32561, 13),
    Position(33623, 32563, 13), Position(33621, 32567, 13),
    Position(33619, 32567, 13)
}

-- POSIÇÕES DOS PIPES PARA EFEITO DE VULNERABILIDADE
local pipePositions = {
    Position(33612, 32568, 13),
    Position(33612, 32567, 13),
    Position(33612, 32566, 13),
    Position(33612, 32565, 13),
    Position(33612, 32564, 13),
    Position(33612, 32563, 13),
    Position(33612, 32562, 13),
    Position(33612, 32561, 13),
    Position(33612, 32560, 13),
    Position(33612, 32559, 13),
    Position(33612, 32558, 13),
    Position(33612, 32557, 13),
    Position(33612, 32556, 13),
    Position(33622, 32556, 13),
    Position(33622, 32557, 13),
    Position(33622, 32558, 13),
    Position(33622, 32559, 13),
    Position(33622, 32560, 13),
    Position(33622, 32561, 13),
    Position(33622, 32562, 13),
    Position(33622, 32563, 13),
    Position(33622, 32564, 13),
    Position(33622, 32565, 13),
    Position(33622, 32566, 13),
    Position(33622, 32567, 13),
    Position(33622, 32568, 13),
}

local AID = 23108
local TILE_STORAGE_KEY = 55001
PLAYER_TILE_COOLDOWN = PLAYER_TILE_COOLDOWN or {} -- [playerGUID] = { ["x,y,z"] = timestamp }

local COOLDOWN_SECONDS = 60

local function posKey(pos)
    return pos.x .. "," .. pos.y .. "," .. pos.z
end

local function findNearestFacelessBane(pos)
    local spectators = Game.getSpectators(pos, false, false, 10, 10, 10, 10)
    for _, c in ipairs(spectators) do
        if c:isMonster() and not c:isRemoved() and c:getName():lower() == "faceless bane" then
            return c
        end
    end
    return nil
end

local function resetBossTileState(boss)
    boss:setStorageValue(TILE_STORAGE_KEY, 0)
end

local function removeFacelessImmunity(boss)
    boss:unregisterEvent("facelessHealth")
end

-- FUNÇÃO PARA ENVIAR EFEITOS NAS PIPES QUANDO BOSS FICAR VULNERÁVEL
local function sendEnergyEffectOnPipes()
    for _, position in ipairs(pipePositions) do
        position:sendMagicEffect(CONST_ME_PURPLEENERGY)
        position:sendSingleSoundEffect(SOUND_EFFECT_TYPE_SPELL_GREAT_ENERGY_BEAM)
    end
end

local facelessTileMove = MoveEvent()

function facelessTileMove.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then return true end

    local boss = findNearestFacelessBane(position)
    if not boss then return true end

    local key = posKey(position)
    local playerKey = player:getGuid()
    PLAYER_TILE_COOLDOWN[playerKey] = PLAYER_TILE_COOLDOWN[playerKey] or {}

    -- Cooldown por player e tile
    local lastUse = PLAYER_TILE_COOLDOWN[playerKey][key]
    if lastUse and os.time() - lastUse < COOLDOWN_SECONDS then
        return true
    end

    -- Atualiza tempo de uso
    PLAYER_TILE_COOLDOWN[playerKey][key] = os.time()

    -- Aplica efeitos e incrementa contador
    position:sendMagicEffect(CONST_ME_YELLOWENERGY)

    local count = boss:getStorageValue(TILE_STORAGE_KEY)
    if count < 0 then count = 0 end
    count = count + 1
    boss:setStorageValue(TILE_STORAGE_KEY, count)

    if count >= 13 then
        position:sendMagicEffect(CONST_ME_HOLYAREA)
        removeFacelessImmunity(boss)
        resetBossTileState(boss)
        sendEnergyEffectOnPipes() -- <<<<<<<<<< EFEITO NAS PIPES!
        Game.broadcastMessage("Faceless Bane is now vulnerable!", MESSAGE_STATUS_WARNING)
        boss:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
    end

    return true
end

facelessTileMove:aid(AID)
facelessTileMove:register()
