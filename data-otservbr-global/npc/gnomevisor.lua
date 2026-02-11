local internalNpcName = "Gnomevisor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = "A Gnomevisor"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 493,
    lookHead = 79,
    lookBody = 92,
    lookLegs = 79,
    lookFeet = 115,
    lookAddons = 0,
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

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    -- Troca de Eldritch Crystal (ID 36835) pela montaria Shellodon (ID 183)
    if MsgContains(message, "shellodon") then
        if player:hasMount(183) then
            npcHandler:say("Voce ja possui a montaria Shellodon!", npc, creature)
            return true
        end
        if player:removeItem(36835, 1) then
            player:addMount(183)
            npcHandler:say("Parabens! Voce trocou um Eldritch Crystal pela montaria Shellodon!", npc, creature)
        else
            npcHandler:say("Voce nao possui um Eldritch Crystal.", npc, creature)
        end
        return true
    end

    -- Verificar se o jogador ja tem a storage 60004
    if player:getStorageValue(60004) ~= 1 then
        if MsgContains(message, "mission") then
            npcHandler:say("Para voce poder enfrentar o grande chefe voce tera que provar seu valor e realizar todas as tarefas das warzones 7, 8 e 9, tem certeza que e isto que vc quer?", npc, creature)
            npcHandler:setTopic(playerId, 1)
        elseif MsgContains(message, "yes") then
            if npcHandler:getTopic(playerId) == 1 then
                player:setStorageValue(60004, 1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce aceitou a missao! Boa sorte!")
                npcHandler:setTopic(playerId, 0)
                -- Resetar a storage apos 20 horas
                addEvent(function()
                    player:setStorageValue(60004, -1)
                   -- player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sua missao foi resetada, voce pode aceita-la novamente.")
                end, 20 * 60 * 60 * 1000) -- 20 horas em milissegundos
            else
                npcHandler:say("Nao entendi o que voce quer dizer.", npc, creature)
            end
        end
    else
        npcHandler:say("Voce ja aceitou esta missao recentemente. Por favor, volte mais tarde.", npc, creature)
    end

    return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ola |PLAYERNAME|. Precisa de uma {mission}? Ou quer trocar um {shellodon}?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
