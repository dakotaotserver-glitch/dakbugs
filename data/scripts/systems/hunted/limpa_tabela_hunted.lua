local removeExpired = GlobalEvent("RemoveExpiredBounties")

function removeExpired.onThink(interval, lastExecution)
    local now = os.time()

    -- Busca todos os registros em bounty_list cujo expire_time <= agora
    local query = "SELECT id FROM bounty_list WHERE expire_time <= " .. now
    local resultId = db.storeQuery(query)
    if not resultId then
        return true
    end

    repeat
        -- Pega o bountyId
        local bountyId = result.getNumber(resultId, "id")

        -- Remove também as contribuições associadas (se quiser)
        -- db.query("DELETE FROM bounty_contributions WHERE bounty_id = " .. bountyId)
        db.query("DELETE FROM bounty_list WHERE id = " .. bountyId)
    until not result.next(resultId)

    result.free(resultId)
    return true
end

-- Roda a cada 10 segundos (10000ms). Ajuste o tempo conforme necessário.
removeExpired:interval(10000)
removeExpired:register()
