local internalNpcName = "Test Booster"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {
    amountMoney = 100, -- Quantidade fixa de Gold Coins por saque (100)
    maxGoldWithdrawals = 10, -- Número máximo de saques permitidos
    storageKeyGold = 50002, -- Chave de armazenamento para rastrear os saques de Gold Coins
    amountLevel = 100,
    maxLevel = 800,
    amountTibiaCoins = 100,
    maxTibiaCoins = 3500, -- Máximo permitido de Tibia Coins
    storageKeyTibiaCoins = 50001, -- Chave de armazenamento para Tibia Coins
    vocationItems = {
        [1] = { -- Sorcerer e Master Sorcerer
            {itemId = 34095, count = 1}, -- soulmantle
            {itemId = 43884, count = 1}, -- sanguine boots
            {itemId = 34092, count = 1}, -- soulshanks
            {itemId = 39151, count = 1}, -- arcanomancer regalia
            {itemId = 43882, count = 1}, -- Sanguine Coil
            {itemId = 34090, count = 1}, -- Soultainter
            {itemId = 39152, count = 1}, -- Arcanomancer Folio
            {itemId = 9596, count = 1}, -- Squeezing Gear of Girlpower
        },
        [2] = { -- Druid e Elder Druid
            {itemId = 34096, count = 1}, -- soulshroud
            {itemId = 43887, count = 1}, -- sanguine galoshes
            {itemId = 34093, count = 1}, -- soulstrider
            {itemId = 39153, count = 1}, -- arboreal crown
            {itemId = 43885, count = 1}, -- Sanguine Rod
            {itemId = 34091, count = 1}, -- Soulhexer
            {itemId = 39154, count = 1}, -- Arboreal Tome
            {itemId = 9596, count = 1}, -- Squeezing Gear of Girlpower
        },
        [3] = { -- Paladin e Royal Paladin
            {itemId = 34094, count = 1}, -- soulshell
            {itemId = 34098, count = 1}, -- pair of soulstalkers
            {itemId = 43881, count = 1}, -- sanguine greaves
            {itemId = 39149, count = 1}, -- alicorn headguard
            {itemId = 39150, count = 1}, -- alicorn quiver
            {itemId = 43879, count = 1}, -- sanguine crossbow
            {itemId = 43877, count = 1}, -- sanguine bow
            {itemId = 9596, count = 1}, -- Squeezing Gear of Girlpower
        },
        [4] = { -- Knight e Elite Knight
            {itemId = 39147, count = 1}, -- spiritthorn armor
            {itemId = 34097, count = 1}, -- pair of soulwalkers
            {itemId = 43876, count = 1}, -- sanguine legs
            {itemId = 39148, count = 1}, -- spiritthorn helmet
            {itemId = 43874, count = 1}, -- Sanguine Battleaxe
            {itemId = 43868, count = 1}, -- Sanguine Hatchet
            {itemId = 34085, count = 1}, -- Souleater (Axe)
            {itemId = 28724, count = 1}, -- Falcon Battleaxe
            {itemId = 47369, count = 1}, -- Amber Greataxe
            {itemId = 43872, count = 1}, -- Sanguine Bludgeon
            {itemId = 43866, count = 1}, -- Sanguine Cudgel
            {itemId = 34086, count = 1}, -- Soulcrusher
            {itemId = 34087, count = 1}, -- Soulmaimer
            {itemId = 47376, count = 1}, -- Amber Cudgel
            {itemId = 43864, count = 1}, -- Sanguine Blade
            {itemId = 43870, count = 1}, -- Sanguine Razor
            {itemId = 34082, count = 1}, -- Soulcutter
            {itemId = 34083, count = 1}, -- Soulshredder
            {itemId = 34155, count = 1}, -- Lion Longsword
            {itemId = 34099, count = 1}, -- Soulbastion
            {itemId = 9596, count = 1}, -- Squeezing Gear of Girlpower
        },
        [5] = { -- Monk e Exalted Monk
            {itemId = 50254, count = 1}, -- soulgarb
            {itemId = 50146, count = 1}, -- Sanguine Trousers
            {itemId = 50240, count = 1}, -- Soulsoles
            {itemId = 50188, count = 1}, -- Ethereal Coned Hat
            {itemId = 50157, count = 1}, -- Sanguine Claws
            {itemId = 50159, count = 1}, -- Soulkamas
            {itemId = 50239, count = 1}, -- Amber Kusarigama
            {itemId = 9596, count = 1}, -- Squeezing Gear of Girlpower
        },
    },
    storageKey = 50000, -- Chave de armazenamento para verificar se o jogador já recebeu os itens
    guildbankBackpackId = 61956 -- ID da Guildbank Backpack
}
npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2
npcConfig.outfit = {
    lookType = 146,
    lookHead = 60,
    lookBody = 24,
    lookLegs = 38,
    lookFeet = 0,
    lookAddons = 0,
}
npcConfig.flags = {
    floorchange = false,
}
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
npcType.onThink = function(npc, interval)
    npcHandler:onThink(npc, interval)
