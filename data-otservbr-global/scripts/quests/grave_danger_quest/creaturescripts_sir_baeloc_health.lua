local sir_baeloc_health = CreatureEvent("sir_baeloc_health")

sir_baeloc_health:type("healthchange")

function sir_baeloc_health.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local healthThreshold = creature:getMaxHealth() * 0.60
	local baelocPercent = (creature:getHealth() / creature:getMaxHealth()) * 100

	local brother = Creature("Sir Nictros")
	if brother then
		local brotherPercent = (brother:getHealth() / brother:getMaxHealth()) * 100
		if baelocPercent < 55 then
			local diff = brotherPercent - baelocPercent
			if diff > 5 then
				creature:addHealth(28000)
			end
		end
	end

	local currentDamage = creature:getStorageValue(1)
	if currentDamage == -1 then
		currentDamage = 0
	end

	local totalDamage = primaryDamage + secondaryDamage
	currentDamage = currentDamage + totalDamage
	creature:setStorageValue(1, currentDamage)

	if creature:getStorageValue(2) < 1 and currentDamage >= healthThreshold then
		creature:setStorageValue(2, 1)
		creature:say("Join me in battle my brother. Let's share the fun!")

		local nictros = Creature("Sir Nictros")
		if nictros then
			nictros:teleportTo(Position(33426, 31438, 13))
			nictros:setMoveLocked(false)
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

sir_baeloc_health:register()
