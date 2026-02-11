local config = {
	boss = {
		name = "Chagorz",
		position = Position(33044, 32361, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33078, 32367, 15), teleport = Position(33044, 32373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33077, 32367, 15), teleport = Position(33044, 32373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33076, 32367, 15), teleport = Position(33044, 32373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33075, 32367, 15), teleport = Position(33044, 32373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33074, 32367, 15), teleport = Position(33044, 32373, 15), effect = CONST_ME_TELEPORT },
	},
	
	monsters = {
		{ name = "Elder Bloodjaw", pos = Position(33040, 32369, 15) },
		{ name = "Elder Bloodjaw", pos = Position(33048, 32368, 15) },
	},
	specPos = {
		from = Position(33032, 32356, 15),
		to = Position(33054, 32376, 15),
	},
	exit = Position(33900, 31881, 15),
}

local lever = BossLever(config)
lever:position(Position(33079, 32367, 15))
lever:register()