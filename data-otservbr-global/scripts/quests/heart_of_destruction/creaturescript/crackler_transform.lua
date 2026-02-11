local cracklerTransformEvent = CreatureEvent("CracklerTransform")

function cracklerTransformEvent.onThink(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	-- Verifica se a transformação está ativa usando Global Storage
	local globalTransform = getGlobalStorageValue(65103)
	if globalTransform == 1 then
		local monster = Game.createMonster("depolarized crackler", creature:getPosition(), false, true)
		if monster then
			monster:setHealth(creature:getHealth()) -- Transfere a vida para o novo monstro
			creature:remove() -- Remove o monstro original
			monster:say("I have transformed!", TALKTYPE_MONSTER_SAY) -- Mensagem para verificação visual
		end
	end

	return true
end

cracklerTransformEvent:register()

