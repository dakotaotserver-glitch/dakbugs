local REQUIRED_STORAGES = {
	[Storage.Quest.U11_80.TheSecretLibrary.Library.GhuloshKilled] = 1,
	[Storage.Quest.U11_80.TheSecretLibrary.Library.MazzinorKilled] = 1,
	[Storage.Quest.U11_80.TheSecretLibrary.Library.LokathmorKilled] = 1,
	[Storage.Quest.U11_80.TheSecretLibrary.Library.GorzindelKilled] = 1
}

local DOOR_POSITION = Position(32480, 32591, 15)
local DEST_INSIDE = Position(32480, 32590, 15) -- Para quem está fora
local DEST_OUTSIDE = Position(32480, 32592, 15) -- Para quem está dentro

local doorAction = Action()

function doorAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getPosition() ~= DOOR_POSITION then
		return false
	end

	-- Se estiver dentro (posição 32590), teleportar para fora (32592)
	if player:getPosition() == DEST_INSIDE then
		player:teleportTo(DEST_OUTSIDE)
		DEST_OUTSIDE:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	-- Verifica todas as storages para entrar
	for storage, requiredValue in pairs(REQUIRED_STORAGES) do
		if player:getStorageValue(storage) < requiredValue then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must defeat Ghulosh, Gorzindel, Mazzinor, and Lokathmor before facing the final boss.")
			return true
		end
	end

	-- Teleporta para dentro (posição 32590)
	player:teleportTo(DEST_INSIDE)
	DEST_INSIDE:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

doorAction:uid(22007)
doorAction:register()
