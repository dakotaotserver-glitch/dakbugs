-- Teleporte ao Castle para membros da guild vencedora
local castleTeleport = TalkAction("!castle")
function castleTeleport.onSay(player, words, param)
    -- Verificar se o personagem específico é um administrador (GOD ou GM)
    local isAdmin = player:getGroup():getAccess() and player:getGroup():getId() >= 2
    
    -- Se for admin, não precisa fazer as verificações normais
    if isAdmin then
        player:teleportTo(Position(17196, 17138, 4))
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Como administrador, voce foi teleportado para o castelo.")
        return false
    end
    
    local isInPZ = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
    local hasInfight = player:isPzLocked() or player:hasCondition(CONDITION_INFIGHT) or player:hasCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
    
    -- Se estiver fora de PZ e com battle, não permitir teleporte
    if not isInPZ and hasInfight then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao pode usar este comando enquanto estiver em batalha fora de area protegida.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    
    -- Verificar se o jogador pertence a alguma guild
    if not player:getGuild() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao pertence a nenhuma guild.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    
    local playerGuildId = player:getGuild():getId()
    
    -- Verificar no banco de dados se a guild do jogador é a detentora do castelo
    local query = db.storeQuery("SELECT `guild_id` FROM `castle` WHERE `guild_id` = " .. playerGuildId .. " LIMIT 1")
    if not query then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sua guild nao possui o castelo atualmente.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    
    -- Guild confirmada como detentora do castelo, liberar teleporte
    local guildId = result.getNumber(query, "guild_id")
    result.free(query)
    
    if guildId == playerGuildId then
        -- Teleportar o jogador para o castelo
        player:teleportTo(Position(17196, 17138, 4))
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce foi teleportado para o castelo da sua guild.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Erro ao verificar a posse do castelo. Contate um administrador.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end
    
    return false
end
castleTeleport:separator(" ")
castleTeleport:groupType("normal")
castleTeleport:register()