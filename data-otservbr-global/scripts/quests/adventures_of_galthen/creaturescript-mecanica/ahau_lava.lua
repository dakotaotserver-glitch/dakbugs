local ahauThink = CreatureEvent("AhauThink")

-- Posições onde os itens ID 39195 serão criados a 90% de vida
local positions90 = {
    Position(34003, 31696, 10),
    Position(34003, 31697, 10),
    Position(34003, 31698, 10),
    Position(34003, 31699, 10),
    Position(34003, 31700, 10),
    Position(34014, 31696, 10),
    Position(34014, 31697, 10),
    Position(34014, 31698, 10),
    Position(34014, 31699, 10),
    Position(34014, 31700, 10),
}

-- Posições onde os itens serão criados a 40% de vida
local positions40 = {
    Position(34003, 31701, 10),
    Position(34001, 31702, 10),
    Position(34002, 31702, 10),
    Position(34003, 31702, 10),
    Position(34004, 31702, 10),
    Position(34001, 31703, 10),
    Position(34002, 31703, 10),
    Position(34003, 31703, 10),
    Position(34004, 31703, 10),
    Position(34001, 31704, 10),
    Position(34002, 31704, 10),
    Position(34003, 31704, 10),
    Position(34004, 31704, 10),
    Position(34014, 31701, 10),
    Position(34012, 31702, 10),
    Position(34013, 31702, 10),
    Position(34014, 31702, 10),
    Position(34015, 31702, 10),
    Position(34012, 31703, 10),
    Position(34013, 31703, 10),
    Position(34014, 31703, 10),
    Position(34015, 31703, 10),
    Position(34012, 31704, 10),
    Position(34013, 31704, 10),
    Position(34014, 31704, 10),
    Position(34015, 31704, 10),
    Position(34013, 31699, 10),
}

-- Posições e itens adicionais a serem criados a 90% de vida
local additionalItems90 = {
    {itemId = 14101, positions = {
        Position(34002, 31696, 10),
        Position(34002, 31697, 10),
        Position(34002, 31698, 10),
        Position(34002, 31699, 10),
        Position(34002, 31700, 10),
        Position(34013, 31696, 10),
        Position(34013, 31697, 10),
        Position(34013, 31698, 10),
        Position(34013, 31699, 10),
        Position(34013, 31700, 10),
    }},
    {itemId = 14103, positions = {
        Position(34004, 31696, 10),
        Position(34004, 31697, 10),
        Position(34004, 31698, 10),
        Position(34004, 31699, 10),
        Position(34004, 31700, 10),
        Position(34015, 31696, 10),
        Position(34015, 31697, 10),
        Position(34015, 31698, 10),
        Position(34015, 31699, 10),
        Position(34015, 31700, 10),
    }},
    {itemId = 14107, positions = {
        Position(34002, 31701, 10),
        Position(34013, 31701, 10),
    }},
    {itemId = 14100, positions = {
        Position(34003, 31701, 10),
        Position(34014, 31701, 10),
    }},
    {itemId = 14106, positions = {
        Position(34004, 31701, 10),
        Position(34015, 31701, 10),
    }},
}

-- Posições e itens adicionais a serem criados a 40% de vida
local additionalItems40 = {
    {itemId = 14101, position = Position(34002, 31701, 10)},
    {itemId = 14103, position = Position(34004, 31701, 10)},
    --{itemId = 40351, position = Position(34003, 31702, 10)},
    {itemId = 14109, position = Position(34004, 31696, 10)},
    {itemId = 14110, position = Position(34004, 31697, 10)},
    {itemId = 14105, position = Position(34005, 31696, 10)},
    {itemId = 14106, position = Position(34005, 31697, 10)},

    -- Novos itens solicitados a serem criados a 40% de vida
    {itemId = 14101, position = Position(34013, 31701, 10)},
    {itemId = 14103, position = Position(34015, 31701, 10)},
    {itemId = 14111, position = Position(34013, 31700, 10)},
    {itemId = 14101, position = Position(34012, 31699, 10)},
    {itemId = 14107, position = Position(34012, 31700, 10)},
    {itemId = 14104, position = Position(34012, 31698, 10)},
    {itemId = 14108, position = Position(34013, 31698, 10)},
}

-- Action ID e item ID que serão atribuídos aos itens criados
local actionId = 33054
local itemId = 39195

-- Variável para controlar se as mecânicas já foram executadas
local mechanicsExecuted = {
    [0.90] = false,
    [0.40] = false
}

-- Função para criar efeito de fogo em um raio de 20x20
local function createFireEffect(creaturePosition)
    local fromPosition = Position(creaturePosition.x - 10, creaturePosition.y - 10, creaturePosition.z)
    local toPosition = Position(creaturePosition.x + 10, creaturePosition.y + 10, creaturePosition.z)
    
    for x = fromPosition.x, toPosition.x do
        for y = fromPosition.y, toPosition.y do
            local position = Position(x, y, creaturePosition.z)
            position:sendMagicEffect(CONST_ME_FIREAREA)
        end
    end
