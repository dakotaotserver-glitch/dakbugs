local config = {
	centerRoom = Position(33443, 31545, 13),
	newPosition = Position(33436, 31572, 13),
	exitPos = Position(32172, 31917, 8),
	x = 30,
	y = 30,
	summons = {
		{
			name = "Rewar The Bloody",
			pos = Position(33463, 31562, 13),
		},
		{
			name = "The Red Knight",
			pos = Position(33423, 31562, 13),
		},
		{
			name = "Magnor Mournbringer",
			pos = Position(33463, 31529, 13),
		},
		{
			name = "Nargol the Impaler",
			pos = Position(33423, 31529, 13),
		},
		{
			name = "King Zelos",
			pos = Position(33443, 31545, 13),
		},
	},
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Room,
	fromPos = Position(33414, 31520, 13),
	toPos = Position(33474, 31574, 13),
}

local zelos_damage = CreatureEvent("zelos_damage")

function zelos_damage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if primaryType ~= COMBAT_HEALING then
		local storage = creature:getStorageValue(1)

		if storage < 800 then
			primaryDamage = (primaryDamage + secondaryDamage) - ((primaryDamage + secondaryDamage) * (storage / 800))
			secondaryDamage = 0
		else
			primaryDamage = (primaryDamage + secondaryDamage) - ((primaryDamage + secondaryDamage) * 0.99)
			secondaryDamage = 0
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

zelos_damage:register()

local zelos_init = CreatureEvent("zelos_init")

function zelos_init.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local knights = { "Nargol The Impaler", "Magnor Mournbringer", "The Red Knight", "Rewar The Bloody", "Shard Of Magnor", "Regenerating Mass" }

	for _, knight in pairs(knights) do
		local boss = Creature(knight)
		if boss and boss:getId() ~= creature:getId() then
			return true
		end
	end

	local zelos = Creature("King Zelos")

	if zelos then
		local eq = os.time() - zelos:getStorageValue(1)

		zelos:setStorageValue(1, eq)
	end

	return true
end

zelos_init:register()

local blood_explode = Combat()
local area = createCombatArea(AREA_SQUARE1X1)
blood_explode:setArea(area)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()
	if tile then
		if target and target:getId() ~= cid:getId() then
			if target:isMonster() and target:getName():lower() == "the red knight" or target:isPlayer() then
				doTargetCombatHealth(0, target, COMBAT_DROWNDAMAGE, -20000, -25000)
			end
		end
	end
end

blood_explode:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local blood_death = CreatureEvent("blood_death")

function blood_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local var = { type = 1, number = creature:getId() }

	blood_explode:execute(creature, var)

	return true
end

blood_death:register()

local nargol_death = CreatureEvent("nargol_death")

function nargol_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	Game.createMonster("Regenerating Mass", Position(33423, 31529, 13), false, true)

	addEvent(function()
		local mass = Creature("Regenerating Mass")
		if mass then
			mass:remove()
			Game.createMonster("Nargol The Impaler", Position(33423, 31529, 13), false, true)
		end
	end, 30 * 1000)

	return true
end

nargol_death:register()

local shard_explode = Combat()
shard_explode:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

local area = createCombatArea(AREA_CIRCLE2X2)
shard_explode:setArea(area)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()

	if tile then
		if target and target:isPlayer() then
			doTargetCombatHealth(0, target, COMBAT_LIFEDRAIN, -2000, -4000)
		end
	end
end

shard_explode:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local shard_death = CreatureEvent("shard_death")

function shard_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local var = { type = 1, number = creature:getId() }

	shard_explode:execute(creature, var)

	return true
end

shard_death:register()

local magnor_death = CreatureEvent("magnor_death")

function magnor_death.onDeath(creature)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local groupId = os.time()
	SharedShardGroups[groupId] = {}

	for i = 1, 4 do
		local pos = creature:getClosestFreePosition(creature:getPosition(), true)
		local shard = Game.createMonster("Shard Of Magnor", pos, false, true)

		if shard then
			shard:setStorageValue(50000, groupId)
			table.insert(SharedShardGroups[groupId], shard)
			shard:registerEvent("SharedLife")
			shard:registerEvent("shard_death")
		end
	end

	return true
