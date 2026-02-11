local depolarizedTransform = CreatureEvent("DepolarizedTransform")

-- Definir um valor de Global Storage para controlar a reversão
local REVERSE_TRANSFORM_STORAGE = 65103

function depolarizedTransform.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	-- Verifica se a transformação reversa está ativa usando Global Storage
	local reverseTransform = getGlobalStorageValue(REVERSE_TRANSFORM_STORAGE)
	if reverseTransform == 0 then
		local monster = Game.createMonster("Crackler", creature:getPosition(), false, true)
		if monster then
			-- Transfere a vida para o novo monstro e remove a criatura original
			monster:addHealth(-monster:getHealth() + creature:getHealth(), COMBAT_PHYSICALDAMAGE)
			creature:remove()
		end
	end

	return true
end

depolarizedTransform:register()
