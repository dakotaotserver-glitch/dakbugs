local sharedDamage = CreatureEvent("yseldadano")

local saplingCooldown = {}

function sharedDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    -- Verifica se a criatura é "Megasylvan Yselda"
    if creature:isMonster() and creature:getName():lower() == "megasylvan yselda" then
        -- Procura por todas as criaturas "Megasylvan Sapling" em um raio de 20 unidades ao redor de "Megasylvan Yselda"
        local spectators = Game.getSpectators(creature:getPosition(), false, false, 20, 20, 20, 20)
        for _, spectator in ipairs(spectators) do
            if spectator:isMonster() and spectator:getName():lower() == "megasylvan sapling" then
                local spectatorId = spectator:getId()

                -- Verifica se o sapling está em cooldown
                if not saplingCooldown[spectatorId] or saplingCooldown[spectatorId] < os.time() then
                    -- Define o cooldown de 2 segundos
                    saplingCooldown[spectatorId] = os.time() + 2

                    -- Calcula o dano aleatório entre 100 e 200
                    local damage = math.random(100, 1000)

                    -- Aplica o dano ao "Megasylvan Sapling"
                    spectator:addHealth(-damage)

                    -- Aplica o efeito de planta
                    spectator:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
                end
            end
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

sharedDamage:register()
