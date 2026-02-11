local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    local center = Position(33529, 32334, 12)
    local center2 = Position(33528, 32334, 12)

    creature:say("GET OVER HERE!", TALKTYPE_MONSTER_YELL, false, 0, center2)

    for x = 33519, 33538 do
        for y = 32327, 32342 do
            local tile = Tile(Position(x, y, 12))
            if tile then
                local creatureTile = tile:getTopCreature()
                if creatureTile then
                    if creatureTile:isMonster() and creatureTile:getName():lower() ~= "prince drazzak" then
                        creatureTile:teleportTo(center, true)
                    elseif creatureTile:isPlayer() then
                        creatureTile:teleportTo(center, true)
                    end
                end
            end
        end
    end

    -- Teleporta o boss só uma vez, após todos os outros
    creature:teleportTo(center2, true)

    return true
end

spell:name("prince drazzak tp")
spell:words("###353")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
