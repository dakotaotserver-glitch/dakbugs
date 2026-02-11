local stolenTomeDeath = CreatureEvent("StolenTomeDeath")

-- Definir a posição onde o item será criado
local itemPosition = Position(32687, 32714, 10)

function stolenTomeDeath.onDeath(creature)
    if creature:getName() == "Stolen Tome of Portals" then
        -- Criar o item com ID 1949 na posição especificada
        local teleportItem = Game.createItem(1949, 1, itemPosition)

        if teleportItem then
            -- Atribuir o action ID 33026 ao item criado
            teleportItem:setActionId(33026)
            
            -- Agendar a remoção do item após 10 segundos (10000 ms)
            addEvent(function()
                local item = Tile(itemPosition):getItemById(1949)
                if item then
                    item:remove()
                end
            end, 10000)
        end
    end
    return true
end

stolenTomeDeath:register()


