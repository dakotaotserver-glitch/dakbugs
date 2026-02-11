local config = {
    boss = {
        name = "The Unwelcome",
        position = Position(33708, 31539, 14),
    },
    requiredLevel = 250,
    playerPositions = {
        { pos = Position(33736, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(33737, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(33738, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(33739, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
        { pos = Position(33740, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
    },
    monsters = {},
    specPos = {
        from = Position(33698, 31527, 14),
        to = Position(33720, 31548, 14),
    },
    exit = Position(33743, 31535, 14),
}

local lever = BossLever(config)
lever:position({ x = 33735, y = 31537, z = 14 })

local originalOnUse = lever.onUse

function lever:onUse(player, item, fromPosition, target, toPosition)
    -- Executa o comportamento padrão (teleportar jogadores, spawnar boss, etc)
    local success = originalOnUse(self, player, item, fromPosition, target, toPosition)
    if not success then
        return false
    end

    -- 30 segundos depois, verificar se The Unwelcome foi criado e só então criar Brother Worm
    addEvent(function()
        local centerPos = Position(33708, 31539, 14)
        local spectators = Game.getSpectators(centerPos, false, false, 20, 20, 20, 20)

        local foundUnwelcome = nil
        local foundBrotherWorm = nil

        for _, spectator in ipairs(spectators) do
            if spectator:isMonster() then
                local name = spectator:getName():lower()
                if name == "the unwelcome" then
                    foundUnwelcome = spectator -- guarda referência para usar depois
                elseif name == "brother worm" then
                    foundBrotherWorm = spectator
                end
            end
        end

        -- Condição para criar o Brother Worm
        if foundUnwelcome and not foundBrotherWorm then
            Game.createMonster("Brother Worm", centerPos)
        end
    end, 30000)

    return true
end

lever:register()
