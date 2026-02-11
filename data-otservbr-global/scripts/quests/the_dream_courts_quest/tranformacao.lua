local action = Action()
local cooldownTime = 23 -- Tempo de cooldown em segundos
local transformDuration = 15 -- duração em segundos para a primeira transformação
local transformationInterval = 30 -- Intervalo em segundos para repetir a transformação
local requiredLookType = 241 -- LookType necessário para usar o item
local teleportPosition = Position(32211, 32084, 15) -- Posição para onde o player será teleportado

local TRANSFORMED_STORAGE_KEY = 1000 -- Storage para rastrear transformação por criatura
local centralPosition = Position(32207, 32044, 15) -- Posição central fixa para o raio

local playerCooldowns = {} -- Tabela para armazenar o cooldown por jogador
local originalOutfits = {} -- Tabela para armazenar os outfits originais dos jogadores

local function teleportIfStillLooktype241(playerId)
    local player = Player(playerId)
    if player and player:getOutfit().lookType == requiredLookType then
        -- Restaura o outfit original antes de teleportar
        if originalOutfits[playerId] then
            player:setOutfit(originalOutfits[playerId])
            originalOutfits[playerId] = nil -- Limpa o outfit armazenado
        end
        player:teleportTo(teleportPosition)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    end
end

local function transformToLooktype(playerId, looktype)
    local player = Player(playerId)
    if player then
        player:setOutfit({lookType = looktype})
        if looktype == requiredLookType then
            addEvent(teleportIfStillLooktype241, 8000, playerId) -- Verifica e teleporta após 8 segundos
        else
            addEvent(transformToLooktype, transformDuration * 1000, playerId, requiredLookType)
        end
    end
end

local function transformPlayerToSpectre(player)
    local spectreOutfit = 235 -- Looktype do "Spectre"
    
    -- Armazena o outfit original do jogador antes de transformar
    originalOutfits[player:getId()] = player:getOutfit()
    
    player:setOutfit({lookType = spectreOutfit})
    
    -- Transformar novamente para looktype 241 após 15 segundos
    addEvent(transformToLooktype, transformDuration * 1000, player:getId(), requiredLookType)
end

local function chooseAndTransformPlayer(creature)
    -- Define o raio como 25x25x25 a partir da posição central
    local radius = {x = 15, y = 15, z = 15}
    local playersInRange = Game.getSpectators(centralPosition, false, true, radius.x, radius.x, radius.y, radius.y)
    local eligiblePlayers = {}
    
    for _, player in ipairs(playersInRange) do
        if player:isPlayer() then
            table.insert(eligiblePlayers, player)
        end
    end

    if #eligiblePlayers > 0 then
        local randomPlayer = eligiblePlayers[math.random(1, #eligiblePlayers)]
        transformPlayerToSpectre(randomPlayer)
    end
end

local function repeatTransformation(creatureId)
    local creature = Creature(creatureId)
    if creature then
        chooseAndTransformPlayer(creature)
        -- Agenda a próxima transformação para ocorrer em 30 segundos
        addEvent(repeatTransformation, transformationInterval * 1000, creatureId)
    end
end

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerId = player:getId()
    local currentTime = os.time() -- Obtém o tempo atual

    if item:getActionId() == 33056 then
        -- Verifica se o jogador está com o looktype correto
        if player:getOutfit().lookType ~= requiredLookType then
            return true
        end

        -- Verifica o cooldown do jogador
        if playerCooldowns[playerId] and currentTime - playerCooldowns[playerId] < cooldownTime then
            return true
        end

        local createItemPosition = Position(32203, 32046, 15) -- Posição onde o item será criado
        local itemId = 29276 -- ID do item que será criado
        local actionId = 33057 -- Action ID a ser atribuído ao item criado

        local createdItem = Game.createItem(itemId, 1, createItemPosition) -- Cria o item na posição especificada
        if createdItem then
            createdItem:setActionId(actionId) -- Atribui o action ID ao item criado
            playerCooldowns[playerId] = currentTime -- Atualiza o tempo da última utilização para o jogador
        else
            -- Mensagem caso a criação do item falhe
        end
    elseif item:getActionId() == 33057 then
        -- Verifica se o jogador está usando o item nele mesmo
        if target and target:isPlayer() and target:getId() == player:getId() then
            -- Restaura o outfit original do jogador
            if originalOutfits[playerId] then
                player:setOutfit(originalOutfits[playerId])
                originalOutfits[playerId] = nil -- Limpa o outfit armazenado
            else
                -- Caso o outfit original não esteja armazenado, ele remove o looktype 241
                if player:getOutfit().lookType == requiredLookType then
                    local originalOutfit = player:getOutfit()
                    originalOutfit.lookType = 0 -- Define o lookType para 0 (outfit original)
                    player:setOutfit(originalOutfit)
                end
            end
            -- Remove o item após o uso
            item:remove(1)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        end
    end

    return true
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature:getName():lower() == "the nightmare beast" then
        -- Verifica se a criatura já foi transformada verificando a storage value
        if creature:getStorageValue(TRANSFORMED_STORAGE_KEY) ~= 1 then
            creature:setStorageValue(TRANSFORMED_STORAGE_KEY, 1) -- Marca a criatura como transformada
            repeatTransformation(creature:getId()) -- Inicia o ciclo de transformações para os jogadores próximos
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

action:aid(33056) -- ID da ação do primeiro item
action:aid(33057) -- ID da ação do segundo item
action:register()

local nightmareBeastEvent = CreatureEvent("NightmareBeastEvent")
nightmareBeastEvent.onHealthChange = onHealthChange
nightmareBeastEvent:register()
