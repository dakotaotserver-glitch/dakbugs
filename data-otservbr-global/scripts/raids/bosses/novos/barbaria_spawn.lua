-- Barbaria Boss Raid (silenciosa e autônoma)
local debugMode = false -- ✅ true para testes, sem prints

local BarbariaRaid = {
	name = "BarbariaAutonomous",
	position = Position(32006, 31417, 7),
	monsterName = "Barbaria",
	intervalCheck = 60, -- segundos
	minDaysBetween = 8,
	maxDaysBetween = 10,
	lastSpawn = 0,
}

if not BarbariaRaid.lastSpawn or BarbariaRaid.lastSpawn == 0 then
	BarbariaRaid.lastSpawn = os.time() - (11 * 86400) -- força o primeiro spawn real
end

local function spawnBarbaria()
	local tile = Tile(BarbariaRaid.position)
	if tile then
		local existing = tile:getTopCreature()
		if existing and existing:isMonster() and existing:getName():lower() == BarbariaRaid.monsterName:lower() then
			return -- Já está presente
		end
	end

	Game.createMonster(BarbariaRaid.monsterName, BarbariaRaid.position)
	BarbariaRaid.lastSpawn = os.time()
end

local event = GlobalEvent("BarbariaRaidAutonomous")

function event.onThink()
	if debugMode then
		spawnBarbaria()
		return true
	end

	local now = os.time()
	local daysSinceLast = (now - BarbariaRaid.lastSpawn) / 86400

	if daysSinceLast >= math.random(BarbariaRaid.minDaysBetween, BarbariaRaid.maxDaysBetween) then
		spawnBarbaria()
	end

	return true
end

event:interval(BarbariaRaid.intervalCheck * 1000)
event:register()
