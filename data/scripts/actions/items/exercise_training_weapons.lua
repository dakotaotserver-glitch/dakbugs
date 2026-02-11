local exhaustionTime = 10

if not _G.OnExerciseTraining then
	_G.OnExerciseTraining = {}
end

local exerciseWeaponsTable = {
	-- SWORD
	[28540] = { skill = SKILL_SWORD },
	[28552] = { skill = SKILL_SWORD },
	[35279] = { skill = SKILL_SWORD },
	[35285] = { skill = SKILL_SWORD },
	[62009] = { skill = SKILL_SWORD },

	-- AXE
	[28553] = { skill = SKILL_AXE },
	[28541] = { skill = SKILL_AXE },
	[35280] = { skill = SKILL_AXE },
	[35286] = { skill = SKILL_AXE },
	[62004] = { skill = SKILL_AXE },

	-- CLUB
	[28554] = { skill = SKILL_CLUB },
	[28542] = { skill = SKILL_CLUB },
	[35281] = { skill = SKILL_CLUB },
	[35287] = { skill = SKILL_CLUB },
	[62006] = { skill = SKILL_CLUB },

	-- SHIELD
	[44064] = { skill = SKILL_SHIELD },
	[44065] = { skill = SKILL_SHIELD },
	[44066] = { skill = SKILL_SHIELD },
	[44067] = { skill = SKILL_SHIELD },
	[62008] = { skill = SKILL_SHIELD },

	-- ROD
	[28544] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_SMALLICE, allowFarUse = true },
	[28556] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_SMALLICE, allowFarUse = true },
	[35283] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_SMALLICE, allowFarUse = true },
	[35289] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_SMALLICE, allowFarUse = true },

	-- DISTANCE
	[28543] = { skill = SKILL_DISTANCE, effect = CONST_ANI_SIMPLEARROW, allowFarUse = true },
	[28555] = { skill = SKILL_DISTANCE, effect = CONST_ANI_SIMPLEARROW, allowFarUse = true },
	[35282] = { skill = SKILL_DISTANCE, effect = CONST_ANI_SIMPLEARROW, allowFarUse = true },
	[35288] = { skill = SKILL_DISTANCE, effect = CONST_ANI_SIMPLEARROW, allowFarUse = true },
	[62005] = { skill = SKILL_DISTANCE, effect = CONST_ANI_SIMPLEARROW, allowFarUse = true },

	-- WAND
	[28545] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_FIRE, allowFarUse = true },
	[28557] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_FIRE, allowFarUse = true },
	[35284] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_FIRE, allowFarUse = true },
	[35290] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_FIRE, allowFarUse = true },
	[62007] = { skill = SKILL_MAGLEVEL, effect = CONST_ANI_FIRE, allowFarUse = true },

	-- FIST
	[50292] = { skill = SKILL_FIST, effect = CONST_ANI_WHIRLWINDAXE },
	[50293] = { skill = SKILL_FIST, effect = CONST_ANI_WHIRLWINDAXE },
	[50294] = { skill = SKILL_FIST, effect = CONST_ANI_WHIRLWINDAXE },
	[50295] = { skill = SKILL_FIST, effect = CONST_ANI_WHIRLWINDAXE },
	[62010] = { skill = SKILL_FIST, effect = CONST_ANI_WHIRLWINDAXE },
}

local dummies = Game.getDummies()

-- 🔑 cria índice skill → itemIds
local skillWeapons = {}
for itemId, data in pairs(exerciseWeaponsTable) do
	skillWeapons[data.skill] = skillWeapons[data.skill] or {}
	table.insert(skillWeapons[data.skill], itemId)
end

local function isValidItem(item)
	return item and type(item) == "userdata" and type(item.isItem) == "function" and item:isItem()
end

local function leaveExerciseTraining(playerId)
	if _G.OnExerciseTraining[playerId] then
		stopEvent(_G.OnExerciseTraining[playerId].event)
		_G.OnExerciseTraining[playerId] = nil
	end

	local player = Player(playerId)
	if player then
		player:setTraining(false)
	end
