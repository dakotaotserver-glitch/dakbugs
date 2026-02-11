-- ##########################################################################
-- #  Bounty Orphan Check: devolve contribuições órfãs diretamente ao banco.
-- ##########################################################################

local orphanCheckEvent = GlobalEvent("BountyOrphanCheckBank")

-- 1) Função que deposita o dinheiro diretamente no banco do jogador e salva no BD
local function depositMoneyToBank(playerId, totalGold)
    if playerId == nil or totalGold <= 0 then
        return
    end

    local player = Player(playerId)

    if player then
        -- Se o jogador estiver online, adicionamos o dinheiro e salvamos o personagem
        player:setBankBalance(player:getBankBalance() + totalGold)
        player:save() -- Garante que o saldo seja salvo no banco de dados
    else
        -- Se estiver offline, atualizamos direto no banco de dados
        local query = string.format("UPDATE players SET balance = balance + %d WHERE id = %d", totalGold, playerId)
        db.query(query)
        db.query("COMMIT;") -- Força a gravação no banco de dados
    end
end

-- 2) onThink do GlobalEvent: varre contribuições órfãs e devolve sempre para o banco
function orphanCheckEvent.onThink(interval, lastExecution)
    local orphanQuery = [[
        SELECT 
            bc.id AS contribId,
            bc.contributor_guid AS contributorGuid,
            bc.amount AS amount
        FROM bounty_contributions bc
        LEFT JOIN bounty_list bl ON bc.bounty_id = bl.id
        WHERE bl.id IS NULL
    ]]

    local resultId = db.storeQuery(orphanQuery)
    if not resultId then
        return true
    end

    local contribIdsToDelete = {}

    repeat
        local contribId       = result.getNumber(resultId, "contribId")
        local contributorGuid = result.getNumber(resultId, "contributorGuid")
        local amount          = result.getNumber(resultId, "amount")

        -- Deposita no banco do jogador
        depositMoneyToBank(contributorGuid, amount)

        -- Adiciona a contribuição na lista para deletar
        table.insert(contribIdsToDelete, contribId)

    until not result.next(resultId)
    result.free(resultId)

    -- Remove todas as contribuições de uma vez (mais eficiente)
    if #contribIdsToDelete > 0 then
        local deleteQuery = "DELETE FROM bounty_contributions WHERE id IN (" .. table.concat(contribIdsToDelete, ",") .. ")"
        db.query(deleteQuery)
    end

    return true
end

-- 3) Define o intervalo (em milissegundos). Ex.: 60000 = 1 min
orphanCheckEvent:interval(60000)
orphanCheckEvent:register()
