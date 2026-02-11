local ACTION_ID = 33202
local MODAL_ID_PLAYER = 132201
local MODAL_ID_VALUE = 132202
local MIN_LEVEL = 300
local NAMES_PER_PAGE = 10

local bountyValues = {
    1000000,2000000,3000000,4000000,5000000,6000000,7000000,8000000,9000000,10000000,
    20000000,30000000,40000000,50000000,60000000,70000000,80000000,90000000,100000000,
    200000000,300000000,400000000,500000000,1000000000
}

local function formatKk(value)
    if value % 1000000 == 0 then
        return tostring(value / 1000000) .. "kk"
    elseif value % 1000 == 0 then
        return tostring(value / 1000) .. "k"
    else
        return tostring(value)
    end
end

local function getPlayersAboveLevel(level)
    local names = {}
    local query = string.format("SELECT name FROM players WHERE level > %d AND group_id = 1 AND account_id > 1", level)
    local resultId = db.storeQuery(query)
    if resultId then
        repeat
            table.insert(names, result.getString(resultId, "name"))
        until not result.next(resultId)
        result.free(resultId)
    end
    table.sort(names)
    return names
end

local function openValueModal(player, selectedName)
    local window = ModalWindow{
        id = MODAL_ID_VALUE,
        title = "Escolha o Valor",
        message = "Selecione o valor da recompensa (em gold):"
    }
    for _, value in ipairs(bountyValues) do
        window:addChoice(formatKk(value))
    end
    window:addButton("OK", function(player, button, choice)
        if not choice or not choice.id then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa selecionar um valor antes de confirmar.")
            return
        end
        local selectedValue = bountyValues[choice.id]
        if not selectedValue then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Valor invalido selecionado.")
            return
        end
        local param = selectedName .. " " .. selectedValue
        if type(addBounty) == "function" then
            addBounty(player, param)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sistema de hunted nao encontrado.")
        end
    end)
    window:addButton("Voltar", function(player)
        if type(openPlayerListModal) == "function" then
            openPlayerListModal(player)
        end
    end)
    window:sendToPlayer(player)
end

local function openPlayerListModal(player, playerNames, page)
    local allNames = playerNames or getPlayersAboveLevel(MIN_LEVEL)
    local total = #allNames
    if total == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nenhum jogador encontrado para este nivel.")
        return
    end
    local totalPages = math.ceil(total / NAMES_PER_PAGE)
    page = math.max(1, math.min(page or 1, totalPages))

    local window = ModalWindow{
        id = MODAL_ID_PLAYER,
        title = "Escolha um Jogador",
        message = string.format("Pagina %d de %d. Level %d+", page, totalPages, MIN_LEVEL)
    }
    local startIdx = (page - 1) * NAMES_PER_PAGE + 1
    local endIdx = math.min(startIdx + NAMES_PER_PAGE - 1, total)
    for i = startIdx, endIdx do
        window:addChoice(allNames[i])
    end

    window:addButton("Selecionar", function(player, button, choice)
        if not choice or not choice.id then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa selecionar um jogador antes de confirmar.")
            return
        end
        local selectedName = allNames[startIdx + choice.id - 1]
        if selectedName then
            openValueModal(player, selectedName)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nome invalido selecionado.")
        end
    end)

    if page > 1 then
        window:addButton("Anterior", function(player)
            openPlayerListModal(player, allNames, page - 1)
        end)
    end
    if page < totalPages then
        window:addButton("Proxima", function(player)
            openPlayerListModal(player, allNames, page + 1)
        end)
    end
    window:addButton("Cancelar", function(player)
        if _G.openMultiFunctionModal then
            _G.openMultiFunctionModal(player)
        end
    end)
    window:sendToPlayer(player)
end

_G.openPlayerListModal = openPlayerListModal

local playerListAction = Action()
function playerListAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.actionid == ACTION_ID then
        openPlayerListModal(player)
        return true
    end
    return false
end
playerListAction:id(3622)
playerListAction:aid(ACTION_ID)
playerListAction:register()
