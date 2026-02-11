local unleashHexMove = MoveEvent()

local uniqueId = 33023
local newItemId = 32416
local originalItemId = 32415
local creaturePosition = Position(33443, 31542, 13)
local duration = 3 * 60 * 1000 -- 3 minutos em milissegundos
local lastActivationTime = 0 -- Variável para armazenar o último tempo de ativação

function unleashHexMove.onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() and item:getUniqueId() == uniqueId then
        local currentTime = os.time() * 1000 -- Tempo atual em milissegundos
        
        -- Verifica se o cooldown de 3 minutos já passou
        if currentTime - lastActivationTime >= duration then
            -- Atualiza o tempo de ativação
            lastActivationTime = currentTime
            
            -- Transforma o item e cria a criatura
            item:transform(newItemId)
            local unleashedHex = Game.createMonster("Unleashed Hex", creaturePosition)
            
            -- Função para reverter as mudanças após 3 minutos
            addEvent(function()
                -- Verifica se o item ainda existe e reverte
                local tile = Tile(position)
                if tile then
                    local currentItem = tile:getItemById(newItemId)
                    if currentItem and currentItem:getUniqueId() == uniqueId then
                        currentItem:transform(originalItemId)
                    end
                end
                
                -- Remove a criatura "Unleashed Hex"
                if unleashedHex then
                    local hex = Creature(unleashedHex:getId())
                    if hex then
                        hex:remove()
                    end
                end
            end, duration)
        else
            -- Opcional: Pode adicionar uma mensagem ou outro feedback para o jogador se necessário
           
        end
    end
    return true
end

unleashHexMove:type("stepin")
unleashHexMove:uid(uniqueId)
unleashHexMove:register()
