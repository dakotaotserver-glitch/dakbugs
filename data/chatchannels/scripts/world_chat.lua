local CHANNEL_WORLD = 3
local WORLD_SPAM_INTERVAL = 7
local WORLD_AUTOMUTE_SECONDS = 60

local muted = Condition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT)
muted:setParameter(CONDITION_PARAM_SUBID, CHANNEL_WORLD)
muted:setParameter(CONDITION_PARAM_TICKS, WORLD_AUTOMUTE_SECONDS * 1000)

function onSpeak(player, type, message)
	local groupId = player:getGroup():getId()

	-- Bloqueia level 1, exceto GOD/GM
	if player:getLevel() == 1 and groupId < GROUP_TYPE_GAMEMASTER then
		player:sendCancelMessage("You may not speak into channels as long as you are on level 1.")
		return false
	end

	-- GOD/GM fala livre com prefixo fixo
	if groupId >= GROUP_TYPE_GAMEMASTER then
		sendChannelMessage(CHANNEL_WORLD, TALKTYPE_CHANNEL_R1, "[ADM] " .. message)
		return false
	end

	-- Verifica mute visual
	if player:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_WORLD) then
		local expiresAt = player:kv():get("world-channel-muted-until") or 0
		local remaining = expiresAt - os.time()
		if remaining < 0 then remaining = 0 end
		player:sendCancelMessage("You are muted from the World Chat.")
		player:sendCancelMessage("Mute expires in: " .. remaining .. " seconds.")
		return false
	end

	-- Detecção de flood por 3 mensagens consecutivas rápidas
	local now = os.time()
	local speak1 = player:kv():get("world-speak-1") or 0
	local speak2 = player:kv():get("world-speak-2") or 0
	local speak3 = player:kv():get("world-speak-3") or 0

	if (speak2 - speak1 < WORLD_SPAM_INTERVAL) and (speak3 - speak2 < WORLD_SPAM_INTERVAL) and (now - speak3 < WORLD_SPAM_INTERVAL) then
		player:addCondition(muted)
		player:kv():set("world-channel-muted-until", now + WORLD_AUTOMUTE_SECONDS)
		player:sendCancelMessage("You have been muted for 2 minutes for flooding the World Chat.")
		player:sendCancelMessage("Mute expires in: " .. WORLD_AUTOMUTE_SECONDS .. " seconds.")
		return false
	end

	-- Atualiza histórico de envios
	player:kv():set("world-speak-1", speak2)
	player:kv():set("world-speak-2", speak3)
	player:kv():set("world-speak-3", now)

	-- Correção do tipo da fala
	if type == TALKTYPE_CHANNEL_O and groupId < GROUP_TYPE_GAMEMASTER then
		type = TALKTYPE_CHANNEL_Y
	elseif type == TALKTYPE_CHANNEL_R1 and groupId < GROUP_TYPE_GAMEMASTER and not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
		type = TALKTYPE_CHANNEL_Y
	end

	return type
end
