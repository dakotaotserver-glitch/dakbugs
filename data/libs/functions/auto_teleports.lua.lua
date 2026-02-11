-- ========================================
-- SISTEMA DE TELEPORTES AUTOMÁTICOS
-- ========================================

-- Configuração dos teleportes
local teleportList = {
    { from = Position(17109, 17120, 4), to = Position(17114, 17120, 4) },
    -- Adicione mais teleportes aqui seguindo o mesmo padrão:
    -- { from = Position(x, y, z), to = Position(destX, destY, destZ) },
}

-- Armazena os destinos dos teleportes
local teleportDestinations = {}

-- Event de inicialização do servidor
local teleportStartup = GlobalEvent("teleportStartup")
function teleportStartup.onStartup()
    print("Iniciando sistema de teleportes automáticos...")
    
    -- Conta quantos teleportes temos
    local teleportCount = 0
    for _ in pairs(teleportList) do
        teleportCount = teleportCount + 1
    end
    
    print("Carregando " .. teleportCount .. " teleportes...")
    
    -- Cria cada teleporte
    for index, teleportData in ipairs(teleportList) do
        local fromPos = teleportData.from
        local toPos = teleportData.to
        
        -- Verifica se o tile existe
        local tile = Tile(fromPos)
        if tile then
            -- Remove teleporte existente se houver
            local existingItem = tile:getItemById(1949)
            if existingItem then
                existingItem:remove()
            end
            
            -- Cria novo teleporte
            local teleportItem = Game.createItem(1949, 1, fromPos)
            if teleportItem then
                local actionId = 45000 + index
                teleportItem:setAttribute(ITEM_ATTRIBUTE_ACTIONID, actionId)
                teleportDestinations[actionId] = toPos
                
                print("✓ Teleporte " .. index .. " criado: " .. fromPos:toString() .. " → " .. toPos:toString() .. " (AID: " .. actionId .. ")")
            else
                print("✗ Erro ao criar teleporte " .. index .. " na posição: " .. fromPos:toString())
            end
        else
            print("✗ Tile inválido para teleporte " .. index .. ": " .. fromPos:toString())
        end
    end
    
    print("Sistema de teleportes inicializado com sucesso!")
    return true
end
teleportStartup:register()

-- Event de movimento (quando jogador pisa no teleporte)
local teleportMove = MoveEvent()
function teleportMove.onStepIn(creature, item, position, fromPosition)
    -- Verifica se é um jogador
    local player = creature:getPlayer()
    if not player then
        return true
    end
    
    -- Obtém o action ID do item
    local aid = item:getActionId()
    
    -- Busca o destino
    local destination = teleportDestinations[aid]
    if destination then
        -- Teleporta o jogador
        player:teleportTo(destination)
        destination:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você foi teleportado!")
    end
    
    return true
end

-- Registra os action IDs dos teleportes
local teleportCount = 0
for _ in pairs(teleportList) do
    teleportCount = teleportCount + 1
end

for i = 1, teleportCount do
    teleportMove:aid(45000 + i)
end
teleportMove:register()