end

-- Função para transformar itens específicos em outro item no momento correto
local function transformSpecificItems(at90Percent)
    local itemsToTransform = {}
    
    if at90Percent then
        itemsToTransform = {
            {oldItemId = 14100, position = Position(34003, 31696, 10), newItemId = 39195},
            {oldItemId = 14100, position = Position(34014, 31696, 10), newItemId = 39195},
        }
    else
        itemsToTransform = {
            {oldItemId = 14101, position = Position(34013, 31699, 10), newItemId = 39195},
            {oldItemId = 14100, position = Position(34014, 31701, 10), newItemId = 39195},
            {oldItemId = 14100, position = Position(34003, 31701, 10), newItemId = 39195},
        }
    end

    for _, itemData in ipairs(itemsToTransform) do
        local tile = Tile(itemData.position)
        if tile then
            local item = tile:getItemById(itemData.oldItemId)
            if item then
                item:transform(itemData.newItemId)
            end
        end
    end
end

function createItemsAtPositions(positions, itemId, actionId)
    for _, position in ipairs(positions) do
        local item = Game.createItem(itemId, 1, position)
        if item then
            if actionId then
                item:setActionId(actionId)
            end
            
            -- Agendar a remoção do item após 30 segundos (30000 ms) e criar o piso anterior
            addEvent(function()
                local existingItem = Tile(position):getItemById(itemId)
                if existingItem then
                    existingItem:remove()
                end
                -- Criar o item ID 40317 (piso anterior)
                Game.createItem(40317, 1, position)
            end, 300000)
        end
    end
end

function createAdditionalItems(itemsData)
    for _, itemData in ipairs(itemsData) do
        local tile = Tile(itemData.position)
        if tile then
            -- Remover todos os itens da posição
            for i = tile:getThingCount(), 1, -1 do
                local thing = tile:getThing(i)
                if thing and thing:isItem() then
                    thing:remove()
                end
            end
        end
        
        -- Criar o novo item
        local item = Game.createItem(itemData.itemId, 1, itemData.position)
        if item then
            -- Agendar a remoção do item após 30 segundos (30000 ms) e criar o piso anterior
            addEvent(function()
                local existingItem = Tile(itemData.position):getItemById(itemData.itemId)
                if existingItem then
                    existingItem:remove()
                end
                -- Criar o item ID 40317 (piso anterior)
                Game.createItem(40317, 1, itemData.position)
            end, 300000)
        end
    end
end

local function resetMechanicsExecuted(percentage)
    mechanicsExecuted[percentage] = false
end

function ahauThink.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName() == "Ahau" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()
        
        -- Checa se a vida da criatura está em 90% e se a ação já foi executada
        if currentHealth <= maxHealth * 0.90 and not mechanicsExecuted[0.90] then
            -- Criar o efeito de fogo em um raio de 20x20
            createFireEffect(creature:getPosition())
            
            -- Transformar itens específicos para 90% de vida
            transformSpecificItems(true)
            
            -- Criar itens nas posições especificadas
            createItemsAtPositions(positions90, itemId, actionId)
            
            -- Criar os itens adicionais a 90% de vida
            for _, itemData in ipairs(additionalItems90) do
                createItemsAtPositions(itemData.positions, itemData.itemId)
            end
            
            mechanicsExecuted[0.90] = true
            
            -- Agendar o reset da mecânica após 2 minutos (120 segundos)
            addEvent(resetMechanicsExecuted, 300000, 0.90)
        end

        -- Checa se a vida da criatura está em 40% ou menos e se a ação já foi executada
        if currentHealth <= maxHealth * 0.40 and not mechanicsExecuted[0.40] then
            -- Criar o efeito de fogo em um raio de 20x20
            createFireEffect(creature:getPosition())

            -- Transformar itens específicos para 40% de vida
            transformSpecificItems(false)

            -- Criar itens nas posições especificadas
            createItemsAtPositions(positions40, itemId, actionId)
            
            -- Criar os itens adicionais a 40% de vida
            createAdditionalItems(additionalItems40)
            
            mechanicsExecuted[0.40] = true
            
            -- Agendar o reset da mecânica após 2 minutos (120 segundos)
            addEvent(resetMechanicsExecuted, 300000, 0.40)
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

local damageOnStepIn = MoveEvent()

function damageOnStepIn.onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() and item:getActionId() == actionId then
        -- Calcular dano aleatório entre 1500 e 2150
        local damage = math.random(1500, 2150)
        
        -- Aplicar o dano ao jogador
        creature:addHealth(-damage) -- Remove vida do jogador
        
        -- Adicionar o efeito de fogo
        position:sendMagicEffect(CONST_ME_FIREAREA)
    end
    return true
end

damageOnStepIn:type("stepin")
damageOnStepIn:aid(actionId)
damageOnStepIn:register()

ahauThink:register()
