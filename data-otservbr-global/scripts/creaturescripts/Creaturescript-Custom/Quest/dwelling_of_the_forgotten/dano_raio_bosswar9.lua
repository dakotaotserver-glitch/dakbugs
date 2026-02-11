local fleetingThoughtDamage = CreatureEvent("FleetingThoughtDamage")

-- Função para encontrar a criatura "Mental-nexus" próxima
local function findNearbyMentalNexus(creature)
    local position = creature:getPosition()
    local nearbyCreatures = Game.getSpectators(position, false, false, 1, 1, 1, 1)
    for _, target in ipairs(nearbyCreatures) do
        if target:isMonster() and target:getName():lower() == "mental-nexus" then
            return target
        end
    end
    return nil
end

-- Função principal que será acionada quando "Fleeting Thought" tomar dano
function fleetingThoughtDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature and creature:isMonster() and creature:getName() == "Fleeting Thought" then
        -- Encontra a criatura "Mental-nexus" próxima
        local mentalNexus = findNearbyMentalNexus(creature)
        if mentalNexus then
            -- Gera um dano aleatório entre 10 e 1 ponto
            local damageToMentalNexus = math.random(1, 5)
            
            -- Aplica o dano à criatura "Mental-nexus"
            mentalNexus:addHealth(-damageToMentalNexus)
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

fleetingThoughtDamage:register()

function Monster:setFleetingThoughtDamage()
    self:registerEvent("FleetingThoughtDamage")
    return true
end

function Monster:removeFleetingThoughtDamage()
    self:unregisterEvent("FleetingThoughtDamage")
    return true
end
