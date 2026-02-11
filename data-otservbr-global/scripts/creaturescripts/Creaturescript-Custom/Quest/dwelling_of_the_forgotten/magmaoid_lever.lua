local config = {
    boss = {
        name = "The Mega Magmaoid",
        position = Position(32477, 31149, 15),
    },
    requiredLevel = 250,
    timeToDefeat = 20 * 60,
    playerPositions = {
        { pos = Position(32530, 31154, 15), teleport = Position(32504, 31156, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32531, 31154, 15), teleport = Position(32504, 31156, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32532, 31154, 15), teleport = Position(32504, 31156, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32533, 31154, 15), teleport = Position(32504, 31156, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32534, 31154, 15), teleport = Position(32504, 31156, 15), effect = CONST_ME_TELEPORT },
    },
	monsters = {
		{ name = "Magmaoid", pos = Position(32497, 31152, 15) },
		{ name = "Magmaoid", pos = Position(32499, 31158, 15) },
		{ name = "Magmaoid", pos = Position(32502, 31153, 15) },
		{ name = "Magmaoid", pos = Position(32503, 31158, 15) },

	},
    specPos = {
        from = Position(32476, 31141, 15),
        to = Position(32512, 31167, 15),
    },
    exit = Position(32530, 31154, 15),
}

local lever = BossLever(config)
lever:position({ x = 32529, y = 31154, z = 15 })
lever:register()

