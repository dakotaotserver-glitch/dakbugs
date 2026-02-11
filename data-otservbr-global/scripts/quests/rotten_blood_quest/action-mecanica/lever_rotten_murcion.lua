local config = {
	boss = {
		name = "Murcion",
		position = Position(33009, 32362, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32978, 32365, 15), teleport = Position(33009, 32371, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32977, 32365, 15), teleport = Position(33009, 32371, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32976, 32365, 15), teleport = Position(33009, 32371, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32975, 32365, 15), teleport = Position(33009, 32371, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32974, 32365, 15), teleport = Position(33009, 32371, 15), effect = CONST_ME_TELEPORT },
	},
		monsters = {
		{ name = "Elder Bloodjaw", pos = Position(33005, 32368, 15) },
		{ name = "Elder Bloodjaw", pos = Position(33012, 32365, 15) },
	},
	specPos = {
		from = Position(32997, 32356, 15),
		to = Position(33020, 32378, 15),
	},
	exit = Position(33009, 32374, 15),
}

local lever = BossLever(config)
lever:position(Position(32979, 32365, 15))
lever:register()
