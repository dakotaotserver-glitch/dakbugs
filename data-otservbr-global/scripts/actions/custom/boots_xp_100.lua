local doubleXpItem = Action()

local XP_BOOST_STORAGE = 65118             -- Storage para controle de cooldown
local BOOST_PERCENTAGE = 100               -- Porcentagem de boost de XP
local BOOST_DURATION = 60 * 60             -- Duração do efeito em segundos (1 hora)
local BOOST_COOLDOWN = 12 * 60 * 60        -- Tempo de espera entre usos (12 horas)

function doubleXpItem.onUse(player, item, fromPosition, itemEx, toPosition)
    local currentTime = os.time()
    local lastUseTime = player:getStorageValue(XP_BOOST_STORAGE)

    -- Se o boost ainda estiver em cooldown
    if lastUseTime ~= -1 and lastUseTime > currentTime then
        local remaining = lastUseTime - currentTime
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        local seconds = remaining % 60
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
            "Voce so podera usar este item novamente em %02d horas, %02d minutos e %02d segundos.", hours, minutes, seconds))
        return false
    end

    -- Salva o novo tempo de cooldown (12h a partir de agora)
    player:setStorageValue(XP_BOOST_STORAGE, currentTime + BOOST_COOLDOWN)

    -- Aplica o boost de XP
    player:setXpBoostPercent(BOOST_PERCENTAGE)
    player:setXpBoostTime(BOOST_DURATION)
    player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)

    -- Remove o item
    item:remove(1)

    -- Mensagem de ativacao
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ativou um boost de 100% de experiencia por 60 minutos!")

    -- Opcional: resetar o efeito visualmente quando acabar
    addEvent(function()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Seu boost de experiencia terminou.")
        player:setXpBoostPercent(0)
    end, BOOST_DURATION * 1000)

    return true
end

doubleXpItem:id(62144)
doubleXpItem:register()
