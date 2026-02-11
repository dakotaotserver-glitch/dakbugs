local config = {
    [1] = {
        teleportPosition = {x = 33455, y = 32135, z = 9},
        bossName = "Sugar Mommy",
        requiredLevel = 250,
        timeToFightAgain = 2, -- Em horas
        timeToDefeat = 10,    -- Em minutos
        destination = Position({x = 33433, y = 32137, z = 9}),
        bossPosition = Position({x = 33433, y = 32131, z = 9}),
        specPos = {
            from = Position({x = 33426, y = 32127, z = 9}),
            to   = Position({x = 33440, y = 32140, z = 9}),
        },
        exitPosition = Position({x = 33455, y = 32136, z = 9}),
    },
}

local teleportBoss = MoveEvent()

function teleportBoss.onStepIn(creature, item, position, fromPosition)
    if not creature or not creature:isPlayer() then
        return false
    end
    for index, value in pairs(config) do
        if Tile(position) == Tile(value.teleportPosition) then
            if not value.specPos then
                creature:teleportTo(value.exitPosition)
                creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                return true
            end

            local foundPlayer = false
            for _, player in pairs(Game.getPlayers()) do
                local pos = player:getPosition()
                local fromPos = value.specPos.from
                local toPos = value.specPos.to
                -- Ignora o próprio player e só conta players normais
                if pos.x >= fromPos.x and pos.x <= toPos.x and
                   pos.y >= fromPos.y and pos.y <= toPos.y and
                   pos.z == fromPos.z and
                   player:getGroup():getId() == 1 and
                   player:getId() ~= creature:getId() then
                    foundPlayer = true
                    break
                end
            end

            if foundPlayer then
                creature:teleportTo(fromPosition, true)
                creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                creature:say("There's someone fighting with " .. value.bossName .. ".", TALKTYPE_MONSTER_SAY)
                return true
            end

            -- Checa level mínimo
            if creature:getLevel() < value.requiredLevel then
                creature:teleportTo(fromPosition, true)
                creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                creature:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                    "All the players need to be level " .. value.requiredLevel .. " or higher.")
                return true
            end

            -- Checa cooldown do boss
            if not creature:canFightBoss(value.bossName) then
                creature:teleportTo(fromPosition, true)
                creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                creature:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                    "You have to wait " .. value.timeToFightAgain .. " hours to face " .. value.bossName .. " again!")
                return true
            end

            -- Limpa monstros antigos da sala
            local spec = Spectators()
            spec:setOnlyPlayer(false)
            spec:setRemoveDestination(value.exitPosition)
            spec:setCheckPosition(value.specPos)
            spec:check()
            spec:removeMonsters()

            -- Cria o boss
            local monster = Game.createMonster(value.bossName, value.bossPosition, true, true)
            if not monster then
                return true
            end
            creature:teleportTo(value.destination)
            creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            creature:setBossCooldown(value.bossName, os.time() + value.timeToFightAgain * 3600)
            creature:sendBosstiaryCooldownTimer()

            -- Timer para expulsar depois do tempo limite
            addEvent(function()
                spec:clearCreaturesCache()
                spec:setOnlyPlayer(true)
                spec:check()
                spec:removePlayers()
            end, value.timeToDefeat * 60 * 1000)
        end
    end
end

for index, value in pairs(config) do
    teleportBoss:position(value.teleportPosition)
end

teleportBoss:type("stepin")
teleportBoss:register()
