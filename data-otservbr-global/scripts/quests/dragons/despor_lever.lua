local config = {
	boss = {
		name = "Despor",
		position = Position({x = 33219, y = 30974, z = 13}),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position({x = 33260, y = 31061, z = 13}), teleport = Position({x = 33210, y = 30959, z = 13}), effect = CONST_ME_TELEPORT },
		{ pos = Position({x = 33261, y = 31061, z = 13}), teleport = Position({x = 33210, y = 30959, z = 13}), effect = CONST_ME_TELEPORT },
		{ pos = Position({x = 33262, y = 31061, z = 13}), teleport = Position({x = 33210, y = 30959, z = 13}), effect = CONST_ME_TELEPORT },
		{ pos = Position({x = 33263, y = 31061, z = 13}), teleport = Position({x = 33210, y = 30959, z = 13}), effect = CONST_ME_TELEPORT },
		{ pos = Position({x = 33264, y = 31061, z = 13}), teleport = Position({x = 33210, y = 30959, z = 13}), effect = CONST_ME_TELEPORT },
	},
	
	monsters = {
		{ name = "Maliz", pos = Position(33201, 30974, 13) },
		{ name = "Vengar", pos = Position(33204, 30974, 13) },
		{ name = "Bruton", pos = Position(33207, 30974, 13) },
		{ name = "Greedok", pos = Position(33210, 30974, 13) },
		{ name = "Vilear", pos = Position(33213, 30974, 13) },
		{ name = "Crultor", pos = Position(33216, 30974, 13) },
		
	},
	specPos = {
		from = Position({x = 33194, y = 30935, z = 13}),
		to = Position({x = 33224, y = 30978, z = 13}),
	},
	exit = Position({x = 33268, y = 31061, z = 13}),
}

local lever = BossLever(config)
lever:position({x = 33259, y = 31061, z = 13})
lever:register()
