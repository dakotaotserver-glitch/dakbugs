-- =========================================================
-- ==============  B O U N T Y   S Y S T E M  ==============
-- =========================================================

-- ====================== Configurações =====================
local DEBUG_MODE = false

local MESSAGE_STATUS_CONSOLE_RED = 19   -- Ajuste conforme seu OT
local MESSAGE_STATUS_CONSOLE_BLUE = 17  -- Ajuste conforme seu OT
local MESSAGE_LOOK = 0                  -- Mensagem tipo "look" (opcional)

-- ====================== Funções Aux =======================

local function debugLog(msg)
    if DEBUG_MODE then
        print("[DEBUG][Bounty System] " .. msg)
    end
end

-- ====================== Funções de BD =====================

-- addKillPoints: Soma pontos baseados no level da vítima e +1 kill para o assassino
local function addKillPoints(killerId, killerName, victimId)
    -- 1) Obter o level da vítima
    local victimLevel = 0
    local levelResult = db.storeQuery("SELECT `level` FROM `players` WHERE `id` = " .. victimId)
    if levelResult then
        victimLevel = result.getNumber(levelResult, "level")
        result.free(levelResult)
    end

    -- 2) Calcular pontos com base no level da vítima
    local killPoints = 0
    if victimLevel >= 100 then
        killPoints = math.floor(victimLevel / 100) * 10
        if killPoints > 100 then
            killPoints = 100
        end
    end

    -- 3) Buscar registro do assassino em player_kill_points
    local resultId = db.storeQuery("SELECT points, total_kills, total_deaths FROM player_kill_points WHERE player_id = " .. killerId)
    if resultId then
        local currentPoints = result.getNumber(resultId, "points")
        local currentKills = result.getNumber(resultId, "total_kills")
        local currentDeaths = result.getNumber(resultId, "total_deaths")
        result.free(resultId)

        local newPoints = currentPoints + killPoints
        local newKills = currentKills + 1

        db.query(string.format("UPDATE player_kill_points SET points=%d, total_kills=%d WHERE player_id=%d",
            newPoints, newKills, killerId
        ))
        debugLog("Pontos/kills atualizados: " .. killerName .. " recebeu +" .. killPoints .. " pontos (total " .. newPoints .. "), +1 kill")
    else
        -- Não existe registro, cria:
        db.query(string.format(
            "INSERT INTO player_kill_points (player_id, player_name, points, total_kills, total_deaths) VALUES (%d, %s, %d, 1, 0)",
            killerId, db.escapeString(killerName), killPoints
        ))
        debugLog("Criada nova entrada para: " .. killerName .. " com " .. killPoints .. " pontos, 1 kill.")
    end
end

-- addBountyDeath: +1 death para a vítima SOMENTE se for bounty
local function addBountyDeath(playerId, playerName)
    local resultId = db.storeQuery("SELECT points, total_kills, total_deaths FROM player_kill_points WHERE player_id = " .. playerId)
    if resultId then
        local currentPoints = result.getNumber(resultId, "points")
        local currentKills = result.getNumber(resultId, "total_kills")
        local currentDeaths = result.getNumber(resultId, "total_deaths")
        result.free(resultId)

        local newDeaths = currentDeaths + 1
        db.query(string.format("UPDATE player_kill_points SET total_deaths=%d WHERE player_id=%d",
            newDeaths, playerId
        ))
        debugLog("Bounty Death +1 para " .. playerName .. ". total_deaths=" .. newDeaths)
    else
        -- Se não existir, cria registro com 0 kills, 0 points e 1 death
        db.query(string.format(
            "INSERT INTO player_kill_points (player_id, player_name, points, total_kills, total_deaths) VALUES (%d, %s, 0, 0, 1)",
            playerId, db.escapeString(playerName)
        ))
        debugLog("Nova entrada. total_deaths=1 para o jogador " .. playerName)
    end
end

