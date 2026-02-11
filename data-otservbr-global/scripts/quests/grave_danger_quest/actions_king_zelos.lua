local config = {
	boss = {
		name = "King Zelos",
		position = Position(33443, 31545, 13),
	},
	requiredLevel = 250,
	timeToDefeat = 30 * 60,
	playerPositions = {
		{ pos = Position(33485, 31546, 13), teleport = Position(33438, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31547, 13), teleport = Position(33439, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31548, 13), teleport = Position(33440, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31545, 13), teleport = Position(33441, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31544, 13), teleport = Position(33442, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31546, 13), teleport = Position(33443, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31547, 13), teleport = Position(33444, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31548, 13), teleport = Position(33445, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31545, 13), teleport = Position(33446, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31544, 13), teleport = Position(33447, 31572, 13), effect = CONST_ME_TELEPORT },
	},
	
		monsters = {
		{ name = "Rewar The Bloody", pos = Position(33463, 31562, 13) },
		{ name = "Magnor Mournbringer", pos = Position(33463, 31529, 13) },
		{ name = "The Red Knight", pos = Position(33423, 31562, 13) },
		{ name = "Nargol The Impaler", pos = Position(33423, 31529, 13) },


	},
	
	specPos = {
		from = Position(33409, 31515, 13),
		to = Position(33477, 31572, 13),
	},
	exit = Position(32172, 31918, 8),
}

local lever = BossLever(config)
lever:position({ x = 33484, y = 31546, z = 13 })
lever:register()
