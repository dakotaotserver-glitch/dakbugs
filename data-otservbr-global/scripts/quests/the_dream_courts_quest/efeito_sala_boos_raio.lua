local positions = {
    Position(32215, 32047, 14),
    Position(32215, 32046, 14),
    Position(32215, 32048, 14),
    Position(32215, 32049, 14),
    Position(32215, 32050, 14),
    Position(32215, 32045, 14),
    Position(32214, 32045, 14),
    Position(32214, 32044, 14),
    Position(32213, 32044, 14),
    Position(32213, 32043, 14),
    Position(32212, 32043, 14),
    Position(32212, 32042, 14),
    Position(32211, 32042, 14),
    Position(32211, 32041, 14),
    Position(32210, 32041, 14),
    Position(32209, 32041, 14),
    Position(32208, 32041, 14),
    Position(32207, 32041, 14),
    Position(32206, 32041, 14),
    Position(32205, 32041, 14),
    Position(32205, 32042, 14),
    Position(32204, 32042, 14),
    Position(32204, 32043, 14),
    Position(32203, 32043, 14),
    Position(32203, 32044, 14),
    Position(32202, 32044, 14),
    Position(32202, 32045, 14),
    Position(32201, 32045, 14),
    Position(32201, 32046, 14),
    Position(32201, 32047, 14),
    Position(32201, 32048, 14),
    Position(32201, 32049, 14),
    Position(32201, 32050, 14),
    Position(32201, 32051, 14),
    Position(32202, 32051, 14),
    Position(32202, 32052, 14),
    Position(32203, 32052, 14),
    Position(32203, 32053, 14),
    Position(32204, 32053, 14),
    Position(32204, 32054, 14),
    Position(32205, 32054, 14),
    Position(32205, 32055, 14),
    Position(32206, 32055, 14),
    Position(32207, 32055, 14),
    Position(32208, 32055, 14),
    Position(32209, 32055, 14),
    Position(32210, 32055, 14),
    Position(32211, 32055, 14),
    Position(32211, 32054, 14),
    Position(32212, 32054, 14),
    Position(32212, 32053, 14),
    Position(32213, 32053, 14),
    Position(32213, 32052, 14),
    Position(32214, 32052, 14),
    Position(32214, 32051, 14),
    Position(32215, 32051, 14)
}

local lightningEffect = GlobalEvent("LightningEffect")

function lightningEffect.onThink(interval)
    -- Verificar o dia atual
    local currentDay = os.date("%A")
    
    -- Se não for terça-feira (Tuesday) ou sábado (Saturday), não faz nada
    if currentDay ~= "Wednesday" and currentDay ~= "Saturday" then
        return true
    end
 -- Aplica o efeito de raio nas posições especificadas
    for _, pos in ipairs(positions) do
        pos:sendMagicEffect(CONST_ME_ENERGYHIT)
    end
    
    return true
end

-- Define o ID de Ação
local healActionId = 33055

-- Cria um MoveEvent para quando a criatura pisa no item
local moveEvent = MoveEvent()

function moveEvent.onStepIn(creature, item, position, fromPosition)
    -- Verifica se a criatura é um monstro e se seu nome é Maxxenius
    if creature and creature:isMonster() and creature:getName():lower() == "maxxenius" then
        -- Gera uma quantidade de cura aleatória entre 2000 e 5000
        local healAmount = math.random(2000, 5000)
        
        -- Cura a criatura
        creature:addHealth(healAmount)
        
        -- Opcionalmente, envia um efeito mágico para visualizar a cura
        position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    end

    return true
end

lightningEffect:interval(3000) -- 3 segundos
lightningEffect:register()
moveEvent:type("stepin")
moveEvent:aid(healActionId)
moveEvent:register()
