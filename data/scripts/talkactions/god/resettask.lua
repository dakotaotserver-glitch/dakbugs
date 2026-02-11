local talkaction = TalkAction("/tasktime")
talkaction:separator(" ")
talkaction:groupType("god")

function talkaction.onSay(player, words, param)
	local parts = param:split(" ")
	local slotId = tonumber(parts[#parts]) or 0
	local targetName = table.concat(parts, " ", 1, #parts - 1)

	local target = Player(targetName)
	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Jogador '" .. targetName .. "' nao esta online.")
		return false
	end

	local now = os.time() * 1000
	local key = 940050 + slotId
	local value = target:getStorageValue(key)

	if value <= 0 or value <= now then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Slot " .. slotId .. " de " .. targetName .. " ja esta liberado.")
	else
		local minutos = math.ceil((value - now) / 60000)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Faltam " .. minutos .. " minutos para liberar o slot " .. slotId .. " de " .. targetName .. ".")
	end

	return false
end

talkaction:register()








local talkaction = TalkAction("/debugstorages")
talkaction:separator(" ")
talkaction:groupType("god")

function talkaction.onSay(player, words, param)
	local target = Player(param)
	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Jogador '" .. param .. "' nao encontrado.")
		return false
	end

	local message = "Storages de " .. target:getName() .. ":\n"
	for key = 900000, 950000 do
		local value = target:getStorageValue(key)
		if value and value ~= -1 then
			message = message .. "[" .. key .. "] = " .. value .. "\n"
		end
	end

	player:showTextDialog(1950, message)
	return false
end

talkaction:register()
