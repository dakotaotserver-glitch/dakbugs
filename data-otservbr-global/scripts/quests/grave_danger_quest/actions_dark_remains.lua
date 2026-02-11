local voc_table = {
	[31203] = { vocs = {4, 8} },      -- Knight / Elite Knight
	[31204] = { vocs = {3, 7} },      -- Paladin / Royal Paladin
	[31205] = { vocs = {2, 6} },      -- Druid / Elder Druid
	[31206] = { vocs = {1, 5} },      -- Sorcerer / Master Sorcerer
	[50311] = { vocs = {9, 10} },     -- Monk / Exalted Monk
}

local dark_remains = Action()

function dark_remains.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local config = voc_table[item.itemid]
	if not config then
		return false
	end

	-- Checa se é player usando contra boss + vocação correta
	if not target:isMonster() or target:getName():lower() ~= "count vlarkorth" then
		return false
	end

	local playerVocId = player:getVocation():getId()
	if not table.contains(config.vocs, playerVocId) then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Your vocation cannot use this dark remains.")
		return false
	end

	-- Aplica o efeito
	item:remove(1)
	target:setStorageValue(3, target:getStorageValue(3) - 1)
	target:say("The magic shield of protection is weakened!")
	toPosition:sendMagicEffect(CONST_ME_HOLYAREA)

	return true
end

dark_remains:id(31203, 31204, 31205, 31206, 50311)
dark_remains:register()

