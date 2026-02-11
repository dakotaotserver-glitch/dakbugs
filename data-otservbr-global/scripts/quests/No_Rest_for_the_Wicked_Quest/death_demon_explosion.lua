local areaMatrix = {
    { 0, 0, 1, 1, 1, 0, 0 },
    { 0, 1, 1, 1, 1, 1, 0 },
    { 1, 1, 1, 1, 1, 1, 1 },
    { 1, 1, 1, 3, 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, 1 },
    { 0, 1, 1, 1, 1, 1, 0 },
    { 0, 0, 1, 1, 1, 0, 0 },
}

local DAMAGE_TYPE = COMBAT_DEATHDAMAGE
local MIN_DAMAGE, MAX_DAMAGE = 0, 1200
local MIN_HEAL, MAX_HEAL = 2000, 5000
local BOSS_NAME = "arbaziloth"
local EFFECT_AGONE = CONST_ME_AGONIA or 56 -- 56 é o id do efeito Agone

local function getAreaPositions(center, matrix)
    local areaPositions = {}
    local half = math.floor(#matrix / 2)
    for y = 1, #matrix do
        for x = 1, #matrix[y] do
            if matrix[y][x] > 0 then
                local dx, dy = x - (half + 1), y - (half + 1)
                table.insert(areaPositions, Position(center.x + dx, center.y + dy, center.z))
            end
        end
    end
    return areaPositions
end

local function areaEffectAndHeal(centerPos)
    local positions = getAreaPositions(centerPos, areaMatrix)
    local healedBoss = false
    for _, pos in ipairs(positions) do
        pos:sendMagicEffect(223)
        local tile = Tile(pos)
        if tile then
            for _, thing in ipairs(tile:getCreatures()) do
                if thing:isPlayer() then
                    local dmg = math.random(MIN_DAMAGE, MAX_DAMAGE)
                    thing:addHealth(-dmg, false, DAMAGE_TYPE)
                elseif thing:isMonster() and thing:getName():lower() == BOSS_NAME and not healedBoss then
                    local heal = math.random(MIN_HEAL, MAX_HEAL)
                    thing:addHealth(heal)
                    thing:getPosition():sendMagicEffect(223)
                    healedBoss = true
                end
            end
        end
    end
end

local bossDeathEvent = CreatureEvent("BossAreaEffectOnDeath")

function bossDeathEvent.onDeath(creature, corpse, killer, mostDamageKiller)
    local centerPos = creature:getPosition()
    areaEffectAndHeal(centerPos)

    -- Respawn do mesmo monstro após 10 segundos
    local monsterName = creature:getName()
    addEvent(function()
        Game.createMonster(monsterName, centerPos)
    end, 10000)

    return true
end

bossDeathEvent:register()
