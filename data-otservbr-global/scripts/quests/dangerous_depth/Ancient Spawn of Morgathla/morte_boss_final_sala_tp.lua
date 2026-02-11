local ancientSpawnDeath = CreatureEvent("AncientSpawnDeath")

local teleportPosition = Position(33779, 32328, 15) -- Posição onde o teleporte será criado
local teleportDestination = Position(33760, 32332, 15) -- Posição para onde o jogador será teleportado
local teleportItemID = 1949 -- ID do item que será o teleporte
local teleportActionID = 33165 -- Action ID único para o teleporte
local teleportDuration = 60 -- Duração do teleporte em segundos
local rewardStorage = 65107 -- Storage que os jogadores receberão

-- Área de kick após 2 minutos
local areaKickFrom = Position(33700, 32325, 15)
local areaKickTo = Position(33791, 32379, 15)
local kickExitPosition = Position(33693, 32389, 15)

-- Função chamada quando a criatura "Ancient Spawn of Morgathla" morrer
function ancientSpawnDeath.onDeath(creature, corpse, killer, mostDamageKiller)
    if not creature:isMonster() or creature:getName():lower() ~= "ancient spawn of morgathla" then
        return true
    end

    -- Criar o teleporte na posição especificada
    local teleport = Game.createItem(teleportItemID, 1, teleportPosition)
    if teleport then
        teleport:setActionId(teleportActionID) -- Define o action ID do teleporte

        -- Remover o teleporte após 30 segundos
        addEvent(function()
            local item = Tile(teleportPosition):getItemById(teleportItemID)
            if item then
                item:remove()
                teleportPosition:sendMagicEffect(CONST_ME_POFF) -- Efeito visual de remoção
            end
        end, teleportDuration * 1000)
    end

    -- Recompensar os jogadores que participaram da morte
    local damageMap = creature:getDamageMap() -- Mapa de jogadores que causaram dano à criatura
    for playerId, damage in pairs(damageMap) do
        local player = Player(playerId)
        if player then
            player:setStorageValue(rewardStorage, 1) -- Atribui a storage 65107 ao jogador
            --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você recebeu a storage 65107 por derrotar o Ancient Spawn of Morgathla!")
        end
    end

    -- Após 2 minutos, remove todos os jogadores da área do boss
    addEvent(function()
        for _, player in ipairs(Game.getPlayers()) do
            local pos = player:getPosition()
            if pos.z == areaKickFrom.z and
               pos.x >= areaKickFrom.x and pos.x <= areaKickTo.x and
               pos.y >= areaKickFrom.y and pos.y <= areaKickTo.y then
                player:teleportTo(kickExitPosition)
                kickExitPosition:sendMagicEffect(CONST_ME_TELEPORT)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "O tempo acabou, voce foi removido da sala do boss!")
            end
        end
    end, 2 * 60 * 1000) -- 2 minutos (em milissegundos)

    return true
end

-- Função chamada quando o jogador pisar no teleporte
local teleportStepIn = MoveEvent()
function teleportStepIn.onStepIn(player, item, position, fromPosition)
    if player:isPlayer() and item:getActionId() == teleportActionID then
        player:teleportTo(teleportDestination)
        teleportDestination:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito visual de teleporte
    end
    return true
end

-- Registro do evento de pisar no teleporte
teleportStepIn:aid(teleportActionID)
teleportStepIn:type("stepin")
teleportStepIn:register()

-- Registro do evento de morte da criatura
ancientSpawnDeath:register()
