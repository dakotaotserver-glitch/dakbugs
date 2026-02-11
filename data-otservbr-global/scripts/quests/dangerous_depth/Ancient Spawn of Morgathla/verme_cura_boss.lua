local ancientSpawnStepIn = MoveEvent()

-- Define os item IDs que serão verificados
local targetItemIds = {6023, 4191, 4192}

-- Função que será executada quando a criatura "Ancient Spawn of Morgathla" passar por cima dos itens especificados
function ancientSpawnStepIn.onStepIn(creature, item, position, fromPosition)
    if not creature:isMonster() or creature:getName():lower() ~= "ancient spawn of morgathla" then
        return true
    end

    -- Verifica se o item tem um dos item IDs corretos
    if not table.contains(targetItemIds, item:getId()) then
        return true
    end

    -- Gera um valor aleatório entre 1000 e 5000 para curar a criatura
    local healAmount = math.random(1000, 5000)

    -- Cura a criatura "Ancient Spawn of Morgathla"
    creature:addHealth(healAmount)

    -- Mostra um efeito de cura na posição da criatura
    creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

    -- Exibe uma mensagem indicando a cura (opcional)
    creature:say("Ancient Spawn of Morgathla has been healed!", TALKTYPE_MONSTER_SAY)

    return true
end

-- Registra o evento de pisar nos itens
ancientSpawnStepIn:id(6023)
ancientSpawnStepIn:id(4191)
ancientSpawnStepIn:id(4192)
ancientSpawnStepIn:type("stepin")
ancientSpawnStepIn:register()
