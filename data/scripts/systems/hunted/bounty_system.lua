-- Função split que estava faltando
local function splitString(str, sep)
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

-- Função para remover acentos
local function removeAccents(str)
    local accents = {
        ["á"] = "a", ["à"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a",
        ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
        ["í"] = "i", ["ì"] = "i", ["î"] = "i", ["ï"] = "i",
        ["ó"] = "o", ["ò"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o",
        ["ú"] = "u", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
        ["ç"] = "c",
        ["Á"] = "A", ["À"] = "A", ["Â"] = "A", ["Ã"] = "A", ["Ä"] = "A",
        ["É"] = "E", ["È"] = "E", ["Ê"] = "E", ["Ë"] = "E",
        ["Í"] = "I", ["Ì"] = "I", ["Î"] = "I", ["Ï"] = "I",
        ["Ó"] = "O", ["Ò"] = "O", ["Ô"] = "O", ["Õ"] = "O", ["Ö"] = "O",
        ["Ú"] = "U", ["Ù"] = "U", ["Û"] = "U", ["Ü"] = "U",
        ["Ç"] = "C"
    }
    return (str:gsub("[áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ]", accents))
end

-- Modo de depuração
local DEBUG_MODE = false
local function debugLog(message)
    if DEBUG_MODE then
        print("[DEBUG][Bounty System] " .. removeAccents(message))
    end
end

-- Definição de constantes de mensagens
local MESSAGE_STATUS_CONSOLE_RED = 19
local MESSAGE_EVENT_ADVANCE = 18 -- Use este tipo para feedbacks positivos
local MESSAGE_STATUS_CONSOLE_BLUE = 17
local MESSAGE_STATUS_CONSOLE_ORANGE = 18

-- Verifica se o jogador tem saldo suficiente
local function getPlayerCoins(player)
    local accountId = player:getAccountId()
    local resultId = db.storeQuery("SELECT `coins_transferable` FROM `accounts` WHERE `id` = " .. accountId)
    if resultId then
        local coins = result.getDataInt(resultId, "coins_transferable")
        result.free(resultId)
        return coins
    end
    return 0
end

-- Deduz coins do jogador
local function chargePlayerCoins(player)
    local coins = getPlayerCoins(player)
    if coins < 10 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Voce precisa de pelo menos 10 coins para adicionar um player na BLACKLIST.")
        return false
    end
    db.query("UPDATE `accounts` SET `coins_transferable` = `coins_transferable` - 10 WHERE `id` = " .. player:getAccountId())
    return true
end

-- Verifica se o jogador é premium e VIP
local function isPremiumAndVIP(player)
    return player:isPremium() and player:isVip()
end

-- Função GLOBAL para adicionar bounty
function addBounty(player, param)
    if not isPremiumAndVIP(player) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Voce precisa ser premium e VIP para adicionar alguem na BLACKLIST.")
        return true
    end

    if not chargePlayerCoins(player) then
        return true
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Use: \"!hunted [nick] [valor] \" Exemplo: !hunted PlayerName 1000")
        return true
    end

    -- Processa nome e valor da recompensa
    local t = splitString(param, " ")
    if #t < 2 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Formato incorreto. Exemplo: !hunted PlayerName 1000")
        return true
    end

    local prize = tonumber(t[#t])
    table.remove(t, #t)
    local targetName = table.concat(t, " ")

    if not prize or prize < 1000000 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "O valor minimo para colocar alguem na BLACKLIST e 1kk.")
        return true
    end

    -- Função para buscar nível do alvo
    local function getPlayerLevel(name)
        debugLog("Buscando nivel de: " .. name)
        local resultId = db.storeQuery("SELECT `level` FROM `players` WHERE `name` = " .. db.escapeString(name))
        if not resultId then
            debugLog("Jogador alvo nao encontrado")
            return nil
        end
        local level = result.getNumber(resultId, "level")
        result.free(resultId)
        return level
    end

    local targetLevel = getPlayerLevel(targetName)
    if not targetLevel then
        debugLog("Jogador alvo nao encontrado")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Jogador nao encontrado."))
        return true
    end

    if targetLevel < 300 then
        debugLog("Jogador alvo com nivel insuficiente.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("O jogador alvo precisa ter no minimo LVL 300 para entrar na BLACKLIST."))
        return true
    end

    debugLog("Nivel do alvo: " .. targetLevel)

    -- Função para obter GUID, level e vocation do alvo
    local function getPlayerInfoByName(name)
        debugLog("Buscando informacoes para: " .. name)
        local resultId = db.storeQuery("SELECT `id`, `level`, `vocation` FROM `players` WHERE `name` = " .. db.escapeString(name))
        if not resultId then
            debugLog("Informacoes do jogador nao encontradas")
            return nil, nil, nil
        end
        local guid = result.getNumber(resultId, "id")
        local level = result.getNumber(resultId, "level")
        local vocation = result.getNumber(resultId, "vocation")
        result.free(resultId)
        debugLog("GUID encontrado: " .. tostring(guid) .. ", Level: " .. level .. ", Vocacao: " .. vocation)
        return guid, level, vocation
    end

    local targetGuid, targetLevel, targetVocation = getPlayerInfoByName(targetName)
    debugLog("GUID do alvo: " .. tostring(targetGuid) .. ", Level: " .. tostring(targetLevel) .. ", Vocacao: " .. tostring(targetVocation))
    if not targetGuid then
        debugLog("Jogador alvo nao encontrado")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Este jogador nao existe."))
        return true
    end

    if targetGuid == player:getGuid() then
        debugLog("Tentativa de colocar bounty em si mesmo")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Voce nao pode colocar a si mesmo na lista de cacados."))
        return true
    end

    -- Verifica se o jogador tem dinheiro suficiente
    local bankBalance = player:getBankBalance()
    local moneyInHand = player:getMoney()
    local totalMoney = bankBalance + moneyInHand
    debugLog(string.format("Dinheiro do jogador - Banco: %d, Mao: %d, Total: %d, Necessario: %d",
        bankBalance, moneyInHand, totalMoney, prize))

    if totalMoney < prize then
        debugLog("Dinheiro insuficiente")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Voce nao tem dinheiro suficiente."))
        return true
    end

    -- Verifica se já existe um bounty para esse alvo
    debugLog("Verificando bounty existente")
    local resultId = db.storeQuery("SELECT id FROM bounty_list WHERE target_name = " .. db.escapeString(targetName))
    local bountyId
    if resultId then
        -- Se já existe, apenas recupera o ID (não altera expire_time aqui)
        bountyId = result.getNumber(resultId, "id")
        result.free(resultId)
    else
        -- Cria uma nova bounty
        local currentTime = os.time()
        db.query("INSERT INTO bounty_list (target_name, total_bounty, time, level, vocation, expire_time) VALUES (" ..
            db.escapeString(targetName) .. ", 0, " .. currentTime .. ", " .. targetLevel .. ", " .. targetVocation .. ", " .. (currentTime + 24 * 60 * 60) .. ")")
        local newResultId = db.storeQuery("SELECT id FROM bounty_list WHERE target_name = " .. db.escapeString(targetName))
        if not newResultId then
            debugLog("Erro ao criar nova bounty")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Ocorreu um erro ao processar sua solicitacao."))
            return true
        end
        bountyId = result.getNumber(newResultId, "id")
        result.free(newResultId)
        debugLog("Nova bounty criada no banco de dados. ID: " .. bountyId)
    end

    -- Verifica se o jogador já contribuiu para esta bounty
    local contributorGuid = player:getGuid()
    local contributionResult = db.storeQuery(
        "SELECT id FROM bounty_contributions WHERE bounty_id = " .. bountyId .. " AND contributor_guid = " .. contributorGuid
    )
    if contributionResult then
        debugLog("Jogador ja contribuiu para esta bounty")
        result.free(contributionResult)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Voce ja fez uma oferta para este jogador."))
        return true
    else
        debugLog("Nenhuma contribuicao encontrada para este jogador.")
    end

    -- Atualiza o valor total da bounty
    db.query("UPDATE bounty_list SET total_bounty = total_bounty + " .. prize .. " WHERE id = " .. bountyId)
    debugLog("Bounty atualizada no banco de dados. Novo valor adicionado: " .. prize)

    -- Registra quem pagou pela cabeça do alvo.
    local playerName = player:getName()
    local insertQuery = string.format(
        "INSERT INTO bounty_contributions (bounty_id, contributor_guid, contributor_name, amount) VALUES (%d, %d, %s, %d)",
        bountyId, contributorGuid, db.escapeString(playerName), prize
    )
    local success = db.query(insertQuery)
    if not success then
        debugLog("Erro ao registrar contribuicao no banco de dados.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Ocorreu um erro ao registrar sua contribuicao."))
        return true
    end

    debugLog("Contribuicao registrada no banco de dados.")

    -- Remove o dinheiro do jogador
    if moneyInHand >= prize then
        player:removeMoney(prize)
    else
        local remaining = prize - moneyInHand
        player:setBankBalance(bankBalance - remaining)
        player:removeMoney(moneyInHand)
    end

    debugLog("Dinheiro removido do jogador. Valor: " .. prize)

    -- Feedback ao jogador (tipo seguro para qualquer player)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, removeAccents("Voce colocou uma recompensa de " .. prize .. " gold em " .. targetName .. "."))

    -- Mensagem global: agora informamos quem está pagando
    local mensagemGlobal = removeAccents(
        "BLACKLIST ATUALIZADA >> "..targetName.." << "..prize.." gold por sua cabeca! Pago por "..playerName..""
    )
    Game.broadcastMessage(mensagemGlobal, MESSAGE_ADMINISTRATOR)

    debugLog("Mensagem enviada ao jogador: Voce colocou uma recompensa de " .. prize .. " gold em " .. targetName .. ".")
    debugLog("Mensagem global enviada: " .. mensagemGlobal)
    debugLog("Processo concluido com sucesso")
    return true
end

-- TalkAction: !hunted
local bounty = TalkAction("!hunted-desativado102030")
function bounty.onSay(player, words, param)
    return addBounty(player, param)
end

bounty:separator(" ")
bounty:groupType("normal")
bounty:register()
