local StorageTransform = CreatureEvent("StorageTransform")

-- Área principal
local fromPosition = Position(33784, 31967, 4)
local toPosition   = Position(33882, 32042, 4)

-- Storage que controla se o jogador deve ser transformado
local REQUIRED_STORAGE = 65121

-- Armazena o valor antigo de REQUIRED_STORAGE
local PREVIOUS_STORAGE = 65123

-- Armazena o outfit original do jogador
local ORIGINAL_OUTFIT_STORAGE = 65124

-- Posição para onde o jogador é teleportado caso storage < 1
local OUT_OF_AREA_POS = Position(32347, 32625, 7)

--------------------------------------------------------------------------------
-- Vocation -> Transform Lookup
-- Vocations:
--  1 = Sorcerer       -> LookType = 1695
--  2 = Druid          -> LookType = 1696
--  3 = Paladin        -> LookType = 1697
--  4 = Knight         -> LookType = 1694
--  5 = Master Sorcerer-> LookType = 1695
--  6 = Elder Druid    -> LookType = 1696
--  7 = Royal Paladin  -> LookType = 1697
--  8 = Elite Knight   -> LookType = 1694
--------------------------------------------------------------------------------
local transformLookTypes = {
    [1] = 1695, -- Sorcerer
    [2] = 1696, -- Druid
    [3] = 1697, -- Paladin
    [4] = 1694, -- Knight
    [5] = 1695, -- Master Sorcerer
    [6] = 1696, -- Elder Druid
    [7] = 1697, -- Royal Paladin
    [8] = 1694, -- Elite Knight
    [9] = 1694, -- Monk (usa Knight)
    [10] = 1694 -- Exalted Monk (usa Knight)
}


-- Checa se o lookType é um dos lookTypes de transformação
local function isTransformedLookType(lookType)
    return (lookType == 1694 or
            lookType == 1695 or
            lookType == 1696 or
            lookType == 1697)
end

-- Função para checar se pos está dentro [fromPos, toPos]
local function isInRange(pos, fromPos, toPos)
    return (pos.x >= fromPos.x and pos.x <= toPos.x)
       and (pos.y >= fromPos.y and pos.y <= toPos.y)
       and (pos.z == fromPos.z)
end

--------------------------------------------------------------------------------
-- 1) onLogin
--------------------------------------------------------------------------------
function StorageTransform.onLogin(player)
    player:registerEvent("StorageTransform")
    return true
end

--------------------------------------------------------------------------------
-- 2) onThink
--------------------------------------------------------------------------------
function StorageTransform.onThink(creature, interval)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- Verifica se o jogador está DENTRO da área
    local inArea = isInRange(player:getPosition(), fromPosition, toPosition)
    local currentOutfit = player:getOutfit()
    local currentStorageVal = player:getStorageValue(REQUIRED_STORAGE)

    --------------------------------------------------------------------------------
    -- Fora da Área
    --------------------------------------------------------------------------------
    if not inArea then
        -- Se o player está FORA da área mas ESTÁ transformado, reverte
        if isTransformedLookType(currentOutfit.lookType) then
            -- Restaura REQUIRED_STORAGE
            local oldStorageVal = player:getStorageValue(PREVIOUS_STORAGE)
            if oldStorageVal >= 1 then
                player:setStorageValue(REQUIRED_STORAGE, oldStorageVal)
                player:setStorageValue(PREVIOUS_STORAGE, -1)
            else
                player:setStorageValue(REQUIRED_STORAGE, 0)
            end

            -- Restaura outfit original, se salvo
            local oldOutfitValue = player:getStorageValue(ORIGINAL_OUTFIT_STORAGE)
            if oldOutfitValue >= 1 then
                currentOutfit.lookType = oldOutfitValue
                player:setOutfit(currentOutfit)
                player:setStorageValue(ORIGINAL_OUTFIT_STORAGE, -1)
            else
                currentOutfit.lookType = 128 -- Citizen Male, por exemplo
                player:setOutfit(currentOutfit)
            end
        end
        return true
    end

    --------------------------------------------------------------------------------
    -- Dentro da Área
    --------------------------------------------------------------------------------

    -- A) Se o player tem storage >= 1, deve ser transformado
    if currentStorageVal >= 1 then
        -- Se ainda NÃO está transformado, vamos transformar
        if not isTransformedLookType(currentOutfit.lookType) then
            -- Salva valor antigo de REQUIRED_STORAGE (se não estiver salvo)
            if player:getStorageValue(PREVIOUS_STORAGE) < 1 then
                player:setStorageValue(PREVIOUS_STORAGE, currentStorageVal)
            end

            -- Força REQUIRED_STORAGE = 1
            player:setStorageValue(REQUIRED_STORAGE, 1)

            -- Se não salvou outfit original, salva agora
            if player:getStorageValue(ORIGINAL_OUTFIT_STORAGE) < 1 then
                player:setStorageValue(ORIGINAL_OUTFIT_STORAGE, currentOutfit.lookType)
            end

            -- Define lookType baseado na vocação
            local vocId = player:getVocation():getId()
            local newLookType = transformLookTypes[vocId] or 128 -- fallback se voc não estiver mapeada
            currentOutfit.lookType = newLookType
            player:setOutfit(currentOutfit)

            -- Efeito opcional (ex: 188 = CONST_ME_TELEPORT)
            player:getPosition():sendMagicEffect(188)
        end

    else
        -- B) Está dentro da área, mas storage < 1 => teleporta pra fora
        if isTransformedLookType(currentOutfit.lookType) then
            -- Se estava transformado, reverte o outfit
            local oldStorageVal = player:getStorageValue(PREVIOUS_STORAGE)
            if oldStorageVal >= 1 then
                player:setStorageValue(REQUIRED_STORAGE, oldStorageVal)
                player:setStorageValue(PREVIOUS_STORAGE, -1)
            end

            local oldOutfitValue = player:getStorageValue(ORIGINAL_OUTFIT_STORAGE)
            if oldOutfitValue >= 1 then
                currentOutfit.lookType = oldOutfitValue
                player:setOutfit(currentOutfit)
                player:setStorageValue(ORIGINAL_OUTFIT_STORAGE, -1)
            else
                currentOutfit.lookType = 128
                player:setOutfit(currentOutfit)
            end
        end

        -- Teleporta o jogador para fora
        player:teleportTo(OUT_OF_AREA_POS)
        OUT_OF_AREA_POS:sendMagicEffect(54)
    end

    return true
end

--------------------------------------------------------------------------------
-- 3) Registro do Evento
--------------------------------------------------------------------------------
StorageTransform:register()
