-- Script para verificar periodicamente se as criaturas "Rotten Plant Thing" e "Angry Plant Thing" ainda estão vivas na área definida

local area = {
    from = Position(33945, 32026, 11),
    to = Position(33982, 32055, 11)
}

local function transformPlants()
    for x = area.from.x, area.to.x do
        for y = area.from.y, area.to.y do
            local tile = Tile(Position(x, y, area.from.z))
            if tile then
                local creature = tile:getTopCreature()

                -- Verifica e transforma "Rotten Plant Thing" em "Angry Plant Thing"
                if creature and creature:isMonster() and creature:getName():lower() == "rotten plant thing" then
                    addEvent(function()
                        local currentCreature = Tile(Position(x, y, area.from.z)):getTopCreature()
                        if currentCreature and currentCreature:getName():lower() == "rotten plant thing" then
                            currentCreature:remove() -- Remove o "Rotten Plant Thing"
                            Game.createMonster("Angry Plant Thing", Position(x, y, area.from.z)) -- Cria o "Angry Plant Thing"
                        end
                    end, 60000) -- 1 minuto (60.000 milissegundos)
                end

                -- Verifica e transforma "Angry Plant Thing" em "Frenzied Plant Thing"
                if creature and creature:isMonster() and creature:getName():lower() == "angry plant thing" then
                    addEvent(function()
                        local currentCreature = Tile(Position(x, y, area.from.z)):getTopCreature()
                        if currentCreature and currentCreature:getName():lower() == "angry plant thing" then
                            currentCreature:remove() -- Remove o "Angry Plant Thing"
                            Game.createMonster("Frenzied Plant Thing", Position(x, y, area.from.z)) -- Cria o "Frenzied Plant Thing"
                        end
                    end, 60000) -- 1 minuto (60.000 milissegundos)
                end
            end
        end
    end
end

-- Executa a verificação periodicamente a cada 5 segundos
local function startPeriodicCheck()
    addEvent(function()
        transformPlants()
        startPeriodicCheck()
    end, 5000) -- 5 segundos (5000 milissegundos)
end

-- Inicia o ciclo de verificação ao carregar o script
startPeriodicCheck()