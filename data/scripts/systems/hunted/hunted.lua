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

-- Constantes de mensagem
local MESSAGE_STATUS_CONSOLE_RED = 19  -- Erros ou alertas críticos
local MESSAGE_STATUS_CONSOLE_BLUE = 17 -- Mensagens de sucesso ou informações importantes

-- Modo de depuração
local DEBUG_MODE = false

-- Função de log personalizada
local function debugLog(message)
    if DEBUG_MODE then
        print("[DEBUG][Bounty System] " .. removeAccents(message))
    end
end

-- Comando !blacklist
local huntedCommand = TalkAction("!blacklist-desativado102030")

function huntedCommand.onSay(player, words, param)
    debugLog("Comando !blacklist iniciado por: " .. player:getName())

    ------------------------------------------------------------------------
    -- 1) Remover bounties expiradas (expire_time < os.time())
    ------------------------------------------------------------------------
    local now = os.time()
    db.query("DELETE FROM bounty_list WHERE expire_time > 0 AND expire_time < " .. now)
    debugLog("Bounties expiradas foram removidas do banco de dados.")

    --------------------------------------------------------------------------
    -- NOVA QUERY:
    -- Usamos LEFT JOIN com bounty_contributions para agrupar todas as 
    -- contribuições. A função GROUP_CONCAT gera uma string com os nomes 
    -- e quantias contribuídas, separados por vírgula.
    -- AGORA INCLUÍMOS TAMBÉM O expire_time
    --------------------------------------------------------------------------
    local query = [[
        SELECT 
            bl.target_name AS targetName,
            p.level AS level,
            p.vocation AS vocation,
            bl.total_bounty AS totalBounty,
            bl.expire_time AS expireTime, -- para mostrarmos tempo restante
            GROUP_CONCAT(
                CONCAT(contrib.contributor_name, ' (', contrib.amount, ')')
                SEPARATOR ', '
            ) AS contributorList
        FROM bounty_list bl
        INNER JOIN players p ON p.name = bl.target_name
        LEFT JOIN bounty_contributions contrib ON contrib.bounty_id = bl.id
        GROUP BY bl.id
        ORDER BY bl.total_bounty DESC
    ]]

    -- Consulta no banco
    local resultId = db.storeQuery(query)
    if not resultId then
        debugLog("Nenhum bounty ativo encontrado.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Nenhum jogador esta na lista de Hunted no momento."))
        return true
    end

    local bountyList = {}
    repeat
        local targetName     = result.getString(resultId, "targetName")
        local level          = result.getNumber(resultId, "level")
        local vocation       = result.getNumber(resultId, "vocation")
        local totalBounty    = result.getNumber(resultId, "totalBounty")
        local contributorStr = result.getString(resultId, "contributorList")
        local expireTime     = result.getNumber(resultId, "expireTime")

        -- Em casos raros, se não houver contribuições, contributorStr pode ser nil ou "NULL"
        if not contributorStr or contributorStr == "NULL" then
            contributorStr = "Nenhum contribuinte registrado"
        end

        -- Mapeia vocação
local vocationName = "Desconhecido"
if vocation == 1 then
    vocationName = "Sorcerer"
elseif vocation == 2 then
    vocationName = "Druid"
elseif vocation == 3 then
    vocationName = "Paladin"
elseif vocation == 4 then
    vocationName = "Knight"
elseif vocation == 5 then
    vocationName = "Master Sorcerer"
elseif vocation == 6 then
    vocationName = "Elder Druid"
elseif vocation == 7 then
    vocationName = "Royal Paladin"
elseif vocation == 8 then
    vocationName = "Elite Knight"
elseif vocation == 9 then
    vocationName = "Monk"
elseif vocation == 10 then
    vocationName = "Exalted Monk"
end


        ----------------------------------------------------------------------
        -- Cálculo do TEMPO RESTANTE (se expire_time > now)
        ----------------------------------------------------------------------
        local timeLeft = expireTime - os.time()
        if timeLeft < 0 then
            timeLeft = 0
        end
        -- Converte em horas e minutos
        local hours = math.floor(timeLeft / 3600)
        local minutes = math.floor((timeLeft % 3600) / 60)

        local tempoRestanteStr
        if hours > 0 then
            tempoRestanteStr = string.format("%d hora(s) e %d minuto(s)", hours, minutes)
        else
            tempoRestanteStr = string.format("%d minuto(s)", minutes)
        end

        ----------------------------------------------------------------------
        -- Monta a string de exibição. Incluímos "Quem contribuiu (quanto)" 
        -- e agora "Tempo restante"
        ----------------------------------------------------------------------
        table.insert(bountyList, string.format(
            "Nome: %s\nLevel: %d\nVocacao: %s\nValor Acumulado: %d gold\nLances: %s\nTempo: %s\n-----------------------------",
            targetName, level, vocationName, totalBounty, contributorStr, tempoRestanteStr
        ))
    until not result.next(resultId)
    result.free(resultId)

    -- Verifica se há bounties ativos
    if #bountyList == 0 then
        debugLog("Nenhum bounty ativo encontrado apos processamento.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, removeAccents("Nenhum jogador esta na lista de Hunted no momento."))
        return true
    end

    -- Cria a mensagem final
    local message = "======= LISTA DE HUNTED'S =======\n\n" .. table.concat(bountyList, "\n") .. "\n\n<---------------------------------------->"

    -- Exibe a lista em uma janela de texto
    player:showTextDialog(639, removeAccents(message))
    debugLog("Lista de bounty exibida para o jogador: " .. player:getName())

    return true
end

-- Registro do comando
huntedCommand:separator(" ")
huntedCommand:groupType("normal")
huntedCommand:register()

debugLog("Comando !blacklist inicializado")
