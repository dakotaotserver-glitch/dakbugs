local AREA_CIRCLE2X2 = {
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 1, 3, 1, 1 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
}

local function applyPoisonDamageAndRemoveMushroom(mushroomPos)
	local spectators = Game.getSpectators(mushroomPos, false, true, 2, 2, 2, 2)
	
	-- Aplica o efeito de veneno conforme o padrão AREA_CIRCLE2X2
	for x = -2, 2 do
		for y = -2, 2 do
			if AREA_CIRCLE2X2[x + 3] and AREA_CIRCLE2X2[x + 3][y + 3] == 1 then
				local pos = Position(mushroomPos.x + x, mushroomPos.y + y, mushroomPos.z)
				pos:sendMagicEffect(CONST_ME_POISONAREA)  -- Efeito de poison aplicado
			end
		end
	end

	-- Aplica dano a todos os jogadores no raio de 2x2
	local damage = math.random(2500, 3000)
	for _, player in ipairs(spectators) do
		if player:isPlayer() then
			player:addHealth(-damage, COMBAT_LIFEDRAIN)
		end
	end
	
	-- Remove a Mushroom após aplicar o efeito
	local mushroom = Tile(mushroomPos):getTopCreature()
	if mushroom and mushroom:getName():lower() == "mushroom" then
		mushroom:remove()
	end
end

local mushroomEffect = CreatureEvent("MushroomEffect")
function mushroomEffect.onThink(creature)
	if creature:getName():lower() ~= "mushroom" then
		return true
	end

	local spectators = Game.getSpectators(creature:getPosition(), false, true, 2, 2, 2, 2)
	for _, player in ipairs(spectators) do
		if player:isPlayer() then
			-- Verifica se o jogador está no raio de 2x2 da Mushroom
			if player:getPosition():getDistance(creature:getPosition()) <= 2 then
				-- Aplica o efeito de veneno e remove a Mushroom após 2 segundos
				addEvent(applyPoisonDamageAndRemoveMushroom, 2000, creature:getPosition())
			end
		end
	end
	
	return true
end

mushroomEffect:register()
