local checkPlayer = TalkAction("/checkplayer")

function checkPlayer.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Uso: /checkplayer NomeDoJogador")
		return false
	end

	local target = Player(param)
	if target then
		local vocations = {
			[0] = "No vocation",
			[1] = "Sorcerer", [2] = "Druid", [3] = "Paladin", [4] = "Knight",
			[5] = "Master Sorcerer", [6] = "Elder Druid", [7] = "Royal Paladin", [8] = "Elite Knight"
		}

		local accountTypeLabel = {
			[1] = "Normal",
			[2] = "Tutor",
			[3] = "Senior Tutor",
			[4] = "Game Master",
			[5] = "God"
		}

		local pos = target:getPosition()
		local ip = Game.convertIpToString(target:getIp())
		local accType = target:getAccountType()

		local msg = "[CheckPlayer - Online]\n"
		msg = msg .. "Nome: " .. target:getName() .. "\n"
		msg = msg .. "Level: " .. target:getLevel() .. "\n"
		msg = msg .. "Vocacao: " .. (vocations[target:getVocation():getId()] or "Desconhecida") .. "\n"
		msg = msg .. "Conta: " .. (accountTypeLabel[accType] or "Desconhecida") .. "\n"
		msg = msg .. "Grupo ID: " .. target:getGroup():getId() .. "\n"
		msg = msg .. "Posicao: (" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")\n"
		msg = msg .. "IP: " .. ip .. "\n"
		msg = msg .. "Status: Online"

		player:sendTextMessage(MESSAGE_ADMINISTRATOR, msg)
		return false
	end

	-- Jogador offline (sem LOWER)
	local queryString = "SELECT p.name, p.level, p.vocation, p.group_id, a.type as account_type " ..
		"FROM players p LEFT JOIN accounts a ON a.id = p.account_id " ..
		"WHERE p.name = " .. db.escapeString(param) .. " LIMIT 1"

	db.asyncStoreQuery(queryString, function(query)
		if not query or type(query) ~= "userdata" then
			player:sendCancelMessage("Jogador nao encontrado.")
			return
		end

		local vocId = query:getDataInt("vocation")
		local accountType = query:getDataInt("account_type")
		local groupId = query:getDataInt("group_id")

		local vocations = {
			[0] = "No vocation",
			[1] = "Sorcerer", [2] = "Druid", [3] = "Paladin", [4] = "Knight",
			[5] = "Master Sorcerer", [6] = "Elder Druid", [7] = "Royal Paladin", [8] = "Elite Knight"
		}

		local accountTypeLabel = {
			[1] = "Normal",
			[2] = "Tutor",
			[3] = "Senior Tutor",
			[4] = "Game Master",
			[5] = "God"
		}

		local msg = "[CheckPlayer - Offline]\n"
		msg = msg .. "Nome: " .. query:getDataString("name") .. "\n"
		msg = msg .. "Level: " .. query:getDataInt("level") .. "\n"
		msg = msg .. "Vocacao: " .. (vocations[vocId] or "Desconhecida") .. "\n"
		msg = msg .. "Conta: " .. (accountTypeLabel[accountType] or "Desconhecida") .. "\n"
		msg = msg .. "Grupo ID: " .. groupId .. "\n"
		msg = msg .. "Status: Offline"

		player:sendTextMessage(MESSAGE_ADMINISTRATOR, msg)
		query:free()
	end)

	return false
end

checkPlayer:separator(" ")
checkPlayer:groupType("god")
checkPlayer:register()
