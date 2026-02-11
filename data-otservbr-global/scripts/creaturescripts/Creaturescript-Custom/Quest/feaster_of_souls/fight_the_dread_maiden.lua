local bossZone = Zone("boss.the-dread-maiden")

local encounter = Encounter("The Dread Maiden", {
    zone = bossZone,
    timeToSpawnMonsters = "10ms",
})

encounter:addSpawnMonsters({
    {
        name = "The Dread Maiden",
        positions = { Position(33712, 31503, 14) },
        spawn = function(monster)
            monster:setIcon("dread-maiden", CreatureIconCategory_Quests, CreatureIconQuests_PurpleShield, 20)
            monster:registerEvent("dread-maiden.Health") -- Ativa a resistência aos escudos
        end,
    }
})

encounter:register()

local dreadMaidenHealth = CreatureEvent("dread-maiden.Health")

function dreadMaidenHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
    if not creature or not creature:isMonster() or creature:getName():lower() ~= "the dread maiden" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local currentIcon = creature:getIcon("dread-maiden")
    local shields = (currentIcon and currentIcon.count) or 0
    local multiplier = 1 - shields * 0.05
    if multiplier < 0 then multiplier = 0 end -- evita cura/dano negativo

    return primaryDamage * multiplier, primaryType, secondaryDamage * multiplier, secondaryType
end

dreadMaidenHealth:register()