end
npcType.onAppear = function(npc, creature)
    npcHandler:onAppear(npc, creature)
end
npcType.onDisappear = function(npc, creature)
    npcHandler:onDisappear(npc, creature)
end
npcType.onMove = function(npc, creature, fromPosition, toPosition)
    npcHandler:onMove(npc, creature, fromPosition, toPosition)
end
npcType.onSay = function(npc, creature, type, message)
    npcHandler:onSay(npc, creature, type, message)
end
npcType.onCloseChannel = function(npc, creature)
    npcHandler:onCloseChannel(npc, creature)
end

-- Função auxiliar para obter os limites de habilidade por vocação
local function getVocationLimits(player)
    local vocationId = player:getVocation():getBaseId()
    if vocationId == 1 then -- Sorcerer e Master Sorcerer
        return {
            maxMagic = 120,
            maxSword = 30,
            maxAxe = 30,
            maxClub = 30,
            maxDistance = 30,
            maxShielding = 60,
            maxFist = 30,
        }
    elseif vocationId == 2 then -- Druid e Elder Druid
        return {
            maxMagic = 120,
            maxSword = 30,
            maxAxe = 30,
            maxClub = 30,
            maxDistance = 30,
            maxShielding = 60,
            maxFist = 30,
        }
    elseif vocationId == 3 then -- Paladin e Royal Paladin
        return {
            maxMagic = 45,
            maxSword = 30,
            maxAxe = 30,
            maxClub = 30,
            maxDistance = 115,
            maxShielding = 90,
            maxFist = 30,
        }
    elseif vocationId == 4 then -- Knight e Elite Knight
        return {
            maxMagic = 25,
            maxSword = 120,
            maxAxe = 120,
            maxClub = 120,
            maxDistance = 30,
            maxShielding = 120,
            maxFist = 30,
        }
    elseif vocationId == 5 then -- Monk e Exalted Monk (baseid 5)
        return {
            maxMagic = 90,
            maxSword = 30,
            maxAxe = 30,
            maxClub = 30,
            maxDistance = 30,
            maxShielding = 90,
            maxFist = 120,
        }
    else
        return {
            maxMagic = 120,
            maxSword = 120,
            maxAxe = 120,
            maxClub = 120,
            maxDistance = 120,
            maxShielding = 120,
            maxFist = 120,
        }
    end
