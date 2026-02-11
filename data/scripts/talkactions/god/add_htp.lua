local talk = TalkAction("/addhtp")

function talk.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return false
	end

	local targetName, amount = param:match("([^,]+),%s*(%d+)")
	if not targetName or not amount then
		player:sendCancelMessage("Uso correto: /addhtp nomeDoJogador, quantidade")
		return false
	end

	local target = Player(targetName)
	if not target then
		player:sendCancelMessage("Jogador '" .. targetName .. "' não encontrado.")
		return false
	end

	amount = tonumber(amount)
	target:addTaskHuntingPoints(amount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce deu " .. amount .. " HTP para " .. target:getName() .. ".")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu " .. amount .. " Hunting Task Points do administrador.")
	return false
end

talk:separator(" ")
talk:groupType("god") -- 🔒 IMPORTANTE: apenas GOD pode usar
talk:register()
