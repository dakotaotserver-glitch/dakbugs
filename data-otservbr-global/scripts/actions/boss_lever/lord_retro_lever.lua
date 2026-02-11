local config = {
	boss = {
		name = "Lord Retro",
		position = Position(33577, 31013, 15),
	},
	requiredLevel = 250,
	timeToDefeat = 25 * 60,
	playerPositions = {
		{ pos = Position(33516, 31055, 15), teleport = Position(33577, 31020, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33517, 31055, 15), teleport = Position(33577, 31024, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33518, 31055, 15), teleport = Position(33577, 31024, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33519, 31055, 15), teleport = Position(33578, 31024, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33520, 31055, 15), teleport = Position(33578, 31024, 15), effect = CONST_ME_TELEPORT },
	
	},
		monsters = {
		{ name = "Hard Times", pos = Position(33571, 31016, 15) },
		{ name = "Hard Times", pos = Position(33585, 31017, 15) },
		{ name = "Parcel Castle", pos = Position(33576, 31015, 15) },
		{ name = "Parcel Castle", pos = Position(33579, 31015, 15) },

	},
	specPos = {
		from = Position(33564, 31005, 15),
		to = Position(33590, 31033, 15),
	},
	exit = Position(33517, 31053, 15),
}

local lever = BossLever(config)
lever:position({x = 33515, y = 31055, z = 15})
lever:register()
