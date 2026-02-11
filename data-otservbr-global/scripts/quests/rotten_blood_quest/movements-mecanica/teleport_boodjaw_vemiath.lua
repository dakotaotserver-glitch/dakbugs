local function isChagorzInArea()
    local fromPosition = Position(33032, 32325, 15)
    local toPosition = Position(33056, 32346, 15)

    local spectators = Game.getSpectators(fromPosition, false, false, 22, 22, 20, 20)
    for _, spectator in pairs(spectators) do
        if spectator:isMonster() and spectator:getName() == "Vemiath" then
            return true
        end
    end
    return false
end

local function countElderBloodjawInArea()
    local fromPosition = Position(33032, 32325, 15)
    local toPosition = Position(33056, 32346, 15)
    local elderBloodjawCount = 0

    local creatures = Game.getSpectators(fromPosition, false, false, 22, 22, 20, 20)
    for _, creature in pairs(creatures) do
        if creature:isMonster() and creature:getName() == "Elder Bloodjaw" then
            elderBloodjawCount = elderBloodjawCount + 1
        end
    end

    return elderBloodjawCount
end

local function damagePlayersInAreaIfElderBloodjawPresent()
    local fromPosition = Position(33032, 32325, 15)
    local toPosition = Position(33056, 32346, 15)
    
    if countElderBloodjawInArea() == 2 then
        local players = Game.getSpectators(fromPosition, true, false, 22, 22, 20, 20) -- Obter apenas jogadores
        for _, player in pairs(players) do
            if player:isPlayer() then
                local totalHealth = player:getHealth()
                local damage = totalHealth * 0.4 -- 40% do total de vida
                player:addHealth(-damage, COMBAT_AGONYDAMAGE) -- Aplica o dano
            end
        end
    end
end

local function removeItem(itemPosition)
    local item = Tile(itemPosition):getItemById(44049)
    if item then
        item:remove()
    end
end

local function createItemLoop()
    if isChagorzInArea() then
        local itemPosition = Position(33043, 32335, 15)
        local item = Game.createItem(44049, 1, itemPosition)
        if item then
            item:setActionId(33124)
        end

        -- Após 15 segundos, verifica se existem 2 Elder Bloodjaw e aplica o dano
        addEvent(damagePlayersInAreaIfElderBloodjawPresent, 15000)

        -- Remove o item após 20 segundos
        addEvent(function() removeItem(itemPosition) end, 15000)

        -- Repete o ciclo após 1 minuto e 30 segundos
        addEvent(createItemLoop, 110000)
    else
        -- Se Chagorz não estiver na área, verifica novamente após 1 minuto e 30 segundos
        addEvent(createItemLoop, 110000)
    end
end

-- Inicia o ciclo pela primeira vez
createItemLoop()
