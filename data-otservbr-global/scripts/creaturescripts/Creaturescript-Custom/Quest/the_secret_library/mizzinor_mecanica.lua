local mazzinorThink = CreatureEvent("MazzinorThink")

-- Posições usadas no script
local teleportPosition = Position(32722, 32694, 10)
local areaFromPosition = Position(32716, 32713, 10)
local areaToPosition = Position(32732, 32728, 10)

-- Tabela para armazenar referências de Supercharged Mazzinor
local superchargedMazzinors = {}

-- Tabela para controlar os percentuais de vida já executados
local mechanicsExecuted = {
    [0.90] = false,
    [0.70] = false,
    [0.50] = false,
    [0.30] = false,
    [0.10] = false
}

local function isPositionInArea(position, fromPosition, toPosition)
    return position.x >= math.min(fromPosition.x, toPosition.x) and position.x <= math.max(fromPosition.x, toPosition.x) and
           position.y >= math.min(fromPosition.y, toPosition.y) and position.y <= math.max(fromPosition.y, toPosition.y) and
           position.z == fromPosition.z
end

local function removeSuperchargedMazzinor()
    local toRemove = {}
    for _, monster in ipairs(superchargedMazzinors) do
        local monsterPosition = monster:getPosition()
        if isPositionInArea(monsterPosition, areaFromPosition, areaToPosition) then
            monster:remove()
            table.insert(toRemove, monster)
        end
    end
    -- Remove os monstros da tabela após a iteração para evitar problemas de modificação da tabela durante a iteração
    for _, monster in ipairs(toRemove) do
        for i, m in ipairs(superchargedMazzinors) do
            if m == monster then
                table.remove(superchargedMazzinors, i)
                break
            end
        end
    end
end

local function createAndScheduleSuperchargedMazzinor(position)
    -- Cria a criatura Supercharged Mazzinor
    local monster = Game.createMonster("Supercharged Mazzinor", position)
    
    -- Adiciona a criatura criada à lista
    if monster then
        table.insert(superchargedMazzinors, monster)
        -- Define um temporizador para remover a criatura após 6 segundos
        addEvent(removeSuperchargedMazzinor, 5000) -- Ajustado para 6000 ms (6 segundos)
    end
end

function mazzinorThink.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:getName() == "Mazzinor" then
        local maxHealth = creature:getMaxHealth()
        local currentHealth = creature:getHealth()
        
        -- Checa e executa ações baseadas no percentual de vida da criatura
        if currentHealth <= maxHealth * 0.10 and not mechanicsExecuted[0.10] then
            local currentPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            createAndScheduleSuperchargedMazzinor(currentPosition)
            mechanicsExecuted[0.10] = true
        elseif currentHealth <= maxHealth * 0.30 and not mechanicsExecuted[0.30] then
            local currentPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            createAndScheduleSuperchargedMazzinor(currentPosition)
            mechanicsExecuted[0.30] = true
        elseif currentHealth <= maxHealth * 0.50 and not mechanicsExecuted[0.50] then
            local currentPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            createAndScheduleSuperchargedMazzinor(currentPosition)
            mechanicsExecuted[0.50] = true
        elseif currentHealth <= maxHealth * 0.70 and not mechanicsExecuted[0.70] then
            local currentPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            createAndScheduleSuperchargedMazzinor(currentPosition)
            mechanicsExecuted[0.70] = true
        elseif currentHealth <= maxHealth * 0.90 and not mechanicsExecuted[0.90] then
            local currentPosition = creature:getPosition()
            creature:teleportTo(teleportPosition)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            createAndScheduleSuperchargedMazzinor(currentPosition)
            mechanicsExecuted[0.90] = true
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

mazzinorThink:register()
