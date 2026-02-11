local trollConfig = {
	name = "Big Boss Trolliver",
	position = Position(33134, 31722, 10),

	storageLastSpawn = 961200,
	storageDespawnTime = 961201,

	minDays = 3,
	maxDays = 8,
	checkInterval = 300, -- checa a cada 5 minutos
	despawnAfter = 4 * 60 * 60 -- 4 horas
}

local function isTrolliverAlive()
	local tile = Tile(trollConfig.position)
	if not tile then return false end
	for _, creature in ipairs(tile:getCreatures() or {}) do
		if creature:isMonster() and creature:getName():lower() == trollConfig.name:lower() then
			return true
		end
	end
	return false
end

local function removeTrolliver()
	local tile = Tile(trollConfig.position)
	if not tile then return end
	for _, creature in ipairs(tile:getCreatures() or {}) do
		if creature:isMonster() and creature:getName():lower() == trollConfig.name:lower() then
			creature:remove()
		end
	end
end

local function spawnTrolliver()
	if isTrolliverAlive() then return false end
	local mob = Game.createMonster(trollConfig.name, trollConfig.position)
	if mob then
		setGlobalStorageValue(trollConfig.storageLastSpawn, os.time())
		setGlobalStorageValue(trollConfig.storageDespawnTime, os.time() + trollConfig.despawnAfter)
		return true
	end
	return false
end

local function checkTrolliver()
	local now = os.time()
	local lastSpawn = getGlobalStorageValue(trollConfig.storageLastSpawn)
	local despawnAt = getGlobalStorageValue(trollConfig.storageDespawnTime)

	if lastSpawn == -1 then
		lastSpawn = now - (trollConfig.maxDays * 86400) -- força primeiro spawn permitido
	end

	-- Verifica se deve remover
	if isTrolliverAlive() and despawnAt ~= -1 and now >= despawnAt then
		removeTrolliver()
		setGlobalStorageValue(trollConfig.storageDespawnTime, -1)
		return
	end

	-- Verifica se já passaram os dias mínimos
	local daysSinceLast = (now - lastSpawn) / 86400
	local threshold = math.random(trollConfig.minDays, trollConfig.maxDays)
	if daysSinceLast >= threshold then
		spawnTrolliver()
	end
end

local trollEvent = GlobalEvent("TrolliverAutoSpawn")
function trollEvent.onThink()
	checkTrolliver()
	return true
end

trollEvent:interval(trollConfig.checkInterval * 1000)
trollEvent:register()
