local hungerWormDeath = CreatureEvent("HungerWormDeath")

function hungerWormDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
    if creature:getName():lower() == "hunger worm" then
        -- Obter a posição exata onde a criatura morreu
        local deathPosition = creature:getPosition()
        local tile = Tile(deathPosition)

        if tile then
            -- Remover os itens com ID 2890 e 2889 se estiverem na posição
            local itemsToRemove = {2890, 2889, 2891}
            for _, itemId in ipairs(itemsToRemove) do
                local item = tile:getItemById(itemId)
                if item then
                    item:remove()
                end
            end
            
            -- Criar o item com ID 394 na posição da morte
            local createdItem = Game.createItem(394, 1, deathPosition)
            
            if createdItem then
                -- Atribuir o Action ID 33050 ao item criado
                createdItem:setActionId(33050)
                
                -- Agendar a remoção do item após 20 segundos (20000 ms)
                addEvent(function()
                    local item = Tile(deathPosition):getItemById(394)
                    if item then
                        item:remove()
                        
                        -- Criar o item com ID 351 na posição onde o item anterior foi removido
                        Game.createItem(351, 1, deathPosition)
                    end
                end, 20000)
            end
        end
    end
    return true
end

hungerWormDeath:register()
