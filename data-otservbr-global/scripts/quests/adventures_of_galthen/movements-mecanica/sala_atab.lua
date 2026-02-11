local config = {
	bossName = "Atab",
	requiredLevel = 250,
	timeToFightAgain = 10, -- In hour
	destination = Position(34008, 31590, 10),
	exitPosition = Position(34009, 31585, 10),
}

local entrancesTiles = {
	{ x = 34009, y = 31586, z = 10 },
	{ x = 34011, y = 31605, z = 10 },
	{ x = 34011, y = 31604, z = 10 },

}

local zone = Zone("boss." .. toKey(config.bossName))
local encounter = Encounter("Atab", {
	zone = zone,
	timeToSpawnMonsters = "50ms",
})

zone:blockFamiliars()
zone:setRemoveDestination(config.exitPosition)

local locked = false

function encounter:onReset()
	locked = false
	encounter:removeMonsters()
end

encounter:addRemoveMonsters():autoAdvance()
encounter:addBroadcast("You've entered the Atab lair."):autoAdvance()
encounter
	:addSpawnMonsters({
		{
			name = "Atab",
			positions = {
				Position(34009, 31592, 10),
			},
		},
		{
			name = "Mitmah Scout",
			positions = {
				Position(34006, 31590, 10),
				Position(34011, 31590, 10),
		
			},
		},
		{
			name = "Mitmah Seer",
			positions = {
				Position(34006, 31593, 10),
				Position(34011, 31593, 10),
		
			},
		},
		{
			name = "Iks Yapunac",
			positions = {
				Position(34008, 31592, 10),
		
			},
		},
	})
	:autoAdvance("30s")

encounter
	:addStage({
		start = function()
			locked = true
		end,
	})
	:autoAdvance("270s")

encounter:addRemovePlayers():autoAdvance()

encounter:startOnEnter()  -- Inicia o encontro ao entrar na zona
encounter:register()

local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
	if not creature or not creature:isPlayer() then
		return false
	end
	local player = creature
	if player:getLevel() < config.requiredLevel then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be level " .. config.requiredLevel .. " or higher.")
		return true
	end
	if locked then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's already someone fighting with " .. config.bossName .. ".")
		return false
	end
	if zone:countPlayers(IgnoredByMonsters) >= 5 then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The boss room is full.")
		return false
	end
	local timeLeft = player:getBossCooldown(config.bossName) - os.time()
	if timeLeft > 0 then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. getTimeInWords(timeLeft) .. " to face " .. config.bossName .. " again!")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	player:teleportTo(config.destination)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:setBossCooldown(config.bossName, os.time() + config.timeToFightAgain * 3600)
	player:sendBosstiaryCooldownTimer()
	encounter:start()  -- Inicia o encontro, criando os monstros
end

for _, registerPosition in ipairs(entrancesTiles) do
	teleportBoss:position(registerPosition)
end

teleportBoss:type("stepin")
teleportBoss:register()

--SimpleTeleport(Position(34008, 31581, 10), config.exitPosition)