-- Área padrão para a magia de root
local areaRoot = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
}

local createRootArea = createCombatArea(areaRoot)

-- Define a condição de Root (imobilização)
local conditionRoot = Condition(CONDITION_ROOTED)
conditionRoot:setParameter(CONDITION_PARAM_TICKS, 5000) -- Imobiliza por 5 segundos

-- Criação do combate para a magia de root
local rootCombat = Combat()
rootCombat:setParameter(COMBAT_PARAM_EFFECT, 242) -- Efeito visual de cura azul
rootCombat:setArea(createRootArea)

-- Define o comportamento ao atingir cada tile dentro da área de root
function onRootTargetTile(creature, pos)
	local creaturesOnTile = Tile(pos):getCreatures()
	for _, target in ipairs(creaturesOnTile) do
		if target:isPlayer() then
			target:addCondition(conditionRoot) -- Aplica imobilização no jogador
		end
	end
	pos:sendMagicEffect(242) -- Exibe o efeito de cura azul no tile afetado
	return true
end

rootCombat:setCallback(CALLBACK_PARAM_TARGETTILE, "onRootTargetTile")

-- Definição da área de dano de energia
local areaEnergy = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 },
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
}


local createEnergyArea = createCombatArea(areaEnergy)

-- Criação do combate para a magia de dano de energia
local energyCombat = Combat()
energyCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE) -- Define tipo de dano como energia
energyCombat:setParameter(COMBAT_PARAM_EFFECT, 216) -- Efeito visual de área de energia
energyCombat:setArea(createEnergyArea)

-- Define a função para causar dano de energia
function onEnergyTargetTile(creature, pos)
	local min = -4600
	local max = -5800
	local creaturesOnTile = Tile(pos):getCreatures()
	for _, target in ipairs(creaturesOnTile) do
		if target:isPlayer() then
			doTargetCombatHealth(creature, target, COMBAT_ENERGYDAMAGE, min, max, CONST_ME_ENERGYHIT)
		end
	end
	pos:sendMagicEffect(216) -- Exibe o efeito de energia na área afetada
	return true
end

energyCombat:setCallback(CALLBACK_PARAM_TARGETTILE, "onEnergyTargetTile")

-- Função para teletransportar Mitmah Vanguard após 5 segundos e aplicar a magia de dano
local function teleportAndCastSpell(creatureId)
	local creature = Creature(creatureId)
	if not creature then
		return
	end

	-- Definir posições dentro do range especificado
	local fromPosition = Position(34058, 31406, 11)
	local toPosition = Position(34078, 31416, 11)

	-- Gerar coordenadas aleatórias dentro da área
	local randomX = math.random(fromPosition.x, toPosition.x)
	local randomY = math.random(fromPosition.y, toPosition.y)
	local randomPos = Position(randomX, randomY, fromPosition.z)

	-- Teleporta Mitmah Vanguard para a posição aleatória
	creature:teleportTo(randomPos)
	randomPos:sendMagicEffect(CONST_ME_TELEPORT) -- Efeito de teleporte na nova posição

	-- Executa a magia de dano de energia na nova posição
	energyCombat:execute(creature, positionToVariant(randomPos))
end

-- Registra o feitiço e define como ele é lançado pela criatura
local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if creature:getName():lower() == "mitmah vanguard" then
		creature:say("FEAR THE CURSE!!", TALKTYPE_MONSTER_SAY)
		rootCombat:execute(creature, var)
		addEvent(teleportAndCastSpell, 7000, creature:getId()) -- Teleporta e aplica o segundo feitiço após 5 segundos
		return true
	end
	return false
end

spell:name("mitmah_root_area_teleport_energy")
spell:words("###911") -- Palavras mágicas de ativação
spell:blockWalls(true)
spell:isAggressive(false)
spell:register()
