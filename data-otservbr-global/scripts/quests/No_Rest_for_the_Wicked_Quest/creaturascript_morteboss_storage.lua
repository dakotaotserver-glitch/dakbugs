-- creaturescripts/scripts/give_storage_on_kill.lua

local storageToGive = 65149
local bossName = nil -- Coloque o nome do monstro para filtrar (ex: "Arbaziloth"). Deixe como nil para aplicar a todos.

local giveStorageOnKill = CreatureEvent("GiveStorageOnKill")

function giveStorageOnKill.onDeath(creature, corpse, killer, mostDamageKiller)
    -- Se quiser filtrar para um boss específico, descomente a linha abaixo:
    -- if bossName and creature:getName():lower() ~= bossName:lower() then return true end

    -- Busca todos os jogadores que participaram da morte
    local killers = {}
    if creature.getKillers then
        killers = creature:getKillers(true)
    end
    for _, player in ipairs(killers) do
        if player:isPlayer() and player:getStorageValue(storageToGive) ~= 1 then
            player:setStorageValue(storageToGive, 1)
        end
    end
    return true
end

giveStorageOnKill:register()
