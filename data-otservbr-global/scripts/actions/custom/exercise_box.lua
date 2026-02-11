local config = {
    boxItemId = 20313,
    charges   = 72000,
    weapons = {
        {name = "Exercise Sword", id = 28552},
        {name = "Exercise Axe",   id = 28553},
        {name = "Exercise Club",  id = 28554},
        {name = "Exercise Bow",   id = 28555},
        {name = "Exercise Rod",   id = 28556},
        {name = "Exercise Wand",  id = 28557},
        {name = "Exercise Wraps", id = 50293},
    }
}

local MODAL_ID = 654321
local EVENT_NAME = "ExerciseBoxModal"
local STORAGE_CHOICE_ACTIVE = 654323

local exerciseBox = Action()

function exerciseBox.onUse(player, item)
    if item:getId() ~= config.boxItemId then
        return false
    end

    if player:getStorageValue(STORAGE_CHOICE_ACTIVE) > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você já tem uma escolha pendente.")
        return true
    end

    player:registerEvent(EVENT_NAME)

    local modal = ModalWindow(MODAL_ID, "Exercise Box", "Escolha sua Exercise Weapon:")

    for i, weapon in ipairs(config.weapons) do
        modal:addChoice(i, weapon.name)
    end

    modal:addButton(1, "Escolher")
    modal:addButton(2, "Cancelar")

    modal:setDefaultEnterButton(1)
    modal:setDefaultEscapeButton(2)

    player:setStorageValue(STORAGE_CHOICE_ACTIVE, 1)

    if not modal:sendToPlayer(player) then
        player:setStorageValue(STORAGE_CHOICE_ACTIVE, -1)
        player:unregisterEvent(EVENT_NAME)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[ERRO] Falha ao abrir a escolha.")
        return true
    end

    return true
end

exerciseBox:id(config.boxItemId)
exerciseBox:register()

local exerciseModal = CreatureEvent(EVENT_NAME)

function exerciseModal.onModalWindow(player, modalWindowId, buttonId, choiceId)
    if modalWindowId ~= MODAL_ID then
        return false
    end

    player:setStorageValue(STORAGE_CHOICE_ACTIVE, -1)
    player:unregisterEvent(EVENT_NAME)

    if buttonId == 2 or buttonId == 255 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você cancelou a escolha.")
        return true
    end

    if buttonId ~= 1 or not choiceId or choiceId < 1 or choiceId > #config.weapons then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Escolha inválida.")
        return true
    end

    local selected = config.weapons[choiceId]
    local weapon = Game.createItem(selected.id, 1)

    if not weapon then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Erro ao criar a arma.")
        return true
    end

    weapon:setAttribute(ITEM_ATTRIBUTE_CHARGES, config.charges)

    local addResult = player:addItemEx(weapon)
    if addResult == RETURNVALUE_NOERROR then
        -- Função para remover a caixa em qualquer container
        local function removeExerciseBox()
            local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
            if backpack and backpack:getId() == config.boxItemId then
                backpack:remove(1)
                return true
            end

            local storeInbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
            if storeInbox and storeInbox:getId() == config.boxItemId then
                storeInbox:remove(1)
                return true
            end

            local function searchInContainer(container)
                if not container then return false end
                for i = 0, container:getSize() - 1 do
                    local subItem = container:getItem(i)
                    if subItem then
                        if subItem:getId() == config.boxItemId then
                            subItem:remove(1)
                            return true
                        end
                        if subItem:isContainer() then
                            if searchInContainer(subItem) then
                                return true
                            end
                        end
                    end
                end
                return false
            end

            if backpack and backpack:isContainer() then
                if searchInContainer(backpack) then return true end
            end

            return false
        end

        if removeExerciseBox() then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                "Você recebeu uma " .. selected.name .. " com " .. config.charges .. " cargas!")
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                "Você recebeu a arma, mas a caixa não foi removida (verifique se moveu ela).")
        end
    else
        weapon:remove()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você não tem espaço no inventário.")
    end

    return true
end

exerciseModal:register()