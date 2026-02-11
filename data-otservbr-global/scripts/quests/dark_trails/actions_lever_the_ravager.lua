local setting = {
	centerRoom = Position(33487, 32079, 8),
	range = 10,
	playerPositions = {
		Position(33417, 32102, 10),
		Position(33418, 32102, 10),
		Position(33419, 32102, 10),
		Position(33420, 32102, 10),
	},
	newPositions = {
		Position(33487, 32087, 8),
		Position(33487, 32087, 8),
		Position(33487, 32087, 8),
		Position(33487, 32087, 8),
	},
	canopicJarPositions = {
		Position(33486, 32081, 8),
		Position(33488, 32081, 8),
		Position(33486, 32083, 8),
		Position(33488, 32083, 8),
	}
}

-- Storage exclusivo para cooldown do Ravager
local Storage = {
	TheRavagerCooldown = 700200
}

-- Função para verificar se há players vivos na sala
local function isPlayerAliveInRoom(centerPosition, range)
	local spectators = Game.getSpectators(centerPosition, false, true, range, range, range, range)
	for _, creature in ipairs(spectators) do
		if creature:isPlayer() and creature:getHealth() > 0 then
			return true
		end
	end
	return false
end

local leverTheRavager = Action()

function leverTheRavager.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		-- Checa cooldown individual (exceto GMs)
		if not player:getGroup():getAccess() then
			local remainingTime = player:getStorageValue(Storage.TheRavagerCooldown) - os.time()
			if remainingTime > 0 then
				local minutes = math.ceil(remainingTime / 60)
				player:sendCancelMessage("You need to wait " .. minutes .. " minute(s) before entering the boss room again.")
				return true
			end
		end

		-- Bloqueia se houver player vivo na sala (exceto GMs)
		if not player:getGroup():getAccess() and isPlayerAliveInRoom(setting.centerRoom, setting.range) then
			player:say("Someone is fighting against the boss! You need to wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		end

		local storePlayers = {}

		-- GMs ignoram as posições
		if player:getGroup():getAccess() then
			storePlayers = {player}
		else
			for i = 1, #setting.playerPositions do
				local creature = Tile(setting.playerPositions[i]):getTopCreature()
				if creature and creature:isPlayer() then
					storePlayers[#storePlayers + 1] = creature
				end
			end

			if #storePlayers == 0 then
				player:sendCancelMessage("You need at least one player to fight with The Ravager.")
				return true
			end
		end

		-- Limpa todos os monstros e summons da sala
		local spectators = Game.getSpectators(setting.centerRoom, false, false, setting.range, setting.range, setting.range, setting.range)
		for _, creature in ipairs(spectators) do
			if creature:isMonster() then
				creature:remove()
			end
		end

		-- Cria os canopic jars
		for i = 1, #setting.canopicJarPositions do
			Game.createMonster("greater canopic jar", setting.canopicJarPositions[i])
		end

		-- Cria o boss
		Game.createMonster("the ravager", setting.centerRoom)

		-- Teleporta os jogadores e aplica cooldown
		for i = 1, #storePlayers do
			local playerToTeleport = storePlayers[i]
			local oldPosition = setting.playerPositions[i] or playerToTeleport:getPosition()
			local newPosition = setting.newPositions[i] or setting.newPositions[1]

			if Tile(oldPosition) then
				oldPosition:sendMagicEffect(CONST_ME_POFF)
			end
			playerToTeleport:teleportTo(newPosition)
			newPosition:sendMagicEffect(CONST_ME_ENERGYAREA)

			-- Aplica cooldown de 1 hora
			if not playerToTeleport:getGroup():getAccess() then
				playerToTeleport:setStorageValue(Storage.TheRavagerCooldown, os.time() + 3600)
			end
		end

		item:transform(2773)
	elseif item.itemid == 2773 then
		item:transform(2772)
	end
	return true
end

leverTheRavager:uid(30001)
leverTheRavager:register()
