local bossName = "arbaziloth"
local teleportItemId = 37000
local teleportActionId = 65001 -- escolha um valor não usado
local teleportPosition = Position(34041, 32330, 14)
local teleportDestination = Position(34062, 32336, 14)
local teleportDuration = 60 * 1000 -- 1 minuto

-- Evento de morte do boss
local arbazilothDeath = CreatureEvent("ArbazilothDeath")

function arbazilothDeath.onDeath(creature, corpse, killer, mostDamageKiller)
    if creature:getName():lower() == bossName then

        -- Cria o teleporte temporário
        local teleport = Game.createItem(teleportItemId, 1, teleportPosition)
        if teleport then
            teleport:setActionId(teleportActionId)
            teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
        end
        -- Remove o teleporte após 1 minuto
        addEvent(function()
            local tile = Tile(teleportPosition)
            if tile then
                local t = tile:getItemById(teleportItemId)
                if t then
                    t:remove()
                    teleportPosition:sendMagicEffect(CONST_ME_POFF)
                end
            end
        end, teleportDuration)
    end
    return true
end

arbazilothDeath:register()

local teleportMove = MoveEvent()
teleportMove:type("stepin")
teleportMove:aid(teleportActionId)

function teleportMove.onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return true
    end
    creature:teleportTo(teleportDestination)
    teleportDestination:sendMagicEffect(CONST_ME_TELEPORT)
    position:sendMagicEffect(CONST_ME_POFF)
    return true
end

teleportMove:register()
