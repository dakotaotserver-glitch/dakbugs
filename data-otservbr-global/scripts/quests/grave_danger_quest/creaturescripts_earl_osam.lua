-- Earl Osam Boss Script (sem prints)

local config = {
	centerRoom = Position(33488, 31438, 13),
	newPosition = Position(33489, 31441, 13),
	exitPos = Position(33261, 31985, 8),
	x = 10,
	y = 10,
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.EarlOsam.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.EarlOsam.Room,
	fromPos = Position(33479, 31429, 13),
	toPos = Position(33497, 31446, 13),
	spheres = {
		Position(33480, 31438, 13),
		Position(33488, 31430, 13),
		Position(33496, 31438, 13),
		Position(33488, 31446, 13),
	},
}

local function moveSphere()
	local boss = Creature("Earl Osam")
	if not boss or boss:getHealth() <= 0 then return true end

	local spectators = Game.getSpectators(config.centerRoom, false, false, config.x, config.x, config.y, config.y)

	for _, sphere in pairs(spectators) do
		if sphere:isMonster() and sphere:getName():lower() == "magical sphere" then
			local pos = sphere:getPosition()
			local nextPos = nil

			if pos.y == config.centerRoom.y then
				if pos.x > config.centerRoom.x then
					nextPos = Position(pos.x - 1, pos.y, pos.z)
				elseif pos.x < config.centerRoom.x then
					nextPos = Position(pos.x + 1, pos.y, pos.z)
				end
			elseif pos.x == config.centerRoom.x then
				if pos.y > config.centerRoom.y then
					nextPos = Position(pos.x, pos.y - 1, pos.z)
				elseif pos.y < config.centerRoom.y then
					nextPos = Position(pos.x, pos.y + 1, pos.z)
				end
			end

			if nextPos and nextPos ~= pos then
				if nextPos == config.centerRoom then
					sphere:remove()
					boss:addHealth(80000)
				else
					sphere:teleportTo(nextPos, true)
				end
			end
		end
	end

	local hasSphere = false
	for _, mob in pairs(Game.getSpectators(config.centerRoom, false, false, config.x, config.x, config.y, config.y)) do
		if mob:isMonster() and mob:getName():lower() == "magical sphere" then
			hasSphere = true
			break
		end
	end

	if hasSphere then
		addEvent(moveSphere, 4000)
	else
		if boss then
			boss:setMoveLocked(false)
			local pos = boss:getPosition()
			local randomWalk = {
				{x = pos.x + 1, y = pos.y},
				{x = pos.x - 1, y = pos.y},
				{x = pos.x, y = pos.y + 1},
				{x = pos.x, y = pos.y - 1},
			}
			for _, offset in ipairs(randomWalk) do
				local newPos = Position(offset.x, offset.y, pos.z)
				local tile = Tile(newPos)
				if tile and tile:isWalkable() then
					boss:teleportTo(newPos)
					newPos:sendMagicEffect(CONST_ME_TELEPORT)
					break
				end
			end
		end
	end
	return true
end

local function initMech()
	local boss = Creature("Earl Osam")
	if not boss then return true end

	local topCenter = Tile(config.centerRoom):getTopCreature()
	if topCenter and topCenter ~= boss then
		topCenter:teleportTo(Position(config.centerRoom.x, config.centerRoom.y + 2, config.centerRoom.z))
	end

	boss:teleportTo(config.centerRoom)
	boss:setMoveLocked(true)
	boss:setStorageValue(3, 4)

	for _, pos in ipairs(config.spheres) do
		Game.createMonster("Magical Sphere", pos, false, true)
	end

	addEvent(moveSphere, 4000)
	return true
end

local function checkIfBossIsStillProtected(creature)
	local spheres = Game.getSpectators(config.centerRoom, false, false, config.x, config.x, config.y, config.y)
	for _, mob in pairs(spheres) do
		if mob:isMonster() and mob:getName():lower() == "magical sphere" then
			return true
		end
	end
	return false
end

local earl_osam_transform = CreatureEvent("earl_osam_transform")

function earl_osam_transform.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	local players = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)
	for _, player in pairs(players) do
		if player:isPlayer() then
			if player:getStorageValue(config.timer) < os.time() then
				player:setStorageValue(config.timer, os.time() + 20 * 3600)
			end
			if player:getStorageValue(config.room) < os.time() then
				player:setStorageValue(config.room, os.time() + 30 * 60)
			end
		end
	end

	if primaryType == COMBAT_HEALING then
		return 0, primaryType, 0, secondaryType
	end

	local chance = math.random(1, 100)
	local randPos = Position(math.random(config.fromPos.x, config.toPos.x), math.random(config.fromPos.y, config.toPos.y), config.fromPos.z)
	local tile = Tile(randPos)
	if chance >= 95 and tile and tile:isWalkable() then
		Game.createMonster("Frozen Soul", randPos)
	end

	if checkIfBossIsStillProtected(creature) then
		creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		return 0, primaryType, 0, secondaryType
	end

	local healthThreshold = creature:getMaxHealth() * 0.15
	local currentDamage = creature:getStorageValue(1)
	if currentDamage == -1 then currentDamage = 0 end

	local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)
	local newDamage = currentDamage + totalDamage
	creature:setStorageValue(1, newDamage)

	if newDamage >= healthThreshold then
		creature:setStorageValue(1, 0)
		initMech()
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

earl_osam_transform:register()

local sphere_death = CreatureEvent("sphere_death")
function sphere_death.onDeath(creature)
	return true
end

sphere_death:register()
