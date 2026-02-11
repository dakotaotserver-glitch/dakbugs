local bossKillEvent = CreatureEvent("BossKillCounter")

local KILL_COUNT_STORAGE = 65145

function bossKillEvent.onDeath(creature, corpse, killer, mostDamageKiller)
    if not creature:isMonster() then
        return true
    end
    local damageMap = creature:getDamageMap()
    if not damageMap then
        return true
    end

    for playerId, _ in pairs(damageMap) do
        local player = Player(playerId)
        if player then
            local kills = player:getStorageValue(KILL_COUNT_STORAGE)
            if kills < 0 then kills = 0 end
            kills = kills + 1
            player:setStorageValue(KILL_COUNT_STORAGE, kills)

            if kills < 10 then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                    "You have defeated this boss " .. kills .. " times.")
            elseif kills == 10 then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                    "Congratulations! You have defeated this boss 10 times and received a special achievement!")
                player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
            end
            -- Para kills > 10, nada será mostrado!
        end
    end
    return true
end

bossKillEvent:register()
