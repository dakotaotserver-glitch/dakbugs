-- Constantes de mensagem
local MESSAGE_STATUS_CONSOLE_BLUE = 17
local DEBUG_MODE = false -- Desativado por padrão, ative apenas para debug

-- Função de log simplificada
local function debugLog(message)
    if DEBUG_MODE then print("[DEBUG][Online Tokens] " .. message) end
end

-- Função para carregar tokens do banco de dados
local function getPlayerTokens(playerId)
    local resultId = db.storeQuery("SELECT `amount` FROM `player_online_tokens` WHERE `player_id` = " .. playerId)
    
    if resultId then
        local tokens = result.getNumber(resultId, "amount")
        result.free(resultId)
        return tokens
    else
        -- Criar novo registro para o jogador se não existir
        db.query("INSERT INTO `player_online_tokens` (`player_id`, `amount`) VALUES (" 
            .. playerId .. ", 0)")
        return 0
    end
end

-- Função para enviar a janela modal com o saldo de tokens
function sendTokensModalWindow(player, tokens)
    local window = ModalWindow{
        title = "Online Tokens",
        message = "Seu saldo atual de tokens:"
    }
    
    window:addChoice("Tokens: " .. tokens)
    
    window:addButton("Sair", function(player, button, choice) 
        -- Apenas fecha a janela
    end)
    
    window:sendToPlayer(player)
end

-- Comando !onlinetoken
local tokenTalkAction = TalkAction("!onlinetoken")

function tokenTalkAction.onSay(player, words, param)
    -- Usar getGuid() para obter o ID real do banco de dados
    local playerId = player:getGuid()
    
    if not playerId then
        debugLog("Falha ao obter GUID do jogador: " .. player:getName())
        return false
    end
    
    -- Carrega os tokens do jogador
    local tokens = getPlayerTokens(playerId)
    
    -- Mensagem e efeito visual
    player:say("Online Tokens Balance: " .. tokens, TALKTYPE_MONSTER_SAY)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    
    -- Abre a janela modal com os dados
    sendTokensModalWindow(player, tokens)
    
    return true
end


tokenTalkAction:groupType("normal")
tokenTalkAction:register()

