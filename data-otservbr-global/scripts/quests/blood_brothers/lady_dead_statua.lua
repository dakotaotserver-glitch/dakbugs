local vampireBrideDeaths = 0 -- Variavel para contar as mortes de Lady Vampire Bride
local maxVampireBrideDeaths = 2 -- Numero de mortes necessario para ativar o evento
local checkPosition = Position(32940, 31460, 2) -- Posicao de verificacao de morte
local checkRadius = {x = 5, y = 5, z = 1} -- Raio de verificacao

local function teleportPlayersAndSpawnMarziel()
    local playersInRange = Game.getSpectators(checkPosition, false, true, checkRadius.x, checkRadius.x, checkRadius.y, checkRadius.y, checkRadius.z, checkRadius.z)
    local teleportPosition = Position(32940, 31460, 1) -- Posicao para onde os jogadores serao teleportados
    local marzielPosition = Position(32940, 31457, 1) -- Posicao para criar a criatura Marziel
    local marzielRadius = {x = 5, y = 5, z = 1} -- Raio para verificar a presença de Marziel

    -- Teleporta todos os jogadores encontrados na area
    for _, player in ipairs(playersInRange) do
        player:teleportTo(teleportPosition)
        teleportPosition:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte
    end

    -- Remove todas as criaturas "Marziel" na área especificada
    local existingMarziels = Game.getSpectators(marzielPosition, false, false, marzielRadius.x, marzielRadius.x, marzielRadius.y, marzielRadius.y, marzielRadius.z, marzielRadius.z)
    for _, creature in ipairs(existingMarziels) do
        if creature:getName():lower() == "marziel" then
            creature:remove() -- Remove a criatura Marziel existente
        end
    end

    -- Cria a criatura Marziel na posicao especificada
    local marziel = Game.createMonster("Marziel", marzielPosition)
    if marziel then
        marzielPosition:sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual ao criar Marziel
    end

    -- Reseta a contagem de mortes de Lady Vampire Bride
    vampireBrideDeaths = 0
end

local vampireBrideDeathEvent = CreatureEvent("VampireBrideDeathEvent")

function vampireBrideDeathEvent.onDeath(creature, corpse)
    local position = creature:getPosition()

    -- Verifica se a criatura morta é "Lady Vampire Bride"
    if creature:getName():lower() == "lady vampire bride" then
        -- Verifica se a posição está dentro do raio de 5x5x1 ao redor de {32940, 31460, 2}
        if math.abs(position.x - checkPosition.x) <= checkRadius.x and
           math.abs(position.y - checkPosition.y) <= checkRadius.y and
           math.abs(position.z - checkPosition.z) <= checkRadius.z then
           
            vampireBrideDeaths = vampireBrideDeaths + 1 -- Incrementa a contagem de mortes

            -- Verifica se o número de mortes atingiu o necessário
            if vampireBrideDeaths >= maxVampireBrideDeaths then
                addEvent(teleportPlayersAndSpawnMarziel, 100) -- Chama a funcao de teleporte e criacao apos 100ms
            end
        end
    end

    return true
end

vampireBrideDeathEvent:register()
