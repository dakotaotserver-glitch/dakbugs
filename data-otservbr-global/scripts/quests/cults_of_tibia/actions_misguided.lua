local function hasPlayerInArea(fromPos, toPos)
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			for z = fromPos.z, toPos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

local function removeCreatures(frompos, topos)
	for x = frompos.x, topos.x do
		for y = frompos.y, topos.y do
			for z = frompos.z, topos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					for _, creature in pairs(tile:getCreatures()) do
						if creature and not creature:isPlayer() then
							creature:remove()
						end
					end
				end
			end
		end
	end
end

local function cleanMMap(frompos, topos)
	for x = frompos.x, topos.x do
		for y = frompos.y, topos.y do
			for z = frompos.z, topos.z do
				local pos = Position(x, y, z)
				local tile = Tile(pos)
				if tile and tile:getItemCount() > 0 then
					for _, item in pairs(tile:getItems()) do
						if item then
							local itemType = ItemType(item:getId())
							if itemType and not itemType:isCorpse() and not itemType:isContainer() and itemType:getWeaponType() <= WEAPON_NONE then
								item:remove()
							end
						end
					end
				end
			end
		end
	end
end

local function changeMap(mapName)
	local current = (type(Game.getStorageValue("cultsMisguidedMap")) == "string" and Game.getStorageValue("cultsMisguidedMap") or "illusion")
	if current:lower() == mapName:lower() then
		return true
	end

	local frompos = Position(32523, 32323, 10)
	local topos = Position(32573, 32477, 10)

	-- Verifica se há players antes de alterar o mapa
	if hasPlayerInArea(frompos, topos) then
		--print("⛔ Cancelada a troca de mapa: há jogadores na área.")
		return false
	end

	-- Remove criaturas e limpa o mapa antes da troca
	removeCreatures(frompos, topos)
	cleanMMap(frompos, topos)
	cleanMMap(Position(32512, 32364, 10), Position(32526, 32474, 10))

	-- Carrega o novo mapa
	if mapName:lower() == "illusion" then
		Game.setStorageValue("cultsMisguidedMap", "illusion")
		Game.loadMap(DATA_DIRECTORY .. "/world/quest/cults_of_tibia/misguided/illusion.otbm")
	else
		Game.setStorageValue("cultsMisguidedMap", "reality")
		Game.loadMap(DATA_DIRECTORY .. "/world/quest/cults_of_tibia/misguided/reality.otbm")
		addEvent(changeMap, 30000, "illusion") -- Delay maior para evitar conflito
	end
end

local cultsOfTibiaMisguided = Action()

function cultsOfTibiaMisguided.onUse(player, item, position, target, targetPosition)
	local creature = Creature(target)
	if not creature then
		return false
	end

	local map = (type(Game.getStorageValue("cultsMisguidedMap")) == "string" and Game.getStorageValue("cultsMisguidedMap") or "illusion")
	if creature:getName():lower() == "misguided bully" or creature:getName():lower() == "misguided thief" then
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Monsters, 0)
		item:remove(1)

		local pos = creature:getPosition()
		Game.createItem(25298, 1, pos)
		creature:remove()

		local newCreature = Game.createMonster("Misguided Shadow", pos)
		if newCreature then
			newCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You paralyse the bully and the amulet reveals the true face of the creature behind the possession of this misguided creature.")
		local newAmulet = player:addItem(25296, 1)
		if map == "illusion" then
			addEvent(changeMap, 5000, "reality") -- 5s delay para garantir segurança
		end
		if newAmulet then
			newAmulet:decay()
		end
	end

	return true
end

cultsOfTibiaMisguided:id(25297)
cultsOfTibiaMisguided:register()
