local blockPaleWormPortal = MoveEvent()

function blockPaleWormPortal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	-- Verifica se o jogador tem a storage necessária
	if player:getStorageValue(Storage.Quest.U12_30.PoltergeistOutfits.Received) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to defeat: The Pale Worm")
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(fromPosition, true)
		return false
	end

	return true
end

blockPaleWormPortal:type("stepin")
blockPaleWormPortal:position({ x = 33568, y = 31538, z = 10 }) -- posição do tile bloqueado
blockPaleWormPortal:register()
