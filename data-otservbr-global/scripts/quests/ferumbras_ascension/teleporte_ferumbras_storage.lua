local teleportAction = MoveEvent()

function teleportAction.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return false
    end

    -- Defina as posições de destino
    local destinationPosition = Position(33293, 31453, 12)
    local destinationPosition2 = Position(33275, 32392, 9)

    -- Verificar se o jogador tem acesso e completou todas as missões necessárias
    if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Access) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Razzagorn) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Ragiaz) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Zamulosh) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Mazoran) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Tarbaz) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Shulgrax) >= 1 and
       player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Plagirath) >= 1 then

        -- Teleportar para o destino correto e enviar mensagem
        player:teleportTo(destinationPosition)
        destinationPosition:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce rompeu os 7 Selos do Ferumbras!")
    else
        -- Caso contrário, teleporte para a segunda posição e envie outra mensagem
        player:teleportTo(destinationPosition2)
        destinationPosition2:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ainda nao e digno.")
    end

    return true
end

teleportAction:aid(63000) -- ID do teleporte
teleportAction:register()
