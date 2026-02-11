local config = {
    cooldownTimeInMinutes = 60,
    removeBossTotalMinutes = 10,
}

local sacrificialAltarTable = {
    [8] = {
        bossName = "Malvaroth",
        bossPosition = Position(33776, 32392, 8),
        needUsedItemId = 50101,
        cooldownCache = 0,
        itemUsedInAltarCache = 0,
        summonMonster = "Brinebrute Inferniarch",
        summonMonsterPosition1 = Position(33774, 32392, 8),
        summonMonsterPosition2 = Position(33775, 32394, 8),
        summonMonsterPosition3 = Position(33775, 32390, 8),
    },
    [9] = {
        bossName = "Twisterror",
        bossPosition = Position(33823, 32302, 9),
        needUsedItemId = 50054,
        cooldownCache = 0,
        itemUsedInAltarCache = 0,
        summonMonster = "Spellreaper Inferniarch",
        summonMonsterPosition1 = Position(33826, 32301, 9),
        summonMonsterPosition2 = Position(33821, 32300, 9),
        summonMonsterPosition3 = Position(33823, 32299, 9),
    },
    [10] = {
        bossName = "Gralvalon",
        bossPosition = Position(33809, 32300, 10),
        needUsedItemId = 50055,
        cooldownCache = 0,
        itemUsedInAltarCache = 0,
        summonMonster = "Hellhunter Inferniarch",
        summonMonsterPosition1 = Position(33811, 32299, 10),
        summonMonsterPosition2 = Position(33806, 32299, 10),
        summonMonsterPosition3 = Position(33809, 32298, 10),
    },
}

local eventBossCache = {}
local finishEventBossCache = {}

local function finishBossEvent(bossUid, index)
    local sacrificialAltar = sacrificialAltarTable[index]
    if not sacrificialAltar then
        return
    end

    local boss = Monster(bossUid)
    if boss and boss:getName() == sacrificialAltar.bossName then
        boss:remove()
    end

    finishEventBossCache[index] = nil
    eventBossCache[index] = nil
end

local function summonWave(index, wave)
    local sacrificialAltar = sacrificialAltarTable[index]
    if not sacrificialAltar then
        return
    end

    Game.createMonster(sacrificialAltar.summonMonster, sacrificialAltar.summonMonsterPosition1, true, true)
    Game.createMonster(sacrificialAltar.summonMonster, sacrificialAltar.summonMonsterPosition2, true, true)

    if wave >= 4 then
        eventBossCache[index] = nil
    else
        eventBossCache[index] = addEvent(summonWave, 1000 * 30, index, wave + 1) -- 30 seconds
    end
end

local function summonWaveBoss(index)
    local sacrificialAltar = sacrificialAltarTable[index]
    if not sacrificialAltar then
        return
    end

    local boss = Game.createMonster(sacrificialAltar.bossName, sacrificialAltar.bossPosition, true, true)
    if boss then
        Game.createMonster(sacrificialAltar.summonMonster, sacrificialAltar.summonMonsterPosition1, true, true)
        Game.createMonster(sacrificialAltar.summonMonster, sacrificialAltar.summonMonsterPosition2, true, true)
        Game.createMonster(sacrificialAltar.summonMonster, sacrificialAltar.summonMonsterPosition3, true, true)

        eventBossCache[index] = addEvent(summonWave, 1000 * 20, index, 1) -- 20 seconds
        finishEventBossCache[index] = addEvent(finishBossEvent, 1000 * 60 * config.removeBossTotalMinutes, boss.uid, index) -- 10 minutes
    end
end

local azzilonMiniBossesAction = Action()

function azzilonMiniBossesAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or type(target) ~= "userdata" then
        return false
    end

    if target.itemid ~= 49407 then -- Sacrificial Altar
        return false
    end

    local targetPosition = target:getPosition()
    if not targetPosition then
        return false
    end

    local sacrificialAltar = sacrificialAltarTable[targetPosition.z]
    if not sacrificialAltar then
        targetPosition:sendMagicEffect(CONST_ME_POFF)
        return false
    end

    if item.itemid ~= sacrificialAltar.needUsedItemId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item cannot be used as a sacrifice on this altar.")
        targetPosition:sendMagicEffect(CONST_ME_POFF)
    end

    local altarCooldown = sacrificialAltar.cooldownCache
    if (altarCooldown - os.time()) > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait for this altar to cooldown to summon the boss.")
        targetPosition:sendMagicEffect(CONST_ME_POFF)
    end

    local itemUsedInAltarInScript = sacrificialAltar.itemUsedInAltarCache
    if not itemUsedInAltarInScript then
        itemUsedInAltarInScript = 0
    end

    targetPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
    item:remove(1)
    itemUsedInAltarInScript = itemUsedInAltarInScript + 1

    if itemUsedInAltarInScript > 9 then
        itemUsedInAltarInScript = 0
        sacrificialAltar.cooldownCache = config.cooldownTimeInMinutes * 60
        player:say("You feel a malevolent aura creeping closer.", TALKTYPE_MONSTER_SAY, false, player, targetPosition)
        eventBossCache[targetPosition.z] = addEvent(summonWaveBoss, 1000 * 10, targetPosition.z) -- 10 seconds
    end

    sacrificialAltar.itemUsedInAltarCache = itemUsedInAltarInScript

    return true
end

azzilonMiniBossesAction:id(50054, 50055, 50101)
azzilonMiniBossesAction:register()
