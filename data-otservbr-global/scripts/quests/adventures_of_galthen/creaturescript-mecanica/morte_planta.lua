local saplingDeath = CreatureEvent("saplingDeath")

function saplingDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
    -- Verifica se a criatura que morreu é "Megasylvan Sapling"
    if creature:isMonster() and creature:getName():lower() == "megasylvan sapling" then
        -- Procura por todas as criaturas "Megasylvan Yselda" em um raio de 20 unidades ao redor do "Megasylvan Sapling"
        local spectators = Game.getSpectators(creature:getPosition(), false, false, 20, 20, 20, 20)
        for _, spectator in ipairs(spectators) do
            if spectator:isMonster() and spectator:getName():lower() == "megasylvan yselda" then
                -- Guarda a posição da "Megasylvan Yselda"
                local position = spectator:getPosition()
                
                -- Remove a criatura "Megasylvan Yselda"
                spectator:remove()
                
                -- Aplica o efeito de plantas pequenas na posição onde "Megasylvan Yselda" foi removida
                position:sendMagicEffect(CONST_ME_SMALLPLANTS)
            end
        end
    end
    return true
end

saplingDeath:register()

