local missionZone = Zone("death.of.dance")

missionZone:addArea({ x = 32957, y = 31412, z = 6 }, { x = 32977, y = 31427, z = 6 })

local tilesPositions = {
	[1] = Position(32960, 31417, 6),
	[2] = Position(32974, 31417, 6),
	[3] = Position(32960, 31421, 6),
	[4] = Position(32974, 31421, 6),
	[5] = Position(32963, 31423, 6),
	[6] = Position(32963, 31415, 6),
	[7] = Position(32971, 31423, 6),
	[8] = Position(32971, 31415, 6),
	[9] = Position(32967, 31424, 6),
	[10] = Position(32967, 31414, 6),
	[11] = Position(32964, 31419, 6),
	[12] = Position(32970, 31419, 6),
	[13] = Position(32967, 31421, 6),
	[14] = Position(32967, 31417, 6),
}

local playerIconAddEvent = {}
local deathOfDanceAddEvent = nil

local angryOrcAncestorSpiritOneUid = nil
local angryOrcAncestorSpiritTwoUid = nil

local function stopPlayerIconAddEvent(playerGuid)
	stopEvent(playerIconAddEvent[playerGuid])
	playerIconAddEvent[playerGuid] = nil
end

local function removeAngryOrcAncestorSpirits()
	if angryOrcAncestorSpiritOneUid then
		local angryOrcAncestorSpirit = Monster(angryOrcAncestorSpiritOneUid)
		if angryOrcAncestorSpirit and angryOrcAncestorSpirit:getName() == "Angry Orc Ancestor Spirit" then
			angryOrcAncestorSpirit:remove()
			angryOrcAncestorSpiritOneUid = nil
		end
	end

	if angryOrcAncestorSpiritTwoUid then
		local angryOrcAncestorSpirit = Monster(angryOrcAncestorSpiritTwoUid)
		if angryOrcAncestorSpirit and angryOrcAncestorSpirit:getName() == "Angry Orc Ancestor Spirit" then
			angryOrcAncestorSpirit:remove()
			angryOrcAncestorSpiritTwoUid = nil
		end
	end
end

local function createAngryOrcAncestorSpirits()
	if not angryOrcAncestorSpiritOneUid then
		local monster = Game.createMonster("Angry Orc Ancestor Spirit", Position(32968, 31419, 6), false, true)
		if monster then
			angryOrcAncestorSpiritOneUid = monster.uid
		end
	end

	if not angryOrcAncestorSpiritTwoUid then
		local monster = Game.createMonster("Angry Orc Ancestor Spirit", Position(32966, 31419, 6), false, true)
		if monster then
			angryOrcAncestorSpiritTwoUid = monster.uid
		end
	end
end

local function stopDeathOfDanceAddEvent()
	if not missionZone then
		stopEvent(deathOfDanceAddEvent)
		deathOfDanceAddEvent = nil
		removeAngryOrcAncestorSpirits()
		return
	end

	local players = missionZone:getPlayers()
	if #players <= 0 then
		stopEvent(deathOfDanceAddEvent)
		deathOfDanceAddEvent = nil
		removeAngryOrcAncestorSpirits()
	end
end

local function updateDeathOfDanceIcon(playerGuid, currentCount)
	local player = Player(playerGuid)
	if not player then
		stopPlayerIconAddEvent(playerGuid)
		return
	end

	if player:getStorageValue(Storage.Quest.U15_10.BloodyTusks.DanceOfDeath) ~= 1 then
		return true
	end

	local playerPosition = player:getPosition()

	local tile = Tile(playerPosition)
	if not tile then
		stopPlayerIconAddEvent(playerGuid)
		return
	end

	local hasActiveTile = false

	local items = tile:getItems()
	if items then
		for i = 1, #items do
			local item = items[i]
			if item:getId() == 51292 then
				hasActiveTile = true
			end
		end
	end

	if not hasActiveTile then
		currentCount = currentCount - 1
		if currentCount <= 0 then
			player:removeIcon("death-of-dance")
			stopPlayerIconAddEvent(playerGuid)
		else
			player:setIcon("death-of-dance", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, currentCount)
			playerIconAddEvent[playerGuid] = addEvent(updateDeathOfDanceIcon, 1000, playerGuid, currentCount)
		end
		return
	end

	currentCount = currentCount + 2
	if currentCount >= 50 then
		player:removeIcon("death-of-dance")
		stopPlayerIconAddEvent(playerGuid)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "YOU HAVE APPEASED THE ORCISH ANCESTORS!")
		playerPosition:sendMagicEffect(CONST_ME_HOLYAREA)
		player:setStorageValue(Storage.Quest.U15_10.BloodyTusks.DanceOfDeath, 2)
		player:setStorageValue(Storage.Quest.U15_10.BloodyTusks.TheNextStep, 1)
	else
		player:setIcon("death-of-dance", CreatureIconCategory_Quests, CreatureIconQuests_RedBall, currentCount)
		playerIconAddEvent[playerGuid] = addEvent(updateDeathOfDanceIcon, 1000, playerGuid, currentCount)
	end

	return
end

local function updateDeathOfDanceTiles()
	stopDeathOfDanceAddEvent()

	if not missionZone or not deathOfDanceAddEvent then
		return
	end

	createAngryOrcAncestorSpirits()

	for i = 1, #tilesPositions do
		local rand = math.random(100)
		local tile = Tile(tilesPositions[i])
		if tile then
			local item = tile:getItemById(51292)
			if item then
				if rand > 80 then
					item:transform(51655)
				end
			else
				item = tile:getItemById(51655)
				if item then
					if rand > 80 then
						item:transform(51292)
					end
				end
			end
		end
	end

	deathOfDanceAddEvent = addEvent(updateDeathOfDanceTiles, 1000)
end

local tile = MoveEvent()

function tile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U15_10.BloodyTusks.DanceOfDeath) ~= 1 then
		return true
	end

	if missionZone and missionZone:isInZone(position) then
		local playerGuid = player:getGuid()
		if not playerIconAddEvent[playerGuid] then
			playerIconAddEvent[playerGuid] = addEvent(updateDeathOfDanceIcon, 1, playerGuid, 0)
		end
	end

	return true
end

tile:id(51292)
tile:type("stepin")
tile:register()

local zoneEvent = ZoneEvent(missionZone)

function zoneEvent.afterEnter(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if not deathOfDanceAddEvent then
		deathOfDanceAddEvent = addEvent(updateDeathOfDanceTiles, 1000)
	end
end

function zoneEvent.afterLeave(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	stopDeathOfDanceAddEvent()
	stopPlayerIconAddEvent(player:getGuid())
	player:removeIcon("death-of-dance")
end

zoneEvent:register()
