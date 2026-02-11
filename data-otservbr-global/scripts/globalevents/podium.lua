local player1, player2, player3
local interval = 120 -- interval (in minutes)
local positions = { -- position in map
	top1 = Position({x = 1228, y = 854, z = 8}),
	top2 = Position({x = 1225, y = 854, z = 8}),
	top3 = Position({x = 1231, y = 854, z = 8})
}

local function getTopPlayers()
	local topPlayersQuery = db.storeQuery("SELECT `name`, `level`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons` FROM `players` WHERE `group_id` != 6 ORDER BY `level` DESC LIMIT 3")
	local index = 1
	if topPlayersQuery then
		repeat
			local player = {
				name = result.getDataString(topPlayersQuery, "name"),
				level = result.getDataInt(topPlayersQuery, "level"),
				outfit = {
					lookType = result.getDataInt(topPlayersQuery, "looktype"),
					lookHead = result.getDataInt(topPlayersQuery, "lookhead"),
					lookBody = result.getDataInt(topPlayersQuery, "lookbody"),
					lookLegs = result.getDataInt(topPlayersQuery, "looklegs"),
					lookFeet = result.getDataInt(topPlayersQuery, "lookfeet"),
					lookAddons = result.getDataInt(topPlayersQuery, "lookaddons")
				}
			}

			if index == 1 then
				player1 = player
			elseif index == 2 then
				player2 = player
			elseif index == 3 then
				player3 = player
			end

			index = index + 1
		until not result.next(topPlayersQuery)

		result.free(topPlayersQuery)
	else
		print("[PODIUM] Error retrieving top players.")
	end
end

local function spawnNpcs()
	getTopPlayers()

	if player1 then
		local npc1 = Game.createNpc("Top one", positions.top1)
		if npc1 then
			local npcName1 = string.format("%s [%d]", player1.name, player1.level)
			npc1:setMasterPos(positions.top1)
			npc1:setName(npcName1)
			npc1:setOutfit(player1.outfit)
			Game.setStorageValue(GlobalStorage.Podium.One, npcName1)
		end
	end

	if player2 then
		local npc2 = Game.createNpc("Top two", positions.top2)
		if npc2 then
			local npcName2 = string.format("%s [%d]", player2.name, player2.level)
			npc2:setMasterPos(positions.top2)
			npc2:setName(npcName2)
			npc2:setOutfit(player2.outfit)
			Game.setStorageValue(GlobalStorage.Podium.Two, npcName2)
		end
	end

	if player3 then
		local npc3 = Game.createNpc("Top three", positions.top3)
		if npc3 then
			local npcName3 = string.format("%s [%d]", player3.name, player3.level)
			npc3:setMasterPos(positions.top3)
			npc3:setName(npcName3)
			npc3:setOutfit(player3.outfit)
			Game.setStorageValue(GlobalStorage.Podium.Three, npcName3)
		end
	end
end

local function updatePodium()
	getTopPlayers()

	if player1 then
		local npc1Name = Game.getStorageValue(GlobalStorage.Podium.One)
		local npc1 = Npc(npc1Name)
		if npc1 then
			local newName = string.format("%s [%d]", player1.name, player1.level)
			npc1:setName(newName)
			npc1:setOutfit(player1.outfit)
			Game.setStorageValue(GlobalStorage.Podium.One, newName)
		end
	end

	if player2 then
		local npc2Name = Game.getStorageValue(GlobalStorage.Podium.Two)
		local npc2 = Npc(npc2Name)
		if npc2 then
			local newName = string.format("%s [%d]", player2.name, player2.level)
			npc2:setName(newName)
			npc2:setOutfit(player2.outfit)
			Game.setStorageValue(GlobalStorage.Podium.Two, newName)
		end
	end

	if player3 then
		local npc3Name = Game.getStorageValue(GlobalStorage.Podium.Three)
		local npc3 = Npc(npc3Name)
		if npc3 then
			local newName = string.format("%s [%d]", player3.name, player3.level)
			npc3:setName(newName)
			npc3:setOutfit(player3.outfit)
			Game.setStorageValue(GlobalStorage.Podium.Three, newName)
		end
	end
end

-- Evento ao iniciar o servidor
local initializePodium = GlobalEvent("initializePodium")
function initializePodium.onStartup()
	spawnNpcs()
end
initializePodium:register()

-- Evento periódico (padrão: a cada 120 minutos)
local podium = GlobalEvent("podium")
function podium.onThink(interval)
	updatePodium()
	return true
end
podium:interval(interval * 60000)
podium:register()