end

local function getAnyTrainingWeaponBySkill(player, skill)
	for _, itemId in ipairs(skillWeapons[skill] or {}) do
		local weapon = player:getItemById(itemId, true)
		if weapon and weapon:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
			local charges = weapon:getAttribute(ITEM_ATTRIBUTE_CHARGES)
			if charges and charges > 0 then
				return weapon
			end
		end
	end
	return nil
end

local function exerciseTrainingEvent(playerId, tilePosition, weaponId, dummyId)
	local player = Player(playerId)
	if not player then
		return leaveExerciseTraining(playerId)
	end

	if player:isTraining() == 0 then
		return leaveExerciseTraining(playerId)
	end

	if player:getPosition():getDistance(tilePosition) > 4 then
		player:sendTextMessage(MESSAGE_FAILURE, "You moved too far from the dummy.")
		return leaveExerciseTraining(playerId)
	end

	local dummyTile = Tile(tilePosition)
	if not dummyTile or not dummyTile:getItemById(dummyId) then
		player:sendTextMessage(MESSAGE_FAILURE, "Someone has moved the dummy.")
		return leaveExerciseTraining(playerId)
	end

	local skill = exerciseWeaponsTable[weaponId].skill

	-- 🔑 pega qualquer weapon válida da mesma skill
	local weapon = getAnyTrainingWeaponBySkill(player, skill)
	if not weapon then
		player:sendTextMessage(MESSAGE_FAILURE, "You don't have any training weapon left.")
		return leaveExerciseTraining(playerId)
	end

	local charges = weapon:getAttribute(ITEM_ATTRIBUTE_CHARGES)
	if not charges or charges <= 0 then
		weapon:remove(1)
		return true
	end

	local rate = dummies[dummyId] / 100
	if skill == SKILL_MAGLEVEL then
		player:addManaSpent(500 * rate)
	else
		player:addSkillTries(skill, 7 * rate)
	end

	weapon:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges - 1)

	tilePosition:sendMagicEffect(CONST_ME_HITAREA)
	if exerciseWeaponsTable[weapon:getId()] and exerciseWeaponsTable[weapon:getId()].effect then
		player:getPosition():sendDistanceEffect(
			tilePosition,
			exerciseWeaponsTable[weapon:getId()].effect
		)
	end

	if weapon:getAttribute(ITEM_ATTRIBUTE_CHARGES) <= 0 then
		weapon:remove(1)
	end

	local vocation = player:getVocation()
	local speed = vocation:getBaseAttackSpeed() / configManager.getFloat(configKeys.RATE_EXERCISE_TRAINING_SPEED)

	if _G.OnExerciseTraining[playerId] then
		_G.OnExerciseTraining[playerId].event =
			addEvent(exerciseTrainingEvent, speed, playerId, tilePosition, weaponId, dummyId)
	end
	return true
end

local function isDummy(id)
	return dummies[id] and dummies[id] > 0
end

local exerciseTraining = Action()

function exerciseTraining.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not isValidItem(target) or not isDummy(target:getId()) then
		return true
	end

	local playerId = player:getId()
	if _G.OnExerciseTraining[playerId] then
		player:sendTextMessage(MESSAGE_FAILURE, "You are already training.")
		return true
	end

	_G.OnExerciseTraining[playerId] = {}
	_G.OnExerciseTraining[playerId].event =
		addEvent(exerciseTrainingEvent, 0, playerId, target:getPosition(), item.itemid, target:getId())

	player:setTraining(true)
	player:setExhaustion("training-exhaustion", exhaustionTime)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have started training on an exercise dummy.")
	return true
end

for weaponId, weapon in pairs(exerciseWeaponsTable) do
	exerciseTraining:id(weaponId)
	if weapon.allowFarUse then
		exerciseTraining:allowFarUse(true)
	end
end

exerciseTraining:register()
