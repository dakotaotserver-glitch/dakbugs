-- Look README.md for see the reserved action/unique numbers
-- This file is only for teleports items (miscellaneous) not for magic forcefields

TeleportItemAction = {
	-- Feyrist shrines entrance
	-- Path: data\scripts\actions\other\gems.lua
	[15001] = {
		itemId = false,
		itemPos = {
			{ x = 32194, y = 31418, z = 2 },
			{ x = 32194, y = 31419, z = 2 },
			{ x = 32195, y = 31418, z = 2 },
			{ x = 32195, y = 31419, z = 2 },
		},
	},
	[15002] = {
		itemId = false,
		itemPos = {
			{ x = 32910, y = 32338, z = 15 },
			{ x = 32910, y = 32339, z = 15 },
			{ x = 32911, y = 32338, z = 15 },
			{ x = 32911, y = 32339, z = 15 },
		},
	},
	[15003] = {
		itemId = false,
		itemPos = {
			{ x = 32973, y = 32225, z = 7 },
			{ x = 32973, y = 32226, z = 7 },
			{ x = 32974, y = 32225, z = 7 },
			{ x = 32974, y = 32226, z = 7 },
		},
	},
	[15004] = {
		itemId = false,
		itemPos = {
			{ x = 33060, y = 32713, z = 5 },
			{ x = 33060, y = 32714, z = 5 },
			{ x = 33061, y = 32713, z = 5 },
			{ x = 33061, y = 32714, z = 5 },
		},
	},
	-- Deeper fibula draw well
	-- Path: data\scripts\quests\deeper_fibula\action-draw_well.lua
	[15005] = {
		itemId = false,
		itemPos = {
			{ x = 32171, y = 32439, z = 7 },
			{ x = 32172, y = 32439, z = 7 },
		},
	},
	-- Forgotten Knowledge Quest - Teleports Thais
	[24873] = {
		itemId = 25047,
		itemPos = {
			{ x = 32325, y = 32087, z = 7 },
		},
	},
	[24873] = {
		itemId = 25051,
		itemPos = {
			{ x = 32328, y = 32087, z = 7 },
		},
	},
	[24873] = {
		itemId = 25049,
		itemPos = {
			{ x = 32331, y = 32087, z = 7 },
		},
	},
	[24873] = {
		itemId = 25053,
		itemPos = {
			{ x = 32334, y = 32087, z = 7 },
		},
	},
	[24873] = {
		itemId = 25057,
		itemPos = {
			{ x = 32337, y = 32087, z = 7 },
		},
	},
	[24873] = {
		itemId = 25055,
		itemPos = {
			{ x = 32340, y = 32087, z = 7 },
		},
	},
	[24873] = {
		itemId = 10840,
		itemPos = {
			{ x = 32332, y = 32094, z = 7 },
		},
	},
	[24873] = {
		itemId = 25048,
		itemPos = {
			{ x = 32805, y = 31657, z = 8 },
		},
	},
	[24873] = {
		itemId = 25052,
		itemPos = {
			{ x = 32786, y = 32818, z = 13 },
		},
	},
	[24873] = {
		itemId = 25050,
		itemPos = {
			{ x = 32637, y = 32255, z = 7 },
		},
	},
	[24873] = {
		itemId = 25054,
		itemPos = {
			{ x = 33341, y = 31167, z = 7 },
		},
	},
	[24873] = {
		itemId = 25058,
		itemPos = {
			{ x = 32205, y = 31036, z = 10 },
		},
	},
	[24873] = {
		itemId = 25056,
		itemPos = {
			{ x = 32780, y = 32684, z = 14 },
		},
	},
	[24873] = {
		itemId = 10842,
		itemPos = {
			{ x = 32906, y = 32846, z = 13 },
		},
	},
	[26668] = {
		itemId = 1949,
		itemPos = {
			{ x = 33396, y = 31129, z = 9 },
		},
	},
}

TeleportItemUnique = {
	[15001] = {
		itemId = 31673,
		itemPos = { x = 33315, y = 32647, z = 6 },
		destination = { x = 33384, y = 32627, z = 7 },
		effect = CONST_ME_TELEPORT,
	},
	[15002] = {
		itemId = 1759,
		itemPos = { x = 33383, y = 32626, z = 7 },
		destination = { x = 33314, y = 32647, z = 6 },
		effect = CONST_ME_TELEPORT,
	},
	
	[15003] = {
		itemId = 5679,
		itemPos = { x = 33918, y = 31471, z = 7 },
		destination = { x = 33916, y = 31466, z = 8 },
		effect = CONST_ME_TELEPORT,
	},
	-- Faceless Bane entrance
	[15004] = {
		itemId = 29954,
		itemPos = { x = 33619, y = 32518, z = 15 },
		destination = { x = 33640, y = 32561, z = 13 },
		effect = CONST_ME_TELEPORT,
	},
	[15005] = {
		itemId = 4997,
		itemPos = { x = 33384, y = 32626, z = 7 },
		destination = { x = 33314, y = 32647, z = 6 },
		effect = CONST_ME_TELEPORT,
	},
	[15006] = {
		itemId = 50978,
		itemPos = { x = 33185, y = 31794, z = 7 },
		destination = { x = 32519, y = 32514, z = 8 },
		effect = 296,
	},
	[15007] = {
		itemId = 50747,
		itemPos = { x = 32519, y = 32513, z = 8 },
		destination = { x = 33185, y = 31795, z = 7 },
		effect = CONST_ME_TELEPORT,
	},
	[15008] = {
		itemId = 51626,
		itemPos = { x = 32540, y = 32512, z = 8 },
		destination = { x = 32584, y = 32559, z = 11 },
		effect = 296,
	},
	[15009] = {
		itemId = 51756,
		itemPos = { x = 32526, y = 32512, z = 9 },
		destination = { x = 32526, y = 32513, z = 8 },
		effect = 296,
	},
	[15010] = {
		itemId = 51756,
		itemPos = { x = 32585, y = 32558, z = 11 },
		destination = { x = 32540, y = 32513, z = 8 },
		effect = 296,
	},
	[15011] = {
		itemId = 51528,
		itemPos = { x = 32584, y = 32587, z = 11 },
		destination = { x = 32522, y = 32513, z = 8 },
		effect = 296,
	},
	[15012] = {
		itemId = 51756,
		itemPos = { x = 32552, y = 32595, z = 10 },
		destination = { x = 32536, y = 32513, z = 8 },
		effect = 296,
	},
	[15013] = {
		itemId = 51528,
		itemPos = { x = 32522, y = 32512, z = 8 },
		destination = { x = 32584, y = 32588, z = 11 },
		effect = 296,
	},
	[15014] = {
		itemId = 51624,
		itemPos = { x = 32526, y = 32512, z = 8 },
		destination = { x = 32526, y = 32513, z = 9 },
		effect = 296,
	},
	[15015] = {
		itemId = 51625,
		itemPos = { x = 32536, y = 32512, z = 8 },
		destination = { x = 32552, y = 32596, z = 10 },
		effect = 296,
	},
}
