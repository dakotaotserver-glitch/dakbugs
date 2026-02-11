local action = Action()

local VOCATION_ITEMS = {
    [1] = 28544,  -- Sorcerer
    [2] = 28545,  -- Druid 
    [3] = 28543,  -- Paladin
    [5] = 28544,  -- Master Sorcerer
    [6] = 28545,  -- Elder Druid
    [7] = 28543   -- Royal Paladin
}

local KNIGHT_ITEMS = {
    axe = 28541,   -- Item ID para skill de axe
    club = 28542,  -- Item ID para skill de club
    sword = 28540  -- Item ID para skill de sword
}

local COOLDOWN_STORAGE = 65019
local COOLDOWN_TIME = 24 * 60 * 60 -- 24 horas em segundos
local EXTRA_ITEM_ID_1 = 3043 -- ID do item extra comum a todas as vocações
local EXTRA_ITEM_ID_2 = 236 -- ID do item extra para Knights e Paladins
local EXTRA_ITEM_ID_3 = 237 -- ID do item extra para Druids e Sorcerers
local EXTRA_ITEM_ID_4 = 3585 -- ID do item extra comum a todas as vocações (20 unidades)
local CONTAINER_ID = 21411 -- ID do container

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentTime = os.time()
    local lastUsedTime = player:getStorageValue(COOLDOWN_STORAGE)

    if lastUsedTime > 0 and (currentTime - lastUsedTime) < COOLDOWN_TIME then
        local remainingTime = COOLDOWN_TIME - (currentTime - lastUsedTime)
        player:sendCancelMessage("Aguarde 24 Horas")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local vocationId = player:getVocation():getId()
    local rewardItemId

    if vocationId == 4 or vocationId == 8 then
        -- Knights e Elite Knights recebem itens com base no maior skill
        local skills = {
            axe = player:getSkillLevel(SKILL_AXE),
            club = player:getSkillLevel(SKILL_CLUB),
            sword = player:getSkillLevel(SKILL_SWORD)
        }

        local highestSkill = "axe"
        for skill, level in pairs(skills) do
            if level > skills[highestSkill] then
                highestSkill = skill
            end
        end
        rewardItemId = KNIGHT_ITEMS[highestSkill]
    else
        rewardItemId = VOCATION_ITEMS[vocationId]
    end

    if rewardItemId then
        local container = player:addItem(CONTAINER_ID, 1) -- Adiciona o container ao jogador
        if container then
            container:addItem(rewardItemId, 100)  -- Adiciona o item específico da vocação com 100 cargas ao container
            container:addItem(EXTRA_ITEM_ID_1, 1)  -- Adiciona uma unidade do item extra comum a todas as vocações ao container
            container:addItem(EXTRA_ITEM_ID_4, 20)  -- Adiciona 20 unidades do item 3585 ao container

            -- Adiciona itens extras específicos para cada grupo de vocações ao container
            if vocationId == 1 or vocationId == 5 or vocationId == 2 or vocationId == 6 then
                container:addItem(EXTRA_ITEM_ID_3, 100)  -- Adiciona 100 unidades do item 237 para Druids e Sorcerers
            elseif vocationId == 3 or vocationId == 7 or vocationId == 4 or vocationId == 8 then
                container:addItem(EXTRA_ITEM_ID_2, 100)  -- Adiciona 100 unidades do item 236 para Knights e Paladins
            end

            player:setStorageValue(COOLDOWN_STORAGE, currentTime)
            player:sendCancelMessage("You have received your daily reward!")
            player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
        else
            player:sendCancelMessage("Could not create the reward container.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
    else
        player:sendCancelMessage("Your vocation does not have a reward.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end

    return true
end

action:uid(33021) -- Unique ID do item
action:register()
