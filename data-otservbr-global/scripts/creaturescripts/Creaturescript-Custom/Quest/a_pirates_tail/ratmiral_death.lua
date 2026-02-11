local ratmiralBlackwhiskersDeath = CreatureEvent("RatmiralBlackwhiskersDeath")
local outfits = { 1371, 1372 }

function ratmiralBlackwhiskersDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature or not creature:getMonster() then
		return
	end
	local damageMap = creature:getMonster():getDamageMap()

	for key, _ in pairs(damageMap) do
		local player = Player(key)
		if player and not player:hasOutfit(outfits[1]) and not player:hasOutfit(outfits[2]) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Rascoohan Outfit.")
			player:setStorageValue(Storage.Quest.U12_60.APiratesTail.Ratmiralkilled, 2)
			player:setStorageValue(Storage.Quest.U12_60.APiratesTail.RitaLetter, 1)
			player:addOutfit(1371, 0)
			player:addOutfit(1372, 0)
			player:getPosition():sendMagicEffect(171)
		end
	end
end

ratmiralBlackwhiskersDeath:register()
