local pos = {
	[2025] = { x = 32831, y = 32333, z = 11 },
	[2026] = { x = 32833, y = 32333, z = 11 },
	[2027] = { x = 32835, y = 32333, z = 11 },
	[2028] = { x = 32837, y = 32333, z = 11 },
	[2029] = { x = 32839, y = 32333, z = 11 },
}

local function doRemoveFirewalls(fwPos)
	local tile = Position(fwPos):getTile()
	if tile then
		local thing = tile:getItemById(6288)
		if thing then
			thing:remove()
		end
	end
end

local pitsOfInfernoWalls = Action()

function pitsOfInfernoWalls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local uid = item.uid
	local firewallPos = pos[uid]

	if not firewallPos then
		return false
	end

	if item.itemid == 2772 then
		doRemoveFirewalls(firewallPos)
		Position(firewallPos):sendMagicEffect(CONST_ME_FIREAREA)

		-- Verifica se é a alavanca de UID 2029 para remover item 5062 da posição específica
		if uid == 2029 then
			local extraTile = Position(32839, 32334, 11):getTile()
			if extraTile then
				local itemToRemove = extraTile:getItemById(5062)
				if itemToRemove then
					itemToRemove:remove()
				end
			end
		end
	else
		Game.createItem(6288, 1, firewallPos)
		Position(firewallPos):sendMagicEffect(CONST_ME_FIREAREA)
	end

	item:transform(item.itemid == 2772 and 2773 or 2772)
	return true
end

for unique, _ in pairs(pos) do
	pitsOfInfernoWalls:uid(unique)
end

pitsOfInfernoWalls:register()
