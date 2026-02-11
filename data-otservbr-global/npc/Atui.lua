local internalNpcName = "Atui"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "A Atui"
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 533,
    lookHead = 0,
    lookBody = 82,
    lookLegs = 76,
    lookFeet = 0,
    lookAddons = 0,
    lookMount = 0,
}

npcConfig.flags = {
    floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
    npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
    npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
    npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
    npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
    npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
    npcHandler:onCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, msg)
    local player = Player(creature)
    if not player then
        return false
    end
    local playerId = player:getId()
    local text = msg:lower()
    local topic = npcHandler:getTopic(playerId)

    -- Verifica se o jogador tem a storage necessaria
    if player:getStorageValue(Storage.U13_40.podzilla.habitantes) ~= 1 then
        npcHandler:say("Nao posso falar com voce agora.", npc, creature)
        return true
    end

    if text:find("misterios") then
        npcHandler:say("Ha muito tempo vivo nestas profundezas, no entanto alguns anos atras um cientista meio esquisito e com promessas boas e mentirosas corrompeu este lugar, transformando um lindo e tranquilo lar em um laboratorio maligno e sombrio, criando um exercito das trevas, jurando destruir todo o mundo tibiano. Sei que deve estar assustado, quer saber mais? {yes} ou {nao}", npc, creature)
        npcHandler:setTopic(playerId, 1)
        return true
    end

    if topic == 1 then
        if text == "yes" then
        npcHandler:say("Nem deveria estar te contando tal segredo, posso perder a cabeca por isso, mas nao aguento mais saber que o mundo inteiro esta em perigo. Este tal doutor criou uma criatura monstruosa a qual todos temem, e e com ela que ele planeja destruir tudo e a todos. Nunca pense em enfrenta-la, pois so de falar o nome dela esse lugar ja estremece. Desculpe, mas nao posso falar mais. Se quiser saber mais, fale com os outros habitantes que ainda nao foram corrompidos pelo misterioso doutor. Depois de tudo que te contei, ainda deseja prosseguir com essa jornada? {yes} ou {nao}", npc, creature)
        npcHandler:setTopic(playerId, 2)
        else
            npcHandler:say("Sem problemas. Volte quando estiver pronto para enfrentar esse desafio.", npc, creature)
            npcHandler:setTopic(playerId, 0)
        end
        return true
    end


    if topic == 2 then
        if text == "yes" then
            npcHandler:say("Boa sorte! Fale com o Two Lips.", npc, creature)
            player:setStorageValue(Storage.U13_40.podzilla.habitantes, 2)
        else
            npcHandler:say("Entendo. De qualquer modo, estarei aqui se mudar de ideia.", npc, creature)
        end
        npcHandler:setTopic(playerId, 0)
        return true
    end

    return false
end

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! How can I help you today? {misterios} ?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
