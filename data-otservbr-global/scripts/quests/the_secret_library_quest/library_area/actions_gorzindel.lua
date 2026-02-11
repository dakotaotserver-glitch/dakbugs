local config = {
	boss = {
		name = "Gorzindel",
		position = Position(32687, 32715, 10),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32747, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32748, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32749, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32750, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(32751, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT },
	},
	
		monsters = {
		{ name = "Stolen Knowledge Of Armor", pos = Position(32687, 32707, 10) },
		{ name = "Stolen Knowledge Of Healing", pos = Position(32698, 32715, 10) },
		{ name = "Stolen Knowledge Of Lifesteal", pos = Position(32693, 32729, 10) },
		{ name = "Stolen Knowledge Of Spells", pos = Position(32681, 32729, 10) },
		{ name = "Stolen Knowledge Of Summoning", pos = Position(32676, 32715, 10) },

	},
	
	specPos = {
		from = Position(32680, 32711, 10),
		to = Position(32695, 32726, 10),
	},
	exit = Position(32660, 32734, 12),
}

local lever = BossLever(config)
lever:position({ x = 32746, y = 32749, z = 10 })
lever:register()