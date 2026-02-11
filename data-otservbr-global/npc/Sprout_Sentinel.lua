local internalNpcName = "Sprout Sentinel"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1762,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
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

    -- Somente interage se a storage == 2
    if player:getStorageValue(Storage.U13_40.podzilla.habitantes) ~= 3 then
        npcHandler:say("Nao posso falar com voce agora.", npc, creature)
        return true
    end

    -- 1) Gatilho inicial: "experimento"
    if text:find("experimento") then
        npcHandler:say(
            "Eu seguia o Doutor como seu servo, achando que ele estava fazendo o bem para o nosso lar. " ..
            "No entanto, descobri a tempo de abandona-lo e me esconder aqui que na verdade ele estava criando uma arma mortal para destruir tudo que habita no mundo Tibiano. " ..
            "O nome dessa arma e {The Rootkraken}, uma criatura cruel e maligna, de forca assustadora. " ..
            "Descobri alguns pontos fracos por acidente, enquanto ainda o servia...",
            npc, creature
        )
        npcHandler:setTopic(playerId, 1)
        return true
    end

    -- 2) Se o topico for 1, aguarda "the rootkraken"
    if topic == 1 then
        if text:find("the rootkraken") then
            npcHandler:say(
                "Ok, escute com atencao. Se ela estiver em movimento, nao consegue se teleportar para lugar nenhum. " ..
                "Tambem tem seus sumons que se nao forem mortos rapidamente se transformam e ficam mais fortes ainda, " ..
                "entao recomendo que nao exite em destrui-los sempre que puder. " ..
                "O esconderijo dela e confidencial, mas como eu fazia parte de sua legiao, ainda tenho o encantamento para entrar. " ..
                "Contudo, e uma {mission} suicida, ninguem teria tal coragem...",
                npc, creature
            )
            npcHandler:setTopic(playerId, 2)
        else
            npcHandler:say("Tudo bem, se mudar de ideia, estarei aqui.", npc, creature)
            npcHandler:setTopic(playerId, 0)
        end
        return true
    end

    -- 3) Se o topico for 2, aguarda "missao"
    if topic == 2 then
        if text:find("mission") then
            npcHandler:say(
                "Vejo que voce e muito corajoso e pode realmente se tornar o heroi que salvara todo o mundo Tibiano dessa diabolica criatura. " ..
                "Posso confiar o acesso ao covil deste monstro a voce? {yes} ou {no}?",
                npc, creature
            )
            npcHandler:setTopic(playerId, 3)
        else
            npcHandler:say("Se nao quiser encarar essa tarefa, nao o culpo. Mas estarei aqui se mudar de ideia.", npc, creature)
            npcHandler:setTopic(playerId, 0)
        end
        return true
    end

    -- 4) Se o topico for 3, espera "yes" ou "no"
    if topic == 3 then
        if text == "yes" then
            npcHandler:say(
                "Agora voce tem acesso ao laboratorio secreto do Doutor Marrow e tambem ao local onde esta esse monstro terrivel. " ..
                "Tome muito cuidado!",
                npc, creature
            )
            -- Altera storage para 3 e aplica efeito de cura vermelha
            player:setStorageValue(Storage.U13_40.podzilla.habitantes, 4)
			player:setStorageValue(Storage.U13_40.podzilla.salaboss, 1)
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
        else
            npcHandler:say("Entendo. De qualquer modo, estarei aqui se mudar de ideia.", npc, creature)
        end
        npcHandler:setTopic(playerId, 0)
        return true
    end

    return false
end

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! How can I help you today? {experimento} ?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
