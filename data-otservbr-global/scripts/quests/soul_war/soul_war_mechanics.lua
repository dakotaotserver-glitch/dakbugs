local login = CreatureEvent("SoulWarLogin")

function login.onLogin(player)
	player:registerEvent("GoshnarsHatredBuff")
	player:resetTaints()
	player:resetGoshnarSymbolTormentCounter()
	return true
end

login:register()

-- Goshnar's Malice reflection (100%) of physical and death damage
local goshnarsMaliceReflection = CreatureEvent("Goshnar's-Malice")

function goshnarsMaliceReflection.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local player = attacker:getPlayer()
	if player then
		if primaryDamage > 0 and (primaryType == COMBAT_PHYSICALDAMAGE or primaryType == COMBAT_DEATHDAMAGE) then
			player:addHealth(-primaryDamage)
		end
		if secondaryDamage > 0 and (secondaryType == COMBAT_PHYSICALDAMAGE or secondaryType == COMBAT_DEATHDAMAGE) then
			player:addHealth(-secondaryDamage)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

goshnarsMaliceReflection:register()

local soulCageReflection = CreatureEvent("SoulCageHealthChange")

function soulCageReflection.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local player = attacker:getPlayer()
	if player then
		if primaryDamage > 0 then
			player:addHealth(-primaryDamage * 0.1)
		end
		if secondaryDamage > 0 then
			player:addHealth(-secondaryDamage * 0.1)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

soulCageReflection:register()

local soulCageDeath = CreatureEvent("SoulCageDeath")

function soulCageDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if not creature or creature:isPlayer() or creature:getMaster() then
		return true
	end

	addEvent(SpawnSoulCage, 23000)
end

soulCageDeath:register()

local fourthTaintBossesDeath = CreatureEvent("FourthTaintBossesPrepareDeath")

function fourthTaintBossesDeath.onPrepareDeath(creature, killer, realDamage)
	if not creature or not killer:getPlayer() then
		return true
	end

	if creature:getHealth() - realDamage < 1 then
		if killer:getTaintNameByNumber(4) then
			local isInZone = killer:getSoulWarZoneMonster()
			if isInZone ~= nil then
				-- 10% of chance to heal
				if math.random(1, 10) == 1 then
					creature:say("Health restored by the mystic powers of Zarganash!")
					creature:addHealth(creature:getMaxHealth())
				end
			end
		end
	end
	return true
end

fourthTaintBossesDeath:register()

local bossesDeath = CreatureEvent("SoulWarBossesDeath")

function bossesDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local bossName = creature:getName()
	if SoulWarQuest.miniBosses[bossName] then
		local killers = creature:getKillers(true)
		for i, killerPlayer in ipairs(killers) do
			logger.debug("Player {} killed the boss.", killerPlayer:getName())
			local soulWarQuest = killerPlayer:soulWarQuestKV()
			-- Checks if the boss has already been defeated
			if not soulWarQuest:get(bossName) then
				local firstTaintTime = soulWarQuest:get("firstTaintTime")
				if not firstTaintTime then
					local currentTime = os.time()
					soulWarQuest:set("firstTaintTime", currentTime)
				end

				soulWarQuest:set(bossName, true) -- Mark the boss as defeated
				-- Adds the next taint in the sequence that the player does not already have
				killerPlayer:addNextTaint()
			end
		end
	end
end

bossesDeath:register()

fourthTaintBossesDeath:register()

local lastUse = 0
local cooldown = 30

local mirrorImageCreation = Action()
function mirrorImageCreation.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local currentTime = os.time()
	local timePassed = currentTime - lastUse
	if timePassed >= cooldown or lastUse == 0 then
		Game.createMonster("Mirror Image", player:getPosition())
		lastUse = currentTime
		item:transform(33783)
	else
		local timeLeft = cooldown - timePassed
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait " .. timeLeft .. " second(s) to use this item again.")
	end

	return true
end

mirrorImageCreation:id(33782)
mirrorImageCreation:register()

local mirroredNightmareApparitionDeath = CreatureEvent("MirroredNightmareBossAccess")

function mirroredNightmareApparitionDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local creatureName = creature:getName()
	if table.contains(SoulWarQuest.apparitionNames, creatureName) then
		local damageMap = creature:getMonster():getDamageMap()
		for key, _ in pairs(damageMap) do
			local player = Player(key)
			if player then
				local soulWarQuest = player:soulWarQuestKV()
				local currentCount = soulWarQuest:get(creatureName) or 0
				soulWarQuest:set(creatureName, currentCount + 1)
			end
		end
	end
end

mirroredNightmareApparitionDeath:register()

-- Check mirrored nightmare boss access
local goshnarGreedEntrance = MoveEvent()

function goshnarGreedEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local soulWarQuest = player:soulWarQuestKV()
	local hasAccess = true
	local message = "Progress towards Mirrored Nightmare boss access:\n"

	for _, apparitionName in pairs(SoulWarQuest.apparitionNames) do
		local count = soulWarQuest:get(apparitionName) or 0
		if count < SoulWarQuest.requiredCountPerApparition then
			hasAccess = false
			message = message .. apparitionName .. ": " .. count .. "/" .. SoulWarQuest.requiredCountPerApparition .. " kills\n"
		else
			message = message .. apparitionName .. ": Access achieved!\n"
		end
	end

	if not hasAccess then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
		player:teleportTo(fromPosition)
		return false
	end

	player:teleportTo(SoulWarQuest.goshnarsGreedAccessPosition.to)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

goshnarGreedEntrance:position(SoulWarQuest.goshnarsGreedAccessPosition.from)
goshnarGreedEntrance:register()



if GreedbeastKills == nil then
    GreedbeastKills = 0
end

local greedMonsterDeath = CreatureEvent("GreedMonsterDeath")

function greedMonsterDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if creature:getName() == "Greedbeast" then
        GreedbeastKills = GreedbeastKills + 1
        
        local createMonsterPosition = GreedMonsters[creature:getName()]
        
        CreateGoshnarsGreedMonster(creature:getName(), createMonsterPosition)
    end
end

greedMonsterDeath:register()






local checkTaint = TalkAction("!checktaint")

function checkTaint.onSay(player, words, param)
	local taintLevel = player:getTaintLevel()
	local taintName = player:getTaintNameByNumber(taintLevel)
	if taintLevel ~= nil and taintName ~= nil then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current taint level is: " .. taintLevel .. " name: " .. taintName)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You currently have no taint.")
	end

	return true
end

checkTaint:groupType("normal")
checkTaint:register()

local setTaint = TalkAction("/settaint")

function setTaint.onSay(player, words, param)
	local split = param:split(",")
	local target = Player(split[1])
	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player is offline")
		return false
	end

	local taintLevel = split[2]:trim():lower()
	local taintName = player:getTaintNameByNumber(tonumber(taintLevel), true)
	if taintName ~= nil then
		target:resetTaints(true)
		target:soulWarQuestKV():set(taintName, true)
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You new taint level is: " .. taintLevel .. ", name: " .. taintName)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Added taint level: " .. taintLevel .. ", name: " .. taintName .. " to player: " .. target:getName())
		target:setTaintIcon()
	end
end

setTaint:separator(" ")
setTaint:groupType("god")
setTaint:register()

local goshnarGreedTeleport = MoveEvent()

function goshnarGreedTeleport.onStepIn(creature, item, position, fromPosition)
	local creatureName = creature:getName()
	if creatureName == "Greedbeast" then
		return
	end

	local foundCreaturePosition = GreedMonsters[creatureName]
	if not foundCreaturePosition then
		return false
	end

	if item:getId() == 33791 then
		creature:remove()
		item:transform(33790)
		position:sendMagicEffect(CONST_ME_MORTAREA)
		CreateGoshnarsGreedMonster(creatureName, foundCreaturePosition)
	end

	return true
end

goshnarGreedTeleport:id(33790, 33791)
goshnarGreedTeleport:register()

local setTaint = TalkAction("/removetaint")

function setTaint.onSay(player, words, param)
	local split = param:split(",")
	local target = Player(split[1])
	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player is offline")
		return false
	end

	local taintLevel = split[2]:trim():lower()
	local taintName = player:getTaintNameByNumber(tonumber(taintLevel))
	if taintName ~= nil then
		target:soulWarQuestKV():remove(taintName)
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You lose taint level: " .. taintLevel .. ", name: " .. taintName)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Removed taint level: " .. taintLevel .. ", name: " .. taintName .. " from player: " .. target:getName())
	end
end

setTaint:separator(" ")
setTaint:groupType("god")
setTaint:register()

local changeMap = TalkAction("/changeflowmap")

function changeMap.onSay(player, words, param)
	if param == "empty" then
		Game.loadMap(SoulWarQuest.ebbAndFlow.mapsPath.empty)
	elseif param == "inundate" then
		Game.loadMap(SoulWarQuest.ebbAndFlow.mapsPath.inundate)
	elseif param == "ebb" then
		Game.loadMap(SoulWarQuest.ebbAndFlowmapsPath.ebbFlow)
	end
end

changeMap:separator(" ")
changeMap:groupType("god")
changeMap:register()

local hazardousPhantomDeath = CreatureEvent("HazardousPhantomDeath")

function hazardousPhantomDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local killers = creature:getKillers(true)
	for i, killerPlayer in ipairs(killers) do
		-- Checks if the killer is a player
		if killerPlayer:isPlayer() then
			local soulWarQuest = killerPlayer:soulWarQuestKV()
			local deathCount = soulWarQuest:get("hazardous-phantom-death") or 0
			-- Checks that the death count has not yet reached the limit
			if deathCount < SoulWarQuest.hardozousPanthomDeathCount then
				-- Increases death count
				soulWarQuest:set("hazardous-phantom-death", deathCount + 1)
				-- Send the count for the player
				killerPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You killed " .. (deathCount + 1) .. " of " .. SoulWarQuest.hardozousPanthomDeathCount .. " Hazardous Panthom.")
			end

			if deathCount + 1 == SoulWarQuest.hardozousPanthomDeathCount then
				killerPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can now access the boss room.")
			end
		end
	end
end

hazardousPhantomDeath:register()

local weepingSoulCorpse = MoveEvent()

local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit(SoulWarQuest.waterElementalOutfit)
condition:setTicks(14000)

function weepingSoulCorpse.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	if player:hasCondition(CONDITION_OUTFIT) then
		return
	end

	local monster = Creature("Goshnar's Spite")
	if monster then
		local chance = math.random(100)
		if chance <= SoulWarQuest.goshnarsSpiteHealChance then
			local healAmount = math.floor(monster:getMaxHealth() * (SoulWarQuest.goshnarsSpiteHealPercentage / 100))
			-- Heal percentage of the maximum health
			monster:addHealth(healAmount)
			logger.debug("Goshnar's Spite was healed to 10% of its maximum health.")
		end
	end

	item:remove()
	player:addCondition(condition)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are soaked by tears of the weeping soul!")
	return true
end

weepingSoulCorpse:id(SoulWarQuest.weepingSoulCorpseId)
weepingSoulCorpse:register()

local function removeSearingFire(position)
	local tile = Tile(position)
	if tile then
		local fire = tile:getItemById(SoulWarQuest.searingFireId)
		if fire then
			local monster = Creature("Goshnar's Spite")
			if monster then
				monster:addDefense(SoulWarQuest.goshnarsSpiteIncreaseDefense)
				logger.debug("Found Goshnar's Spite on boss zone, adding defense.")
			end
			fire:remove()
		end
	end
end

local goshnarSpiteFire = GlobalEvent("CreateGoshnarSpiteFire")

