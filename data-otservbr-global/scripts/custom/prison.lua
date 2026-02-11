-- SISTEMA COMPLETO DE PRISAO COM DESAFIO MATEMATICO E 3 TENTATIVAS

local prison = {
    storage = 59999,
    cellStorage = 59998,
    prisonCountStorage = 59800,
    exhaustStorage = 60000,
    materialId = 22720,
    chance = 20,
    miningExhaust = 2,
    minedEffect = 50,
    failEffect = CONST_ME_POFF,
    pickId = 31615,
    rockMineId = 1910,
    smallRockId = 1913,
    rockMineRegeneration = 5,
    templePosition = Position(32369,32241,7),
    wagonAid = 39011,
    MiningRockActionId = 39012,
    cellsOccupied = 60001,
    cells = {
        Position(37302, 22072, 14), Position(37306, 22072, 14),
        Position(37311, 22072, 14), Position(37316, 22072, 14),
        Position(37321, 22072, 14), Position(37326, 22072, 14),
        Position(37326, 22065, 14), Position(37321, 22065, 14),
        Position(37316, 22065, 14), Position(37311, 22065, 14),
        Position(37306, 22065, 14), Position(37302, 22065, 14)
    }
}

local function isCellOccupied(index)
    return Game.getStorageValue(prison.cellsOccupied + index) == 1
end

local function setCellOccupied(index, status)
    Game.setStorageValue(prison.cellsOccupied + index, status and 1 or 0)
end

local function findAvailableCell()
    for i, pos in ipairs(prison.cells) do
        if not isCellOccupied(i) then
            return i, pos
        end
    end
    return nil
end

local function updatePrisonCount(player)
    local count = player:getStorageValue(prison.prisonCountStorage)
    player:setStorageValue(prison.prisonCountStorage, count > 0 and count + 1 or 1)
    return player:getStorageValue(prison.prisonCountStorage)
end

-- SISTEMA DE PERGUNTA
local mathChallenge = {}
mathChallenge.active = {}
mathChallenge.timeLimit = 300
mathChallenge.repeatDelay = 20

