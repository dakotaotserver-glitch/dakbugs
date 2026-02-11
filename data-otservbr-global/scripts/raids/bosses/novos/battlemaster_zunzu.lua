local debugMode = false -- ✅ true para testes automáticos

local ZunzuRaid = {
	name = "Battlemaster Zunzu",
	positions = {
		Position(33230, 31242, 7),
		Position(33271, 31237, 7),
		Position(33204, 31239, 7)
	},
	minDays = 10,
	maxDays = 14,
	intervalCheck = 60, -- em segundos
	lastSpawn = 0,
}

if ZunzuRaid.lastSpawn == 0 then
	ZunzuRaid.lastSpawn = os.time() - (ZunzuRaid.maxDays * 86400)
end

local function spawnZunzu()
	local spawnPos = ZunzuRaid.positions[math.random(1, #ZunzuRaid.positions)]
	local tile = Tile(spawnPos)
	if tile then
		local creature = tile:getTopCreature()
		if creature and creature:isMonster() and creature:getName():lower() == ZunzuRaid.name:lower() then
			return -- Já está presente
		end
	end
	Game.createMonster(ZunzuRaid.name, spawnPos)
	ZunzuRaid.lastSpawn = os.time()
end

local event = GlobalEvent("ZunzuRaidAutonomous")

function event.onThink()
	if debugMode then
		spawnZunzu()
		return true
	end

	local now = os.time()
	local daysSince = (now - ZunzuRaid.lastSpawn) / 86400

	if daysSince >= math.random(ZunzuRaid.minDays, ZunzuRaid.maxDays) then
		spawnZunzu()
	end

	return true
end

event:interval(ZunzuRaid.intervalCheck * 1000)
event:register()
