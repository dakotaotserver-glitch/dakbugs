local healOnApproach = CreatureEvent("lavahole")
local healCooldown = 2000 -- tempo em milissegundos (2 segundos)
local lastHeal = {} -- tabela para armazenar o tempo da última cura por criatura

-- Definição do padrão de efeito da área
local areaEffectPositions = {
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0},
}

function healOnApproach.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= "lavahole" then
        return true
    end

    local currentTime = os.time() * 1000 -- tempo atual em milissegundos
    local creatureId = creature:getId()

    if not lastHeal[creatureId] then
        lastHeal[creatureId] = 0 -- inicializa o tempo da última cura se não existir
    end

    if currentTime - lastHeal[creatureId] < healCooldown then
        return true -- se o cooldown não passou ainda, não faz nada
    end

    lastHeal[creatureId] = currentTime -- atualiza o tempo da última cura

    local spectators = Game.getSpectators(creature:getPosition(), false, false, 2, 2, 2, 2)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() then
            local name = spectator:getName():lower()
            if name == "gnomish explorer" or name == "gnomish explore" then
                local healAmount = math.random(-200, -500) -- gera um dano entre 200 e 500 pontos de vida
                spectator:addHealth(healAmount)
                spectator:getPosition():sendMagicEffect(CONST_ME_HITBYFIRE)

                -- Cria o efeito com base no padrão definido em areaEffectPositions
                local generatorPosition = creature:getPosition()
                local centerX = math.floor(#areaEffectPositions / 2) + 1
                local centerY = math.floor(#areaEffectPositions[1] / 2) + 1

                for x = 1, #areaEffectPositions do
                    for y = 1, #areaEffectPositions[x] do
                        if areaEffectPositions[x][y] > 0 then
                            local effectPosition = Position(
                                generatorPosition.x + (x - centerX),
                                generatorPosition.y + (y - centerY),
                                generatorPosition.z
                            )
                            effectPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
                        end
                    end
                end
            end
        end
    end

    return true
end

healOnApproach:register()
