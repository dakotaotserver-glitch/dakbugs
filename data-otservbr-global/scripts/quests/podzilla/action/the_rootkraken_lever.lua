local config = {
	boss = {
		name = "The Rootkraken",
		position = Position(33963, 32037, 11),
	},
	
	requiredLevel = 800,
	timeToDefeat = 25 * 60,
	
	playerPositions = {
		{ pos = Position(33965, 32006, 11), teleport = Position(33964, 32047, 11) }, 
		{ pos = Position(33965, 32007, 11), teleport = Position(33964, 32047, 11) },
		{ pos = Position(33965, 32008, 11), teleport = Position(33964, 32047, 11) },
		{ pos = Position(33965, 32009, 11), teleport = Position(33964, 32047, 11) },
		{ pos = Position(33965, 32010, 11), teleport = Position(33964, 32047, 11) },
	},
	monsters = {
		{ name = "Doctor Marrow", pos = Position(33969, 32038, 11) },
		{ name = "Rotten Plant Thing", pos = Position(33957, 32038, 11) },
		{ name = "Rotten Plant Thing", pos = Position(33957, 32042, 11) },
		{ name = "Rotten Plant Thing", pos = Position(33961, 32044, 11) },
		{ name = "Rotten Plant Thing", pos = Position(33969, 32044, 11) },
		{ name = "Rotten Plant Thing", pos = Position(33970, 32036, 11) },
		{ name = "Rotten Plant Thing", pos = Position(33966, 32043, 11) },
	
		},
	
	specPos = {
		from = Position(33945, 32026, 11),
		to = Position(33982, 32055, 11),
	},
	exit = Position(33968, 32006, 11),
	
}

local lever = BossLever(config)
lever:position(Position(33965, 32005, 11))
lever:register()
