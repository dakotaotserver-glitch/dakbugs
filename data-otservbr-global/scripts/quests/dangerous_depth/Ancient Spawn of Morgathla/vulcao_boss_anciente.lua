-- IDs dos itens e configurações
local machineID = 27471 -- ID da máquina desativada
local activeMachineID = 27467 -- ID da máquina ativada
local lavaID = 390 -- ID do buraco de lava desativado
local activatedLavaID = 391 -- ID do buraco de lava ativado

-- Tabela de área do efeito de erupção
local areaEffectPositions = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
}

-- Função para verificar o boss e ativar as máquinas
local function activateMachines()
    local boss
    local spectators = Game.getSpectators(Position(33754, 32355, 15), false, false, 70, 70, 70, 70)
    for _, creature in pairs(spectators) do
        if creature:isMonster() and creature:getName():lower() == "ancient spawn of morgathla" then
            boss = creature
            break
        end
    end

    if not boss then
        addEvent(activateMachines, 8 * 1000)
        return
    end

    local bossPosition = boss:getPosition()
    for x = bossPosition.x - 70, bossPosition.x + 70 do
        for y = bossPosition.y - 70, bossPosition.y + 70 do
            for z = bossPosition.z - 2, bossPosition.z + 2 do
                local pos = Position(x, y, z)
                local tile = Tile(pos)
                if tile then
                    local machine = tile:getItemById(machineID)
                    if machine then
                        machine:transform(activeMachineID)
                        pos:sendMagicEffect(CONST_ME_FIREATTACK)

                        local directions = {
                            {x = 0, y = 1},
                            {x = 0, y = -1},
                            {x = -1, y = 0},
                            {x = 1, y = 0}
                        }

                        local randomDirection = directions[math.random(#directions)]

                        addEvent(function()
                            for i = 1, 10 do
                                local firePos = Position(pos.x + (randomDirection.x * i), pos.y + (randomDirection.y * i), pos.z)
                                local creature = Tile(firePos) and Tile(firePos):getTopCreature()
                                firePos:sendMagicEffect(168)
                                if creature then
                                    if creature:isPlayer() then
                                        creature:addHealth(-math.random(1000, 2500))
                                    elseif creature:getName():lower() == "ancient spawn of morgathla" then
                                        creature:addHealth(math.random(1000, 2500))
                                    end
                                end
                            end
                            addEvent(function()
                                if machine then
                                    machine:transform(machineID)
                                end
                            end, 1000)
                        end, 2000)
                    end
                end
            end
        end
    end
    addEvent(activateMachines, 8 * 1000)
end

-- Função para transformar buracos de lava e causar dano em área seguindo o padrão de efeito
local function transformLavaHoles()
    local boss
    local spectators = Game.getSpectators(Position(33754, 32355, 15), false, false, 70, 70, 70, 70)
    for _, creature in pairs(spectators) do
        if creature:isMonster() and creature:getName():lower() == "ancient spawn of morgathla" then
            boss = creature
            break
        end
    end

    if not boss then
        addEvent(transformLavaHoles, 6 * 1000)
        return
    end

    local bossPosition = boss:getPosition()
    for x = bossPosition.x - 70, bossPosition.x + 70 do
        for y = bossPosition.y - 70, bossPosition.y + 70 do
            for z = bossPosition.z - 2, bossPosition.z + 2 do
                local pos = Position(x, y, z)
                local tile = Tile(pos)
                if tile then
                    local lava = tile:getItemById(lavaID)
                    if lava then
                        lava:transform(activatedLavaID)
                        pos:sendMagicEffect(CONST_ME_FIREATTACK)

                        addEvent(function()
                            local activatedLava = tile:getItemById(activatedLavaID)
                            if activatedLava then
                                -- Aplicar o padrão de efeito de erupção baseado em areaEffectPositions
                                for dx = -3, 3 do
                                    for dy = -3, 3 do
                                        local patternX = dx + 4
                                        local patternY = dy + 4
                                        if areaEffectPositions[patternX] and areaEffectPositions[patternX][patternY] == 1 then
                                            local damagePos = Position(pos.x + dx, pos.y + dy, pos.z)
                                            local target = Tile(damagePos) and Tile(damagePos):getTopCreature()
                                            if target and target:isPlayer() then
                                                target:addHealth(-math.random(1000, 2500)) -- Dano nos jogadores próximos
                                            end
                                            damagePos:sendMagicEffect(168)
                                        end
                                    end
                                end
                                addEvent(function()
                                    if activatedLava then
                                        activatedLava:transform(lavaID)
                                    end
                                end, 1000)
                            end
                        end, 3000)
                    end
                end
            end
        end
    end
    addEvent(transformLavaHoles, 6 * 1000)
end

-- Inicia a verificação quando o script é carregado
activateMachines()
transformLavaHoles()
