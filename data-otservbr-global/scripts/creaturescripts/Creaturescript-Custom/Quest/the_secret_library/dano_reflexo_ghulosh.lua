local healOnApproach = CreatureEvent("ghuloshreflexo")
local healCooldown = 3000 -- tempo em milissegundos (3 segundos)
local lastHeal = {} -- tabela para armazenar o tempo do último heal por criatura
local ghuloshPosition = nil -- variável para armazenar a posição de "ghulosh' deathgaze"

function healOnApproach.onThink(creature)
    -- Verifica se a criatura é "Concentrated Death"
    if not creature:isMonster() or creature:getName():lower() ~= "concentrated death" then
        return true
    end

    local currentTime = os.time() * 1000 -- tempo atual em milissegundos
    local creatureId = creature:getId()

    if not lastHeal[creatureId] then
        lastHeal[creatureId] = 0 -- inicializa o tempo do último heal se não existir
    end

    if currentTime - lastHeal[creatureId] < healCooldown then
        return true -- se ainda não passou o cooldown, não faz nada
    end

    lastHeal[creatureId] = currentTime -- atualiza o tempo do último heal

    local position = creature:getPosition()
    local spectators = Game.getSpectators(position, false, false, 1, 1, 1, 1)

    -- Atualiza a posição de "ghulosh' deathgaze" se a criatura for encontrada
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and spectator:getName():lower() == "ghulosh' deathgaze" then
            ghuloshPosition = spectator:getPosition()
            break
        end
    end

    -- Se a posição de "ghulosh' deathgaze" foi encontrada, aplica o efeito de morte em área
    if ghuloshPosition then
        for _, spectator in ipairs(spectators) do
            if spectator:isMonster() and spectator:getName():lower() == "ghulosh' deathgaze" then
                spectator:addHealth(-7500)
                ghuloshPosition:sendMagicEffect(CONST_ME_MORTAREA)

                -- Aplica o efeito de morte em área 2x2 na posição de "ghulosh' deathgaze"
                for x = -1, 1 do
                    for y = -1, 1 do
                        local targetPos = Position(ghuloshPosition.x + x, ghuloshPosition.y + y, ghuloshPosition.z)
                        targetPos:sendMagicEffect(CONST_ME_MORTAREA)
                    end
                end

                -- Aplica o dano à criatura "Concentrated Death"
                local concentrationPos = creature:getPosition()
                local creatures = Game.getSpectators(concentrationPos, false, false, 10, 10, 10, 10) -- Ajuste o alcance se necessário
                for _, monster in ipairs(creatures) do
                    if monster:isMonster() and monster:getName():lower() == "concentrated death" then
                        monster:addHealth(-1000)
                        break
                    end
                end
            end
        end
    end

    return true
end

healOnApproach:register()