-- removePointsOnBountyDeath: Jogador que MORREU perde pontos, baseado em seu level.
-- lvl 100–199 => -5, 200–299 => -10, ..., até lvl >= 1000 => -50. Não fica < 0.
local function removePointsOnBountyDeath(victimId, victimName)
    local victimLevel = 0
    local levelResult = db.storeQuery("SELECT `level` FROM `players` WHERE `id` = " .. victimId)
    if levelResult then
        victimLevel = result.getNumber(levelResult, "level")
        result.free(levelResult)
    end

    local penaltyPoints = 0
    if victimLevel >= 100 then
        penaltyPoints = math.floor(victimLevel / 100) * 5
        if penaltyPoints > 50 then
            penaltyPoints = 50
        end
    end

    if penaltyPoints <= 0 then
        debugLog("Vítima (" .. victimName .. ") level < 100, não perde pontos.")
        return
    end

    local resultId = db.storeQuery("SELECT points FROM player_kill_points WHERE player_id = " .. victimId)
    if resultId then
        local currentPoints = result.getNumber(resultId, "points")
        result.free(resultId)

        local newPoints = currentPoints - penaltyPoints
        if newPoints < 0 then
            newPoints = 0
        end

        db.query("UPDATE player_kill_points SET points=" .. newPoints .. " WHERE player_id=" .. victimId)
        debugLog("Vítima " .. victimName .. " perdeu " .. penaltyPoints .. " pontos. Pontos finais = " .. newPoints)
    else
        debugLog("Vítima " .. victimName .. " não tinha registro em kill_points. Nada a subtrair.")
    end
end

------------------------------------------------------------------------------
-- Função para entregar dinheiro correto em coins (Gold, Platinum, Crystal)
-- 3031 = 1 gold, 3035 = 100 gold, 3043 = 10000 gold
-- Exemplo: se totalGold = 123456, então:
-- 12 crystal coins (3043) = 120000 gold
-- sobra 3456 => 34 platinum coins (3035) = 3400 gold
-- sobra 56 => 56 gold coins (3031)
------------------------------------------------------------------------------
local function giveMoneyInCoins(container, totalGold)
    -- Valores equivalentes
    local crystalCoinValue  = 10000
    local platinumCoinValue = 100
    local goldCoinValue     = 1

    -- Stack limits (dependem do seu items.xml)
    local stackLimitCrystal  = 100
    local stackLimitPlatinum = 100
    local stackLimitGold     = 100

    -- 1) Crystal coins
    local numCrystal = math.floor(totalGold / crystalCoinValue)
    local remainder  = totalGold % crystalCoinValue

    -- 2) Platinum coins
    local numPlatinum = math.floor(remainder / platinumCoinValue)
    local remainder2  = remainder % platinumCoinValue

    -- 3) Gold coins
    local numGold = remainder2  -- resto final, cada coin = 1 gold

    -- Adiciona CRYSTAL COINS (3043) em pilhas
    while numCrystal > 0 do
        local toAdd = math.min(numCrystal, stackLimitCrystal) -- máx por stack
        container:addItem(3043, toAdd)
        numCrystal = numCrystal - toAdd
    end

    -- Adiciona PLATINUM COINS (3035) em pilhas
    while numPlatinum > 0 do
        local toAdd = math.min(numPlatinum, stackLimitPlatinum)
        container:addItem(3035, toAdd)
        numPlatinum = numPlatinum - toAdd
    end

    -- Adiciona GOLD COINS (3031) em pilhas
    while numGold > 0 do
        local toAdd = math.min(numGold, stackLimitGold)
        container:addItem(3031, toAdd)
        numGold = numGold - toAdd
    end
end

