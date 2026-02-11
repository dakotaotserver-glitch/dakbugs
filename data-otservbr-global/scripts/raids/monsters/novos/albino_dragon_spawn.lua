local albinoDragonConfig = {
	name = "Albino Dragon",
	positions = {
		Position(32094, 32565, 14),
		Position(32586, 31372, 15),
		Position(33086, 32593, 5),
		Position(33147, 31269, 5),
		Position(32769, 32312, 12),
	},
	storageNextSpawn = 940001,
	storageLastSpawnPos = 940002,
	debugMode = false, -- true para testes rápidos
	debugRespawnCooldownMin = 30, -- segundos
	debugRespawnCooldownMax = 90, -- segundos
	respawnDelayMin = 1 * 60 * 60, -- 1 hora
	respawnDelayMax = 3 * 60 * 60  -- 3 horas
}

local function getRandomSpawnPosition(excludePos)
	local candidates = {}
	for _, pos in ipairs(albinoDragonConfig.positions) do
		if excludePos == nil or (pos.x ~= excludePos.x or pos.y ~= excludePos.y or pos.z ~= excludePos.z) then
			table.insert(candidates, pos)
		end
	end
	return candidates[math.random(#candidates)]
end

local function getRandomRespawnDelay()
	if albinoDragonConfig.debugMode then
		return math.random(albinoDragonConfig.debugRespawnCooldownMin, albinoDragonConfig.debugRespawnCooldownMax)
	end
	return math.random(albinoDragonConfig.respawnDelayMin, albinoDragonConfig.respawnDelayMax)
end

local function getCurrentSpawnPosition()
	local encoded = getGlobalStorageValue(albinoDragonConfig.storageLastSpawnPos)
	if encoded == -1 then return nil end
	local z = math.floor(encoded / 100000000)
	local y = math.floor((encoded % 100000000) / 100000)
	local x = encoded % 100000
	return Position(x, y, z)
end

local function findAlbinoDragon()
	for _, pos in ipairs(albinoDragonConfig.positions) do
		local tile = Tile(pos)
		if tile then
			for _, creature in ipairs(tile:getCreatures() or {}) do
				if creature:isMonster() and creature:getName():lower() == albinoDragonConfig.name:lower() then
					return creature, pos
				end
			end
		end
	end
	return nil, nil
end

local function removeAlbinoDragon()
	for _, pos in ipairs(albinoDragonConfig.positions) do
		local tile = Tile(pos)
		if tile then
			for _, creature in ipairs(tile:getCreatures() or {}) do
				if creature:isMonster() and creature:getName():lower() == albinoDragonConfig.name:lower() then
					creature:remove()
					pos:sendMagicEffect(CONST_ME_POFF)
				end
			end
		end
	end
end

local function spawnAlbinoDragon(excludePos)
	removeAlbinoDragon()
	local spawnPos = getRandomSpawnPosition(excludePos)
	local monster = Game.createMonster(albinoDragonConfig.name, spawnPos)
	if monster then
		local delay = getRandomRespawnDelay()
		setGlobalStorageValue(albinoDragonConfig.storageLastSpawnPos, spawnPos.x + spawnPos.y * 100000 + spawnPos.z * 100000000)
		setGlobalStorageValue(albinoDragonConfig.storageNextSpawn, os.time() + delay)
		spawnPos:sendMagicEffect(CONST_ME_TELEPORT)

		-- 🔊 Broadcast enigmático
		Game.broadcastMessage("Ancient tales speak of the albino creature that never rests today, it streaked across the skies and vanished into the whispering mountains.", MESSAGE_STATUS_WARNING)
	end
end

local function checkAlbinoDragon()
	local now = os.time()
	local nextSpawn = getGlobalStorageValue(albinoDragonConfig.storageNextSpawn)
	local dragon, dragonPos = findAlbinoDragon()

	if not dragon then
		if nextSpawn == -1 or now >= nextSpawn then
			spawnAlbinoDragon(dragonPos)
		end
	else
		if now >= nextSpawn then
			dragon:remove()
			addEvent(function()
				spawnAlbinoDragon(dragonPos)
			end, 2000)
		end
	end
end

local function scheduleAlbinoDragonLoop()
	local function loop()
		checkAlbinoDragon()
		local interval = albinoDragonConfig.debugMode and 30 or 60
		addEvent(loop, interval * 1000)
	end
	loop()
end

local albinoDragonEvent = GlobalEvent("AlbinoDragonSpawn")

function albinoDragonEvent.onStartup()
	scheduleAlbinoDragonLoop()
	return true
end

albinoDragonEvent:register()