end

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    -- Dinheiro
    if MsgContains(message, "money") or MsgContains(message, "gold") then
        local currentWithdrawals = player:getStorageValue(npcConfig.storageKeyGold)
        if currentWithdrawals >= npcConfig.maxGoldWithdrawals then
            npcHandler:say("You have already reached the maximum number of gold withdrawals!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end
        player:addItem(3043, npcConfig.amountMoney) -- Adiciona 100 Gold Coins
        player:setStorageValue(npcConfig.storageKeyGold, currentWithdrawals + 1) -- Incrementa o contador de saques
        npcHandler:say("Here are your 100 Gold Coins! You have " .. (npcConfig.maxGoldWithdrawals - (currentWithdrawals + 1)) .. " withdrawals remaining.", npc, creature)
    end

    -- Tibia Coins
    if MsgContains(message, "tibiacoin") or MsgContains(message, "tibia coin") then
        local currentCoins = player:getStorageValue(npcConfig.storageKeyTibiaCoins)
        if currentCoins >= npcConfig.maxTibiaCoins then
            npcHandler:say("You have already reached the maximum amount of Tibia coins allowed!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end
        local coinsToAdd = math.min(npcConfig.amountTibiaCoins, npcConfig.maxTibiaCoins - currentCoins)
        player:addItem(22118, coinsToAdd)
        player:setStorageValue(npcConfig.storageKeyTibiaCoins, currentCoins + coinsToAdd)
        npcHandler:say("Here are your Tibia coins! You now have " .. (currentCoins + coinsToAdd) .. " coins.", npc, creature)
    end

    -- Magia
    if MsgContains(message, "magic") then
        local limits = getVocationLimits(player)
        if player:getMagicLevel() >= limits.maxMagic then
            npcHandler:say("You have already reached the maximum magic level of " .. limits.maxMagic .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum magic level allowed.")
        else
            local targetMagic = math.min(player:getMagicLevel() + 20, limits.maxMagic)
            player:setMagicLevel(targetMagic)
            npcHandler:say("Your magic level has been increased to " .. targetMagic .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Espada
    if MsgContains(message, "sword") then
        local limits = getVocationLimits(player)
        local currentSkill = player:getSkillLevel(SKILL_SWORD)
        if currentSkill >= limits.maxSword then
            npcHandler:say("You have already reached the maximum sword skill level of " .. limits.maxSword .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum sword skill level allowed.")
        else
            local targetSkill = math.min(currentSkill + 10, limits.maxSword)
            player:setSkillLevel(SKILL_SWORD, targetSkill)
            npcHandler:say("Your sword skill has been increased to " .. targetSkill .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Machado
    if MsgContains(message, "axe") then
        local limits = getVocationLimits(player)
        local currentSkill = player:getSkillLevel(SKILL_AXE)
        if currentSkill >= limits.maxAxe then
            npcHandler:say("You have already reached the maximum axe skill level of " .. limits.maxAxe .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum axe skill level allowed.")
        else
            local targetSkill = math.min(currentSkill + 10, limits.maxAxe)
            player:setSkillLevel(SKILL_AXE, targetSkill)
            npcHandler:say("Your axe skill has been increased to " .. targetSkill .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Clube
    if MsgContains(message, "club") then
        local limits = getVocationLimits(player)
        local currentSkill = player:getSkillLevel(SKILL_CLUB)
        if currentSkill >= limits.maxClub then
            npcHandler:say("You have already reached the maximum club skill level of " .. limits.maxClub .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum club skill level allowed.")
        else
            local targetSkill = math.min(currentSkill + 10, limits.maxClub)
            player:setSkillLevel(SKILL_CLUB, targetSkill)
            npcHandler:say("Your club skill has been increased to " .. targetSkill .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Distância
    if MsgContains(message, "distance") or MsgContains(message, "dist") then
        local limits = getVocationLimits(player)
        local currentSkill = player:getSkillLevel(SKILL_DISTANCE)
        if currentSkill >= limits.maxDistance then
            npcHandler:say("You have already reached the maximum distance skill level of " .. limits.maxDistance .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum distance skill level allowed.")
        else
            local targetSkill = math.min(currentSkill + 10, limits.maxDistance)
            player:setSkillLevel(SKILL_DISTANCE, targetSkill)
            npcHandler:say("Your distance skill has been increased to " .. targetSkill .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Shielding
    if MsgContains(message, "shielding") or MsgContains(message, "shield") then
        local limits = getVocationLimits(player)
        local currentSkill = player:getSkillLevel(SKILL_SHIELD)
        if currentSkill >= limits.maxShielding then
            npcHandler:say("You have already reached the maximum shielding skill level of " .. limits.maxShielding .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum shielding skill level allowed.")
        else
            local targetSkill = math.min(currentSkill + 10, limits.maxShielding)
            player:setSkillLevel(SKILL_SHIELD, targetSkill)
            npcHandler:say("Your shielding skill has been increased to " .. targetSkill .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Fist Fighting (Nova skill adicionada para Monk)
    if MsgContains(message, "fist") or MsgContains(message, "fist fighting") then
        local limits = getVocationLimits(player)
        local currentSkill = player:getSkillLevel(SKILL_FIST)
        if currentSkill >= limits.maxFist then
            npcHandler:say("You have already reached the maximum fist fighting skill level of " .. limits.maxFist .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have reached the maximum fist fighting skill level allowed.")
        else
            local targetSkill = math.min(currentSkill + 10, limits.maxFist)
            player:setSkillLevel(SKILL_FIST, targetSkill)
            npcHandler:say("Your fist fighting skill has been increased to " .. targetSkill .. "!", npc, creature)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    -- Experiência
    if MsgContains(message, "exp") or MsgContains(message, "experience") then
        if player:getLevel() > npcConfig.maxLevel then
            npcHandler:say("You cannot take it anymore.", npc, creature)
        else
            npcHandler:say("Here you go, |PLAYERNAME|.", npc, creature)
            local level = player:getLevel() + npcConfig.amountLevel - 1
            local experience = ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
            player:addExperience(experience - player:getExperience(), true, true)
        end
    end

    -- Bênçãos
    if MsgContains(message, "bless") or MsgContains(message, "blessing") then
        local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or true
        local donthavefilter = function(p, b)
            return not p:hasBlessing(b)
        end
        local missingBless = player:getBlessings(nil, donthavefilter)
        local missingBlessAmt = #missingBless + (hasToF and 0 or 1)
        if missingBlessAmt == 0 then
            player:sendTextMessage(MESSAGE_STATUS, "You are already blessed.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return false
        end
        for i, v in ipairs(missingBless) do
            player:addBlessing(v.id, 1)
        end
        npcHandler:say("You have been blessed by all gods, |PLAYERNAME|.", npc, creature)
        player:sendTextMessage(MESSAGE_STATUS, "You received the remaining " .. missingBlessAmt .. " blessings.")
        player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
    end

    -- Reset
    if MsgContains(message, "reset") then
        if player:getLevel() > 8 then
            local level = 7
            local experience = ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
            player:removeExperience(player:getExperience() - experience)
        else
            npcHandler:say("You cannot take it anymore.", npc, creature)
        end
    end

    -- Itens por Vocação
    if MsgContains(message, "items") or MsgContains(message, "vocation items") then
        local playerName = player:getName()
        local storageKey = npcConfig.storageKey
        if player:getStorageValue(storageKey) == 1 then
            npcHandler:say("You have already received your vocation-specific items!", npc, creature)
            return true
        end
        local vocationId = player:getVocation():getBaseId()
        local itemsForVocation = npcConfig.vocationItems[vocationId]
        if not itemsForVocation then
            npcHandler:say("Sorry, I don't have any items configured for your vocation.", npc, creature)
            return true
        end
        -- Cria a Guildbank Backpack
        local backpack = Game.createItem(npcConfig.guildbankBackpackId, 1)
        if not backpack then
            npcHandler:say("An error occurred while creating your backpack. Please contact an administrator.", npc, creature)
            return true
        end
        -- Adiciona os itens à Guildbank Backpack
        for _, itemData in ipairs(itemsForVocation) do
            backpack:addItem(itemData.itemId, itemData.count)
        end
        -- Entrega a Guildbank Backpack ao jogador
        if player:addItemEx(backpack) ~= RETURNVALUE_NOERROR then
            npcHandler:say("You don't have enough space in your inventory to receive the backpack. Please free some space and try again.", npc, creature)
            return true
        end

        -- Marca o jogador como tendo recebido os itens
        player:setStorageValue(storageKey, 1)
        npcHandler:say("Here is your Guildbank Backpack with your vocation-specific items!", npc, creature)
        player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|. I'm Testserver Assistant and I can give {money}, {experience}, {blessing}, {tibiacoin}, {magic}, {sword}, {axe}, {club}, {distance}, {shielding}, {fist}, and {items} which will be useful for testing on " .. configManager.getString(configKeys.SERVER_NAME) .. " server." .. " You can also reset to level 8 with {reset}.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Register NPC
npcType:register(npcConfig)

