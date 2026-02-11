local debugMode = false -- ✅ true para testes automáticos sem chance

local FoldaYeti = {
	nameEvent = "FoldaYetiInvasion",
	fromPos = Position(31991, 31580, 7),
	toPos = Position(32044, 31616, 7),
	monster = { "Yeti" },
	mcount = math.random(15, 25),
	broadcasts = {
		"Something is moving to the icy grounds of Folda.",
		"Many Yetis are emerging from the icy mountains of Folda.",
		"Numerous Yetis are dominating Folda, beware!",
	},
	minutesToClear = 60,
	chancePerCheck = 0.01,
	checkInterval = 600,
	minGapSeconds = 72 * 60 * 60,
	lastActivation = 0,
	debugInterval = 60,
}

local cacheMonsters = {}

local function getRandomTile()
	local from, to = FoldaYeti.fromPos, FoldaYeti.toPos
	for _ = 1, 100 do
		local pos = Position(math.random(from.x, to.x), math.random(from.y, to.y), from.z)
		local tile = Tile(pos)
		if tile and tile:isWalkable() then
			return tile
		end
	end
	return nil
end

function FoldaYeti:spawn()
	cacheMonsters = {}

	-- Mensagens em sequência
	for i, msg in ipairs(self.broadcasts) do
		addEvent(function()
			Game.broadcastMessage(msg, MESSAGE_GAME_HIGHLIGHT)
		end, (i - 1) * 25000)
	end

	-- Spawn após mensagens
	addEvent(function()
		for i = 1, self.mcount do
			local tile = getRandomTile()
			if tile then
				local pos = tile:getPosition()
				local monName = self.monster[math.random(1, #self.monster)]
				local mob = Game.createMonster(monName, pos)
				if mob then
					table.insert(cacheMonsters, mob:getId())
				end
			end
		end
	end, (#self.broadcasts + 1) * 3000)

	self.lastActivation = os.time()

	addEvent(function()
		FoldaYeti:clear()
	end, self.minutesToClear * 60 * 1000)
end

function FoldaYeti:clear()
	for _, uid in ipairs(cacheMonsters) do
		local mob = Monster(uid)
		if mob and mob:isMonster() then
			mob:remove()
		end
	end
	cacheMonsters = {}
end

if debugMode then
	local debugEvent = GlobalEvent("FoldaYetiDebug")
	function debugEvent.onThink()
		FoldaYeti:spawn()
		return true
	end
	debugEvent:interval(FoldaYeti.debugInterval * 1000)
	debugEvent:register()
end

if not debugMode then
	local autorunEvent = GlobalEvent("FoldaYetiChance")
	function autorunEvent.onThink()
		local now = os.time()
		if now - FoldaYeti.lastActivation < FoldaYeti.minGapSeconds then
			return true
		end

		local roll = math.random()
		if roll <= FoldaYeti.chancePerCheck then
			FoldaYeti:spawn()
		end
		return true
	end
	autorunEvent:interval(FoldaYeti.checkInterval * 1000)
	autorunEvent:register()
end
