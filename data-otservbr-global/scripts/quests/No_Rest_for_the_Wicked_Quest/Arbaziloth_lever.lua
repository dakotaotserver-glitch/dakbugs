local config = {
	boss = {
		name = "Arbaziloth",
		position = Position(34034, 32330, 14),
	},
	requiredLevel = 250,
	timeToDefeat = 20 * 60,
	playerPositions = {
		{ pos = Position(34029, 32365, 14), teleport = Position(34033, 32336, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(34029, 32366, 14), teleport = Position(34033, 32336, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(34029, 32367, 14), teleport = Position(34033, 32336, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(34029, 32368, 14), teleport = Position(34033, 32336, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(34029, 32369, 14), teleport = Position(34033, 32336, 14), effect = CONST_ME_TELEPORT },
		
	},
		monsters = {
		{ name = "imp minion", pos = Position(34023, 32329, 14) },
		{ name = "imp minion", pos = Position(34023, 32334, 14) },
		{ name = "The Forgemaster", pos = Position(34033, 32325, 14) },
		{ name = "Overcharged Demon", pos = Position(34038, 32332, 14) },
		{ name = "Overcharged Demon", pos = Position(34029, 32331, 14) },

	},
	specPos = {
		from = Position(34013, 32319, 14), 
		to = Position(34048, 32346, 14),
	},
	exit = Position(33877, 32398, 10),
	onUseExtra = function(player, infoPositions)
    local fromPos = Position(34013, 32319, 14)
    local toPos = Position(34048, 32346, 14)
    local removeItemId = 37000
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            for z = fromPos.z, toPos.z do
                local tile = Tile(Position(x, y, z))
                if tile then
                    -- Remove todos os itens com ID 37000 do chão
                    local item
                    repeat
                        item = tile:getItemById(removeItemId)
                        if item then
                            item:remove()
                        end
                    until not item
                end
            end
        end
    end
    -- Teleporta o player normalmente
    player:teleportTo(Position(33618, 32523, 15))
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
end,

}

local lever = BossLever(config)
lever:position({x = 34029, y = 32364, z = 14})
lever:register()
