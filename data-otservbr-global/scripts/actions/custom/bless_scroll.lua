local config = {
    scrollId = 61616,  -- ID do item Bless Scroll
}

local blessScroll = Action()
function blessScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Adicionar todas as bênçãos, independentemente se o jogador já tem ou não
    for i = 1, 8 do
        player:addBlessing(i, 1)
    end
    
    -- Enviar mensagem de confirmação
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received all blessings.")
    
    -- Efeito visual de bênção
    player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
    
    -- Remover o scroll após o uso
    item:remove(1)
    
    return true
end

blessScroll:id(config.scrollId)
blessScroll:register()