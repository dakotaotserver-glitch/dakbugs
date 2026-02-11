local vortex = {
	[14321] = Position(32149, 31359, 14), -- Charger TP 1
	[14322] = Position(32092, 31330, 12), -- Charger Exit
	[14324] = Position(32104, 31329, 12), -- Anomaly Exit
	[14325] = Position(32216, 31380, 14), -- Main Room
	[14340] = Position(32159, 31329, 11), -- Main Room Exit
	[14341] = Position(32078, 31320, 13), -- Cracklers Exit
	[14343] = Position(32088, 31321, 13), -- Rupture Exit
	[14345] = Position(32230, 31358, 11), -- Realityquake Exit
	[14347] = Position(32225, 31347, 11), -- Unstable Sparks Exit
	[14348] = Position(32218, 31375, 14), -- Eradicator Exit (Main Room)
	[14350] = Position(32208, 31372, 14), -- Outburst Exit (Main Room)
	[14352] = Position(32214, 31376, 14), -- World Devourer Exit (Main Room)
	[14354] = Position(32112, 31375, 14), -- World Devourer (Reward Room)
}

local accessVortex = {
	[14323] = {position = Position(32246, 31252, 14), storage = 14320, boss = "Anomaly"},
	[14342] = {position = Position(32305, 31249, 14), storage = 14322, boss = "Rupture"},
	[14344] = {position = Position(32181, 31240, 14), storage = 14324, boss = "Realityquake"},
}

local finalBosses = {
	[14346] = {position = Position(32336, 31293, 14), storage1 = 14326, storage2 = 14327, storage3 = 14328, boss = "Eradicator"},
	[14349] = {position = Position(32204, 31290, 14), storage1 = 14326, storage2 = 14327, storage3 = 14328, boss = "Outburst"},
}

local teleportHeart = MoveEvent()

function teleportHeart.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local normalVortex = vortex[item.actionid]
	local bossVortex = accessVortex[item.actionid]
	local uBosses = finalBosses[item.actionid]
	
	-- Verificação para Anomaly com Action ID 14323
	if item.actionid == 14323 then
		if player:getStorageValue(14320) >= 1 then
			player:teleportTo(accessVortex[14323].position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to the Anomaly room.")
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this portal.")
		end
		return true
	end

	-- Verificação para Rupture com Action ID 14342
	if item.actionid == 14342 then
		if player:getStorageValue(14322) >= 1 then
			player:teleportTo(accessVortex[14342].position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to the Rupture room.")
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this portal.")
		end
		return true
	end

	-- Verificação para Realityquake com Action ID 14344
	if item.actionid == 14344 then
		if player:getStorageValue(14324) >= 1 then
			player:teleportTo(accessVortex[14344].position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to the Realityquake room.")
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this portal.")
		end
		return true
	end

	-- Verificação para Eradicator com Action ID 14346
	if item.actionid == 14346 then
		if player:getStorageValue(14326) >= 1 and player:getStorageValue(14327) >= 1 and player:getStorageValue(14328) >= 1 then
			player:teleportTo(finalBosses[14346].position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to the Eradicator room.")
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this portal.")
		end
		return true
	end

	-- Verificação para Outburst com Action ID 14349
	if item.actionid == 14349 then
		if player:getStorageValue(14326) >= 1 and player:getStorageValue(14327) >= 1 and player:getStorageValue(14328) >= 1 then
			player:teleportTo(finalBosses[14349].position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to the Outburst room.")
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this portal.")
		end
		return true
	end

	if normalVortex then
		player:teleportTo(normalVortex)
	elseif bossVortex then
		if player:getStorageValue(bossVortex.storage) >= 1 then
			if player:canFightBoss(bossVortex.boss) then
				player:teleportTo(bossVortex.position)
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	elseif uBosses then
		if player:getStorageValue(uBosses.storage1) >= 1 and player:getStorageValue(uBosses.storage2) >= 1 and player:getStorageValue(uBosses.storage3) >= 1 then
			if player:canFightBoss(uBosses.boss) then
				player:teleportTo(uBosses.position)
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	elseif item.actionid == 14351 then
		if player:getStorageValue(14330) >= 1 and player:getStorageValue(14332) >= 1 then
			if player:canFightBoss("World Devourer") then
				player:teleportTo(Position(32272, 31384, 14))
			else
				player:teleportTo(fromPosition)
				player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
			end
		else
			player:teleportTo(fromPosition)
			player:sendTextMessage(19, "You don't have access to this portal.")
		end
	elseif item.actionid == 14353 then
		player:teleportTo(Position(32214, 31376, 14))
		player:setStorageValue(14334, -1)
		player:setStorageValue(14335, -1)
		player:setStorageValue(14336, -1)
		player:unregisterEvent("DevourerStorage")
	end
	return true
end

teleportHeart:type("stepin")

-- Registra o evento para cada Action ID no script
for index, _ in pairs(vortex) do
	teleportHeart:aid(index)
end
teleportHeart:aid(14351)
teleportHeart:aid(14323)
teleportHeart:aid(14342)
teleportHeart:aid(14344)
teleportHeart:aid(14346)
teleportHeart:aid(14349)
teleportHeart:register()
