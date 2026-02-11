local storageId = 65079
local actionIds = {33090, 33091, 33092, 33093, 33094, 33095} -- Lista de Action IDs válidos
local storageIdBase = 65080 -- Storage base para rastrear o uso de cada Action ID
local positionWithStorage = Position(32973, 32362, 15) -- Posição para quem tem a storage 65079
local actionId = 33096 -- Action ID que será verificado ao usar o item

local teleportAction = Action()

-- Função para resetar as storages dos Action IDs
local function resetPlayerStorages(player)
    if player and player:isPlayer() then
        -- Reseta as storages de todos os itens usados (33090 a 33095)
        for _, actionId in ipairs(actionIds) do
            player:setStorageValue(storageIdBase + actionId, -1)
        end
        player:setStorageValue(storageId, -1) -- Reseta a storage de recompensa (65079)
    end
end

function teleportAction.onUse(player, item, fromPosition, target, toPosition)
    if item:getActionId() == actionId then
        -- Verifica se o jogador tem a storage 65079
        if player:getStorageValue(storageId) == 1 then
            -- Teleporta o jogador para a posição 32973, 32362, 15
            player:teleportTo(positionWithStorage)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            
            -- Reseta a storage 65079 e os Action IDs sem esperar o tempo de reset
            resetPlayerStorages(player)
        else
            -- Mensagem clara ao jogador
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nivel de Contaminacao Insuficiente, Clique nos pilares de caveira para se contaminar")
        end
        return true
    end
    return false
end

teleportAction:aid(actionId) -- Registra o Action ID 33096
teleportAction:register()
