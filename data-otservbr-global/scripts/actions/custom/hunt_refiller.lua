-- local refiller = Action()
-- local timeToDisapear = 100 * 1000
-- function refiller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and  player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked() then
        -- player:sendCancelMessage("You can't use this while in battle.")
        -- player:getPosition():sendMagicEffect(CONST_ME_POFF)
        -- return true
    -- end
    
    
    -- local pid = player:getId()
    -- if HUNT_REFILLER[pid] and HUNT_REFILLER[pid].time > os.time() then
        -- player:sendCancelMessage("You need to wait before use this item again")
		
        -- return true
    -- end

    -- if not HUNT_REFILLER[pid] then HUNT_REFILLER[pid] = {} end
        -- local position = player:getPosition()
        -- local npc = Game.createNpc('Hunt Refiller', position)
        -- HUNT_REFILLER[pid].time = os.time() + 15 * 60
        -- HUNT_REFILLER[pid].npc = npc:getId()
        
        -- addEvent(function() 
            -- npc:remove()
        -- end, timeToDisapear)
        -- if npc then
            -- npc:setMasterPos(position)
            -- position:sendMagicEffect(CONST_ME_MAGIC_RED)
        -- end


    -- return true
-- end

-- refiller:id(49736) -- REPLACE HERE
-- refiller:register()


local refiller = Action()
local timeToDisapear = 100 * 1000 -- tempo em milissegundos para o NPC desaparecer

-- Garantir que a tabela global esteja inicializada
HUNT_REFILLER = HUNT_REFILLER or {}

function refiller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Impede uso em batalha ou em zona de proteção
    if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE)
        and (player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked()) then
        player:sendCancelMessage("You can't use this while in battle.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local pid = player:getId()

    -- Verifica se o cooldown ainda está ativo
    if HUNT_REFILLER[pid] and HUNT_REFILLER[pid].time > os.time() then
        local timeLeft = HUNT_REFILLER[pid].time - os.time()
        local minutes = math.floor(timeLeft / 60)
        local seconds = timeLeft % 60
        player:sendCancelMessage(string.format("You need to wait %d minutes and %d seconds before using this item again.", minutes, seconds))
        return true
    end

    -- Cria nova entrada se necessário
    if not HUNT_REFILLER[pid] then
        HUNT_REFILLER[pid] = {}
    end

    local position = player:getPosition()
    local npc = Game.createNpc("Hunt Refiller", position)

    if npc then
        HUNT_REFILLER[pid].time = os.time() + 45 * 60 -- 45 minutos de cooldown
        HUNT_REFILLER[pid].npc = npc:getId()

        npc:setMasterPos(position)
        position:sendMagicEffect(CONST_ME_MAGIC_RED)

        -- Remove o NPC após o tempo definido
        addEvent(function()
            if npc and npc:isNpc() then
                npc:remove()
            end
        end, timeToDisapear)
    else
        player:sendCancelMessage("Failed to summon Hunt Refiller.")
    end

    return true
end

refiller:id(61736) -- ID do item que ativa o refiller
refiller:register()
