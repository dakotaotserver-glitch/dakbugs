local spell = Spell("instant")

-- A matriz original contendo 0,1,2,3
local areaOriginal = {
	{ 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0 },
	{ 0, 1, 2, 0, 0, 0, 2, 0, 0, 0, 2, 1, 0 },
	{ 0, 2, 1, 2, 0, 0, 0, 0, 0, 2, 1, 2, 0 },
	{ 0, 0, 2, 1, 0, 0, 0, 0, 0, 1, 2, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0 },
	{ 0, 0, 2, 1, 0, 0, 0, 0, 0, 1, 2, 0, 0 },
	{ 0, 2, 1, 2, 0, 0, 0, 0, 0, 2, 1, 2, 0 },
	{ 0, 1, 2, 0, 0, 0, 2, 0, 0, 0, 2, 1, 0 },
	{ 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0 },
}

----------------------------------------------------------------
-- 1) Convertendo areaOriginal em duas matrizes: holyArea e deathArea
----------------------------------------------------------------
local holyArea = {}
local deathArea = {}

for i = 1, #areaOriginal do
	holyArea[i] = {}
	deathArea[i] = {}
	for j = 1, #areaOriginal[i] do
		local value = areaOriginal[i][j]
		-- Holy: marca 1 ou 3
		if value == 1 or value == 3 then
			holyArea[i][j] = value -- mantém 1 ou 3
		else
			holyArea[i][j] = 0
		end
		-- Death: marca 2 ou 3
		if value == 2 or value == 3 then
			-- Para o Death, podemos colocar 1 no lugar de 2 e manter 3,
			-- pois só precisamos que seja "válido" para o createCombatArea.
			if value == 2 then
				deathArea[i][j] = 1
			else
				deathArea[i][j] = 3
			end
		else
			deathArea[i][j] = 0
		end
	end
end

----------------------------------------------------------------
-- 2) Criando dois Combats distintos
----------------------------------------------------------------

-- Combat do Holy
local combatHoly = Combat()
combatHoly:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)             -- Dano Holy
combatHoly:setParameter(COMBAT_PARAM_EFFECT, 18)        -- Efeito visual Holy
combatHoly:setArea(createCombatArea(holyArea))

-- Combat do Death
local combatDeath = Combat()
combatDeath:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)          -- Dano Death
combatDeath:setParameter(COMBAT_PARAM_EFFECT, 40)         -- Efeito visual Death
combatDeath:setArea(createCombatArea(deathArea))

----------------------------------------------------------------
-- 3) No onCastSpell, executamos os dois combates
----------------------------------------------------------------
function spell.onCastSpell(creature, var)
	-- Executa o Holy primeiro
	local successHoly = combatHoly:execute(creature, var)
	
	-- Depois executa o Death
	local successDeath = combatDeath:execute(creature, var)
	
	-- Retorna true somente se ambos executaram com sucesso
	return (successHoly and successDeath)
end

----------------------------------------------------------------
-- 4) Registro normal do spell
----------------------------------------------------------------
spell:name("holy_death_spell_aoe")
spell:words("###holydeathaoe")      -- Exemplo de "palavra" para conjurar
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
