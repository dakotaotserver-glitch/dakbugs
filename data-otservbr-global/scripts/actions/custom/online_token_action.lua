local onlineToken = Action()

function onlineToken.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Obter GUID do jogador (ID real do banco de dados)
    local playerId = player:getGuid()
    
    -- Verificar se o player já existe na tabela
    local resultId = db.storeQuery("SELECT `player_id` FROM `player_online_tokens` WHERE `player_id` = " .. playerId)
    
    -- Se não existir, criar um registro para o jogador
    if not resultId then
        db.query("INSERT INTO `player_online_tokens` (`player_id`, `amount`) VALUES (" .. playerId .. ", 0)")
    else
        result.free(resultId)
    end
    
    -- Obter quantidade de tokens que o jogador está segurando
    local tokenCount = item:getCount()
    
    -- Adicionar todos os tokens à conta do jogador
    db.query("UPDATE `player_online_tokens` SET `amount` = `amount` + " .. tokenCount .. " WHERE `player_id` = " .. playerId)
    
    -- Verificar o saldo atual
    local resultQuery = db.storeQuery("SELECT `amount` FROM `player_online_tokens` WHERE `player_id` = " .. playerId)
    local tokenAmount = 0
    
    if resultQuery then
        tokenAmount = result.getNumber(resultQuery, "amount")
        result.free(resultQuery)
    end
    
    -- Mensagem visual acima do personagem
    local message = "Added " .. tokenCount .. " Online Token(s). Balance: " .. tokenAmount
    player:say(message, TALKTYPE_MONSTER_SAY)
    
    -- Remover todos os tokens após uso
    item:remove(tokenCount)
    
    -- Efeito visual de sucesso
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    
    return true
end

onlineToken:id(62218) -- ID do token online
onlineToken:register()