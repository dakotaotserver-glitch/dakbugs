local config = {
	centerRoom = Position(33456, 31437, 13),
	newPosition = Position(33457, 31442, 13),
	exitPos = Position(33195, 31696, 8),
	x = 10,
	y = 10,
	summons = {
		[1] = { summon = "Dark Sorcerer" },
		[5] = { summon = "Dark Sorcerer" },
		[2] = { summon = "Dark Druid" },
		[6] = { summon = "Dark Druid" },
		[3] = { summon = "Dark Paladin" },
		[7] = { summon = "Dark Paladin" },
		[4] = { summon = "Dark Knight" },
		[8] = { summon = "Dark Knight" },
		[9] = { summon = "Dark'Monk" },
		[10] = { summon = "Dark'Monk" },
	},
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorth.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorth.Room,
}

local function findBoss()
	for _, creature in ipairs(Game.getSpectators(config.centerRoom, false, false, config.x, config.x, config.y, config.y)) do
		if creature:isMonster() and creature:getName():lower() == "count vlarkorth" then
			return creature
		end
	end
	return nil
end

local function summonDarks()
	local spectators = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)
	local boss = findBoss()
	if not boss then
		return false
	end

	local summonsCount = 0
	for _, player in pairs(spectators) do
		if player:isPlayer() then
			local vocationId = player:getVocation():getId()
			local toSummon = config.summons[vocationId]
			if toSummon then
				local newPosition = boss:getClosestFreePosition(boss:getPosition(), true)
				if newPosition then
					local dark = Game.createMonster(toSummon.summon, newPosition, false, true)
					if dark then
						summonsCount = summonsCount + 1
					end
				end
			end
		end
	end

	if summonsCount > 0 then
		boss:say("Face your own darkness!")
		boss:setStorageValue(3, summonsCount)
	end

	return true
end

local count_vlarkorth_transform = CreatureEvent("count_vlarkorth_transform")

function count_vlarkorth_transform.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getStorageValue(3) > 0 then
		creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		return 0, primaryType, 0, secondaryType
	end

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
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)
	local accumulated = creature:getStorageValue(1)
	if accumulated < 0 then accumulated = 0 end

	local newAccumulated = accumulated + totalDamage
	creature:setStorageValue(1, newAccumulated)

	local healthThreshold = creature:getMaxHealth() * 0.15

	if newAccumulated >= healthThreshold then
		creature:setStorageValue(1, 0)
		creature:setStorageValue(3, 0)
		summonDarks()
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

count_vlarkorth_transform:register()
