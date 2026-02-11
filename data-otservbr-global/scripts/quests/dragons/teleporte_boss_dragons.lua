local malizActionId = 33133 -- Action ID para teleportar Maliz
local vengarActionId = 33134 -- Action ID para teleportar Vengar
local brutonActionId = 33135 -- Action ID para teleportar Bruton
local greedokActionId = 33136 -- Action ID para teleportar Greedok
local vilearActionId = 33137 -- Action ID para teleportar Vilear
local crultorActionId = 33138 -- Action ID para teleportar Crultor
local desporActionId = 33139 -- Action ID para teleportar Despor

local storageId = 65092 -- Primeira Storage ID para verificar
local storages = {65092, 65093, 65094, 65095, 65096, 65097} -- Todas as storages envolvidas

-- Definição das criaturas e suas posições
local creatures = {
    ["Maliz"] = {fromPosition = Position(33201, 30974, 13), toPosition = Position(33210, 30951, 13)},
    ["Vengar"] = {fromPosition = Position(33204, 30974, 13), toPosition = Position(33210, 30951, 13)},
    ["Bruton"] = {fromPosition = Position(33207, 30974, 13), toPosition = Position(33210, 30951, 13)},
    ["Greedok"] = {fromPosition = Position(33210, 30974, 13), toPosition = Position(33210, 30951, 13)},
    ["Vilear"] = {fromPosition = Position(33213, 30974, 13), toPosition = Position(33210, 30951, 13)},
    ["Crultor"] = {fromPosition = Position(33216, 30974, 13), toPosition = Position(33210, 30951, 13)},
    ["Despor"] = {fromPosition = Position(33219, 30974, 13), toPosition = Position(33210, 30951, 13)}
}

local useTeleportCreature = Action()

-- Função para verificar se o jogador possui todas as storages necessárias
local function hasRequiredStorages(player, storages)
    for _, storage in ipairs(storages) do
        if player:getStorageValue(storage) ~= 1 then
            return false
        end
    end
    return true
end

-- Função para teletransportar a criatura para a posição especificada
local function teleportCreature(creatureName, fromPos, toPos, player, message)
    local creature = Creature(creatureName)
    if creature and creature:getPosition() == fromPos then
        creature:teleportTo(toPos)
        creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:say(message, TALKTYPE_MONSTER_SAY)
    else
        player:sendCancelMessage("The creature " .. creatureName .. " is not in the expected position.")
    end
end

-- Função chamada quando o jogador clica no item com Action IDs especificados
function useTeleportCreature.onUse(player, item, fromPosition, target, toPosition)
    local actionId = item:getActionId() -- Obtém o Action ID do item clicado

    if actionId == malizActionId then
        teleportCreature("Maliz", creatures["Maliz"].fromPosition, creatures["Maliz"].toPosition, player, "Maliz has been teleported!")

    elseif actionId == vengarActionId then
        if player:getStorageValue(storageId) == 1 then
            teleportCreature("Vengar", creatures["Vengar"].fromPosition, creatures["Vengar"].toPosition, player, "Vengar has been teleported!")
        else
            player:sendCancelMessage("Mate Maliz.")
        end

    elseif actionId == brutonActionId then
        if hasRequiredStorages(player, {65092, 65093}) then
            teleportCreature("Bruton", creatures["Bruton"].fromPosition, creatures["Bruton"].toPosition, player, "Bruton has been teleported!")
        else
            player:sendCancelMessage("Mate Vengar.")
        end

    elseif actionId == greedokActionId then
        if hasRequiredStorages(player, {65092, 65093, 65094}) then
            teleportCreature("Greedok", creatures["Greedok"].fromPosition, creatures["Greedok"].toPosition, player, "Greedok has been teleported!")
        else
            player:sendCancelMessage("Mate Bruton.")
        end

    elseif actionId == vilearActionId then
        if hasRequiredStorages(player, {65092, 65093, 65094, 65095}) then
            teleportCreature("Vilear", creatures["Vilear"].fromPosition, creatures["Vilear"].toPosition, player, "Vilear has been teleported!")
        else
            player:sendCancelMessage("Mate Greedok.")
        end

    elseif actionId == crultorActionId then
        if hasRequiredStorages(player, {65092, 65093, 65094, 65095, 65096}) then
            teleportCreature("Crultor", creatures["Crultor"].fromPosition, creatures["Crultor"].toPosition, player, "Crultor has been teleported!")
        else
            player:sendCancelMessage("Mate Vilear.")
        end

    elseif actionId == desporActionId then
        if hasRequiredStorages(player, {65092, 65093, 65094, 65095, 65096, 65097}) then
            teleportCreature("Despor", creatures["Despor"].fromPosition, creatures["Despor"].toPosition, player, "Despor has been teleported!")
        else
            player:sendCancelMessage("Mate Todos os Dragons Primeiro.")
        end
    end

    return true
end

-- Registra os Action IDs para o evento
useTeleportCreature:aid(malizActionId)
useTeleportCreature:aid(vengarActionId)
useTeleportCreature:aid(brutonActionId)
useTeleportCreature:aid(greedokActionId)
useTeleportCreature:aid(vilearActionId)
useTeleportCreature:aid(crultorActionId)
useTeleportCreature:aid(desporActionId)

-- Registra o evento no servidor
useTeleportCreature:register()
