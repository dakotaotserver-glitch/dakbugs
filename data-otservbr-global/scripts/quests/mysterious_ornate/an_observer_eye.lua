local config = {
	boss = {
		name = "An Observer Eye", 
		position = Position(32814, 32963, 14),
	},
	requiredLevel = 150,
	playerPositions = {
		{ pos = Position(32782, 32913, 14), teleport = Position(32812, 32946, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32777, 32918, 14), teleport = Position(32819, 32946, 14), effect = CONST_ME_TELEPORT },

	},
	monsters = {
		{ name = "An Observer Eye (imune)", pos = Position(32815, 32942, 14) },
		
		},
	specPos = {
		from = Position(32804, 32930, 14),
		to = Position(32825, 32953, 14),
	},
	exit = Position(32815, 32904, 14),
}

local lever = BossLever(config)
lever:aid(33156)
lever:register()
