local healOnApproachi = CreatureEvent("HealOnApproachi")
local healCooldown = 3000 -- tempo em milissegundos (2 segundos)
local lastHeal = {} -- tabela para armazenar o tempo do último heal por criatura

function healOnApproachi.onThink(creature, item, position, fromPosition)
    if not creature:isMonster() or (creature:getName():lower() ~= "biting cold" and creature:getName():lower() ~= "brother chill" and creature:getName():lower() ~= "brother freeze") then
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

    local spectators = Game.getSpectators(creature:getPosition(), false, false, 1, 1, 1, 1)
    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() and (spectator:getName():lower() == "brother chill" or spectator:getName():lower() == "brother freeze") then
            spectator:addHealth(2000)
            spectator:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    return true
end

healOnApproachi:register()
