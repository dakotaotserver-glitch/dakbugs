local vortex = MoveEvent()
local config = AscendingFerumbrasConfig

local fromPos = Position(33379, 31460, 14)
local toPos   = Position(33405, 31485, 14)

function vortex.onStepIn(creature, item, position, fromPosition)
    if not creature then
        return true
    end

    local monster = creature:getMonster()
    if not monster then
        return true
    end

    if monster:getName():lower() ~= "ferumbras essence" then
        return true
    end

    monster:remove()
    position:sendMagicEffect(CONST_ME_POFF)

    -- Incrementa storage global
    local currentEssenceCount = Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence)
    if currentEssenceCount < 0 then currentEssenceCount = 0 end
    Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, currentEssenceCount + 1)

    local updatedEssenceCount = Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence)

    if updatedEssenceCount >= 8 then
        -- Varredura total da área, contando Essences e Soul Splinters
        local essences, splinters = 0, 0
        for x = fromPos.x, toPos.x do
            for y = fromPos.y, toPos.y do
                local pos = Position(x, y, fromPos.z)
                local tile = Tile(pos)
                if tile then
                    local top = tile:getTopCreature()
                    if top and top:isMonster() then
                        local name = top:getName():lower()
                        if name == "ferumbras essence" then
                            essences = essences + 1
                        elseif name == "ferumbras soul splinter" then
                            splinters = splinters + 1
                        end
                    end
                end
            end
        end

        if essences == 0 and splinters == 0 then
            -- Remover todos Rift Invaders (área de 30 SQM em torno do centro)
            local riftInvaders = Game.getSpectators(config.centerRoom, false, false, 30, 30, 30, 30)
            for _, invader in ipairs(riftInvaders) do
                if invader:isMonster() and invader:getName():lower() == "rift invader" then
                    invader:remove()
                end
            end

            -- Verificar se o boss já existe
            local bossExists = false
            local bossCheck = Game.getSpectators(config.centerRoom, false, false, 20, 20, 20, 20)
            for _, s in ipairs(bossCheck) do
                if s:isMonster() and s:getName():lower() == "destabilized ferumbras" then
                    bossExists = true
                    break
                end
            end

            if not bossExists then
                Game.createMonster("Destabilized Ferumbras", config.bossPos, true, true)
            end

            -- Criar 8 Rift Fragments em posições aleatórias livres
            local createdFragments = 0
            local maxAttempts = 50
            local attempts = 0
            while createdFragments < 8 and attempts < maxAttempts do
                local spawnPosition = Position(math.random(33381, 33403), math.random(31462, 31483), 14)
                local tile = Tile(spawnPosition)
                if tile and not tile:getTopCreature() then
                    local fragment = Game.createMonster("Rift Fragment", spawnPosition, true, true)
                    if fragment then
                        spawnPosition:sendMagicEffect(CONST_ME_TELEPORT)
                        createdFragments = createdFragments + 1
                    end
                end
                attempts = attempts + 1
            end

            -- Reset das storages
            Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, 0)
            Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals, 0)
            Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.EventDone, 0)
            for i = 1, 8 do
                local crystalKey = Storage.Quest.U10_90.FerumbrasAscension.Crystals["Crystal"..i]
                Game.setStorageValue(crystalKey, 0)
            end
        end
    end

    return true
end

vortex:type("stepin")
vortex:id(config.vortex)
vortex:register()
