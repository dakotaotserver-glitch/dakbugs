local config = {
	boss = {
		name = "Kusuma",
		position = Position(33712, 32781, 5),
	},
	requiredLevel = 100,
	timeToDefeat = 20 * 60,
	playerPositions = {
		{ pos = Position(33703, 32768, 5), teleport = Position(33711, 32778, 5), effect = CONST_ME_TELEPORT },
		{ pos = Position(33702, 32768, 5), teleport = Position(33711, 32778, 5), effect = CONST_ME_TELEPORT },
		{ pos = Position(33701, 32768, 5), teleport = Position(33711, 32778, 5), effect = CONST_ME_TELEPORT },
		{ pos = Position(33700, 32768, 5), teleport = Position(33711, 32778, 5), effect = CONST_ME_TELEPORT },
		{ pos = Position(33699, 32768, 5), teleport = Position(33711, 32778, 5), effect = CONST_ME_TELEPORT },
	
	},

	specPos = {
		from = Position(33707, 32774, 5),
		to = Position(33717, 32784, 5),
	},
	exit = Position(33711, 32772, 5),
}

local lever = BossLever(config)
lever:position({ x = 33704, y = 32768, z = 5 })
lever:register()
