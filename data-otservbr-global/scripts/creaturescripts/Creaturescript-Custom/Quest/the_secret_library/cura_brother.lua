local healBrothersOnProximity = CreatureEvent("HealBrothersOnProximity")
local healAmount = 10000 -- Quantidade de cura
local healRadius = 3 -- Raio de proximidade para acionar a cura
local healEffect = CONST_ME_MAGIC_BLUE -- Efeito visual da cura
local healCooldown = 2000 -- Tempo de cooldown em milissegundos (2 segundos)
local lastHeal = {} -- Tabela para armazenar o tempo do último heal por criatura

function healBrothersOnProximity.onThink(creature)
    if not creature:isMonster() then
        return true
    end

    local creatureName = creature:getName():lower()
    if creatureName ~= "brother chill" and creatureName ~= "brother freeze" then
        return true
    end

    local currentTime = os.time() * 1000 -- Tempo atual em milissegundos
    local creatureId = creature:getId()

    -- Inicializa o tempo do último heal se não existir
    if not lastHeal[creatureId] then
        lastHeal[creatureId] = 0
    end

    -- Verifica se o cooldown foi atingido
    if currentTime - lastHeal[creatureId] < healCooldown then
        return true -- Se o cooldown não foi atingido, não faz nada
    end

    -- Atualiza o tempo do último heal
    lastHeal[creatureId] = currentTime

    local position = creature:getPosition()
    local spectators = Game.getSpectators(position, false, false, healRadius, healRadius, healRadius, healRadius)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() then
            local spectatorName = spectator:getName():lower()
            if (creatureName == "brother chill" and spectatorName == "brother freeze") or 
               (creatureName == "brother freeze" and spectatorName == "brother chill") then
                creature:addHealth(healAmount)
                spectator:addHealth(healAmount)

                -- Aplica o efeito visual de cura na área de 4x4 ao redor da posição da criatura e do espectador
                local creaturePos = creature:getPosition()
                local x, y, z = creaturePos.x, creaturePos.y, creaturePos.z
                for i = -2, 1 do
                    for j = -2, 1 do
                        local pos = Position(x + i, y + j, z)
                        pos:sendMagicEffect(healEffect)
                    end
                end

                local spectatorPos = spectator:getPosition()
                local x2, y2, z2 = spectatorPos.x, spectatorPos.y, spectatorPos.z
                for i = -2, 1 do
                    for j = -2, 1 do
                        local pos = Position(x2 + i, y2 + j, z2)
                        pos:sendMagicEffect(healEffect)
                    end
                end

                break -- Para evitar curas adicionais desnecessárias na mesma iteração
            end
        end
    end

    return true
end

healBrothersOnProximity:register()