function goshnarSpiteFire.onThink(interval)
	local randomIndex = math.random(#SoulWarQuest.goshnarsSpiteFirePositions) -- Choose a random index
	local firePosition = SoulWarQuest.goshnarsSpiteFirePositions[randomIndex] -- Get the corresponding position
	local tile = Tile(firePosition)
	if tile then
		local fire = Game.createItem(SoulWarQuest.searingFireId, 1, firePosition)
		if fire then
			addEvent(removeSearingFire, SoulWarQuest.timeToRemoveSearingFire * 1000, firePosition)
		end
	end

	return true
end

goshnarSpiteFire:interval(SoulWarQuest.timeToCreateSearingFire * 1000)
goshnarSpiteFire:register()

local goshnarSpiteSoulFire = MoveEvent()

function goshnarSpiteSoulFire.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local tile = Tile(position)
	if not tile then
		return
	end

	local searingFire = tile:getItemById(SoulWarQuest.searingFireId)
	if not searingFire then
		return
	end

	local soulWarQuest = player:soulWarQuestKV()
	local lastSteppedTime = soulWarQuest:get("goshnar-spite-fire") or 0
	local currentTime = os.time()

	if lastSteppedTime + SoulWarQuest.cooldownToStepOnSearingFire > currentTime then
		local remainingTime = lastSteppedTime + SoulWarQuest.cooldownToStepOnSearingFire - currentTime
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "His soul won't need to recover again! You need wait " .. remainingTime .. " seconds.")
		return true
	end

	addEvent(function(playerId)
		local eventPlayer = Player(playerId)
		if eventPlayer then
			eventPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your soul has recovered!")
		end
	end, SoulWarQuest.cooldownToStepOnSearingFire * 1000, player:getId())

	soulWarQuest:set("goshnar-spite-fire", currentTime)
	searingFire:remove()
	player:setStorageValue(65091, -1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The soul fire was stomped out in time! Your soul will now have to recover before you can do this again.")

	return true
end

for _, pos in pairs(SoulWarQuest.goshnarsSpiteFirePositions) do
	goshnarSpiteSoulFire:position(pos)
end

goshnarSpiteSoulFire:register()

local ebbAndFlowBoatTeleports = MoveEvent()

function ebbAndFlowBoatTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or not SoulWarQuest.ebbAndFlow.isActive() then
		return
	end

	for _, pos in pairs(SoulWarQuest.ebbAndFlowBoatTeleportPositions) do
		if Position(pos.register) == position then
			player:teleportTo(pos.teleportTo)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for _, pos in pairs(SoulWarQuest.ebbAndFlowBoatTeleportPositions) do
	ebbAndFlowBoatTeleports:position(pos.register)
end
ebbAndFlowBoatTeleports:register()

local ebbAndFlowDoor = Action()

function ebbAndFlowDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if SoulWarQuest.ebbAndFlow.isActive() then
		return false
	end

	-- Determines whether the player is north or south of the door
	local playerPosition = player:getPosition()
	local destination = Position(toPosition.x, toPosition.y, toPosition.z)
	if playerPosition.y < toPosition.y then
		-- Player is north, move south
		destination.y = toPosition.y + 1
	else
		-- Player is south (or at the same y position), moves north
		destination.y = toPosition.y - 1
	end

	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

ebbAndFlowDoor:id(SoulWarQuest.ebbAndFlow.doorId)
ebbAndFlowDoor:register()

local rottenWastelandShrines = Action()

function rottenWastelandShrines.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local soulWarQuest = player:soulWarQuestKV()
	local shrineUsed = soulWarQuest:get("rotten-wasterland-activated-shrine-id") or 0
	if shrineUsed == item:getId() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already activated this shrine.")
		return true
	end

	local activatedShrinesCount = soulWarQuest:get("rotten-wasterland-activated-shrine-count") or 0
	if activatedShrinesCount >= 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already activated all the shrines.")
		return true
	end

	soulWarQuest:set("rotten-wasterland-activated-shrine-id", item:getId())

	soulWarQuest:set("rotten-wasterland-activated-shrine-count", activatedShrinesCount + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have activated this shrine.")
	return true
end

for itemId, position in pairs(SoulWarQuest.rottenWastelandShrines) do
	rottenWastelandShrines:id(itemId)
end

rottenWastelandShrines:register()

local goshnarsHatredAccess = Action()

function goshnarsHatredAccess.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local soulWarQuest = player:soulWarQuestKV()
	local activatedShrineCount = soulWarQuest:get("rotten-wasterland-activated-shrine-count") or 0
	if activatedShrineCount < 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to activate all the shrines.")
		return true
	end

	player:teleportTo(SoulWarQuest.goshnarsHatredAccessPosition.to)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

goshnarsHatredAccess:position(SoulWarQuest.goshnarsHatredAccessPosition.from)
goshnarsHatredAccess:register()

local goshnarsHatredSorrow = Action()
local STORAGE_BURNING_TIMER = 99995
local FROM_POS = Position(33734, 31591, 14)
local TO_POS = Position(33753, 31609, 14)

-- Procura o Ashes of Burning Hatred na área
local function findAshesInArea()
    local spectators = Game.getSpectators(FROM_POS, false, false,
        TO_POS.x - FROM_POS.x, TO_POS.x - FROM_POS.x,
        TO_POS.y - FROM_POS.y, TO_POS.y - FROM_POS.y)
    for _, spect in ipairs(spectators) do
        if spect:isMonster() and spect:getName():lower() == "ashes of burning hatred" then
            return spect
        end
    end
    return nil
end

-- Função do countdown de transformação
local function burningTransformationCountdown(ashesId)
    local ashes = Creature(ashesId)
    if not ashes or not ashes:isMonster() or ashes:isRemoved() then return end

    local timeLeft = ashes:getStorageValue(STORAGE_BURNING_TIMER)
    if timeLeft == -1 or timeLeft == 0 then return end

    for _, transformation in ipairs(SoulWarQuest.burningTransformations) do
        local triggerTime, newName = unpack(transformation)
        if timeLeft == triggerTime then
            if ashes:getName() ~= newName then
                ashes:setType(newName, true)
            end

            if newName == "Blaze of Burning Hatred" then
			ashes:say("The burning hatred reaches its peak and empowers Goshnar's Hate!", TALKTYPE_MONSTER_SAY)
			local boss = Creature("Goshnar's Hatred")
			if boss then
			boss:increaseHatredDamageMultiplier(100)
			end
				end
            break
        end
    end

    ashes:setStorageValue(STORAGE_BURNING_TIMER, timeLeft - 1)
    if timeLeft > 1 then
        addEvent(burningTransformationCountdown, 1000, ashesId)
    else
        ashes:setStorageValue(STORAGE_BURNING_TIMER, -1)
    end
end

-- ACTION que ATRASA a transformação, somando +10s no Ashes
function goshnarsHatredSorrow.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target then return false end

    if not table.contains(SoulWarQuest.burningHatredMonsters, target:getName()) then
        logger.error("Player {} tried to use the item on a non-burning hatred monster.", player:getName())
        return false
    end

    -- Atualiza o timer do Ashes de Burning Hatred
    local actualTime = target:getStorageValue(STORAGE_BURNING_TIMER) or 0
    if actualTime < 0 then actualTime = 0 end

    local newTime = actualTime + 10
    target:setStorageValue(STORAGE_BURNING_TIMER, newTime)

    logger.debug("Player {} used the item on the monster {}, oldTime {}, newTime {}.",
        player:getName(), target:getName(), actualTime, newTime)

    -- Mensagem ao jogador com tempo restante e tempo até próxima transformação
    local nextTransformIn = nil
    for _, transformation in ipairs(SoulWarQuest.burningTransformations) do
        local tTime, _ = unpack(transformation)
        if newTime > tTime then
            nextTransformIn = newTime - tTime
            break
        end
    end

    local msg = "The flame of hatred is doused! (" .. newTime .. "s restantes"
    if nextTransformIn then
        msg = msg .. " | " .. nextTransformIn .. "s para a proxima transformacao"
    end
    msg = msg .. ")"

    player:say(msg, TALKTYPE_MONSTER_SAY, 0, 0, target:getPosition())
    item:remove()
    return true
end



goshnarsHatredSorrow:id(SoulWarQuest.goshnarsHatredSorrowId)
goshnarsHatredSorrow:register()

-- No seu script de ataque ao boss:
local hatredTransformationStart = CreatureEvent("HatredBurningTransformationStart")
function hatredTransformationStart.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature:getName():lower() ~= "goshnar's hatred" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Só inicia o timer uma vez, se não começou ainda
    local ashes = findAshesInArea()
    if ashes and ashes:getStorageValue(STORAGE_BURNING_TIMER) == -1 then
        ashes:setStorageValue(STORAGE_BURNING_TIMER, 180)
        addEvent(burningTransformationCountdown, 1000, ashes:getId())
        ashes:say("The ashes start to fuel the burning transformation...", TALKTYPE_MONSTER_SAY)
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
hatredTransformationStart:register()


local hatredBurningTransformation = CreatureEvent("HatredBurningTransformation")
function hatredBurningTransformation.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature:isMonster() or creature:getName():lower() ~= "goshnar's hatred" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local ashes = findAshesInArea()
    if ashes and ashes:getStorageValue(STORAGE_BURNING_TIMER) == -1 then
        ashes:setStorageValue(STORAGE_BURNING_TIMER, 180)
        addEvent(burningTransformationCountdown, 1000, ashes:getId())
        ashes:say("The ashes start to fuel the burning transformation...", TALKTYPE_MONSTER_SAY)
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
hatredBurningTransformation:register()




local goshnarsHatredBuff = CreatureEvent("GoshnarsHatredBuff")

function goshnarsHatredBuff.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	-- Ensure both attacker and creature are valid and the creature is "Goshnar's Hatred"
	if creature then
		-- Check if the attacker is a player and the creature is being hit
		if attacker and creature:isMonster() and attacker:isPlayer() and (creature:getName() == "Goshnar's Hatred" or creature:getName() == "Goshnar's Megalomania") then
			local defenseMultiplier = creature:getHatredDamageMultiplier()
			if defenseMultiplier > 0 then
				-- Apply the defense multiplier
				creature:addDefense(defenseMultiplier)
				logger.debug("Adding defense to {}.", creature:getName())
			end
		-- Check if the attacker is a monster and the player is being hit
		elseif attacker and creature:isPlayer() and attacker:isMonster() and (attacker:getName() == "Goshnar's Hatred" or creature:getName() == "Goshnar's Megalomania") then
			local damageMultiplier = attacker:getHatredDamageMultiplier()
			if damageMultiplier > 0 then
				local multip = 1 + (damageMultiplier / 100)
				logger.debug("Adding damage: {} to {}.", multip, attacker:getName())
				-- Return modified damage values
				return primaryDamage * multip, primaryType, secondaryDamage, secondaryType
			end
		end
	end

	-- Return original damage values if no conditions are met
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

goshnarsHatredBuff:register()


local condensedRemorse = MoveEvent()

function condensedRemorse.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local soulWarKV = player:soulWarQuestKV()
	local remorseCount = soulWarKV:get("condensed-remorse") or 0
	soulWarKV:set("condensed-remorse", remorseCount + 1)
	if remorseCount + 1 == 2 then
		player:resetGoshnarSymbolTormentCounter()
		player:say("The remorse calms your dread!", TALKTYPE_MONSTER_SAY, 0, 0, item:getPosition())
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		soulWarKV:remove("condensed-remorse")
	end

	item:remove()
	return true
end

condensedRemorse:id(SoulWarQuest.condensedRemorseId)
condensedRemorse:register()

local furiousCraterAccess = EventCallback("FuriousCraterAccessDropLoot")

function furiousCraterAccess.monsterOnDropLoot(monster, corpse)
	if not monster or not corpse then
		return
	end

	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end

	local mType = monster:getType()
	if not mType then
		return
	end

	if not table.contains(SoulWarQuest.pulsatingEnergyMonsters, mType:getName()) then
		return
	end

	Game.createItem(SoulWarQuest.pulsatingEnergyId, 1, monster:getPosition())
end

furiousCraterAccess:register()

local pulsatingEnergy = MoveEvent()

function pulsatingEnergy.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local kv = player:pulsatingEnergyKV()
	local energyCount = kv:get("access-counter") or 0
	energyCount = energyCount + 1
	kv:set("access-counter", energyCount)

	logger.debug("Player {} stepped on a pulsating energy, current count: {}", player:getName(), energyCount)

	local firstFloorAccess = kv:get("first-floor-access") or false
	local secondFloorAccess = kv:get("second-floor-access") or false
	local thirdFloorAccess = kv:get("third-floor-access") or false
	if thirdFloorAccess then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've already gained access to fight with the Goshnar's Cruelty.")
		return true
	end

	if energyCount >= 40 and not firstFloorAccess then
		kv:set("access-counter", 0)
		kv:set("first-floor-access", true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've gained access to the first floor. Continue collecting Pulsating Energies to gain further access.")
	end

	if energyCount >= 55 and not secondFloorAccess then
		kv:set("access-counter", 0)
		kv:set("second-floor-access", true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've gained access to the second floor. Continue collecting Pulsating Energies to gain further access.")
	end

	if energyCount >= 70 and not thirdFloorAccess then
		kv:set("access-counter", 0)
		kv:set("third-floor-access", true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've gained access to the third floor. You can now fight with the Goshnar's Cruelty.")
	end

	item:remove()
	return true
end

pulsatingEnergy:id(SoulWarQuest.pulsatingEnergyId)
pulsatingEnergy:register()

local pulsatingEnergyTeleportAccess = MoveEvent()

function pulsatingEnergyTeleportAccess.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for _, posData in pairs(SoulWarQuest.goshnarsCrueltyTeleportRoomPositions) do
		if posData.from == position then
			local kv = player:pulsatingEnergyKV()
			local hasAccess = kv:get(posData.access) or false
			local energyCount = kv:get("access-counter") or 0
			local energiesNeeded = posData.count - energyCount
			if not hasAccess then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this floor yet. You have collected " .. energyCount .. "/" .. posData.count .. ", and need " .. energiesNeeded .. " more pulsating energies to gain access.")
				player:teleportTo(fromPosition, true)
				fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:teleportTo(posData.to)
				posData.to:sendMagicEffect(CONST_ME_TELEPORT)
			end

			break
		end
	end

	return true
end

for _, positions in pairs(SoulWarQuest.goshnarsCrueltyTeleportRoomPositions) do
	pulsatingEnergyTeleportAccess:position(positions.from)
end

pulsatingEnergyTeleportAccess:register()

local cloakOfTerrorHealthLoss = CreatureEvent("CloakOfTerrorHealthLoss")

function cloakOfTerrorHealthLoss.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if attacker:getPlayer() and primaryDamage > 0 or secondaryDamage > 0 then
		local position = creature:getPosition()
		local tile = Tile(position)
		if tile then
			if not tile:getItemById(SoulWarQuest.theBloodOfCloakTerrorIds[1]) then
				Game.createItem(SoulWarQuest.theBloodOfCloakTerrorIds[1], 1, position)
			end
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

cloakOfTerrorHealthLoss:register()

local theBloodOfCloakStep = MoveEvent()

function theBloodOfCloakStep.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	-- If a player steps in blood, it takes damage
	if player then
		local damagePercentage = SoulWarQuest.poolDamagePercentages[item:getId()] or 0
		local maxHealth = player:getMaxHealth()
		local damage = maxHealth * damagePercentage

		player:addHealth(-damage, COMBAT_ENERGYDAMAGE)
	end

	-- If a "Cloak of Terror" monster steps in blood, it heals itself
	local monster = creature:getMonster()
	if monster and monster:getName() == "Cloak of Terror" then
		local healAmount = math.random(1500, 2000)
		monster:addHealth(healAmount)
	end

	item:remove()

	return true
end

for _, itemId in pairs(SoulWarQuest.theBloodOfCloakTerrorIds) do
	theBloodOfCloakStep:id(itemId)
end

theBloodOfCloakStep:register()

local greedyMaw = Action()

function greedyMaw.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not item or not target then
		logger.error("Greedy Maw action failed, item or target is nil.")
		return false
	end

	if target:getId() == SoulWarQuest.greedyMawId then
		local kv = player:soulWarQuestKV():scoped("furious-crater")
		local cooldown = kv:get("greedy-maw-action") or 0
		local currentTime = os.time()
		if cooldown + SoulWarQuest.useGreedMawCooldown > currentTime then
			local timeLeft = cooldown + SoulWarQuest.useGreedMawCooldown - currentTime
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait " .. timeLeft .. " more seconds before using the greedy maw again.")
			return true
		end

		kv:set("greedy-maw-action", currentTime)
		local timeToIncreaseDefense = SoulWarQuest.timeToIncreaseCrueltyDefense
		SoulWarQuest.kvSoulWar:set("greedy-maw-action", currentTime + timeToIncreaseDefense)
		target:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use the item again within " .. timeToIncreaseDefense .. " seconds, or the monster's defense will increase by 2 every " .. timeToIncreaseDefense .. " seconds.")
		local goshnarsCruelty = Creature("Goshnar's Cruelty")
		if goshnarsCruelty then
			local mtype = goshnarsCruelty:getType()
			if not mtype then
				logger.error("Greedy Maw action failed, Goshnar's Cruelty has no type.")
				return false
			end

			-- If the defense of Goshnar's Cruelty is higher than the default defense, decrease it by 2
			if goshnarsCruelty:getDefense() > mtype:defense() then
				logger.debug("Greedy Maw used on Goshnar's Cruelty, old defense {}", goshnarsCruelty:getDefense())
				goshnarsCruelty:addDefense(-SoulWarQuest.goshnarsCrueltyDefenseChange)
				logger.debug("Greedy Maw used on Goshnar's Cruelty, new defense {}", goshnarsCruelty:getDefense())
			end

			local defenseDrainValue = SoulWarQuest.kvSoulWar:get("goshnars-cruelty-defense-drain") or 0
			if defenseDrainValue > 0 then
				SoulWarQuest.kvSoulWar:set("goshnars-cruelty-defense-drain", defenseDrainValue - 1)
			end
		end
		return true
	end

	return false
end

greedyMaw:id(SoulWarQuest.someMortalEssenceId)
greedyMaw:register()


local ARENA_CENTER = Position(33710, 31635, 14)  -- Troque para o centro real da sua arena!
local ARENA_WIDTH = 15  -- Ajuste conforme o tamanho da sua arena
local ARENA_HEIGHT = 15

local soulWarAspectOfPowerDeath = CreatureEvent("SoulWarAspectOfPowerDeath")

function soulWarAspectOfPowerDeath.onDeath(creature)
    local targetMonster = creature:getMonster()
    if not targetMonster or targetMonster:getMaster() then
        return
    end

    -- Busca o boss na área da arena pelos spectators
    local boss = nil
    local spectators = Game.getSpectators(ARENA_CENTER, false, false, ARENA_WIDTH, ARENA_WIDTH, ARENA_HEIGHT, ARENA_HEIGHT)
    for _, spect in ipairs(spectators) do
        if spect:isMonster() and spect:getName() == "Goshnar's Megalomania" and spect:getTypeName() == "Goshnar's Megalomania Purple" then
            boss = spect
            break
        end
    end

    if boss then
        boss:increaseAspectOfPowerDeathCount()
    end

    -- Respawn do Aspect após 15 segundos na posição do boss ou na do aspecto morto
    local position = boss and boss:getPosition() or creature:getPosition()
    addEvent(function(pos)
        local aspectMonster = Game.createMonster("Aspect of Power", pos)
        if aspectMonster then
            local outfit = aspectMonster:getOutfit()
            outfit.lookType = math.random(1303, 1307)
            aspectMonster:setOutfit(outfit)
        end
    end, 15000, position)

    return true
end

soulWarAspectOfPowerDeath:register()





local madnessReduce = MoveEvent()

function madnessReduce.onStepIn(creature, item, position, fromPosition)
	-- Obtém o jogador, se a criatura for um jogador
	local player = creature and creature:getPlayer()
	
	if player then
		-- Efeito de área sagrada e remoção do item
		item:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		item:remove()
		player:setStorageValue(65116, 0) -- Ajustado para 0 para redefinir o valor de armazenamento
		
		-- Verificação e reset do contador de tormento
		if player:getGoshnarSymbolTormentCounter() > 0 then
			player:resetGoshnarSymbolTormentCounter()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ooze calms your dread but leaves you vulnerable to phantasmal attacks!")
		end
	end

	-- Verifica se a criatura é uma das Splinters of Madness e executa o processo de respawn
	local creatureName = creature:getName()
	if creatureName == "Lesser Splinter of Madness" or creatureName == "Greater Splinter of Madness" or creatureName == "Mighty Splinter of Madness" then
	    local creaturePosition = creature:getPosition()
	    creature:remove()
		item:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		item:remove()
	    Game.createItem(SoulWarQuest.cleansedSanityItemId, 1, creaturePosition)
	    
	    local respawnPosition = Position(33712, 31632, 14)
	    addEvent(function()
	        Game.createMonster("Lesser Splinter of Madness", respawnPosition)
	        respawnPosition:sendMagicEffect(CONST_ME_TELEPORT)
	    end, 20000)
	end

	return true
end

-- Registrar o evento corretamente
madnessReduce:id(SoulWarQuest.deadAspectOfPowerCorpseId)
madnessReduce:register()



local cleansedSanity = Action()

-- Função utilitária para buscar o boss Goshnar's Megalomania em qualquer forma/fase
local function findMegalomaniaBoss()
    local ARENA_CENTER = Position(33710, 31635, 14)
    local ARENA_WIDTH = 15
    local ARENA_HEIGHT = 15

    local spectators = Game.getSpectators(ARENA_CENTER, false, false, ARENA_WIDTH, ARENA_WIDTH, ARENA_HEIGHT, ARENA_HEIGHT)
    for _, spect in ipairs(spectators) do
        if spect:isMonster() then
            local tName = spect:getTypeName()
            if tName and tName:find("Goshnar's Megalomania") then
                return spect
            end
        end
    end
    return nil
end

function cleansedSanity.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not item or not target then
        return false
    end

    local kv = player:soulWarQuestKV():scoped("furious-crater")
    local cooldown = kv:get("cleansed-sanity-action") or 0
    local currentTime = os.time()

    if cooldown + SoulWarQuest.useGreedMawCooldown > currentTime then
        local timeLeft = cooldown + SoulWarQuest.useGreedMawCooldown - currentTime
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait " .. timeLeft .. " more seconds before using the cleansed again.")
        return true
    end

    kv:set("cleansed-sanity-action", currentTime)

    if target:getId() == SoulWarQuest.greedyMawId then
        local timeToIncreaseDefense = SoulWarQuest.timeToIncreaseCrueltyDefense
        SoulWarQuest.kvSoulWar:set("cleansed-sanity-action", currentTime + timeToIncreaseDefense)
        target:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
        item:remove()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use the item again within " .. timeToIncreaseDefense .. " seconds, or the monster's defense will increase every " .. timeToIncreaseDefense .. " seconds.")

        local boss = findMegalomaniaBoss()
        if boss then
            local mtype = boss:getType()
            local bossDefense = boss:getDefense()
            local baseDefense = mtype:defense()

            if bossDefense > baseDefense then
                boss:addDefense(-SoulWarQuest.goshnarsCrueltyDefenseChange)
            end
        end
        return true
    end

    return false
end

cleansedSanity:id(SoulWarQuest.cleansedSanityItemId)
cleansedSanity:register()




local necromanticRemainsReduce = MoveEvent()

function necromanticRemainsReduce.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	player:removeGoshnarSymbolTormentCounter(5)
	item:remove()
	position:sendMagicEffect(CONST_ME_HOLYAREA)
	return true
end

necromanticRemainsReduce:id(SoulWarQuest.necromanticRemainsItemId)
necromanticRemainsReduce:register()

local necromanticFocusDeath = CreatureEvent("NecromanticFocusDeath")

function necromanticFocusDeath.onDeath(creature)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return
	end

	local position = targetMonster:getPosition()
	addEvent(function()
		position:increaseNecromaticMegalomaniaStrength()
	end, 5 * 60 * 1000)

	return true
end

necromanticFocusDeath:register()

local megalomaniaDeath = CreatureEvent("MegalomaniaDeath")

function megalomaniaDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local killers = creature:getKillers(true)
	for i, killerPlayer in ipairs(killers) do
		local soulWarQuest = killerPlayer:soulWarQuestKV()
		-- Checks if the boss has already been defeated
		if not soulWarQuest:get("goshnar's-megalomania-killed") then
			soulWarQuest:set("goshnar's-megalomania-killed", true)
			killerPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have defeated Goshnar's Megalomania. Report the 'task' to Flickering Soul and earn your outfit.")
		end

		-- Reset taints and torment counters
		if killerPlayer.resetTaints then
			killerPlayer:resetTaints(true)
		end
		if killerPlayer.resetGoshnarSymbolTormentCounter then
			killerPlayer:resetGoshnarSymbolTormentCounter()
		end
	end
	return true
end

megalomaniaDeath:register()


local teleportStepRemoveIcon = MoveEvent()

function teleportStepRemoveIcon.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	player:resetGoshnarSymbolTormentCounter()
	return true
end

local teleportPositions = {
	Position(33713, 31642, 14),
	Position(33743, 31606, 14),
}

for _, pos in pairs(teleportPositions) do
	teleportStepRemoveIcon:position(pos)
end

teleportStepRemoveIcon:register()

local goshnarsCrueltyBuff = CreatureEvent("GoshnarsCrueltyBuff")

function goshnarsCrueltyBuff.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if creature and creature:isMonster() and attacker:isPlayer() and creature:getName() == "Goshnar's Cruelty" then
		local newValue = SoulWarQuest.kvSoulWar:get("goshnars-cruelty-defense-drain") or SoulWarQuest.goshnarsCrueltyDefenseChange
		if newValue ~= 0 then
			local multiplier = math.max(0, 1 - (newValue / 100))
			return primaryDamage * multiplier, primaryType, secondaryDamage * multiplier, secondaryType
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

goshnarsCrueltyBuff:register()
