-- Definição das posições para transformação dos itens
local positionsToTransform44312 = {
    Position(34063, 31413, 11),
    Position(34064, 31413, 11),
    Position(34071, 31414, 11),
    Position(34072, 31414, 11),
    Position(34072, 31407, 11),
    Position(34073, 31407, 11),
    Position(34065, 31404, 11),
    Position(34066, 31404, 11)
}

local positionsToTransform44314 = {
    Position(34060, 31409, 11),
    Position(34060, 31408, 11),
    Position(34075, 31411, 11),
    Position(34075, 31410, 11)
}

-- IDs dos itens para transformação
local ITEM_TO_TRANSFORM = 3144
local NEW_ITEM_44312 = 44312
local NEW_ITEM_44314 = 44314

-- Nome da criatura a ser monitorada
local MONITOR_CREATURE_NAME = "Mitmah Vanguard"

-- Função para transformar os itens nas posições especificadas
local function transformSpecificItems(positions, currentItemId, newItemId)
    for _, pos in ipairs(positions) do
        local tile = Tile(pos)
        if tile then
            local item = tile:getItemById(currentItemId)
            if item then
                item:transform(newItemId) -- Transforma o item no novo ID
                --item:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN) -- Efeito visual da transformação
            end
        end
    end
end

-- Evento para capturar a morte da criatura
local mitmahVanguardDeathEvent = CreatureEvent("MitmahVanguardDeathCheck")

function mitmahVanguardDeathEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    if creature:getName():lower() == MONITOR_CREATURE_NAME:lower() then
        -- Agenda a transformação dos itens 1 minuto após a morte (60.000 milissegundos)
        addEvent(function()
            -- Transformar itens para 44312 nas posições especificadas
            transformSpecificItems(positionsToTransform44312, ITEM_TO_TRANSFORM, NEW_ITEM_44312)
            
            -- Transformar itens para 44314 nas posições especificadas
            transformSpecificItems(positionsToTransform44314, ITEM_TO_TRANSFORM, NEW_ITEM_44314)
        end, 60000) -- 60 segundos de espera antes de executar
    end
    return true
end

-- Registro do evento
mitmahVanguardDeathEvent:register()
