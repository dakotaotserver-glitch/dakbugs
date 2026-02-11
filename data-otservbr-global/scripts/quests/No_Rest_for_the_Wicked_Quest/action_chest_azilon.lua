local singleRewardChest = Action()

local REWARD_STORAGE = 65147

-- Tabela de [uid] = itemId
local chestRewards = {
    [57510] = 49520,
    [57511] = 49522,
    [57512] = 49523,
    [57513] = 49524,
    [57514] = 49525,
    [57515] = 49526,
    [57516] = 49527,
    [57517] = 49530,
    [57521] = 49528,
    [57519] = 49529,
    [57520] = 50250,
}

function singleRewardChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(REWARD_STORAGE) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already claimed your reward.")
        return true
    end

    local rewardId = chestRewards[item.uid]
    if rewardId then
        player:addItem(rewardId, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received your reward!")
        player:setStorageValue(REWARD_STORAGE, 1)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This chest has no reward configured.")
    end
    return true
end

-- Registra a action para todos os UIDs
singleRewardChest:uid(
    57510, 57511, 57512, 57513, 57514,
    57515, 57516, 57517, 57521, 57519,
    57520
)
singleRewardChest:register()
