local ropeshovel = TalkAction("!tools")

-- Garantia de que Storage.Tools está definida
Storage = Storage or {}
Storage.Tools = Storage.Tools or 10002 -- Substitua 10002 por um ID único

-- Função principal do comando
function ropeshovel.onSay(player, words, param)
    -- Verifica se o jogador é válido
    if not player or not player:isPlayer() then

        return false
    end

    -- Define o tempo de espera entre usos do comando
    local usedelay = 5 -- em segundos

    -- Verifica se o tempo de espera já passou
    local currentTime = os.time()
    local nextUse = player:getStorageValue(Storage.Tools)
    if nextUse > currentTime then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa esperar " .. (nextUse - currentTime) .. " segundos para usar este comando novamente.")
        return false
    end

    -- Verifica e entrega cada ferramenta
    local tools = {
        {id = 3457, name = "shovel"}, -- Pá
        {id = 3003, name = "rope"},   -- Corda
        {id = 3456, name = "pick"},   -- Picareta
        {id = 3308, name = "machete"} -- Facão
    }

    for _, tool in ipairs(tools) do
        if player:getItemCount(tool.id) >= 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja possui uma " .. tool.name .. ".")
        else
            player:addItem(tool.id, 1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce recebeu uma " .. tool.name .. "!")
        end
    end

    -- Atualiza o tempo de espera
    player:setStorageValue(Storage.Tools, currentTime + usedelay)
    return true
end

ropeshovel:groupType("normal") -- Define o tipo de grupo permitido para usar o comando
ropeshovel:register() -- Registra o comando
