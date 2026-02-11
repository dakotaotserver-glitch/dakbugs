local config = {
	boss = {
		name = "The Scourge of Oblivion",
		position = Position(32726, 32710, 11),
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(32676, 32743, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32744, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32745, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32741, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32676, 32742, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32677, 32741, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32677, 32742, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32677, 32743, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32677, 32744, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(32677, 32745, 11), teleport = Position(32726, 32733, 11), effect = CONST_ME_TELEPORT },
	},
		monsters = {
		{ name = "The Spellstealer", pos = Position(32744, 32716, 11) },
		{ name = "The Scion of Havoc", pos = Position(32744, 32755, 11) },
		{ name = "Brother Chill", pos = Position(32703, 32753, 11) },
		{ name = "Brother Freeze", pos = Position(32709, 32753, 11) },
		{ name = "The Devourer of Secrets", pos = Position(32706, 32716, 11) },


	},
	
	specPos = {
		from = Position(32693, 32702, 11),
		to = Position(32758, 32767, 11),
	},
	exit = Position(32480, 32599, 15),
}

local lever = BossLever(config)
lever:position({ x = 32675, y = 32743, z = 11 })
lever:register()
