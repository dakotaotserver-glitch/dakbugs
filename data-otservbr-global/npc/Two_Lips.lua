local internalNpcName = "Two Lips"
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

local habitantes = player:getStorageValue(Storage.U13_40.podzilla.habitantes)
local salaboss   = player:getStorageValue(Storage.U13_40.podzilla.salaboss)


-- Agora a verificação
if not ((habitantes == 2) or (habitantes == 4 and salaboss == 2)) then
    npcHandler:say("Nao posso falar com voce agora.", npc, creature)
    return true
end


    -- [2] Nova lógica para quem tem habitantes=4 e salaboss=2:
    -- Se o jogador está na parte final da quest, abrimos um mini-fluxo sobre "mission" e "outfit".
    if habitantes == 4 and salaboss == 2 then
        -- Se o player disser "mission", oferecemos a fala sobre a recompensa.
        if text:find("mission") then
            npcHandler:say(
                "Parabens, aventureiro! Voce conseguiu nos livrar de todo o mal que nos cercava. Finalmente o doutor foi embora e agora podemos viver em paz! Como prometido, tenho uma recompensa para voce. O que voce acha de uma nova e poderosa {outfit}?",
                npc, creature
            )
            npcHandler:setTopic(playerId, 50)
            return true
        end

        -- Se o player disser "outfit" E estivermos no topic=50, damos a recompensa.
        if text:find("outfit") and topic == 50 then
            -- Dá outfit dependendo do sexo
            if player:getSex() == PLAYERSEX_FEMALE then
                player:addOutfit(1775) -- Female
            else
                player:addOutfit(1774) -- Male
            end
            -- Efeito de cura vermelho
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
            -- Atualiza a storage para 3 (quest concluída)
            player:setStorageValue(Storage.U13_40.podzilla.salaboss, 3)

            npcHandler:say("Aqui esta sua nova outfit! Obrigado por tudo que fez por nos.", npc, creature)
            npcHandler:setTopic(playerId, 0)
            return true
        end

        -- Caso o jogador não tenha digitado "mission" nem "outfit", mas esteja nesse estágio,
        -- podemos fazer um 'prompt' amigável:
        if topic == 0 then
            npcHandler:say("Ola, meu nobre! Conseguiu completar sua {mission}?", npc, creature)
            return true
        end

        -- Repare que se o jogador digitar algo muito fora do contexto
        -- e não estiver no topic 50, o script cai mais adiante (return false).
    end

    -- [3] Lógica antiga permanece inalterada daqui pra baixo

    -- Se o jogador tem habitantes == 2 (o estado original), a lógica antiga roda normal:
    if text:find("doutor") then
        npcHandler:say(
            "Entao voce ja sabe sobre o vigarista e infame Doutor Marrow! Ele criou uma criatura assustadora e abominavel que o serve, e ele detem total controle sobre ela. Tem certeza que quer enfrenta-la? {yes} ou {no}?",
            npc, creature
        )
        npcHandler:setTopic(playerId, 1)
        return true
    end

    if topic == 1 then
        if text == "yes" then
            npcHandler:say(
                "Ok! Ha rumores de que esse tal doutor criou geradores que os tornam imortais, entao e muito importante que voce os destrua se quiser realmente lutar contra esses demonios. Quer saber mais? {yes} ou {no}?",
                npc, creature
            )
            npcHandler:setTopic(playerId, 2)
        else
            npcHandler:say("Sem problemas. Volte quando estiver pronto para enfrentar esse desafio.", npc, creature)
            npcHandler:setTopic(playerId, 0)
        end
        return true
    end

    if topic == 2 then
        if text == "yes" then
            npcHandler:say(
                "Infelizmente, nao posso mais te ajudar... isso e tudo que eu sei. Meu {irmao} mais velho seguia os passos do doutor; porem, ele percebeu todo o mal antes de ser corrompido. Fale com ele! Pergunte sobre o experimento diabolico do Doutor Marrow, pois ele deve ter mais informacoes sobre esta terrivel criatura.",
                npc, creature
            )
            npcHandler:setTopic(playerId, 3)
        else
            npcHandler:say("Tudo bem, boa sorte em sua jornada, valente!", npc, creature)
            npcHandler:setTopic(playerId, 0)
        end
        return true
    end

    if topic == 3 and text:find("irmao") then
        npcHandler:say(
            "O nome do meu irmao e Sprout Sentinel. Ele ira te ajudar sem duvidas. Mas nao se esqueca: caso derrote esses malfeitores, volte ate mim e reporte a missao, pois tenho uma recompensa pra voce. Esta bem? {yes} ou {no}?",
            npc, creature
        )
        npcHandler:setTopic(playerId, 4)
        return true
    end

    if topic == 4 then
        if text == "yes" then
            npcHandler:say("Boa sorte, nobre corajoso!", npc, creature)
            player:setStorageValue(Storage.U13_40.podzilla.habitantes, 3)
        else
            npcHandler:say("Entendo. De qualquer modo, estarei aqui se mudar de ideia.", npc, creature)
        end
        npcHandler:setTopic(playerId, 0)
        return true
    end

    return false
end

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! How can I help you today? {doutor} or {mission} ?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
