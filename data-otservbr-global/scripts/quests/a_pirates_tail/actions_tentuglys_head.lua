local config = {
    boss = {
        name = "Tentugly's Head",
        position = Position(33722, 31182, 7),
    },
    requiredLevel = 250,
    playerPositions = {
        { pos = Position(33792, 31391, 6), teleport = Position(33722, 31186, 7), effect = CONST_ME_TELEPORT },
        { pos = Position(33793, 31391, 6), teleport = Position(33722, 31186, 7), effect = CONST_ME_TELEPORT },
        { pos = Position(33794, 31391, 6), teleport = Position(33722, 31186, 7), effect = CONST_ME_TELEPORT },
        { pos = Position(33795, 31391, 6), teleport = Position(33722, 31186, 7), effect = CONST_ME_TELEPORT },
        { pos = Position(33796, 31391, 6), teleport = Position(33722, 31186, 7), effect = CONST_ME_TELEPORT },
    },
    specPos = {
        from = Position(33690, 31149, 6),
        to = Position(33738, 31192, 7),
    },
    exit = Position(33799, 31356, 7),

    -- Função extra: limpa itens da sala antes de expulsar player
    onUseExtra = function(player, infoPositions)
        local fromPos = Position(33690, 31149, 6)
        local toPos   = Position(33736, 31190, 7)
        local itemIDs = { 35600, 35109, 35112, 35126, 35119}

        for x = fromPos.x, toPos.x do
            for y = fromPos.y, toPos.y do
                for z = fromPos.z, toPos.z do
                    local tile = Tile(Position(x, y, z))
                    if tile then
                        for _, itemId in ipairs(itemIDs) do
                            local item = tile:getItemById(itemId)
                            while item do
                                item:remove()
                                item = tile:getItemById(itemId)
                            end
                        end
                    end
                end
            end
        end

        -- Use a posição diretamente aqui:
        local exitPos = Position(33799, 31356, 7)
        player:teleportTo(exitPos)
        exitPos:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você foi removido da sala e os itens especiais foram limpos!")
    end,
}

local lever = BossLever(config)
lever:position(Position(33791, 31391, 6))
lever:register()
