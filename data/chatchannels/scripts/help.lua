local CHANNEL_HELP = 7
local HELP_COOLDOWN_SECONDS = 60

local muted = Condition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT)
muted:setParameter(CONDITION_PARAM_SUBID, CHANNEL_HELP)
muted:setParameter(CONDITION_PARAM_TICKS, 3600000) -- 1 hora

function onSpeak(player, type, message)
	if player:getLevel() == 1 and player:getAccountType() == ACCOUNT_TYPE_NORMAL then
		player:sendCancelMessage("You may not speak into channels as long as you are on level 1.")
		return false
	end

	local hasExhaustion = player:kv():get("channel-help-exhaustion") or 0
	if hasExhaustion > os.time() then
		player:sendCancelMessage("You are muted from the Help channel for using it inappropriately.")
		return false
	end

	if player:getAccountType() >= ACCOUNT_TYPE_TUTOR then
		if string.sub(message, 1, 6) == "!mute " then
			local targetName = string.sub(message, 7)
			local target = Player(targetName)
			if target then
				if player:getAccountType() > target:getAccountType() then
					if not target:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_HELP) then
						target:addCondition(muted)
						target:kv():set("channel-help-exhaustion", os.time() + 3600)
						sendChannelMessage(CHANNEL_HELP, TALKTYPE_CHANNEL_R1, "[ADM] " .. target:getName() .. " has been muted by " .. player:getName() .. " for using Help Channel inappropriately.")
					else
						player:sendCancelMessage("That player is already muted.")
					end
				else
					player:sendCancelMessage("You are not authorized to mute that player.")
				end
			else
				player:sendCancelMessage(RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE)
			end
			return false

		elseif string.sub(message, 1, 8) == "!unmute " then
			local targetName = string.sub(message, 9)
			local target = Player(targetName)
			if target then
				if player:getAccountType() > target:getAccountType() then
					local hasExhaustionTarget = target:kv():get("channel-help-exhaustion") or 0
					if hasExhaustionTarget > os.time() then
						target:removeCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_HELP)
						sendChannelMessage(CHANNEL_HELP, TALKTYPE_CHANNEL_R1, "[ADM] " .. target:getName() .. " has been unmuted.")
						target:kv():remove("channel-help-exhaustion")
					else
						player:sendCancelMessage("That player is not muted.")
					end
				else
					player:sendCancelMessage("You are not authorized to unmute that player.")
				end
			else
				player:sendCancelMessage(RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE)
			end
			return false
		end
	end

	-- Cooldown por jogador (exceto staff)
	if player:getAccountType() == ACCOUNT_TYPE_NORMAL then
		local lastSpeak = player:kv():get("help-channel-last-speak") or 0
		local now = os.time()
		local remaining = HELP_COOLDOWN_SECONDS - (now - lastSpeak)
		if remaining > 0 then
			player:sendCancelMessage("You must wait " .. remaining .. " seconds before speaking again in the Help Channel.")
			return false
		end
		player:kv():set("help-channel-last-speak", now)
	end

	-- Definição da cor e envio customizado baseado no grupo
	if type == TALKTYPE_CHANNEL_Y or type == TALKTYPE_CHANNEL_O or type == TALKTYPE_CHANNEL_R1 then
		local accountType = player:getAccountType()

		if accountType == ACCOUNT_TYPE_NORMAL then
			type = TALKTYPE_CHANNEL_Y -- Amarelo
			return type
		elseif accountType == ACCOUNT_TYPE_TUTOR or accountType == ACCOUNT_TYPE_SENIORTUTOR then
			type = TALKTYPE_CHANNEL_O -- Laranja
			sendChannelMessage(CHANNEL_HELP, type, "[STAFF] " .. message)
			return false
		elseif accountType >= ACCOUNT_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_R1 -- Vermelho claro
			sendChannelMessage(CHANNEL_HELP, type, "[ADM] " .. message)
			return false
		end
	end

	return type
end
