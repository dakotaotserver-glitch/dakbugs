-- Função auxiliar para converter segundos em texto legível
function getTimeInWords(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    local parts = {}

    if minutes > 0 then
        table.insert(parts, minutes .. " minuto" .. (minutes ~= 1 and "s" or ""))
    end
    if secs > 0 then
        table.insert(parts, secs .. " segundo" .. (secs ~= 1 and "s" or ""))
    end

    return table.concat(parts, " e ")
end

-- Tabela de venda
sellingTable = {}

local count = 0
for _, eachType in pairs(LootShopConfigTable) do
    for _, eachItem in ipairs(eachType) do
        local insertItem = {name = eachItem.itemName, sell = eachItem.sell}
        sellingTable[eachItem.clientId] = insertItem
        count = count + 1
    end
end

logger.info("The price list for the Loot Seller has been updated, with "..count.." items.")

-- Configurações
local conf = {
    toggleLogger = false,
    itemSellerId = 61641,
    exhaust = 600,
    lootPouchId = 61812,
    percentPrice = 0.9,
    maxValueSell = 700
}

-- Função recursiva para coletar todos os itens vendáveis de um container e subcontainers
function getAllSellableItems(container, limit, collected)
    collected = collected or {}
    for _, item in pairs(container:getItems() or {}) do
        if #collected >= limit then break end
        if item:isContainer() then
            local inner = Container(item:getUniqueId())
            if inner then
                getAllSellableItems(inner, limit, collected)
            end
        elseif sellingTable[item:getId()] then
            table.insert(collected, item)
        end
    end
    return collected
end

-- Ação principal
local itemSeller = Action()

function itemSeller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getExhaustion("itemSellerExhaustion") > 0 then
        player:sendCancelMessage("You must wait "..getTimeInWords(player:getExhaustion("itemSellerExhaustion")).." to use this item again.")
        return true
    end

    local lootPouchStore = nil
    local lootPouch = player:getItemById(conf.lootPouchId, true)
    local inbox = player:getStoreInbox():getItems()

    for _, inboxItem in pairs(inbox) do
        if inboxItem:getId() == conf.lootPouchId then
            lootPouchStore = Container(inboxItem:getUniqueId())
            break
        end
    end

    if not lootPouch and not lootPouchStore then
        player:sendCancelMessage("You don't have a loot pouch.")
        player:setExhaustion("itemSellerExhaustion", conf.exhaust)
        return true
    end

    local totalItemsInPouch = 0
    if lootPouch then totalItemsInPouch = lootPouch:getItemHoldingCount() end
    if lootPouchStore then totalItemsInPouch = totalItemsInPouch + lootPouchStore:getItemHoldingCount() end

    if totalItemsInPouch < 1 then
        player:sendCancelMessage("You don't have anything to sell.")
        return true
    end

    local itemsToSell = {}

    if lootPouchStore then
        getAllSellableItems(lootPouchStore, conf.maxValueSell, itemsToSell)
    end
    if lootPouch then
        getAllSellableItems(lootPouch, conf.maxValueSell, itemsToSell)
    end

    local totalEarn = 0
    local totalSelled = 0

    for _, it in pairs(itemsToSell) do
        local count = it:getCount()
        if not it:isContainer() and sellingTable[it:getId()] then
            if it:remove() then
                totalSelled = totalSelled + count
                totalEarn = totalEarn + (count * sellingTable[it:getId()].sell * conf.percentPrice)
            end
        end
    end

    player:setExhaustion("itemSellerExhaustion", conf.exhaust)

    if totalSelled < 1 then
        player:sendCancelMessage("You have some items, but none of them are saleable.")
        return true
    end

    Bank.credit(player:getName(), totalEarn)
    player:sendTextMessage(MESSAGE_TRADE, "You sold " .. totalSelled .. " items and received " .. totalEarn .. " golds. The money has been sent to your bank account.")

    if conf.toggleLogger then
        logger.info(player:getName() .. " used itemSeller and sold " .. totalSelled .. " items, receiving " .. totalEarn .. " golds.")
    end

    return true
end

itemSeller:id(conf.itemSellerId)
itemSeller:register()
