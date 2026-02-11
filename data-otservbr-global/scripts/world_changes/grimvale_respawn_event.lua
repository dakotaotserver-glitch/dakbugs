local grimvaleConfig = {
	position = { fromPosition = Position(33330, 31670, 7), toPosition = Position(33350, 31690, 7) },
}

local owinConfig = {
	name = "Owin",
	position = Position(33368, 31614, 9),
	respawnInterval = 50 * 60 * 1000 -- 50 minutos
}

local OWIN_STORAGE_NEXT_RESPAWN = 9200001
local forceOwin = false -- true para ignorar lua cheia no spawn de Owin (modo debug)

-- 🔁 Copia profunda de tabelas
local function deepcopy(orig)
	local copy = {}
	for k, v in pairs(orig) do
		if type(v) == "table" then
			copy[k] = deepcopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

-- 🌕 Detecta lua cheia real
local function isFullMoonToday()
	local lunarPeriod = 29.53058770576
	local newMoon2000 = os.time({ year = 2000, month = 1, day = 6, hour = 18, min = 14 })
	local now = os.time()
	local moonAgeDays = ((now - newMoon2000) % (lunarPeriod * 86400)) / 86400
	return moonAgeDays >= 13.8 and moonAgeDays <= 15.8
end

-- 👾 Cria monstro e registra respawn automático (como se fosse XML)
local function createRandomMonster(position, availableMonsters)
	local tile = Tile(position)
	if not tile or tile:getItemById(486) or tile:hasProperty(CONST_PROP_BLOCKSOLID) or tile:getTopCreature() then
		return false
	end

	local monsterName = availableMonsters[math.random(#availableMonsters)]
	local monster = Game.createMonster(monsterName, position)
	if monster then
		monster:setSpawnPosition() -- ✅ grava como spawn permanente
		monster:remove() -- ✅ remove o primeiro, deixa o servidor cuidar do respawn
	end
	return true
end

-- 🧠 Spawns garantidos + aleatórios por fase da lua
local function spawnMonsters(monstersToSpawn)
	local area = {
		fromX = grimvaleConfig.position.fromPosition.x,
		toX = grimvaleConfig.position.toPosition.x,
		fromY = grimvaleConfig.position.fromPosition.y,
		toY = grimvaleConfig.position.toPosition.y,
		z = grimvaleConfig.position.fromPosition.z,
	}

	local validPositions = {}
	for x = area.fromX, area.toX do
		for y = area.fromY, area.toY do
			table.insert(validPositions, Position(x, y, area.z))
		end
	end

	for _, monsterName in ipairs(monstersToSpawn) do
		local shuffled = deepcopy(validPositions)
		for i = #shuffled, 2, -1 do
			local j = math.random(i)
			shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
		end
		for _, pos in ipairs(shuffled) do
			if createRandomMonster(pos, { monsterName }) then
				break
			end
		end
	end

	for _, pos in ipairs(validPositions) do
		if math.random(1000) >= 970 then
			createRandomMonster(pos, monstersToSpawn)
		end
	end
end

-- 👑 Spawn de Owin com controle por tempo
local function spawnOwinIfNotPresent()
	local tile = Tile(owinConfig.position)
	if tile then
		local creature = tile:getTopCreature()
		if creature and creature:isMonster() and creature:getName():lower() == owinConfig.name:lower() then
			return -- Owin já está presente
		end
	end

	local nextAllowedRespawn = getGlobalStorageValue(OWIN_STORAGE_NEXT_RESPAWN)
	if nextAllowedRespawn ~= -1 and os.time() < nextAllowedRespawn then
		return -- Ainda não é hora de renascer
	end

	local boss = Game.createMonster(owinConfig.name, owinConfig.position)
	if boss then
		local delay = owinConfig.respawnInterval / 1000
		setGlobalStorageValue(OWIN_STORAGE_NEXT_RESPAWN, os.time() + delay)
	end
end

-- 🔁 Loop de Owin com controle por tempo
local function startOwinRespawnLoop()
	local function loop()
		if forceOwin or isFullMoonToday() then
			spawnOwinIfNotPresent()
			addEvent(loop, owinConfig.respawnInterval)
		end
	end
	loop()
end

-- 🌍 Evento global
local grimvaleRespawnEvent = GlobalEvent("GrimvaleRespawnEvent")

function grimvaleRespawnEvent.onStartup()
	local monstersToSpawn = isFullMoonToday() and {
		"wereboar", "werebadger"
	} or {
		"bandit", "badger", "blue butterfly", "yellow butterfly"
	}

	spawnMonsters(monstersToSpawn)

	if forceOwin or isFullMoonToday() then
		startOwinRespawnLoop()
	end

	return true
end

grimvaleRespawnEvent:register()
