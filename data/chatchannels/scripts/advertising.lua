function canJoin(player)
	return player:getVocation():getId() ~= VOCATION_NONE or player:getGroup():getId() >= GROUP_TYPE_SENIORTUTOR
end

local CHANNEL_ADVERTISING = 5
local ADVERTISING_SPAM_INTERVAL = 10
local ADVERTISING_AUTOMUTE_SECONDS = 120

local muted = Condition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT)
muted:setParameter(CONDITION_PARAM_SUBID, CHANNEL_ADVERTISING)
muted:setParameter(CONDITION_PARAM_TICKS, ADVERTISING_AUTOMUTE_SECONDS * 1000)

function onSpeak(player, type, message)
	local groupId = player:getGroup():getId()

	if groupId >= GROUP_TYPE_GAMEMASTER then
		sendChannelMessage(CHANNEL_ADVERTISING, TALKTYPE_CHANNEL_R1, "[ADM] " .. message)
		return false
	end

	if player:getLevel() < 10 and not player:isPremium() then
		player:sendCancelMessage("You may not speak in this channel unless you have reached level 10 or your account has premium status.")
		return false
	end

	-- Verifica se o jogador está mutado
	if player:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_ADVERTISING) then
		local expiresAt = player:kv():get("ad-channel-muted-until") or 0
		local remaining = expiresAt - os.time()
		if remaining < 0 then remaining = 0 end
		player:sendCancelMessage("You are muted from the Advertising Channel.")
		player:sendCancelMessage("Mute expires in: " .. remaining .. " seconds.")
		return false
	end

	-- Detecta flood (mensagens rápidas consecutivas)
	local now = os.time()
	local lastSpeak = player:kv():get("ad-channel-last-speak") or 0
	local previousSpeak = player:kv():get("ad-channel-previous-speak") or 0

	if (now - lastSpeak) < ADVERTISING_SPAM_INTERVAL and (lastSpeak - previousSpeak) < ADVERTISING_SPAM_INTERVAL then
		player:addCondition(muted)
		player:kv():set("ad-channel-muted-until", now + ADVERTISING_AUTOMUTE_SECONDS)
		player:sendCancelMessage("You have been muted for 2 minutes for flooding the Advertising Channel.")
		player:sendCancelMessage("Mute expires in: " .. ADVERTISING_AUTOMUTE_SECONDS .. " seconds.")
		return false
	end

	player:kv():set("ad-channel-previous-speak", lastSpeak)
	player:kv():set("ad-channel-last-speak", now)

	if type == TALKTYPE_CHANNEL_O and groupId < GROUP_TYPE_GAMEMASTER then
		type = TALKTYPE_CHANNEL_Y
	elseif type == TALKTYPE_CHANNEL_R1 and not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
		type = TALKTYPE_CHANNEL_Y
	end

	return type
end
