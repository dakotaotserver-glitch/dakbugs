local snailEffect = CreatureEvent("SnailEffect")
local checkInterval = 3000 -- Intervalo de verificação em milissegundos (2 segundos)
local effectCooldown = 3000 -- Cooldown de 2 segundos
local lastCheck = {} -- Tabela para armazenar o tempo do último check por criatura
local lastEffect = {} -- Tabela para armazenar o tempo do último efeito por criatura

function snailEffect.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= "snail slime" then
        return true
    end

    local currentTime = os.time() * 1000 -- Tempo atual em milissegundos
    local creatureId = creature:getId()

    if not lastCheck[creatureId] then
        lastCheck[creatureId] = 0 -- Inicializa o tempo do último check se não existir
    end

    if not lastEffect[creatureId] then
        lastEffect[creatureId] = 0 -- Inicializa o tempo do último efeito se não existir
    end

    if currentTime - lastCheck[creatureId] < checkInterval then
        return true -- Se ainda não passou o intervalo de verificação, não faz nada
    end

    lastCheck[creatureId] = currentTime -- Atualiza o tempo do último check

    local position = creature:getPosition()
    local spectators = Game.getSpectators(position, false, false, 1, 1, 1, 1)

    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and spectator:getName():lower() == "the count of the core" then
            -- Verifica se o cooldown para o efeito já passou
            if currentTime - lastEffect[creatureId] >= effectCooldown then
                -- Cria o efeito de fogo em área 2x2 na posição da criatura Snail Slime
                for x = -1, 1 do
                    for y = -1, 1 do
                        local targetPos = Position(position.x + x, position.y + y, position.z)
                        targetPos:sendMagicEffect(CONST_ME_HITBYFIRE)
                    end
                end

                -- Cura "The Count of the Core" com uma quantidade aleatória entre 0 e 2000 pontos de vida
                local healAmount = math.random(0, 2000)
                spectator:addHealth(healAmount)

                -- Atualiza o tempo do último efeito
                lastEffect[creatureId] = currentTime
            end
            break
        end
    end

    return true
end

snailEffect:register()