-------------------------------------------------------------------------------
-- ======================= payBounty =========================
-------------------------------------------------------------------------------
local function payBounty(killerName, targetName, totalBounty)
    local killerPlayer = Player(killerName)
    if not killerPlayer then
        debugLog("Assassino nao esta online: " .. killerName)
        return false
    end

    -- 1) Contar quantos jogadores contribuíram
    local contributorsCount = 0
    local contributorsQuery = db.storeQuery("SELECT COUNT(*) as total FROM bounty_contributions WHERE bounty_id IN (SELECT id FROM bounty_list WHERE target_name = " .. db.escapeString(targetName) .. ")")
    if contributorsQuery then
        contributorsCount = result.getNumber(contributorsQuery, "total")
        result.free(contributorsQuery)
    end

    -- 2) Remover a recompensa do banco de dados
    db.query("DELETE FROM bounty_contributions WHERE bounty_id IN (SELECT id FROM bounty_list WHERE target_name = " .. db.escapeString(targetName) .. ")")
    db.query("DELETE FROM bounty_list WHERE target_name = " .. db.escapeString(targetName))
    debugLog("Alvo removido da lista de bounty: " .. targetName)

    -- 3) Criar container (ex.: 2856, 21411) no inventário do assassino
    local containerId = 2856
    local rewardContainer = killerPlayer:addItem(containerId, 1)
    if not rewardContainer then
        debugLog("Falha ao criar o container de recompensas para " .. killerName)
        return false
    end

    -- 4) Adicionar os itens com pequeno delay
    addEvent(function()
        local player = Player(killerName)
        if not player then
            debugLog("O jogador saiu antes de receber o container.")
            return
        end

        local container = player:getItemById(containerId, true)
        if not container then
            debugLog("Container não encontrado no inventário de " .. killerName)
            return
        end

        -- (A) Entrega de gold total (em 3043/3035/3031 conforme valor)
        if totalBounty > 0 then
            giveMoneyInCoins(container, totalBounty)
            debugLog("Recompensa de " .. totalBounty .. " gold adicionada (em coins) ao container de " .. killerName)
        end

        -- (B) Adicionar coins_transferable (ID 22118) se houver contribuidores
        if contributorsCount > 0 then
            local totalCoins = contributorsCount * 5
            container:addItem(22118, totalCoins)
            debugLog(killerName .. " recebeu " .. totalCoins .. " coins_transferable dentro do container.")
            player:getPosition():sendMagicEffect(244)
        end

        -- (C) Mensagens ao assassino
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "Você recebeu um container com " .. totalBounty .. " gold (convertido em coins) pela morte de " .. targetName .. ".")
        if contributorsCount > 0 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
                "O container também contém " .. (contributorsCount * 5) .. " coins_transferable oferecidas pelos contribuidores da recompensa.")
        end

    end, 100) -- 100ms de delay

    debugLog("Pagamento concluído para " .. killerName .. ". (Itens serão adicionados após o delay).")
    return true
end

-------------------------------------------------------------------------------
-- ======================= !receber ==========================
-------------------------------------------------------------------------------
local receiveCommand = TalkAction("!receber")

