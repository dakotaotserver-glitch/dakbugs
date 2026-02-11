local ancientSpawnTeleport = CreatureEvent("AncientSpawnTeleport")

local targetPosition = Position(33788, 32377, 15) -- Posição para onde a criatura será teleportada em todos os casos
local teleportCreationPosition1 = Position(33732, 32368, 15) -- Posição do teleporte (80% de vida)
local teleportCreationPosition2 = Position(33745, 32340, 15) -- Posição do teleporte (60% de vida)
local teleportCreationPosition3 = Position(33782, 32368, 15) -- Posição do teleporte (40% de vida)
local teleportDestinationPosition1 = Position(33729, 32356, 15) -- Destino do jogador (80% de vida)
local teleportDestinationPosition2 = Position(33755, 32357, 15) -- Destino do jogador (60% de vida)
local teleportDestinationPosition3 = Position(33781, 32348, 15) -- Destino do jogador (40% de vida)
local teleportItemID = 1949
local teleportDuration = 30 -- 30 segundos de duração para cada teleporte

-- Função principal que lida com a criatura "Ancient Spawn of Morgathla"
function ancientSpawnTeleport.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= "ancient spawn of morgathla" then
        return true
    end

    -- Verifica se a criatura já foi teleportada em 80%, 60%, e 40%
    if creature:getStorageValue(10000) == 1 and creature:getStorageValue(10001) == 1 and creature:getStorageValue(10002) == 1 then
        return true
    end

    -- Calcula a porcentagem de vida da criatura
    local healthPercentage = math.floor((creature:getHealth() / creature:getMaxHealth()) * 100)

    -- Verifica se a vida está em 80% ou menos e se ainda não foi teleportada a 80%
    if healthPercentage <= 80 and creature:getStorageValue(10000) ~= 1 then
        -- Marca que a criatura já foi teleportada a 80%
        creature:setStorageValue(10000, 1)

        -- Teleporta a criatura para a posição alvo
        creature:teleportTo(targetPosition)
        targetPosition:sendMagicEffect(CONST_ME_TELEPORT)

        -- Cria o primeiro teleporte na posição especificada (80% de vida)
        local teleport = Game.createItem(teleportItemID, 1, teleportCreationPosition1)
        if teleport then
            teleport:setActionId(33162) -- Define um action ID único para o teleporte

            -- Remove o teleporte após 30 segundos
            addEvent(function()
                local item = Tile(teleportCreationPosition1):getItemById(teleportItemID)
                if item then
                    item:remove()
                    teleportCreationPosition1:sendMagicEffect(CONST_ME_POFF)
                end
            end, teleportDuration * 1000)
        end
    end

    -- Verifica se a vida está em 60% ou menos e se ainda não foi teleportada a 60%
    if healthPercentage <= 60 and creature:getStorageValue(10001) ~= 1 then
        -- Marca que a criatura já foi teleportada a 60%
        creature:setStorageValue(10001, 1)

        -- Teleporta a criatura para a mesma posição alvo
        creature:teleportTo(targetPosition)
        targetPosition:sendMagicEffect(CONST_ME_TELEPORT)

        -- Cria o segundo teleporte na posição especificada (60% de vida)
        local teleport = Game.createItem(teleportItemID, 1, teleportCreationPosition2)
        if teleport then
            teleport:setActionId(33163) -- Define um action ID único para o segundo teleporte

            -- Remove o teleporte após 30 segundos
            addEvent(function()
                local item = Tile(teleportCreationPosition2):getItemById(teleportItemID)
                if item then
                    item:remove()
                    teleportCreationPosition2:sendMagicEffect(CONST_ME_POFF)
                end
            end, teleportDuration * 1000)
        end
    end

    -- Verifica se a vida está em 40% ou menos e se ainda não foi teleportada a 40%
    if healthPercentage <= 40 and creature:getStorageValue(10002) ~= 1 then
        -- Marca que a criatura já foi teleportada a 40%
        creature:setStorageValue(10002, 1)

        -- Teleporta a criatura novamente para a mesma posição alvo
        creature:teleportTo(targetPosition)
        targetPosition:sendMagicEffect(CONST_ME_TELEPORT)

        -- Cria o terceiro teleporte na posição especificada (40% de vida)
        local teleport = Game.createItem(teleportItemID, 1, teleportCreationPosition3)
        if teleport then
            teleport:setActionId(33164) -- Define um action ID único para o terceiro teleporte

            -- Remove o teleporte após 30 segundos
            addEvent(function()
                local item = Tile(teleportCreationPosition3):getItemById(teleportItemID)
                if item then
                    item:remove()
                    teleportCreationPosition3:sendMagicEffect(CONST_ME_POFF)
                end
            end, teleportDuration * 1000)
        end
    end

    return true
