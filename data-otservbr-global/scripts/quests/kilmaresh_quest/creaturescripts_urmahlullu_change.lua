local healthMultiplier = configManager.getFloat(configKeys.RATE_BOSS_HEALTH)

local urmahlulluChanges = CreatureEvent("UrmahlulluChanges")

local stages = {
	{ name = "Urmahlullu the Immaculate", health = 515000 * healthMultiplier },
	{ name = "Wildness of Urmahlullu", health = 400000 * healthMultiplier },
	{ name = "Urmahlullu the Tamed", health = 300000 * healthMultiplier },
	{ name = "Wisdom of Urmahlullu", health = 200000 * healthMultiplier },
	{ name = "Urmahlullu the Weakened", health = 100000 * healthMultiplier },
}

local changeEvent = nil

local function changeStage(cid, stageName, stageHealth)
	changeEvent = nil
	local creature = Creature(cid)
	if not creature then
		return
	end

	local position = creature:getPosition()
	creature:remove()
	local newCreature = Game.createMonster(stageName, position, true, true)
	if not newCreature then
		return
	end
	newCreature:setHealth(stageHealth)
end

function urmahlulluChanges.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local name = creature:getName()
	local nextStageIndex = 1
	for i, stage in ipairs(stages) do
		if stage.name == name then
			nextStageIndex = i + 1
			break
		end
	end

	if nextStageIndex > #stages then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local stage = stages[nextStageIndex]
	if creature:getHealth() <= stage.health and not changeEvent then
		changeEvent = addEvent(changeStage, SCHEDULER_MIN_TICKS, creature:getId(), stage.name, stage.health)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

urmahlulluChanges:register()