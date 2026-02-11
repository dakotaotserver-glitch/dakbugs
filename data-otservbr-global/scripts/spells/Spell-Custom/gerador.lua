local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

function onTargetCreature(creature, target)
	local spectators, spectator = Game.getSpectators(creature:getPosition(), false, false, 2, 2, 2, 2)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName():lower() == "Maxxenius" then
			creature:setTarget("Maxxenius")
			if target:getName():lower() == "Maxxenius" then
				target:addHealth(2000)
				return true
			end
		end
	end
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("heal maxxenius")
spell:words("###901")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:isSelfTarget(false)
spell:register()