local function generateMathQuestion()
    local ops = {"+", "-", "*", "/"}
    local a, b, op, answer

    while true do
        op = ops[math.random(#ops)]

        if op == "+" then
            a = math.random(1, 20)
            b = math.random(1, 20)
            answer = a + b
        elseif op == "-" then
            a = math.random(1, 20)
            b = math.random(1, a)
            answer = a - b
        elseif op == "*" then
            a = math.random(1, 10)
            b = math.random(1, 10)
            answer = a * b
        elseif op == "/" then
            b = math.random(2, 10)
            answer = math.random(1, 10)
            a = b * answer
        end

        if answer ~= 0 then break end
    end

    local question = "Quanto e " .. a .. " " .. op .. " " .. b .. "?"
    return question, answer
end

local function sendQuestionReminder(pid)
    local player = Player(pid)
    local data = mathChallenge.active[pid]
    if player and data then
        player:say("[Desafio] " .. data.question .. " (responda com /responder numero)", TALKTYPE_MONSTER_SAY)
        data.repeatEvent = addEvent(sendQuestionReminder, mathChallenge.repeatDelay * 1000, pid)
    end
end

local function failToAnswer(pid)
    local targetPlayer = Player(pid)
    if not targetPlayer then return end

    local cellIndex, cellPos = findAvailableCell()
    if not cellIndex then return end

    setCellOccupied(cellIndex, true)
    local prisonCount = updatePrisonCount(targetPlayer)
    local tokensRequired = prisonCount * 25

    targetPlayer:setStorageValue(prison.storage, tokensRequired)
    targetPlayer:setStorageValue(prison.cellStorage, cellIndex)
    targetPlayer:teleportTo(cellPos)
    targetPlayer:addItem(prison.pickId, 1)
    targetPlayer:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Voce foi preso! Serao necessarios " .. tokensRequired .. " tokens para sair.")

    mathChallenge.active[pid] = nil
end

local prisonTalkaction = TalkAction("/prison")
function prisonTalkaction.onSay(player, words, param)
    if player:getGroup():getAccess() and param ~= "" then
        local targetPlayer = Player(param)
        if not targetPlayer then
            player:sendCancelMessage("Player offline ou nome incorreto.")
            return false
        end

        if mathChallenge.active[targetPlayer:getId()] then
            player:sendCancelMessage("Este jogador ja esta respondendo um desafio.")
            return false
        end

        local question, answer = generateMathQuestion()
        local pid = targetPlayer:getId()
        mathChallenge.active[pid] = {
            question = question,
            answer = answer,
            attempts = 0,
            timerEvent = addEvent(failToAnswer, mathChallenge.timeLimit * 1000, pid)
        }

        targetPlayer:say("[Desafio] " .. question .. " (responda com /responder numero)", TALKTYPE_MONSTER_SAY)
        sendQuestionReminder(pid)

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Desafio iniciado para " .. targetPlayer:getName() .. ".")
        return false
    end
end
prisonTalkaction:separator(" ")
prisonTalkaction:groupType("god")
prisonTalkaction:register()

local responder = TalkAction("/responder")
function responder.onSay(player, words, param)
    local pid = player:getId()
    local challenge = mathChallenge.active[pid]
    if not challenge then
        player:sendCancelMessage("Voce nao tem uma pergunta ativa.")
        return false
    end

    local answer = tonumber(param)
    if not answer then
        player:sendCancelMessage("Use apenas numeros. Ex: /responder 4")
        return false
    end

    if answer == challenge.answer then
        stopEvent(challenge.timerEvent)
        stopEvent(challenge.repeatEvent)
        mathChallenge.active[pid] = nil
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Resposta correta! Voce escapou da prisao.")
    else
        challenge.attempts = challenge.attempts + 1
        if challenge.attempts >= 3 then
            stopEvent(challenge.timerEvent)
            stopEvent(challenge.repeatEvent)
            player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Voce errou 3 vezes. Sera enviado diretamente para a prisao.")
            failToAnswer(pid)
        else
            local remaining = 3 - challenge.attempts
            player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Resposta incorreta! Voce ainda tem " .. remaining .. " tentativa(s).")
        end
    end
    return false
end
responder:separator(" ")
responder:groupType("normal")
responder:register()

-- ACTION DO WAGON E PICK (REINSERIDOS)

local wagon = Action()
function wagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tokensRequired = player:getStorageValue(prison.storage)
    local tokensCount = player:getItemCount(prison.materialId)

    if tokensCount >= tokensRequired then
        local cellIndex = player:getStorageValue(prison.cellStorage)
        setCellOccupied(cellIndex, false)
        player:removeItem(prison.pickId, 1)
        player:removeItem(prison.materialId, tokensCount)
        player:setStorageValue(prison.storage, 0)
        player:setStorageValue(prison.cellStorage, 0)
        player:teleportTo(prison.templePosition)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce foi libertado da prisao.")
        return true
    end

    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Voce ainda precisa de " .. (tokensRequired - tokensCount) .. " tokens para sair.")
    return false
end
wagon:aid(prison.wagonAid)
wagon:register()

local prisonPick = Action()
function prisonPick.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tile = Tile(toPosition)
    if not tile or not tile:getItemById(prison.rockMineId) then return false end
    if target:getActionId() ~= prison.MiningRockActionId then return false end

    if player:getStorageValue(prison.exhaustStorage) > os.time() then
        player:sendCancelMessage("Voce esta exausto.")
        return true
    end

    player:setStorageValue(prison.exhaustStorage, os.time() + prison.miningExhaust)
    player:sendCancelMessage("Swing!")

    if math.random(1, 100) > prison.chance then
        toPosition:sendMagicEffect(prison.failEffect)
        player:sendCancelMessage("Nada encontrado.")
        return true
    end

    toPosition:sendMagicEffect(prison.minedEffect)
    player:addItem(prison.materialId, 1)

    local pos = toPosition
    target:remove(1)

    addEvent(function(p)
        local t = Tile(p)
        if t and type(t) == "userdata" then
            local smallRock = t:getItemById(prison.smallRockId)
            if smallRock and type(smallRock) == "userdata" then
                smallRock:remove(1)
            end
            local newRock = Game.createItem(prison.rockMineId, 1, p)
            if newRock then
                newRock:setActionId(prison.MiningRockActionId)
            end
        end
    end, prison.rockMineRegeneration * 1000, pos)

    Game.createItem(prison.smallRockId, 1, pos)
    return true
end
prisonPick:id(prison.pickId)
prisonPick:register()
