local config = {
    charges   = 30000,
    weapons = {
        {name = "Exercise Sword", id = 28552},
        {name = "Exercise Axe",   id = 28553},
        {name = "Exercise Club",  id = 28554},
        {name = "Exercise Bow",   id = 28555},
        {name = "Exercise Rod",   id = 28556},
        {name = "Exercise Wand",  id = 28557},
        {name = "Exercise Wraps",  id = 50293},
    }
}

local MODAL_ID = 654322
local EVENT_NAME = "ExerciseCommandModal"
local STORAGE_CHOICE_ACTIVE = 654325
local STORAGE_EXERCISE_USED = 654324

local function sendExerciseModal(player)
    player:registerEvent(EVENT_NAME)

    local modal = ModalWindow(MODAL_ID, "Exercise Weapon", "Escolha sua Exercise Weapon:")

    for i, weapon in ipairs(config.weapons) do
        modal:addChoice(i, weapon.name)
    end

    modal:addButton(1, "Escolher")

    modal:setDefaultEnterButton(1)
    modal:setDefaultEscapeButton(1)  -- No escape, but if closed, we'll handle

    player:setStorageValue(STORAGE_CHOICE_ACTIVE, 1)

    if not modal:sendToPlayer(player) then
        player:setStorageValue(STORAGE_CHOICE_ACTIVE, -1)
        player:unregisterEvent(EVENT_NAME)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[ERRO] Falha ao abrir a escolha.")
        return false
    end

    return true
end

local exerciseCommand = TalkAction("!exercise")

function exerciseCommand.onSay(player, words, param)
    if player:getStorageValue(STORAGE_EXERCISE_USED) > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja utilizou este comando.")
        return false
    end

    if player:getStorageValue(STORAGE_CHOICE_ACTIVE) > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja tem uma escolha pendente.")
        return false
    end

    sendExerciseModal(player)
    return false
end

exerciseCommand:separator(" ")
exerciseCommand:groupType("normal")
exerciseCommand:register()

local exerciseModal = CreatureEvent(EVENT_NAME)

function exerciseModal.onModalWindow(player, modalWindowId, buttonId, choiceId)
    if modalWindowId ~= MODAL_ID then
        return false
    end

    if buttonId == 255 then  -- Closed without choosing
        sendExerciseModal(player)  -- Re-send modal to force choice
        return true
    end

    if buttonId ~= 1 or not choiceId or choiceId < 1 or choiceId > #config.weapons then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Escolha inválida. Tente novamente.")
        sendExerciseModal(player)  -- Re-send if invalid
        return true
    end

    -- Valid choice
    player:setStorageValue(STORAGE_CHOICE_ACTIVE, -1)
    player:unregisterEvent(EVENT_NAME)

    local selected = config.weapons[choiceId]
    local weapon = Game.createItem(selected.id, 1)

    if not weapon then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Erro ao criar a arma.")
        return true
    end

    weapon:setAttribute(ITEM_ATTRIBUTE_CHARGES, config.charges)
    weapon:setAttribute("store", 1)  -- Marca como item da store

    local inbox = player:getStoreInbox()
    if not inbox then
        weapon:remove()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Erro ao acessar a Store Inbox.")
        return true
    end

    local addResult = inbox:addItemEx(weapon)
    if addResult == RETURNVALUE_NOERROR then
        player:setStorageValue(STORAGE_EXERCISE_USED, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            "Você recebeu uma " .. selected.name .. " com " .. config.charges .. " cargas na sua Store Inbox!")
    else
        weapon:remove()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Não há espaço na sua Store Inbox.")
    end

    return true
end

exerciseModal:register()