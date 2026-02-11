local config = {
	boss = {
		name = "The Nightmare Beast",
		position = Position(32208, 32046, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32212, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32210, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32211, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32213, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32214, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32210, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32211, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32212, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32213, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(32214, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT },
	},
			monsters = {
		{ name = "Nightmare Tendril", pos = Position(32206, 32048, 15) },
		{ name = "Nightmare Tendril", pos = Position(32212, 32045, 15) },
		{ name = "Nightmare Tendril", pos = Position(32210, 32040, 15) },
		{ name = "Nightmare Tendril", pos = Position(32215, 32047, 15) },
		{ name = "Nightmare Tendril", pos = Position(32201, 32041, 15) },
		{ name = "Nightmare Tendril", pos = Position(32208, 32043, 15) },

	},
	specPos = {
		from = Position(32195, 32035, 15),
		to = Position(32220, 32055, 15),
	},
	exit = Position(32211, 32084, 15),
}

local lever = BossLever(config)
lever:position({ x = 32212, y = 32069, z = 15 })
lever:register()
