-- blacklist_action.lua (ModalWindow version)
-- Remove acentos para exibir corretamente na Modal
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

-- Blacklist como ModalWindow (paginando se necessario)
local BLACKLIST_MODAL_ID = 912345
local BLACKLIST_PER_PAGE = 5  -- Mostra 5 players por pagina

local function showBlacklistModal(player, bountyList, page)
    page = page or 1
    local total = #bountyList
    local maxPage = math.ceil(total / BLACKLIST_PER_PAGE)
    local startIndex = (page-1)*BLACKLIST_PER_PAGE + 1
    local endIndex = math.min(page*BLACKLIST_PER_PAGE, total)
    
    local msg = "******** HUNTED'S ******** \n\n"
    if total == 0 then
        msg = msg .. "Nenhum jogador esta na blacklist.\n"
    else
        for i = startIndex, endIndex do
            msg = msg .. bountyList[i] .. "\n"
        end
        msg = msg .. string.format("\nPagina %d/%d", page, maxPage)
    end
    
    local window = ModalWindow{
        id = BLACKLIST_MODAL_ID,
        title = "Blacklist de Hunted",
        message = removeAccents(msg)
    }
    if page > 1 then window:addButton("Anterior", function(p) showBlacklistModal(p, bountyList, page-1) end) end
    if page < maxPage then window:addButton("Proxima", function(p) showBlacklistModal(p, bountyList, page+1) end) end
    window:addButton("Voltar", function(p)
        if type(_G.openMultiFunctionModal) == "function" then
            _G.openMultiFunctionModal(p)
        end
    end)
    window:addButton("Fechar")
    window:sendToPlayer(player)
end

-- Função principal para gerar a lista e abrir Modal
function showBlacklistDialog(player)
    local now = os.time()
    db.query("DELETE FROM bounty_list WHERE expire_time > 0 AND expire_time < " .. now)
    local query = [[
        SELECT 
            bl.target_name AS targetName,
            p.level AS level,
            p.vocation AS vocation,
            bl.total_bounty AS totalBounty,
            bl.expire_time AS expireTime,
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
    local resultId = db.storeQuery(query)
    local bountyList = {}
    if resultId then
        repeat
            local targetName  = result.getString(resultId, "targetName")
            local level       = result.getNumber(resultId, "level")
            local vocation    = result.getNumber(resultId, "vocation")
            local totalBounty = result.getNumber(resultId, "totalBounty")
            local contributorStr = result.getString(resultId, "contributorList")
            local expireTime  = result.getNumber(resultId, "expireTime")

            if not contributorStr or contributorStr == "NULL" then
                contributorStr = "Nenhum contribuinte registrado"
            end

            local vocationName = "Desconhecido"
            if vocation == 1 then vocationName = "Sorcerer"
            elseif vocation == 2 then vocationName = "Druid"
            elseif vocation == 3 then vocationName = "Paladin"
            elseif vocation == 4 then vocationName = "Knight"
            elseif vocation == 5 then vocationName = "Master Sorcerer"
            elseif vocation == 6 then vocationName = "Elder Druid"
            elseif vocation == 7 then vocationName = "Royal Paladin"
            elseif vocation == 8 then vocationName = "Elite Knight"
            elseif vocation == 9 then vocationName = "Monk"
            elseif vocation == 10 then vocationName = "Exalted Monk"
            end

            local timeLeft = expireTime - os.time()
            if timeLeft < 0 then timeLeft = 0 end
            local hours = math.floor(timeLeft / 3600)
            local minutes = math.floor((timeLeft % 3600) / 60)
            local tempoRestanteStr
            if hours > 0 then
                tempoRestanteStr = string.format("%d hora(s) e %d minuto(s)", hours, minutes)
            else
                tempoRestanteStr = string.format("%d minuto(s)", minutes)
            end

            table.insert(bountyList, string.format(
                "Nome: %s\nLevel: %d\nVocacao: %s\nValor: %d gold\nLances: %s\nTempo: %s\n==============================================",
                targetName, level, vocationName, totalBounty, contributorStr, tempoRestanteStr
            ))
        until not result.next(resultId)
        result.free(resultId)
    end
    showBlacklistModal(player, bountyList, 1)
    return true
end

-- Action padrao (opcional, caso queira usar no item)
local blacklistAction = Action()
function blacklistAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    return showBlacklistDialog(player)
end
blacklistAction:aid(33201)
blacklistAction:register()

-- Exporta funcao global para action multifuncao
_G.showBlacklistDialog = showBlacklistDialog
