local teleportToItem = TalkAction("/gotoitem")

function teleportToItem.onSay(player, words, param)
    -- Verificar se o jogador tem permissão
    if not player:getGroup():getAccess() then
        return true
    end

    -- Criar log do comando
    logCommand(player, words, param)

    -- Verificar se o parâmetro foi fornecido
    if param == "" then
        player:sendCancelMessage("Uso correto: /gotoitem [ID do item]")
        return true
    end

    -- Converter o parâmetro para número
    local itemId = tonumber(param)
    if not itemId then
        player:sendCancelMessage("ID do item inválido. Use apenas números.")
        return true
    end

    -- Verificar se o ItemType existe
    local itemType = ItemType(itemId)
    if itemType:getId() == 0 then
        player:sendCancelMessage("Item com ID " .. itemId .. " não existe.")
        return true
    end

    -- Informar ao jogador que a busca começou
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Procurando pelo item com ID " .. itemId .. " no mapa...")

    -- Posição atual do jogador para iniciar a busca
    local playerPos = player:getPosition()
    local startX = math.max(0, playerPos.x - 50)
    local startY = math.max(0, playerPos.y - 50)
    local endX = playerPos.x + 50
    local endY = playerPos.y + 50
    local foundItem = false
    local itemPosition = Position(0, 0, 0)

    -- Buscar o item em uma área ao redor do jogador
    for z = 0, 15 do -- Verificar todos os andares
        for x = startX, endX do
            for y = startY, endY do
                local position = Position(x, y, z)
                local tile = Tile(position)
                
                if tile then
                    -- Verificar itens no tile
                    for i = 0, tile:getItemCount() - 1 do
                        local item = tile:getItemByIndex(i)
                        if item and item:getId() == itemId then
                            foundItem = true
                            itemPosition = position
                            break
                        end
                    end
                    
                    if foundItem then
                        break
                    end
                end
            end
            
            if foundItem then
                break
            end
        end
        
        if foundItem then
            break
        end
    end

    -- Se o item foi encontrado, teleportar o jogador
    if foundItem then
        player:teleportTo(itemPosition)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você foi teleportado para o item com ID " .. itemId .. ".")
    else
        -- Se não encontrou na área próxima, tentar uma busca mais ampla
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item não encontrado na área próxima. Iniciando busca ampliada...")
        
        -- Busca ampliada (pode ser pesada para o servidor)
        local found = false
        
        -- Verificar áreas conhecidas do mapa (ajuste conforme seu mapa)
        local knownAreas = {
            {minX = 0, maxX = 1000, minY = 0, maxY = 1000, minZ = 0, maxZ = 15},
            {minX = 1000, maxX = 2000, minY = 0, maxY = 1000, minZ = 0, maxZ = 15},
            {minX = 0, maxX = 1000, minY = 1000, maxY = 2000, minZ = 0, maxZ = 15},
            {minX = 1000, maxX = 2000, minY = 1000, maxY = 2000, minZ = 0, maxZ = 15}
        }
        
        for _, area in ipairs(knownAreas) do
            for z = area.minZ, area.maxZ do
                for x = area.minX, area.maxX, 10 do -- Pular de 10 em 10 para otimizar
                    for y = area.minY, area.maxY, 10 do
                        local position = Position(x, y, z)
                        local tile = Tile(position)
                        
                        if tile then
                            -- Verificar itens no tile
                            for i = 0, tile:getItemCount() - 1 do
                                local item = tile:getItemByIndex(i)
                                if item and item:getId() == itemId then
                                    found = true
                                    itemPosition = position
                                    break
                                end
                            end
                            
                            if found then
                                break
                            end
                        end
                    end
                    
                    if found then
                        break
                    end
                end
                
                if found then
                    break
                end
            end
            
            if found then
                break
            end
        end
        
        if found then
            player:teleportTo(itemPosition)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Você foi teleportado para o item com ID " .. itemId .. ".")
        else
            player:sendCancelMessage("Item com ID " .. itemId .. " não foi encontrado no mapa.")
        end
    end
    
    return true
end

teleportToItem:separator(" ")
teleportToItem:groupType("god")
teleportToItem:register()
