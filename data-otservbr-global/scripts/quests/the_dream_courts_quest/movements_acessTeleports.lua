local default = {
	[1] = {
		itemPosition = Position(33618, 32546, 13),
		toPosition = Position(32723, 32270, 8),
		neededStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 2,
		blockedText = "Connect all three gateways to restore the circle of energy sustaining this nexus.",
	},
	[2] = {
		itemPosition = Position(32720, 32270, 8),
		toPosition = Position(33618, 32544, 13),
		neededStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 2,
		blockedText = "Connect all three gateways to restore the circle of energy sustaining this nexus.",
	},
	[3] = {
		itemPosition = Position(33619, 32526, 15),
		toPosition = Position(33619, 32528, 15),
		neededStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 2,
		msg = "You traverse the rubble with ease but more of it falls down behind you, essentially blocking your path once again.",
	},
}

local dreamScar = {
	[1] = {
		day = "Monday",
		bossName = "Plagueroot",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.PlaguerootTimer,
	},
	[2] = {
		day = "Tuesday",
		bossName = "Malofur Mangrinder",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MalofurTimer,
	},
	[3] = {
		day = "Wednesday",
		bossName = "Maxxenius",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MaxxeniusTimer,
	},
	[4] = {
		day = "Thursday",
		bossName = "Alptramun",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunTimer,
	},
	[5] = {
		day = "Friday",
		bossName = "Izcandar the Banished",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarTimer,
	},
	[6] = {
		day = "Saturday",
		bossName = "Maxxenius",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MaxxeniusTimer,
	},
	[7] = {
		day = "Sunday",
		bossName = "Alptramun",
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunTimer,
	},
}


local permission = Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission

local movements_acessTeleports = MoveEvent()

function movements_acessTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player then
		return true
	end

	local iPos = item:getPosition()
	local dreamScarTeleport = Position(32208, 32033, 13)
	local nightmareTeleport = Position(32211, 32081, 15)

	if item:getPosition() == nightmareTeleport then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount) >= 5 then
			if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.NightmareTimer) > os.time() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait to challenge The Nightmare Beast again!")
				player:teleportTo(fromPosition)
			else
				player:teleportTo(Position(32211, 32075, 15))
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this teleport yet.")
			player:teleportTo(fromPosition)
		end
	end

	for _, k in pairs(default) do
		if k.itemPosition == iPos then
			if player:getStorageValue(k.neededStorage) >= k.value then
				player:teleportTo(k.toPosition)
				if k.msg then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, k.msg)
				end
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, k.blockedText)
			end
		end
	end

	if iPos == dreamScarTeleport then
	if player:getStorageValue(permission) >= 1 then
		player:teleportTo(Position(32208, 32026, 13))
	else
		player:teleportTo(fromPosition)
	end
end


	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	return true
end

movements_acessTeleports:aid(23103)
movements_acessTeleports:register()
