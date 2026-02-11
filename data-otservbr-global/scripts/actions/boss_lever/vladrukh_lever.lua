local config = {
    boss = {
        name = "Vladrukh",
        position = Position(32912, 31463, 15), 
        timeToFightAgain = 10 * 60 * 60,
    },
    requiredLevel = 250,
    timeToDefeat = 20 * 60,
    playerPositions = {
        { pos = Position(32951, 31464, 15), teleport = Position(32912, 31457, 15), effect = CONST_ME_TELEPORT }, 
        { pos = Position(32951, 31465, 15), teleport = Position(32912, 31457, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32951, 31466, 15), teleport = Position(32912, 31457, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32951, 31467, 15), teleport = Position(32912, 31457, 15), effect = CONST_ME_TELEPORT },
        { pos = Position(32951, 31468, 15), teleport = Position(32912, 31457, 15), effect = CONST_ME_TELEPORT },
    },
	-- monsters = { -- POSSIVELMENTE EDITAR ISSO COM SUMMOMS BAT ETC
		--{ name = "Magmaoid", pos = Position(32497, 31152, 15) },
		--{ name = "Magmaoid", pos = Position(32499, 31158, 15) },
		--{ name = "Magmaoid", pos = Position(32502, 31153, 15) },
		--{ name = "Magmaoid", pos = Position(32503, 31158, 15) },

	--},
    specPos = { -- COLOQUEI A POSICAO DO FIM DA ESQUERDA PARA FIM DA DIREITA
        from = Position(32904, 31463, 15),
        to = Position(32920, 31463, 15),
    },
    exit = Position(32918, 31457, 15), 
    storage = Storage.Quest.U15_10.BloodyTusks.VladrukhTimer
}

local lever = BossLever(config)
lever:position({ x = 32951, y = 31463, z = 15 })
lever:register()

