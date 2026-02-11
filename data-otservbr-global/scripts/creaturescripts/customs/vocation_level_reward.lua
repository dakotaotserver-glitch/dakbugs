-- ========================================
-- SCRIPT DE RECOMPENSAS POR VOCAÇÃO - VERSÃO MELHORADA
-- ========================================
-- Autor: Análise e melhorias por Manus AI
-- Data: 2025-06-02
-- Descrição: Sistema de recompensas por nível para diferentes vocações
-- ========================================

local vocationRewards = {
    
    -- ========================================
    -- SORCERER/MASTER SORCERER (1,5)
    -- Storage Range: 41000-41099
    -- ========================================
    [{1, 5}] = {
        -- Níveis baixos - Wands progressivas
        [13] = {items = {{itemid = 3075, count = 1}}, storage = 41000, msg = "You won wand of dragonbreath for reaching level 13!"},
        [19] = {items = {{itemid = 3072, count = 1}}, storage = 41001, msg = "You won wand of decay for reaching level 19!"},
        [20] = {items = {{itemid = 3043, count = 2}}, storage = 41002, msg = "You won 20k gold for reaching level 20!"},
        [22] = {items = {{itemid = 8093, count = 1}}, storage = 41003, msg = "You won wand of draconia for reaching level 22!"},
        [26] = {items = {{itemid = 3073, count = 1}}, storage = 41004, msg = "You won wand of cosmic energy for reaching level 26!"},
        [33] = {items = {{itemid = 3071, count = 1}}, storage = 41005, msg = "You won wand of inferno for reaching level 33!"},
        [37] = {items = {{itemid = 8092, count = 1}}, storage = 41006, msg = "You won wand of starstorm for reaching level 37!"},
        [42] = {items = {{itemid = 8094, count = 1}}, storage = 41007, msg = "You won wand of voodoo for reaching level 42!"},
        
        -- Níveis intermediários - Gold rewards
        [50] = {items = {{itemid = 3043, count = 5}}, storage = 41050, msg = "You won 50k gold for reaching level 50!"},
        [60] = {items = {{itemid = 3043, count = 10}}, storage = 41060, msg = "You won 100k gold for reaching level 60!"},
        
        -- Níveis altos - Sage Gems
        [70] = {items = {{itemid = 44608, count = 1}}, storage = 41008, msg = "You won lesser sage gem for reaching level 70!"},
        [100] = {items = {{itemid = 44609, count = 1}, {itemid = 3043, count = 10}}, storage = 41009, msg = "You won sage gem and 100k gold for reaching level 100!"},
        [130] = {items = {{itemid = 44610, count = 1}}, storage = 41010, msg = "You won greater sage gem for reaching level 130!"},
        [170] = {items = {{itemid = 44608, count = 1}}, storage = 41011, msg = "You won lesser sage gem for reaching level 170!"},
        [200] = {items = {{itemid = 44609, count = 1}}, storage = 41012, msg = "You won sage gem for reaching level 200!"},
        [230] = {items = {{itemid = 44610, count = 1}}, storage = 41013, msg = "You won greater sage gem for reaching level 230!"},
        [270] = {items = {{itemid = 44608, count = 1}}, storage = 41014, msg = "You won lesser sage gem for reaching level 270!"},
        [300] = {items = {{itemid = 44609, count = 1}}, storage = 41015, msg = "You won sage gem for reaching level 300!"},
        [330] = {items = {{itemid = 44610, count = 1}}, storage = 41016, msg = "You won greater sage gem for reaching level 330!"}
    },
    
    -- ========================================
    -- DRUID/ELDER DRUID (2,6)
    -- Storage Range: 41100-41199
    -- ========================================
    [{2, 6}] = {
        -- Níveis baixos - Rods progressivas
        [13] = {items = {{itemid = 3070, count = 1}}, storage = 41100, msg = "You won moonlight rod for reaching level 13!"},
        [19] = {items = {{itemid = 3069, count = 1}}, storage = 41101, msg = "You won necrotic rod for reaching level 19!"},
        [20] = {items = {{itemid = 3043, count = 2}}, storage = 41102, msg = "You won 20k gold for reaching level 20!"},
        [22] = {items = {{itemid = 8083, count = 1}}, storage = 41103, msg = "You won northwind rod for reaching level 22!"},
        [26] = {items = {{itemid = 3065, count = 1}}, storage = 41104, msg = "You won terra rod for reaching level 26!"},
        [33] = {items = {{itemid = 3067, count = 1}}, storage = 41105, msg = "You won hailstorm rod for reaching level 33!"},
        [37] = {items = {{itemid = 8084, count = 1}}, storage = 41106, msg = "You won springsprout rod for reaching level 37!"},
        [42] = {items = {{itemid = 8082, count = 1}}, storage = 41107, msg = "You won underworld rod for reaching level 42!"},
        
        -- Níveis intermediários - Gold rewards
        [50] = {items = {{itemid = 3043, count = 5}}, storage = 41150, msg = "You won 50k gold for reaching level 50!"},
        [60] = {items = {{itemid = 3043, count = 10}}, storage = 41160, msg = "You won 100k gold for reaching level 60!"},
        
        -- Níveis altos - Mystic Gems
        [70] = {items = {{itemid = 44611, count = 1}}, storage = 41108, msg = "You won lesser mystic gem for reaching level 70!"},
        [100] = {items = {{itemid = 44612, count = 1}, {itemid = 3043, count = 10}}, storage = 41109, msg = "You won mystic gem and 100k gold for reaching level 100!"},
        [130] = {items = {{itemid = 44613, count = 1}}, storage = 41110, msg = "You won greater mystic gem for reaching level 130!"},
        [170] = {items = {{itemid = 44611, count = 1}}, storage = 41111, msg = "You won lesser mystic gem for reaching level 170!"},
        [200] = {items = {{itemid = 44612, count = 1}}, storage = 41112, msg = "You won mystic gem for reaching level 200!"},
        [230] = {items = {{itemid = 44613, count = 1}}, storage = 41113, msg = "You won greater mystic gem for reaching level 230!"},
        [270] = {items = {{itemid = 44611, count = 1}}, storage = 41114, msg = "You won lesser mystic gem for reaching level 270!"},
        [300] = {items = {{itemid = 44612, count = 1}}, storage = 41115, msg = "You won mystic gem for reaching level 300!"},
        [330] = {items = {{itemid = 44613, count = 1}}, storage = 41116, msg = "You won greater mystic gem for reaching level 330!"}
    },
    
    -- ========================================
    -- PALADIN/ROYAL PALADIN (3,7)
    -- Storage Range: 41200-41299
    -- ========================================
    [{3, 7}] = {
        -- Níveis baixos - Armas de distância e equipamentos
        [13] = {items = {{itemid = 3350, count = 1}, {itemid = 3447, count = 300}}, storage = 41200, msg = "You won bow and 200 Arrows for reaching level 13!"},
        [20] = {items = {{itemid = 3043, count = 2}}, storage = 41202, msg = "You won 20k gold for reaching level 20!"},
        
        -- Níveis intermediários - Gold rewards
        [50] = {items = {{itemid = 3043, count = 8}, {itemid = 8027, count = 1}}, storage = 41250, msg = "You won 50k gold for reaching level 50!"},
        [60] = {items = {{itemid = 3043, count = 10}}, storage = 41260, msg = "You won 100k gold for reaching level 60!"},
        
        -- Níveis altos - Marksman Gems
        [70] = {items = {{itemid = 44605, count = 1}}, storage = 41208, msg = "You won lesser marksman gem for reaching level 70!"},
        [100] = {items = {{itemid = 44606, count = 1}, {itemid = 3043, count = 10}}, storage = 41209, msg = "You won marksman gem and 100k gold for reaching level 100!"},
        [130] = {items = {{itemid = 44607, count = 1}}, storage = 41210, msg = "You won greater marksman gem for reaching level 130!"},
        [170] = {items = {{itemid = 44605, count = 1}}, storage = 41211, msg = "You won lesser marksman gem for reaching level 170!"},
        [200] = {items = {{itemid = 44606, count = 1}}, storage = 41212, msg = "You won marksman gem for reaching level 200!"},
        [230] = {items = {{itemid = 44607, count = 1}}, storage = 41213, msg = "You won greater marksman gem for reaching level 230!"},
        [270] = {items = {{itemid = 44605, count = 1}}, storage = 41214, msg = "You won lesser marksman gem for reaching level 270!"},
        [300] = {items = {{itemid = 44606, count = 1}}, storage = 41215, msg = "You won marksman gem for reaching level 300!"},
        [330] = {items = {{itemid = 44607, count = 1}}, storage = 41216, msg = "You won greater marksman gem for reaching level 330!"}
    },
    
    -- ========================================
    -- KNIGHT/ELITE KNIGHT (4,8)
    -- Storage Range: 41300-41399
    -- ========================================
    [{4, 8}] = {
        -- Níveis baixos - Armas corpo a corpo e equipamentos
        [20] = {items = {{itemid = 3043, count = 2}}, storage = 41302, msg = "You won 20k gold for reaching level 20!"},
        
        -- Níveis intermediários - Gold rewards
        [50] = {items = {{itemid = 3043, count = 8}}, storage = 41350, msg = "You won 80k gold for reaching level 50!"},
        [60] = {items = {{itemid = 3043, count = 10}}, storage = 41360, msg = "You won 100k gold for reaching level 60!"},
        
        -- Níveis altos - Guardian Gems
        [70] = {items = {{itemid = 44602, count = 1}}, storage = 41308, msg = "You won lesser guardian gem for reaching level 70!"},
        [100] = {items = {{itemid = 44603, count = 1}, {itemid = 3043, count = 10}}, storage = 41309, msg = "You won guardian gem and 100k gold for reaching level 100!"},
        [130] = {items = {{itemid = 44604, count = 1}}, storage = 41310, msg = "You won greater guardian gem for reaching level 130!"},
        [170] = {items = {{itemid = 44602, count = 1}}, storage = 41311, msg = "You won lesser guardian gem for reaching level 170!"},
        [200] = {items = {{itemid = 44603, count = 1}}, storage = 41312, msg = "You won guardian gem for reaching level 200!"},
        [230] = {items = {{itemid = 44604, count = 1}}, storage = 41313, msg = "You won greater guardian gem for reaching level 230!"},
        [270] = {items = {{itemid = 44602, count = 1}}, storage = 41314, msg = "You won lesser guardian gem for reaching level 270!"},
        [300] = {items = {{itemid = 44603, count = 1}}, storage = 41315, msg = "You won guardian gem for reaching level 300!"},
        [330] = {items = {{itemid = 44604, count = 1}}, storage = 41316, msg = "You won greater guardian gem for reaching level 330!"}
    },
    
    -- ========================================
    -- VOCAÇÃO CUSTOMIZADA (9,10)
    -- Storage Range: 41400-41499
    -- ========================================
    [{9, 10}] = {
        -- Níveis baixos - Equipamentos únicos (customize conforme necessário)
        [20] = {items = {{itemid = 3043, count = 2}}, storage = 41402, msg = "You won 20k gold for reaching level 20!"},

        
        -- Níveis intermediários - Gold rewards
        [50] = {items = {{itemid = 3043, count = 8}}, storage = 41450, msg = "You won 50k gold for reaching level 50!"},
        [60] = {items = {{itemid = 3043, count = 10}}, storage = 41460, msg = "You won 100k gold for reaching level 60!"},
        
        -- Níveis altos - Gems customizadas (ajuste conforme necessário)
        [70] = {items = {{itemid = 49371, count = 1}}, storage = 41408, msg = "You won lesser custom gem for reaching level 70!"},
        [100] = {items = {{itemid = 49372, count = 1}, {itemid = 3043, count = 10}}, storage = 41409, msg = "You won custom gem and 100k gold for reaching level 100!"},
        [130] = {items = {{itemid = 49373, count = 1}}, storage = 41410, msg = "You won greater custom gem for reaching level 130!"},
        [170] = {items = {{itemid = 49371, count = 1}}, storage = 41411, msg = "You won lesser custom gem for reaching level 170!"},
        [200] = {items = {{itemid = 49372, count = 1}}, storage = 41412, msg = "You won custom gem for reaching level 200!"},
        [230] = {items = {{itemid = 49373, count = 1}}, storage = 41413, msg = "You won greater custom gem for reaching level 230!"},
        [270] = {items = {{itemid = 49371, count = 1}}, storage = 41414, msg = "You won lesser custom gem for reaching level 270!"},
        [300] = {items = {{itemid = 49372, count = 1}}, storage = 41415, msg = "You won custom gem for reaching level 300!"},
        [330] = {items = {{itemid = 49373, count = 1}}, storage = 41416, msg = "You won greater custom gem for reaching level 330!"}
    }
}

