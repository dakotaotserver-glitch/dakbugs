local deathEvent = CreatureEvent("RootkrakenKillStorage")

function deathEvent.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    -- Verifica se a criatura morta é "The Rootkraken"
    if creature:getName():lower() ~= "the rootkraken" then
        return true
    end

    -- Lista para armazenar todos os jogadores que participaram do combate
    local involvedPlayers = {}

    -- Verifica o killer (quem deu o último hit)
    if killer and killer:isPlayer() then
        table.insert(involvedPlayers, killer)
    elseif killer and killer:isMonster() then
        -- Se foi morto por um monstro, pegamos os atacantes do monstro
        for _, damageDealer in pairs(creature:getDamageMap()) do
            if damageDealer and damageDealer:isPlayer() then
                table.insert(involvedPlayers, damageDealer)
            end
        end
    end

    -- Verifica o mostDamageKiller (quem deu mais dano)
    if mostDamageKiller and mostDamageKiller:isPlayer() then
        table.insert(involvedPlayers, mostDamageKiller)
    elseif mostDamageKiller and mostDamageKiller:isMonster() then
        -- Se o maior dano foi de um monstro, pegamos os atacantes
        for _, damageDealer in pairs(creature:getDamageMap()) do
            if damageDealer and damageDealer:isPlayer() then
                table.insert(involvedPlayers, damageDealer)
            end
        end
    end

    -- Remove jogadores duplicados da lista
    local uniquePlayers = {}
    for _, player in ipairs(involvedPlayers) do
        uniquePlayers[player:getId()] = player
    end

    -- Para cada jogador envolvido, verifica e atualiza a storage
    for _, player in pairs(uniquePlayers) do
        local storageValue = player:getStorageValue(Storage.U13_40.podzilla.salaboss)

        if storageValue == 1 then
            player:setStorageValue(Storage.U13_40.podzilla.salaboss, 2)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce derrotou The Rootkraken!")
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED) -- Efeito visual vermelho ao receber a storage
        end
    end

    return true
end

deathEvent:register()
