local sharedDamage = CreatureEvent("AWeakSpotDamage")

function sharedDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)

	if creature:getName():lower() == "a weak spot" and totalDamage > 0 then
		local paleWorm = nil
		local creaturePosition = creature:getPosition()

		-- Procurar "The Pale Worm" no piso ACIMA
		local z = creaturePosition.z - 1
		if z >= 0 then
			local spectators = Game.getSpectators({x = creaturePosition.x, y = creaturePosition.y, z = z}, false, false, 20, 20, 20, 20)
			for _, spectator in ipairs(spectators) do
				if spectator:isMonster() and spectator:getName():lower() == "the pale worm" then
					paleWorm = spectator
					break
				end
			end
		end

		if paleWorm then
			local newHealth = creature:getHealth() - (totalDamage * 0.99)

			local weakSpotWillDie = false
			if newHealth <= 0 then
				newHealth = 1 -- Para evitar morte instantânea
				weakSpotWillDie = true
			end

			paleWorm:setHealth(newHealth)

			-- Se "A Weak Spot" morreu, agenda a morte do Pale Worm e remove criaturas no andar dele
			if weakSpotWillDie then
				addEvent(function()
					if paleWorm and paleWorm:isMonster() then
						-- Mata o Pale Worm
						paleWorm:addHealth(-10000)

						-- Remove criaturas do mesmo andar
						local pos = paleWorm:getPosition()
						local sameFloorSpectators = Game.getSpectators(pos, false, false, 20, 20, 20, 20)
						for _, spectator in ipairs(sameFloorSpectators) do
							local name = spectator:getName():lower()
							if spectator:isMonster() and name ~= "the pale worm" and name ~= "a weak spot" then
								spectator:remove()
							end
						end
					end
				end, 100) -- delay de 100ms
			end
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

sharedDamage:register()
