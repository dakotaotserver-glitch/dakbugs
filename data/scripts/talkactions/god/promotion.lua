local promotion = TalkAction("/promotion")

function promotion.onSay(player, words, param)
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Uso: /promotion nome, nivel (1 a 5)")
		return false
	end

	local split = param:split(",")
	local name = split[1] and split[1]:trim()
	local level = tonumber(split[2])

	if not name or not level then
		player:sendCancelMessage("Formato invalido. Exemplo: /promotion Socram,2")
		return false
	end

	if level < 1 or level > 5 then
		player:sendCancelMessage("Nivel invalido. Use: 1 (Normal), 2 (Tutor), 3 (Senior Tutor), 4 (GM), 5 (God).")
		return false
	end

	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Jogador " .. name .. " nao esta online.")
		return false
	end

	if targetPlayer:getAccountType() == level then
		player:sendCancelMessage("Este jogador ja possui esse nivel.")
		return false
	end

	-- Mapas de cargo
	local groupMap = {
		[1] = 1, -- Normal
		[2] = 1, -- Tutor
		[3] = 1, -- Senior Tutor
		[4] = 4, -- Game Master
		[5] = 6  -- God
	}

	local labels = {
		[1] = "Normal Player",
		[2] = "Tutor",
		[3] = "Senior Tutor",
		[4] = "Game Master",
		[5] = "God"
	}

	targetPlayer:setAccountType(level)
	targetPlayer:setGroup(Group(groupMap[level]))

	local label = labels[level] or "Desconhecido"

	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce foi promovido para " .. label .. " por " .. player:getName() .. ".")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce promoveu " .. targetPlayer:getName() .. " para " .. label .. ".")

	return false
end

promotion:separator(" ")
promotion:groupType("god")
promotion:register()
