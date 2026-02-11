local config = {
	boss = {
		name = "Ratmiral Blackwhiskers",
		position = Position(33922, 31383, 15),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33893, 31388, 15), teleport = Position(33904, 31373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33894, 31388, 15), teleport = Position(33904, 31373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33895, 31388, 15), teleport = Position(33904, 31373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33896, 31388, 15), teleport = Position(33904, 31373, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33897, 31388, 15), teleport = Position(33904, 31373, 15), effect = CONST_ME_TELEPORT },
	},
		monsters = {
		{ name = "Weak Spot", pos = Position(33902, 31363, 15) }, 
		{ name = "Rateye Ric", pos = Position(33902, 31370, 15) },
		--{ name = "Mister Catkiller", pos = Position(33905, 31347, 15) },
		{ name = "1 St Mate Ratticus", pos = Position(33905, 31351, 14) },


	},
	
	specPos = {
		from = Position(33884, 31337, 14),
		to = Position(33927, 31386, 15),
	},
	exit = Position(33891, 31197, 7),
}

local lever = BossLever(config)
lever:position(Position(33892, 31388, 15))
lever:register()
