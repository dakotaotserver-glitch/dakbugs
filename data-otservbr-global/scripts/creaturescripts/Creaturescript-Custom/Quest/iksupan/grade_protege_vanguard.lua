-- Definição das posições para verificar os itens
local fromPosition = Position(34055, 31402, 11)  -- Posição inicial da área
local toPosition = Position(34078, 31417, 11)    -- Posição final da área

-- Definição dos IDs dos itens para o primeiro grupo de transformação
local ITEM_ID_1 = 44312 -- ID inicial do primeiro grupo
local ITEM_ID_2 = 44328 -- ID transformado ao atingir 80% de vida (primeiro grupo)
local ITEM_ID_3 = 44332 -- ID transformado ao atingir 60% de vida (primeiro grupo)
local ITEM_ID_FINAL = 3144 -- ID final ao atingir 40% de vida (primeiro grupo)

-- Definição dos IDs dos itens para o segundo grupo de transformação
local ITEM_ID_A = 44314 -- ID inicial do segundo grupo
local ITEM_ID_B = 44330 -- ID transformado ao atingir 80% de vida (segundo grupo)
local ITEM_ID_C = 44334 -- ID transformado ao atingir 60% de vida (segundo grupo)
local ITEM_ID_FINAL_2 = 3144 -- ID final ao atingir 40% de vida (segundo grupo)

-- Nome da criatura a ser monitorada
local MONITOR_CREATURE_NAME = "Mitmah Vanguard"

-- Função para transformar os itens na área
local function transformItemsInArea(fromPos, toPos, currentItemId, newItemId)
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            local tile = Tile(Position(x, y, fromPos.z))
            if tile then
                local item = tile:getItemById(currentItemId)
                if item then
                    item:transform(newItemId) -- Transforma o item no novo ID
                   -- item:getPosition():sendMagicEffect(CONST_ME_POFF) -- Efeito visual da transformação
                end
            end
        end
    end
end

-- Criação do evento de verificação de vida da criatura
local mitmahVanguardEvent = CreatureEvent("MitmahVanguardHealthCheck")

function mitmahVanguardEvent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature:getName():lower() == MONITOR_CREATURE_NAME:lower() then
        -- Calcula o percentual de vida restante
        local healthPercent = (creature:getHealth() / creature:getMaxHealth()) * 100

        -- Transformar itens ao atingir 80% de vida
        if healthPercent <= 80 and healthPercent > 60 then
            -- Primeiro grupo de itens
            transformItemsInArea(fromPosition, toPosition, ITEM_ID_1, ITEM_ID_2)
            -- Segundo grupo de itens
            transformItemsInArea(fromPosition, toPosition, ITEM_ID_A, ITEM_ID_B)

        -- Transformar itens ao atingir 60% de vida
        elseif healthPercent <= 60 and healthPercent > 40 then
            -- Primeiro grupo de itens
            transformItemsInArea(fromPosition, toPosition, ITEM_ID_2, ITEM_ID_3)
            -- Segundo grupo de itens
            transformItemsInArea(fromPosition, toPosition, ITEM_ID_B, ITEM_ID_C)

        -- Transformar itens ao atingir 40% de vida
        elseif healthPercent <= 40 then
            -- Primeiro grupo de itens
            transformItemsInArea(fromPosition, toPosition, ITEM_ID_3, ITEM_ID_FINAL)
            -- Segundo grupo de itens
            transformItemsInArea(fromPosition, toPosition, ITEM_ID_C, ITEM_ID_FINAL_2)
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

-- Registro do evento
mitmahVanguardEvent:register()