-- ========================================
-- FUNÇÕES AUXILIARES
-- ========================================

-- Função para validar se um item existe
local function isValidItem(itemid)
    local itemType = ItemType(itemid)
    return itemType and itemType:getId() ~= 0
end

-- Função para verificar se o jogador tem espaço suficiente
local function hasInventorySpace(player, items)
    local freeCapacity = player:getFreeCapacity()
    local requiredWeight = 0
    
    for i = 1, #items do
        local itemType = ItemType(items[i].itemid)
        if itemType then
            requiredWeight = requiredWeight + (itemType:getWeight() * items[i].count)
        end
    end
    
    return freeCapacity >= requiredWeight
end

-- Função para log de recompensas (opcional)
local function logReward(player, level, items, storage)
    local logFile = io.open("data/logs/vocation_rewards.log", "a")
    if logFile then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local itemList = {}
        for i = 1, #items do
            table.insert(itemList, string.format("%dx%d", items[i].count, items[i].itemid))
        end
        
        logFile:write(string.format("[%s] Player: %s, Level: %d, Vocation: %d, Items: %s, Storage: %d\n",
                     timestamp, player:getName(), level, player:getVocation():getId(), 
                     table.concat(itemList, ", "), storage))
        logFile:close()
    end
end

-- ========================================
-- EVENTO PRINCIPAL
-- ========================================

