local config = {
	boss = {
		name = "The Fear Feaster",
		position = Position(33711, 31469, 14),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33734, 31471, 14), teleport = Position(33711, 31474, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33735, 31471, 14), teleport = Position(33711, 31474, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33736, 31471, 14), teleport = Position(33711, 31474, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33737, 31471, 14), teleport = Position(33711, 31474, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33738, 31471, 14), teleport = Position(33711, 31474, 14), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "Phobia", pos = Position(33711, 31467, 14) },
		{ name = "Horror", pos = Position(33711, 31472, 14) },
		{ name = "Fear", pos = Position(33708, 31470, 14) },
		{ name = "Horror", pos = Position(33714, 31469, 14) },
	},
	specPos = {
		from = Position(33702, 31459, 14),
		to = Position(33722, 31479, 14),
	},
	exit = Position(33740, 31468, 14),
}

local lever = BossLever(config)
lever:position({ x = 33733, y = 31471, z = 14 })
lever:register()