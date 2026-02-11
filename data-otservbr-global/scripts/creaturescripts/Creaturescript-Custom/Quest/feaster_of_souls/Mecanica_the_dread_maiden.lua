local SOULS = {
    ["red soul stealers"] = 33016,
    ["blue soul stealers"] = 33014,
    ["green soul stealers"] = 33015,
}
local BOSS_NAME = "The Dread Maiden"

local shieldMoveEvent = MoveEvent()

function shieldMoveEvent.onStepIn(creature, item, position, fromPosition)
    if not creature:isMonster() then
        return true
    end

    local stealerName = creature:getName():lower()
    local correctActionId = SOULS[stealerName]
    if not correctActionId then
        return true -- Não é nenhum soul stealer esperado
    end

    local aid = item:getActionId()

    if aid == correctActionId then
        -- Passou no action id correto: remove 1 shield do boss
        local boss
        local spectators = Game.getSpectators(position, false, false, 20, 20, 20, 20)
        for _, spec in ipairs(spectators) do
            if spec:isMonster() and spec:getName():lower() == BOSS_NAME:lower() then
                boss = spec
                break
            end
        end

        if boss then
            local currentIcon = boss:getIcon("dread-maiden")
            local shields = (currentIcon and currentIcon.count) or 0

            if shields > 0 then
                boss:setIcon("dread-maiden", CreatureIconCategory_Quests, CreatureIconQuests_PurpleShield, shields - 1)
                boss:getPosition():sendMagicEffect(CONST_ME_ORANGE_ENERGY_SPARK)
            end
        end

        position:sendMagicEffect(CONST_ME_MORTAREA)
        creature:remove()
    else
        -- Passou no action id errado: punição!
        local players = Game.getSpectators(position, false, true, 20, 20, 20, 20)
        for _, player in ipairs(players) do
            if player:isPlayer() then
                player:addHealth(-1000)
                player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
            end
        end
        position:sendMagicEffect(CONST_ME_ENERGYHIT)
        creature:remove()
    end

    return true
end

shieldMoveEvent:type("stepin")
shieldMoveEvent:aid(33014, 33015, 33016)
shieldMoveEvent:register()

