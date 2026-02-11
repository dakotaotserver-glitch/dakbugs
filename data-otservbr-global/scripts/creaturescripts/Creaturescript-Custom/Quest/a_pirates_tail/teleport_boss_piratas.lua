local creatureThinkEvent = CreatureEvent("CreatureThinkEvent")

local teleportPositions = {
    ["Rateye Ric"] = Position(33920, 31379, 15),
    ["Mister Catkiller"] = Position(33920, 31381, 15),
    ["1 St Mate Ratticus"] = Position(33920, 31383, 15)
}

local itemCreationPosition = Position(33902, 31348, 15)
local itemID = 5542
local itemDuration = 60000 -- 60 segundos em milissegundos

local ratmiralBlackwhiskersPosition = Position(33922, 31383, 15)
local ratmiralTeleportPosition = Position(33905, 31351, 14)

local groupTeleportPosition = Position(33905, 31351, 14)

local misterCatkillerSpawnPosition = Position(33905, 31347, 15) -- Posição de criação de Mister Catkiller

-- IDs de storage únicos para cada criatura (pode escolher qualquer número livre e diferente para cada)
local storages = {
    ["Rateye Ric"] = 65134,
    ["Mister Catkiller"] = 65135,
    ["1 St Mate Ratticus"] = 65136,
    ["Ratmiral Blackwhiskers"] = 65137
}

function creatureThinkEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local creatureName = creature:getName()

    if creature and teleportPositions[creatureName] then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()

        -- Usa storage ao invés da tabela global!
        if currentHealth <= maxHealth * 0.50 and creature:getStorageValue(storages[creatureName]) ~= 1 then
            -- Faz a criatura falar a mensagem "RATREAT!" em laranja
            creature:say("RATREAT!", TALKTYPE_MONSTER_SAY, false, creature, creature:getPosition())
            
            -- Teleporta a criatura para a posição específica
            local teleportPosition = teleportPositions[creatureName]
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            
            -- Se a criatura for "Rateye Ric", cria "Mister Catkiller" em uma posição específica
            if creatureName == "Rateye Ric" then
                Game.createMonster("Mister Catkiller", misterCatkillerSpawnPosition)
                misterCatkillerSpawnPosition:sendMagicEffect(CONST_ME_TELEPORT)
            end

            -- Se a criatura for "Mister Catkiller", cria o item e o remove após 60 segundos
            if creatureName == "Mister Catkiller" then
                local createdItem = Game.createItem(itemID, 1, itemCreationPosition)
                if createdItem then
                    addEvent(function()
                        local item = Tile(itemCreationPosition):getItemById(itemID)
                        if item then
                            item:remove()
                        end
                    end, itemDuration)
                end
            end

            -- Se a criatura for "1 St Mate Ratticus", teleporta "Ratmiral Blackwhiskers"
            if creatureName == "1 St Mate Ratticus" then
                local ratmiral = Tile(ratmiralBlackwhiskersPosition):getTopCreature()
                if ratmiral and ratmiral:getName() == "Ratmiral Blackwhiskers" then
                    ratmiral:teleportTo(ratmiralTeleportPosition)
                    ratmiralTeleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
                end
            end

            creature:setStorageValue(storages[creatureName], 1)
        end
    end

    -- Verifica se Ratmiral Blackwhiskers está com 50% de vida
    if creatureName == "Ratmiral Blackwhiskers" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()

        if currentHealth <= maxHealth * 0.50 and creature:getStorageValue(storages["Ratmiral Blackwhiskers"]) ~= 1 then
            -- Teleporta Rateye Ric, Mister Catkiller e 1 St Mate Ratticus para a posição de grupo
            for name, pos in pairs(teleportPositions) do
                local minion = Tile(pos):getTopCreature()
                if minion and minion:getName() == name then
                    minion:teleportTo(groupTeleportPosition)
                    groupTeleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
                end
            end

            creature:setStorageValue(storages["Ratmiral Blackwhiskers"], 1)
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureThinkEvent:register()
