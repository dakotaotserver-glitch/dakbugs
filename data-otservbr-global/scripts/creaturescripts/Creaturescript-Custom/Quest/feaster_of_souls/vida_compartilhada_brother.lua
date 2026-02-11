local sharedDamage = CreatureEvent("SharedDamage")

function sharedDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)

    if creature:getName():lower() == "brother worm" and totalDamage > 0 then
        local paleWorm = nil
        local creaturePosition = creature:getPosition()

        -- Procurar o The Unwelcome nos andares 0 a 15
        for z = 0, 15 do
            local spectators = Game.getSpectators({x = creaturePosition.x, y = creaturePosition.y, z = z}, false, false, 20, 20, 20, 20)
            for _, spectator in ipairs(spectators) do
                if spectator:isMonster() and spectator:getName():lower() == "the unwelcome" then
                    paleWorm = spectator
                    break
                end
            end
            if paleWorm then break end
        end

        if paleWorm then
            local newHealth = creature:getHealth() - (totalDamage * 0.99)

            local brotherWillDie = false
            if newHealth <= 0 then
                newHealth = 1 -- Evita a morte do Brother Worm
                brotherWillDie = true
            end

            paleWorm:setHealth(newHealth)

            if brotherWillDie then
                addEvent(function()
                    if paleWorm and paleWorm:isMonster() and not paleWorm:isRemoved() then
                        -- ⚠️ Identifica o killer correto (player ou dono da summon)
                        local killer = attacker
                        if killer and killer:isMonster() then
                            local master = killer:getMaster()
                            if master and master:isPlayer() then
                                killer = master
                            end
                        end

                        -- 🧠 Mata o PaleWorm legitimamente com atribuição de killer
                        if killer and killer:isPlayer() then
                            if paleWorm.kill then
                                paleWorm:kill(killer) -- método preferido se disponível
                            else
                                doTargetCombatHealth(killer, paleWorm, COMBAT_PHYSICALDAMAGE, -10000, -10000, CONST_ME_NONE)
                            end
                        else
                            paleWorm:addHealth(-10000) -- fallback se não houver killer válido
                        end

                        -- 🧹 Remove monstros do mesmo andar, exceto os dois principais
                        local pos = paleWorm:getPosition()
                        local sameFloorSpectators = Game.getSpectators(pos, false, false, 20, 20, 20, 20)
                        for _, spectator in ipairs(sameFloorSpectators) do
                            local name = spectator:getName():lower()
                            if spectator:isMonster() and name ~= "the unwelcome" and name ~= "brother worm" then
                                spectator:remove()
                            end
                        end
                    end
                end, 100) -- delay de 100ms
            end
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

sharedDamage:register()
