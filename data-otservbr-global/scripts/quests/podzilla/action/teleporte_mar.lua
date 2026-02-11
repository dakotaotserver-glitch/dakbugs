local teleportAction = Action()

-- Configuração do teleporte principal (para quem clica no item)
local teleportConfig = {
    [33184] = {
        position = Position(33873, 32013, 4),
        -- message = "Você foi teleportado!"
    }
}

local cooldownTime = 6 -- Tempo total em segundos
local cooldownStorageId = 65122 -- Storage do cooldown

-- Lista de tiles que teleportam jogadores próximos
local tileDestinations = {
    { fromTile = Position(33926, 32011, 5), toPos = Position(33873, 32013, 4) },
    { fromTile = Position(33927, 32011, 5), toPos = Position(33873, 32013, 4) },
    { fromTile = Position(33928, 32011, 5), toPos = Position(33873, 32013, 4) },
    { fromTile = Position(33929, 32011, 5), toPos = Position(33873, 32013, 4) },
    { fromTile = Position(33930, 32011, 5), toPos = Position(33873, 32013, 4) }
}

local groupStorageId = 65121
local groupStorageValue = 5

function teleportAction.onUse(player, item, fromPosition, target, toPosition)
    local actionId = item:getActionId()
    local config = teleportConfig[actionId]
    if not config then
        return false
    end

    -- Verifica o cooldown
    local currentTime = os.time()
    local lastTeleport = player:getStorageValue(cooldownStorageId)
    if lastTeleport > 0 and (currentTime - lastTeleport) < cooldownTime then
        local timeLeft = cooldownTime - (currentTime - lastTeleport)
        local minutes = math.floor(timeLeft / 60)
        local seconds = timeLeft % 60

        local timeMessage = ""
        if minutes > 0 then
            timeMessage = minutes .. " minuto" .. (minutes > 1 and "s" or "")
        end
        if seconds > 0 then
            timeMessage = timeMessage .. (minutes > 0 and " e " or "") .. seconds .. " segundo" .. (seconds > 1 and "s" or "")
        end

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            "Você deve aguardar mais " .. timeMessage .. " para se teletransportar novamente.")
        return true
    end

    -- Define storage para controle de cooldown
    player:setStorageValue(cooldownStorageId, currentTime)
    player:setStorageValue(groupStorageId, groupStorageValue)

    -- Remove a montaria do jogador definindo um outfit sem montaria
    local currentOutfit = player:getOutfit()
    currentOutfit.lookMount = 0 -- Remove a montaria
    player:setOutfit(currentOutfit)

    -- Teleporta o jogador principal
    player:teleportTo(config.position)
    config.position:sendMagicEffect(CONST_ME_TELEPORT)

    -- Aplica efeito visual após 100ms
    addEvent(function()
        config.position:sendMagicEffect(188)
    end, 100)

    -- Aplica efeito em área 3x3 ao redor do teleportado
    for dx = -1, 1 do
        for dy = -1, 1 do
            local areaPos = Position(config.position.x + dx, config.position.y + dy, config.position.z)
            areaPos:sendMagicEffect(188)
        end
    end

    -- Teletransporta jogadores em tiles pré-definidos
    for _, info in ipairs(tileDestinations) do
        local tile = Tile(info.fromTile)
        if tile then
            local creaturesOnTile = tile:getCreatures()
            if creaturesOnTile then
                for _, creature in ipairs(creaturesOnTile) do
                    local potentialPlayer = creature:getPlayer()
                    if potentialPlayer then
                        -- Remove a montaria de jogadores que forem teleportados
                        local pOutfit = potentialPlayer:getOutfit()
                        pOutfit.lookMount = 0
                        potentialPlayer:setOutfit(pOutfit)

                        -- Teleporta o jogador
                        potentialPlayer:teleportTo(info.toPos)
                        info.toPos:sendMagicEffect(CONST_ME_TELEPORT)

                        addEvent(function()
                            info.toPos:sendMagicEffect(188)
                        end, 100)

                        -- Define a mesma storage para os teleportados
                        potentialPlayer:setStorageValue(groupStorageId, groupStorageValue)
                    end
                end
            end
        end
    end

    return true
end

-- Vincula a actionId 33184 ao evento
teleportAction:aid(33184)
teleportAction:register()
