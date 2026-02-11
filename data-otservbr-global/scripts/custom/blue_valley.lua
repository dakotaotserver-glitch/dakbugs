local config = {
	[49948] = Position(32203, 32304, 6), -- Blue Valley > Island of Destiny
	[50227] = Position(32203, 32304, 6), -- Blue Valley > Island of Destiny
	[50310] = Position(33614, 31494, 7), -- Island of Destiny > Blue Valley
}

local blueValley = Action()

function blueValley.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local pos = config[item:getId()]
	if not pos then
		return false
	end

	fromPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	player:teleportTo(pos)
	player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)

	return true
end

for itemId, _ in pairs(config) do
	blueValley:id(itemId)
end

blueValley:register()

local config = {
	{ position = Position(33600, 31459, 6) },
	{ position = Position(33601, 31459, 6) },
	{ position = Position(33602, 31459, 6) },
	{ position = Position(33603, 31459, 6) },
	{ position = Position(33604, 31459, 6) },
	{ position = Position(33605, 31459, 6) },
	{ position = Position(33606, 31459, 6) },
	{ position = Position(33607, 31459, 6) },
}

local enterMonkTemple = MoveEvent()

function enterMonkTemple.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for _, value in pairs(config) do
		if value.position == position then
			if player:getVocation():getId() ~= VOCATION.ID.MONK and player:getVocation():getId() ~= VOCATION.ID.EXALTED_MONK then
				player:teleportTo(fromPosition, true)
			end
			return true
		end
	end

	return true
end

enterMonkTemple:type("stepin")

for _, value in pairs(config) do
	enterMonkTemple:position(value.position)
end

enterMonkTemple:register()
