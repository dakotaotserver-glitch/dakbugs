local paleWormDeath = CreatureEvent("paleWormDeath")
local outfits = { 1271, 1270 } -- Poltergeist (male, female)

function paleWormDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
    if not creature or not creature:getMonster() then
        return
    end
    local damageMap = creature:getMonster():getDamageMap()

    for key, _ in pairs(damageMap) do
        local player = Player(key)
        if player and player:getStorageValue(Storage.Quest.U12_30.PoltergeistOutfits.Received) == -1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Poltergeist Outfit.")
            player:addOutfit(1271, 0)
            player:addOutfit(1270, 0)
            player:setStorageValue(Storage.Quest.U12_30.PoltergeistOutfits.Received, 1)
            player:getPosition():sendMagicEffect(171)
        end
    end
end

paleWormDeath:register()
