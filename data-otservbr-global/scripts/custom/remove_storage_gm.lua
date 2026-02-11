local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storageId = 45690
	player:setStorageValue(storageId, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel enlightened. Your mission has been marked.")
	player:say("Mission updated!", TALKTYPE_MONSTER_SAY, false, player, player:getPosition())
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return true
end

action:aid(35000)
action:register()
