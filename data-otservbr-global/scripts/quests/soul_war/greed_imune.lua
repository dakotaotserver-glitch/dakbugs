local BOSS_NAME = "Goshnar's Greed"
local FROM_POS = Position(33739, 31663, 14)
local TO_POS = Position(33746, 31666, 14)
local ACTION_ID = 12125
local GREED_TELEPORT_STORAGE = 65138

local greedTeleportTile = MoveEvent()

function greedTeleportTile.onStepIn(creature, item, position, fromPosition)
    if not creature:isMonster() or creature:getName() ~= BOSS_NAME then
        return true
    end
    if item.actionid ~= ACTION_ID then
        return true
    end
    if position.x ~= FROM_POS.x or position.y ~= FROM_POS.y or position.z ~= FROM_POS.z then
        return true
    end

    if creature:getStorageValue(GREED_TELEPORT_STORAGE) == 1 then
        return true
    end

    creature:setStorageValue(GREED_TELEPORT_STORAGE, 1)
    addEvent(function()
        if creature and creature:isMonster() and creature:getName() == BOSS_NAME then
            creature:teleportTo(TO_POS)
            TO_POS:sendMagicEffect(CONST_ME_TELEPORT)

            -- Ativa imunidade ao teleportar
            creature:immune(true)
            creature:say("You cannot harm me now!", TALKTYPE_MONSTER_SAY)
        end
    end, 500) -- 1 segundo

    return true
end

greedTeleportTile:aid(ACTION_ID)
greedTeleportTile:register()
