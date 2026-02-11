local dukeKruleTransformEvent = CreatureEvent("DukeKruleTransform")
local transformationCooldown = 11 -- Cooldown de 11 segundos para transformação
local lastTransformationTime = 0 -- Armazena o tempo da última transformação em segundos
local damageAmount = 4000 -- Dano a ser aplicado quando jogadores se aproximarem
local damageCooldown = 4 -- Cooldown de 2 segundos para dano
local lastDamageTime = {} -- Armazena o tempo do último dano aplicado a cada jogador
local fromPosition = Position(33447, 31464, 13) -- Posição inicial da sala
local toPosition = Position(33464, 31481, 13) -- Posição final da sala
local transformationDuration = 10000 -- Duração da transformação em milissegundos (10 segundos)

-- Função para verificar se uma posição está dentro da área especificada
local function isInArea(position, fromPos, toPos)
    return position.x >= fromPos.x and position.x <= toPos.x and
           position.y >= fromPos.y and position.y <= toPos.y and
           position.z == fromPos.z
end

-- Função para aplicar efeito de magia em área baseado na transformação
local function applyAreaEffect(player, transformationType)
    if not player or not player:isPlayer() then
        return
    end

    local playerPos = player:getPosition()
    if transformationType == "fire" then
        -- Efeito de "exevo gran mas flam" em área 5x5
        for x = -2, 2 do
            for y = -2, 2 do
                local pos = Position(playerPos.x + x, playerPos.y + y, playerPos.z)
                pos:sendMagicEffect(CONST_ME_HITBYFIRE)
            end
        end
    elseif transformationType == "water" then
        -- Efeito de "exevo gran mas frigo" em área 5x5
        for x = -2, 2 do
            for y = -2, 2 do
                local pos = Position(playerPos.x + x, playerPos.y + y, playerPos.z)
                pos:sendMagicEffect(CONST_ME_ICETORNADO)
            end
        end
    end
end

-- Função para transformar jogadores aleatoriamente em fire elemental ou water elemental
function transformPlayers(position)
    local players = Game.getSpectators(position, false, false, 30, 30, 30, 30)
    local transformedPlayers = {}
    for _, player in ipairs(players) do
        if player:isPlayer() and isInArea(player:getPosition(), fromPosition, toPosition) then
            local originalOutfit = player:getOutfit()
            local randomTransformation = math.random(2)
            if randomTransformation == 1 then
                player:setOutfit({lookType = 49}) -- Fire Elemental outfit
                player:sendCancelMessage("You have been transformed into a Fire Elemental!")
                transformedPlayers[player:getId()] = {type = "fire", originalOutfit = originalOutfit}
            else
                player:setOutfit({lookType = 286}) -- Water Elemental outfit
                player:sendCancelMessage("You have been transformed into a Water Elemental!")
                transformedPlayers[player:getId()] = {type = "water", originalOutfit = originalOutfit}
            end

            -- Aplicar efeito de magia em área a cada 2 segundos enquanto transformado
            local function periodicEffect(playerId, transformationType)
                local player = Player(playerId)
                if player and player:getOutfit().lookType == (transformationType == "fire" and 49 or 286) then
                    applyAreaEffect(player, transformationType)
                    addEvent(periodicEffect, 2000, playerId, transformationType)
                end
            end
            addEvent(periodicEffect, 2000, player:getId(), transformedPlayers[player:getId()].type)

            -- Resetar a transformação após 10 segundos
            addEvent(function()
                for _, p in ipairs(players) do
                    if p:isPlayer() and transformedPlayers[p:getId()] then
                        p:setOutfit(transformedPlayers[p:getId()].originalOutfit)
                        p:sendCancelMessage("You have returned to your normal form.")
                        p:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Efeito de cura azul
                        transformedPlayers[p:getId()] = nil -- Remove o jogador da lista de transformados
                    end
                end
            end, transformationDuration)

            -- Verificar proximidade entre jogadores transformados
            addEvent(checkProximityAndApplyDamage, 1000, transformedPlayers)
        end
    end
end

-- Função para verificar proximidade entre jogadores transformados e aplicar dano
function checkProximityAndApplyDamage(transformedPlayers)
    local currentTime = os.time()
    local playerIds = {}
    for playerId, _ in pairs(transformedPlayers) do
        table.insert(playerIds, playerId)
    end
    for i = 1, #playerIds - 1 do
        local player1 = Player(playerIds[i])
        if player1 then
            local outfit1 = transformedPlayers[player1:getId()].type
            for j = i + 1, #playerIds do
                local player2 = Player(playerIds[j])
                if player2 and player1:getPosition():getDistance(player2:getPosition()) <= 3 then -- Distância de 5x5
                    local outfit2 = transformedPlayers[player2:getId()].type
                    if outfit1 ~= outfit2 then
                        local lastDamage1 = lastDamageTime[player1:getId()] or 0
                        local lastDamage2 = lastDamageTime[player2:getId()] or 0
                        if currentTime - lastDamage1 >= damageCooldown or currentTime - lastDamage2 >= damageCooldown then
                            if currentTime - lastDamage1 >= damageCooldown then
                                player1:addHealth(-damageAmount)
                                player1:sendCancelMessage("You took damage for being too close to an opposite elemental!")
                                player1:getPosition():sendMagicEffect(CONST_ME_BIGCLOUDS) -- Efeito de dano
                                lastDamageTime[player1:getId()] = currentTime
                            end
                            if currentTime - lastDamage2 >= damageCooldown then
                                player2:addHealth(-damageAmount)
                                player2:sendCancelMessage("You took damage for being too close to an opposite elemental!")
                                player2:getPosition():sendMagicEffect(CONST_ME_BIGCLOUDS) -- Efeito de dano
                                lastDamageTime[player2:getId()] = currentTime
                            end
                        end
                    end
                end
            end
        end
    end
    -- Verifica novamente em 1 segundo
    addEvent(checkProximityAndApplyDamage, 1000, transformedPlayers)
end

-- Função chamada quando a criatura "Duke Krule" recebe dano
function dukeKruleTransformEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:isMonster() and creature:getName():lower() == "duke krule" then
        local currentTime = os.time()
        if currentTime - lastTransformationTime >= transformationCooldown then
            transformPlayers(creature:getPosition())
            lastTransformationTime = currentTime
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

dukeKruleTransformEvent:register()
