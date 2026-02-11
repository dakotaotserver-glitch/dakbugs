local config = {
	boss = {
		name = "Vemiath",
		position = Position(33044, 32332, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33078, 32333, 15), teleport = Position(33043, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33077, 32333, 15), teleport = Position(33043, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33076, 32333, 15), teleport = Position(33043, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33075, 32333, 15), teleport = Position(33043, 32341, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33074, 32333, 15), teleport = Position(33043, 32341, 15), effect = CONST_ME_TELEPORT },
	},
	
	monsters = {
		{ name = "Elder Bloodjaw", pos = Position(33040, 32337, 15) },
		{ name = "Elder Bloodjaw", pos = Position(33047, 32336, 15) },
	},
	specPos = {
		from = Position(33032, 32325, 15),
		to = Position(33056, 32346, 15),
	},
	exit = Position(34002, 31818, 15),
}

local lever = BossLever(config)
lever:position(Position(33079, 32333, 15))
lever:register()