local rewardLevel = CreatureEvent("RewardLevel")

function rewardLevel.onAdvance(player, skill, oldLevel, newLevel)
    -- Verifica se é avanço de nível
    if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
        return true
    end

    local playerVocation = player:getVocation():getId()
    
    -- Processa apenas a vocação do jogador
    for voc, rewards in pairs(vocationRewards) do
        if isInArray(voc, playerVocation) then
            -- Verifica se existe recompensa para o nível exato
            if rewards[newLevel] then
                local reward = rewards[newLevel]
                
                -- Verifica se já recebeu a recompensa
                if player:getStorageValue(reward.storage) == 1 then
                    break -- Já recebeu, não faz nada
                end
                
                -- Verifica se tem espaço no inventário
                if not hasInventorySpace(player, reward.items) then
                    player:sendTextMessage(MESSAGE_STATUS_WARNING, "You don't have enough capacity to receive your level reward!")
                    break
                end
                
                -- Adiciona todos os itens da recompensa
                local itemsAdded = true
                for i = 1, #reward.items do
                    local item = reward.items[i]
                    
                    -- Valida o item antes de adicionar
                    if not isValidItem(item.itemid) then
                        print(string.format("Warning: Invalid item ID %d for player %s at level %d", 
                              item.itemid, player:getName(), newLevel))
                        itemsAdded = false
                        break
                    end
                    
                    -- Adiciona o item
                    if not player:addItem(item.itemid, item.count) then
                        print(string.format("Error: Could not add item %d (count: %d) to player %s", 
                              item.itemid, item.count, player:getName()))
                        itemsAdded = false
                        break
                    end
                end
                
                -- Se todos os itens foram adicionados com sucesso
                if itemsAdded then
                    -- Envia mensagem de sucesso
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, reward.msg)
                    
                    -- Marca como recebido
                    player:setStorageValue(reward.storage, 1)
                    
                    -- Log da recompensa (opcional)
                    logReward(player, newLevel, reward.items, reward.storage)
                    
                    -- Efeito visual (opcional)
                    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                end
            end
            
            break -- Importante: sai do loop após processar a vocação
        end
    end
    
    -- Salva o jogador
    player:save()
    return true
end

-- Registra o evento
rewardLevel:register()