end


magnor_death:register()

-- Armazena grupos de shards
SharedShardGroups = SharedShardGroups or {}

local function getGroup(id)
	return SharedShardGroups[id] or {}
end

local sharedLife = CreatureEvent("SharedLife")

function sharedLife.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_HEALING or origin == ORIGIN_REGAINHEALTH then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)
	local groupId = creature:getStorageValue(50000) -- storage para vincular ao grupo

	if groupId <= 0 then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	for _, shard in pairs(getGroup(groupId)) do
		if shard:isMonster() and shard:getId() ~= creature:getId() then
			shard:addHealth(-totalDamage)
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

sharedLife:register()



local fetter_death = CreatureEvent("fetter_death")

function fetter_death.onDeath(creature)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	-- Procura o Rewar The Bloody na área da arena
	local boss = nil
	for x = 33411, 33477 do
		for y = 31515, 31572 do
			local tile = Tile(Position(x, y, 13))
			if tile then
				local topCreature = tile:getTopCreature()
				if topCreature and topCreature:isMonster() and topCreature:getName() == "Rewar The Bloody" then
					boss = topCreature
					break
				end
			end
		end
		if boss then break end
	end

	if not boss then
		return true
	end

	local current = boss:getStorageValue(2)
	boss:setStorageValue(2, current - 1)

	if boss:getStorageValue(2) <= 0 then
		boss:setType("Rewar The Bloody")
	end

	return true
end

fetter_death:register()




local rewar_the_bloody = CreatureEvent("rewar_the_bloody")

rewar_the_bloody:type("healthchange")

function rewar_the_bloody.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local health = creature:getMaxHealth() * 0.05

	local totalDamage = math.abs(primaryDamage) + math.abs(secondaryDamage)
	creature:setStorageValue(1, creature:getStorageValue(1) + totalDamage)


	if creature:getStorageValue(1) >= health then
		creature:setStorageValue(1, 0)
		creature:setStorageValue(2, 0)

		local fetters = math.random(1, 3)
		local fromPos, toPos = Position(33458, 31556, 13), Position(33467, 31566, 13)

		for i = 1, fetters do
			local position = Position(math.random(fromPos.x, toPos.x), math.random(fromPos.y, toPos.y), fromPos.z)
			local fetter = Game.createMonster("Fetter", position, true, true)
			if fetter then
				creature:setStorageValue(2, creature:getStorageValue(2) + 1)
			end
		end
		creature:setType("Rewar The Bloody Inv")
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

rewar_the_bloody:register()



local vampiricBloodDeath = CreatureEvent("VampiricBloodDeath")

function vampiricBloodDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local deathPosition = creature:getPosition() -- Posição onde a criatura 'Vampiric Blood' morreu
    local damageAmount = 10000 -- Dano a ser aplicado ao 'The Red Knight'
    local effect = CONST_ME_HITBYFIRE -- Efeito visual de fotossensibilidade

    -- Função para encontrar a criatura 'The Red Knight' próxima à posição da morte
    local function findNearbyTheRedKnight(position, radius)
        local nearbyCreatures = Game.getSpectators(position, false, false, radius, radius, radius, radius)
        for _, target in ipairs(nearbyCreatures) do
            if target:isMonster() and target:getName():lower() == "the red knight" then
                return target
            end
        end
        return nil
    end

    -- Encontrar a criatura 'The Red Knight' nas proximidades e aplicar dano
    local redKnight = findNearbyTheRedKnight(deathPosition, 1) -- Aumenta o raio para 3x3 ao redor da posição da morte
    if redKnight then
        redKnight:addHealth(-damageAmount) -- Aplica o dano
        redKnight:getPosition():sendMagicEffect(effect) -- Aplica o efeito visual
    end

    return true
end

vampiricBloodDeath:register()