end

-- Função para o primeiro teleporte (80%) levar o jogador para a posição destino e teleportar a criatura após 1 minuto
local teleportStepIn1 = MoveEvent()
function teleportStepIn1.onStepIn(player, item, position, fromPosition)
    if player:isPlayer() and item:getActionId() == 33162 then
        player:teleportTo(teleportDestinationPosition1)
        teleportDestinationPosition1:sendMagicEffect(CONST_ME_TELEPORT)

        -- Adiciona a função para teleportar a criatura após 1 minuto
        addEvent(function()
            local ancientSpawn = Tile(targetPosition):getTopCreature() -- Pega a criatura no local
            if ancientSpawn and ancientSpawn:getName():lower() == "ancient spawn of morgathla" then
                ancientSpawn:teleportTo(Position(33731, 32345, 15)) -- Teleporta para a nova posição
                Position(33731, 32345, 15):sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte
            end
        end, 60 * 1000) -- 1 minuto de delay
    end
    return true
end

-- Função para o segundo teleporte (60%) levar o jogador para a posição destino e teleportar a criatura após 1 minuto
local teleportStepIn2 = MoveEvent()
function teleportStepIn2.onStepIn(player, item, position, fromPosition)
    if player:isPlayer() and item:getActionId() == 33163 then
        player:teleportTo(teleportDestinationPosition2)
        teleportDestinationPosition2:sendMagicEffect(CONST_ME_TELEPORT)

        -- Adiciona a função para teleportar a criatura após 1 minuto
        addEvent(function()
            local ancientSpawn = Tile(targetPosition):getTopCreature() -- Pega a criatura no local
            if ancientSpawn and ancientSpawn:getName():lower() == "ancient spawn of morgathla" then
                ancientSpawn:teleportTo(Position(33765, 32364, 15)) -- Teleporta para a nova posição
                Position(33765, 32364, 15):sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte
            end
        end, 60 * 1000) -- 1 minuto de delay
    end
    return true
end

-- Função para o terceiro teleporte (40%) levar o jogador para a posição destino e teleportar a criatura após 1 minuto
local teleportStepIn3 = MoveEvent()
function teleportStepIn3.onStepIn(player, item, position, fromPosition)
    if player:isPlayer() and item:getActionId() == 33164 then
        player:teleportTo(teleportDestinationPosition3)
        teleportDestinationPosition3:sendMagicEffect(CONST_ME_TELEPORT)

        -- Adiciona a função para teleportar a criatura após 1 minuto
        addEvent(function()
            local ancientSpawn = Tile(targetPosition):getTopCreature() -- Pega a criatura no local
            if ancientSpawn and ancientSpawn:getName():lower() == "ancient spawn of morgathla" then
                ancientSpawn:teleportTo(Position(33779, 32338, 15)) -- Teleporta para a nova posição
                Position(33779, 32338, 15):sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte
            end
        end, 60 * 1000) -- 1 minuto de delay
    end
    return true
end

-- Registra os eventos de quando o jogador pisar nos teleportes
teleportStepIn1:aid(33162)
teleportStepIn1:type("stepin")
teleportStepIn1:register()

teleportStepIn2:aid(33163)
teleportStepIn2:type("stepin")
teleportStepIn2:register()

teleportStepIn3:aid(33164)
teleportStepIn3:type("stepin")
teleportStepIn3:register()

-- Registra o evento de teleporte da criatura
ancientSpawnTeleport:register()
