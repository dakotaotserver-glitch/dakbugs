local healOnApproach = CreatureEvent("HealOnApproach")
local healCooldown = 2000 -- tempo em milissegundos (2 segundos)
local lastHeal = {} -- armazena o tempo do último heal por criatura

function healOnApproach.onThink(creature, item, position, fromPosition)
	if not creature:isMonster() or creature:getName():lower() ~= "soulless minion" then
		return true
	end

	local currentTime = os.time() * 1000
	local creatureId = creature:getId()

	if not lastHeal[creatureId] then
		lastHeal[creatureId] = 0
	end

	if currentTime - lastHeal[creatureId] < healCooldown then
		return true
	end

	lastHeal[creatureId] = currentTime

	local spectators = Game.getSpectators(creature:getPosition(), false, false, 1, 1, 1, 1)
	for _, spectator in ipairs(spectators) do
		if spectator:isMonster() and spectator:getName():lower() == "count vlarkorth" then
			local amount = math.random(200, 2000)
			spectator:addHealth(amount)
			spectator:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end

	return true
end

healOnApproach:register()
