local forge = Action()

local porcentagem = 100
local chance = {
    [1] = 100, [2] = 90, [3] = 80, [4] = 70, [5] = 60,
    [6] = 30, [7] = 20, [8] = 15, [9] = 10, [10] = 5
}

function forge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target:isItem() then return false end

    local targetTier = target:getTier()
    local goldcount = ((targetTier * 0) + 0)
    local description = target:getDescription()
    local classificationString = string.match(description, "Classification: .")

    if classificationString then
        if (classificationString == 'Classification: 1' and targetTier == 1) or 
           (classificationString == 'Classification: 2' and targetTier == 2) or
           (classificationString == 'Classification: 3' and targetTier == 3) or
           (classificationString == 'Classification: 4' and targetTier == 10) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Este item ja tem o nivel maximo.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Este item nao pode ser forjado.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    if targetTier == 10 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Este item ja tem o nivel maximo de forja.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    if player:getItemCount(61937) < 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem a quantidade necessaria do item de forja.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local sameTierItem
    local requiresSameItem = targetTier >= 1
    if requiresSameItem then
        local cylinder = player:getSlotItem(CONST_SLOT_BACKPACK)
        if cylinder and cylinder:isContainer() then
            for i = 0, cylinder:getSize() - 1 do
                local itemSearch = cylinder:getItem(i)
                if itemSearch:getId() == target:getId() and
                   itemSearch:getTier() == target:getTier() and
                   target:getUniqueId() ~= itemSearch:getUniqueId() then
                    sameTierItem = itemSearch
                    break
                end
            end
        end

        if not sameTierItem then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa de um item do mesmo tier.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end
    end

    if not player:removeMoneyBank(goldcount) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            "Voce precisa ter " .. goldcount .. " de gold para realizar a tentativa de forja.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local rand = math.random(100)
    local successChance = chance[targetTier] or 100
    if targetTier >= 1 and rand > successChance then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A forja falhou.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        item:remove(1)
        return true
    end

    local clone = target:clone()
    if clone:setTier(targetTier + 1) then
        target:remove(1)
        player:addItemEx(clone, true, CONST_SLOT_WHEREEVER)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Parabens, o item foi forjado com sucesso!")
        player:getPosition():sendMagicEffect(50)
        item:remove(1)
        if sameTierItem then sameTierItem:remove(1) end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Erro ao aplicar o novo tier. A forja foi cancelada.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end

    return true
end

forge:id(61937)
forge:register()
