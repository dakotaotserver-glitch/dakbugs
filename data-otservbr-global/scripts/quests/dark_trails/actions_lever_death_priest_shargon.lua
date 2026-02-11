local setting = {
	centerRoom = Position(33487, 32111, 9),
	range = 10,
	playerPositions = {
		Position(33583, 31844, 10),
		Position(33584, 31844, 10),
		Position(33585, 31844, 10),
		Position(33586, 31844, 10),
		Position(33587, 31844, 10),
	},
	newPositions = {
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
		Position(33486, 32120, 9),
	},
	minionPositions = {
		Position(33482, 32105, 9),
		Position(33484, 32105, 9),
		Position(33484, 32107, 9),
		Position(33481, 32109, 9),
		Position(33482, 32111, 9),
		Position(33488, 32106, 9),
		Position(33490, 32106, 9),
		Position(33492, 32109, 9),
		Position(33492, 32112, 9),
		Position(33490, 32112, 9),
	},
}

-- Storage para cooldown individual por player (1 hora)
local Storage = {
	DeathPriestShargonCooldown = 700100
}

-- Função para verificar se há jogadores vivos na sala
local function isPlayerAliveInRoom(centerPosition, range)
	local spectators = Game.getSpectators(centerPosition, false, true, range, range, range, range)
	for _, creature in ipairs(spectators) do
		if creature:isPlayer() and creature:getHealth() > 0 then
			return true
		end
	end
	return false
end

local leverDeathPriestShargon = Action()

function leverDeathPriestShargon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		-- Checa cooldown individual (exceto GMs)
		if not player:getGroup():getAccess() then
			local remainingTime = player:getStorageValue(Storage.DeathPriestShargonCooldown) - os.time()
			if remainingTime > 0 then
				local minutes = math.ceil(remainingTime / 60)
				player:sendCancelMessage("You need to wait " .. minutes .. " minute(s) before entering the boss room again.")
				return true
			end
		end

		-- Bloqueia se houver jogador vivo na sala (exceto GMs)
		if not player:getGroup():getAccess() and isPlayerAliveInRoom(setting.centerRoom, setting.range) then
			player:say("Someone is fighting against the boss! You need to wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		end

		local storePlayers = {}

		-- GMs entram sozinhos, ignoram posições
		if player:getGroup():getAccess() then
			storePlayers = {player}
		else
			for i = 1, #setting.playerPositions do
				local tile = Tile(setting.playerPositions[i])
				local creature = tile and tile:getTopCreature()
				if creature and creature:isPlayer() then
					storePlayers[#storePlayers + 1] = creature
				end
			end

			if #storePlayers == 0 then
				player:sendCancelMessage("You need at least one player to fight with Death Priest Shargon.")
				return true
			end
		end

		-- Limpa todos os monstros da sala antes do respawn
		local spectators = Game.getSpectators(setting.centerRoom, false, false, setting.range, setting.range, setting.range, setting.range)
		for _, creature in ipairs(spectators) do
			if creature:isMonster() then
				creature:remove()
			end
		end

		-- Cria os minions
		for i = 1, #setting.minionPositions do
			Game.createMonster("greater death minion", setting.minionPositions[i])
		end

		-- Cria o boss
		Game.createMonster("death priest shargon", Position(33487, 32108, 9))

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
				playerToTeleport:setStorageValue(Storage.DeathPriestShargonCooldown, os.time() + 3600)
			end
		end

		item:transform(2773)
	elseif item.itemid == 2773 then
		item:transform(2772)
	end
	return true
end

leverDeathPriestShargon:uid(30002)
leverDeathPriestShargon:register()