function receiveCommand.onSay(player, words, param)
    debugLog("Comando !receber iniciado por: " .. player:getName())
    debugLog("Parametros: " .. tostring(param))

    if not player:isPlayer() then
        debugLog("Uma criatura nao-jogador tentou usar o comando !receber.")
        return true
    end

    local playerName = player:getName()

    -- Buscamos a morte mais recente que relacione o assassino com bounty
    local query = [[
        SELECT
            pd.killed_by    AS killerName,
            pk.id           AS killerId,
            p.name          AS targetName,
            p.id            AS targetId,
            bl.total_bounty AS totalBounty,
            pd.time         AS deathTime,
            bl.time         AS bountyTime
        FROM player_deaths pd
        INNER JOIN players p  ON p.id = pd.player_id       -- p => vítima
        INNER JOIN players pk ON pk.name = pd.killed_by    -- pk => assassino
        INNER JOIN bounty_list bl ON p.name = bl.target_name
        WHERE pd.killed_by = ]] .. db.escapeString(playerName) .. [[
          AND pd.time >= bl.time
        ORDER BY pd.time DESC
        LIMIT 1
    ]]
    local resultId = db.storeQuery(query)
    if not resultId then
        debugLog("O jogador " .. playerName .. " nao matou ninguem da bounty ou a morte nao e valida.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "[HUNTED SYSTEM] Voce nao matou ninguem na lista de bounty ou a morte nao e valida.")
        return true
    end

    local killerName   = result.getString(resultId, "killerName")
    local killerId     = result.getNumber(resultId, "killerId")
    local targetName   = result.getString(resultId, "targetName")
    local targetId     = result.getNumber(resultId, "targetId")
    local totalBounty  = result.getNumber(resultId, "totalBounty")
    local deathTime    = result.getNumber(resultId, "deathTime")
    local bountyTime   = result.getNumber(resultId, "bountyTime")
    result.free(resultId)

    debugLog("O jogador " .. killerName .. " matou o alvo " .. targetName .. " (bountyTime=" .. bountyTime .. ", deathTime=" .. deathTime .. ")")

    -- Paga a recompensa ao assassino
    payBounty(killerName, targetName, totalBounty)

    -- Pontos (+1 kill) para o assassino
    addKillPoints(killerId, killerName, targetId)

    -- +1 death para a vítima
    addBountyDeath(targetId, targetName)

    -- Retirar pontos da vítima (se nível >= 100)
    removePointsOnBountyDeath(targetId, targetName)

    debugLog("Pagamento manual realizado com sucesso.")
    return true
end

receiveCommand:separator(" ")
receiveCommand:groupType("normal")
receiveCommand:register()

-------------------------------------------------------------------------------
-- ================== Verificação Automática =================
-------------------------------------------------------------------------------
local autoCheckEvent = GlobalEvent("BountyAutoCheck")

function autoCheckEvent.onThink(interval)
    debugLog("Iniciando verificacao automatica de bounties...")

    local query = [[
        SELECT 
            pd.killed_by    AS killerName,
            pk.id           AS killerId,
            p.name          AS targetName,
            p.id            AS targetId,
            bl.total_bounty,
            pd.time         AS deathTime,
            bl.time         AS bountyTime
        FROM player_deaths pd
        INNER JOIN players p  ON p.id = pd.player_id       -- p => vítima
        INNER JOIN players pk ON pk.name = pd.killed_by    -- pk => assassino
        INNER JOIN bounty_list bl ON p.name = bl.target_name
        WHERE pd.time >= bl.time
    ]]

    local resultId = db.storeQuery(query)
    if not resultId then
        debugLog("Nenhuma morte valida encontrada.")
        return true
    end

    repeat
        local killerName  = result.getString(resultId, "killerName")
        local killerId    = result.getNumber(resultId, "killerId")
        local targetName  = result.getString(resultId, "targetName")
        local targetId    = result.getNumber(resultId, "targetId")
        local totalBounty = result.getNumber(resultId, "total_bounty")
        local deathTime   = result.getNumber(resultId, "deathTime")
        local bountyTime  = result.getNumber(resultId, "bountyTime")

        debugLog("Morte bounty encontrada: Alvo=" .. targetName .. ", Assassino=" .. killerName
          .. ", bountyTime=" .. bountyTime .. ", deathTime=" .. deathTime)

        if killerName ~= "" and killerName ~= "Monster" then
            -- Paga o assassino
            payBounty(killerName, targetName, totalBounty)

            -- Pontos baseados no level da vítima, +1 kill
            addKillPoints(killerId, killerName, targetId)

            -- +1 death para vítima
            addBountyDeath(targetId, targetName)

            -- Retirar pontos da vítima
            removePointsOnBountyDeath(targetId, targetName)
        else
            debugLog("Assassino nao identificado ou monstro. Sem recompensa.")
        end
    until not result.next(resultId)

    result.free(resultId)
    debugLog("Verificacao automatica concluida.")
    return true
end

-- Ajuste para tempo de execução do evento automático (em milissegundos):
autoCheckEvent:interval(10000) -- 10s como exemplo. Pode alterar p/ 60000 (1 min), etc.
autoCheckEvent:register()

debugLog("Sistema Bounty inicializado com entrega correta em gold/platinum/crystal coins.")
