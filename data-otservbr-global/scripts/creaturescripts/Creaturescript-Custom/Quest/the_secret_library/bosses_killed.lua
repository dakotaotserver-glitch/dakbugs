local bosses = {
	["ghulosh"] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Library.GhuloshKilled },
	["gorzindel"] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Library.GorzindelKilled },
	["lokathmor"] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Library.LokathmorKilled },
	["mazzinor"] = { storage = Storage.Quest.U11_80.TheSecretLibrary.Library.MazzinorKilled },
	["scourge of oblivion"] = { storage = Storage.Quest.U11_80.TheSecretLibrary.ScourgeOfOblivionKilled },
}

local bossesSecretLibrary = CreatureEvent("SecretLibraryBossDeath")
function bossesSecretLibrary.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		if bossConfig.storage then
			player:setStorageValue(bossConfig.storage, 1)
		end
		local bossesKilled = 0
		for value in pairs(bosses) do
			if player:getStorageValue(bosses[value].storage) > 0 then
				bossesKilled = bossesKilled + 1
			end
		end
		if bossesKilled >= 4 then -- number of mini bosses
			player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.ScourgeOfOblivionDoor, 1)
		end
	end)
	return true
end

bossesSecretLibrary:register()
