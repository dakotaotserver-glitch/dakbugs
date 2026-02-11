local creatureDeathEvent = CreatureEvent("TentuglyDeathSequence")

local function handleCreatureDeath(creature)
    local creatureName = creature:getName()
    local deathPosition = creature:getPosition()

    -- Condições específicas para "Tentugly"
    if creatureName == "Tentugly" then
        if deathPosition == Position(33723, 31184, 7) then
            local removeItemPosition = Position(33723, 31185, 7)
            local nextSpawnPosition = Position(33723, 31185, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33723, 31185, 7) then
            local removeItemPosition = Position(33723, 31186, 7)
            local nextSpawnPosition = Position(33723, 31186, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33723, 31186, 7) then
            local removeItemPosition = Position(33723, 31187, 7)
            local nextSpawnPosition = Position(33723, 31187, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33723, 31187, 7) then
            local removeItemPosition = Position(33723, 31188, 7)
            local nextSpawnPosition = Position(33723, 31188, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33723, 31188, 7) then
            local removeItemPosition = Position(33723, 31189, 7)
            local nextSpawnPosition = Position(33723, 31189, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33723, 31189, 7) then
            local removeItemPosition1 = Position(33723, 31190, 7)
            local removeItemPosition2 = Position(33723, 31191, 7)
            local itemToRemove1 = Tile(removeItemPosition1):getItemById(35112)
            local itemToRemove2 = Tile(removeItemPosition2):getItemById(35109)
            if itemToRemove1 then
                itemToRemove1:remove()
            end
            if itemToRemove2 then
                itemToRemove2:remove()
            end
            Game.createItem(35110, 1, removeItemPosition2)

        elseif deathPosition == Position(33727, 31183, 7) then
            local removeItemPosition = Position(33727, 31184, 7)
            local nextSpawnPosition = Position(33727, 31184, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33727, 31184, 7) then
            local removeItemPosition = Position(33727, 31185, 7)
            local nextSpawnPosition = Position(33727, 31185, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33727, 31185, 7) then
            local removeItemPosition = Position(33727, 31186, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35109)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createItem(35110, 1, removeItemPosition)

        elseif deathPosition == Position(33718, 31186, 6) then
            local removeItemPosition = Position(33718, 31187, 6)
            local nextSpawnPosition = Position(33718, 31187, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31187, 6) then
            local removeItemPosition = Position(33718, 31188, 6)
            local nextSpawnPosition = Position(33718, 31188, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31188, 6) then
            local removeItemPosition = Position(33718, 31189, 6)
            local nextSpawnPosition = Position(33718, 31189, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31189, 6) then
            local removeItemPosition = Position(33718, 31190, 6)
            local nextSpawnPosition = Position(33718, 31190, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31190, 6) then
            local removeItemPosition = Position(33718, 31191, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35109)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createItem(35110, 1, removeItemPosition)

        elseif deathPosition == Position(33716, 31180, 6) then
            local removeItemPosition = Position(33716, 31181, 6)
            local nextSpawnPosition = Position(33716, 31181, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33716, 31181, 6) then
            local removeItemPosition = Position(33716, 31182, 6)
            local nextSpawnPosition = Position(33716, 31182, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugly", nextSpawnPosition)

        elseif deathPosition == Position(33716, 31182, 6) then
            local removeItemPosition = Position(33716, 31183, 6)
            local itemToRemove = Tile(removeItemPosition):getItemById(35109)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createItem(35110, 1, removeItemPosition)
        end

    -- Condições específicas para "Tentuglis"
    elseif creatureName == "Tentuglis" then
        if deathPosition == Position(33718, 31181, 7) then
            local removeItemPosition = Position(33718, 31180, 7)
            local nextSpawnPosition = Position(33718, 31180, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentuglis", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31180, 7) then
            local removeItemPosition = Position(33718, 31179, 7)
            local nextSpawnPosition = Position(33718, 31179, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentuglis", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31179, 7) then
            local removeItemPosition = Position(33718, 31178, 7)
            local nextSpawnPosition = Position(33718, 31178, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentuglis", nextSpawnPosition)

        elseif deathPosition == Position(33718, 31178, 7) then
            local removeItemPosition = Position(33718, 31177, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35112)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createItem(35107, 1, Position(33718, 31176, 7))
        end

    -- Condições específicas para "Tentugli"
    elseif creatureName == "Tentugli" then
        if deathPosition == Position(33731, 31179, 7) then
            local removeItemPosition = Position(33732, 31179, 7)
            local nextSpawnPosition = Position(33732, 31179, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33732, 31179, 7) then
            local removeItemPosition = Position(33733, 31179, 7)
            local nextSpawnPosition = Position(33733, 31179, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33733, 31179, 7) then
            local removeItemPosition = Position(33734, 31179, 7)
            local nextSpawnPosition = Position(33734, 31179, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33734, 31179, 7) then
            local removeItemPosition = Position(33735, 31179, 7)
            local nextSpawnPosition = Position(33735, 31179, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33735, 31179, 7) then
            local removeItemPosition = Position(33736, 31179, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35119)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createItem(35120, 1, removeItemPosition)

        elseif deathPosition == Position(33721, 31180, 7) then
            local removeItemPosition = Position(33722, 31180, 7)
            local nextSpawnPosition = Position(33722, 31180, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33722, 31180, 7) then
            local removeItemPosition = Position(33723, 31180, 7)
            local nextSpawnPosition = Position(33723, 31180, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33723, 31180, 7) then
            local removeItemPosition = Position(33724, 31180, 7)
            local nextSpawnPosition = Position(33724, 31180, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33724, 31180, 7) then
            local removeItemPosition = Position(33725, 31180, 7)
            local nextSpawnPosition = Position(33725, 31180, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35126)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createMonster("Tentugli", nextSpawnPosition)

        elseif deathPosition == Position(33725, 31180, 7) then
            local removeItemPosition = Position(33726, 31180, 7)
            local itemToRemove = Tile(removeItemPosition):getItemById(35119)
            if itemToRemove then
                itemToRemove:remove()
            end
            Game.createItem(35120, 1, removeItemPosition)
        end
    end
end

function creatureDeathEvent.onDeath(creature, corpse, deathList)
    handleCreatureDeath(creature)
    return true
end

creatureDeathEvent:register()
