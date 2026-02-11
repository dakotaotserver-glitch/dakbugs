local config = {
    centerPosition = Position(33578, 31015, 15), -- Center Room  
	rangeX = 11,
	rangeY = 11,
}

local KingzelosDeath = CreatureEvent("lordDeath")
local removeMonsters = false

function KingzelosDeath.onPrepareDeath(creature)
    local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
    for _, cid in pairs(spectators) do
        if removeMonsters and cid:isMonster() and not cid:getMaster() then
            cid:remove()
        elseif cid:isPlayer() then
            if cid:getStorageValue(67094) == -1 then
                cid:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you won Formal Dress Outfit.")
                cid:addOutfit(1460, 0)
                cid:addOutfit(1461, 0)
                cid:setStorageValue(67094, 1)
            end
        end
    end

    return true
end

KingzelosDeath:register()