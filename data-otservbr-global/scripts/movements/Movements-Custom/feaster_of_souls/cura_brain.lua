local badThoughtProximity = MoveEvent()

function badThoughtProximity.onStepIn(creature, item, position, fromPosition)
    -- Verifica se a criatura é um "Bad Thought"
    if creature:getName():lower() == "bad thought" and item:getId() == 12355 then
        -- Define a posição central específica e o raio de 3x3 tiles
        local centralPosition = Position(31954, 32325, 10)
        local radius = 1
        
        -- Verifica se a posição está dentro do raio de 3x3 tiles
        local isInRadius = math.abs(position.x - centralPosition.x) <= radius and
                           math.abs(position.y - centralPosition.y) <= radius and
                           position.z == centralPosition.z
        
        if isInRadius then
            -- Define o raio de proximidade para encontrar "Brain Head"
            local searchRadius = 5
            
            -- Encontra as criaturas próximas
            local espectadores = Game.getSpectators(position, false, false, searchRadius, searchRadius, searchRadius, searchRadius)
            for _, espectador in ipairs(espectadores) do
                if espectador:isMonster() and espectador:getName():lower() == "brain head" then
                    -- Cura o "Brain Head" em 1000 pontos de vida
                    espectador:addHealth(1000)
                    -- Envia um efeito mágico de cura
                    espectador:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
                end
            end
        end
    end
    return true
end

badThoughtProximity:type("stepin")
badThoughtProximity:id(12355)
badThoughtProximity:register()
