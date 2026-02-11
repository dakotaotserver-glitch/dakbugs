
local reward = {
	container = 2854,
	commonItems = {
		{ id = 16277, amount = 1 }, -- Adventurer's stone
	},
	vocationItems = {
		[14025] = { -- Sorcerer
			{ id = 7992, amount = 1, slot = CONST_SLOT_HEAD },
			{ id = 7991, amount = 1, slot = CONST_SLOT_ARMOR },
			{ id = 3559, amount = 1, slot = CONST_SLOT_LEGS },
			{ id = 3552, amount = 1, slot = CONST_SLOT_FEET },
			{ id = 3074, amount = 1, slot = CONST_SLOT_LEFT },
			{ id = 3059, amount = 1, slot = CONST_SLOT_RIGHT },
		},
		[14026] = { -- Druid
			{ id = 7992, amount = 1, slot = CONST_SLOT_HEAD },
			{ id = 7991, amount = 1, slot = CONST_SLOT_ARMOR },
			{ id = 3559, amount = 1, slot = CONST_SLOT_LEGS },
			{ id = 3552, amount = 1, slot = CONST_SLOT_FEET },
			{ id = 3066, amount = 1, slot = CONST_SLOT_LEFT },
			{ id = 3059, amount = 1, slot = CONST_SLOT_RIGHT },
		},
		[14027] = { -- Paladin
			{ id = 3355, amount = 1, slot = CONST_SLOT_HEAD },
			{ id = 3571, amount = 1, slot = CONST_SLOT_ARMOR },
			{ id = 8095, amount = 1, slot = CONST_SLOT_LEGS },
			{ id = 3552, amount = 1, slot = CONST_SLOT_FEET },
			{ id = 3350, amount = 1, slot = CONST_SLOT_LEFT },
			{ id = 35562, amount = 1, slot = CONST_SLOT_RIGHT },
			{ id = 3277, amount = 1 }, -- spear
			{ id = 3447, amount = 100 }, -- arrows
			{ id = 3409, amount = 1, slot = CONST_SLOT_SHIELD },
		},
		[14028] = { -- Knight
			{ id = 3375, amount = 1, slot = CONST_SLOT_HEAD },
			{ id = 3359, amount = 1, slot = CONST_SLOT_ARMOR },
			{ id = 3372, amount = 1, slot = CONST_SLOT_LEGS },
			{ id = 3552, amount = 1, slot = CONST_SLOT_FEET },
			{ id = 7774, amount = 1, slot = CONST_SLOT_LEFT },
			{ id = 3409, amount = 1, slot = CONST_SLOT_RIGHT },
			{ id = 17824, amount = 1 },
			{ id = 7773, amount = 1 },
		},		
		
		[14092] = { -- Monk
			{ id = 50194, amount = 1, slot = CONST_SLOT_HEAD },
			{ id = 50195, amount = 1, slot = CONST_SLOT_NECKLACE },
			{ id = 50257, amount = 1, slot = CONST_SLOT_ARMOR },
			{ id = 3372, amount = 1, slot = CONST_SLOT_LEGS },
			{ id = 50267, amount = 1, slot = CONST_SLOT_FEET },
			{ id = 50171, amount = 1, slot = CONST_SLOT_LEFT },
			{ id = 17824, amount = 1 },
			{ id = 7773, amount = 1 },
		},
	},
}

local vocationReward = Action()

function vocationReward.onUse(player, item, fromPosition, itemEx, toPosition)
	local vocationItems = reward.vocationItems[item.uid]
	if not vocationItems then return true end

	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.VocationReward) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		return true
	end

	local container = Game.createItem(reward.container)

	-- Adiciona itens comuns na mochila
	for i = #reward.commonItems, 1, -1 do
		local entry = reward.commonItems[i]
		if entry.text then
			local doc = Game.createItem(entry.id)
			doc:setAttribute(ITEM_ATTRIBUTE_TEXT, entry.text)
			container:addItemEx(doc)
		else
			container:addItem(entry.id, entry.amount)
		end
	end

	-- Equipa os itens com slot, os outros vao para a mochila
	for i = #vocationItems, 1, -1 do
		local entry = vocationItems[i]
		local itemObj = Game.createItem(entry.id, entry.amount)

		if entry.slot then
			local current = player:getSlotItem(entry.slot)
			if current then
				local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
				if backpack then
					current:moveTo(backpack)
				else
					current:remove()
				end
			end
			player:addItemEx(itemObj, true, entry.slot)
		else
			container:addItemEx(itemObj)
		end
	end

	if player:addItemEx(container, false, CONST_SLOT_WHEREEVER) == RETURNVALUE_NOERROR then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. container:getName() .. ".")
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.VocationReward, 1)
	end
	return true
end

for index, value in pairs(reward.vocationItems) do
	vocationReward:uid(index)
end

vocationReward:register()
