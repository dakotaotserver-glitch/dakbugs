local fromPos = Position(34013, 32319, 14)
local toPos = Position(34048, 32346, 14)
local bossName = "arbaziloth"
local forgemasterName = "the forgemaster"
local newBossName = "arbaziloth_dificil"
local hpThreshold = 0.10 -- 10% de vida (ajuste como preferir)

local alreadyTransformed = {}

local transformEvent = CreatureEvent("ArbazilothTransformIfForgemaster")

function transformEvent.onThink(creature)
    if not creature:isMonster() or creature:getName():lower() ~= bossName then
        return true
    end
    local cid = creature:getId()
    if alreadyTransformed[cid] then
        return true
    end

    local currentHp = creature:getHealth()
    local maxHp = creature:getMaxHealth()
    if currentHp / maxHp <= hpThreshold then
        local forgemasterFound = nil
        local spectators = Game.getSpectators(fromPos, false, false, toPos.x - fromPos.x, toPos.x - fromPos.x, toPos.y - fromPos.y, toPos.y - fromPos.y, fromPos.z, toPos.z)
        for _, spec in ipairs(spectators) do
            if spec:isMonster() and spec:getName():lower() == forgemasterName then
                forgemasterFound = spec
                break
            end
        end

        if forgemasterFound then
            local bossPos = creature:getPosition()
            forgemasterFound:remove()
            creature:remove()
            local newBoss = Game.createMonster(newBossName, bossPos)
            bossPos:sendMagicEffect(CONST_ME_MORTAREA)
            alreadyTransformed[cid] = true
        end
    end
    return true
end

transformEvent:register()
