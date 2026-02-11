function Creature:onTargetCombat(target)
	if not self then
		return true
	end

	if (target:isMonster() and self:isPlayer() and target:getMaster() == self) or (self:isMonster() and target:isPlayer() and self:getMaster() == target) then
		return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
	end

	-- ============================================
	-- SISTEMA PVP ON/OFF - INICIO
	-- ============================================
	local PVP_STORAGE = 45000
	
	-- Verifica se ambos são players
	if self:isPlayer() and target:isPlayer() then
		local attacker = self
		local victim = target
		
		-- Verifica se atacante tem PVP OFF
		local attackerPvp = attacker:getStorageValue(PVP_STORAGE)
		if attackerPvp == 1 then
			attacker:sendCancelMessage("Você está em modo pacífico e não pode atacar outros jogadores!")
			attacker:getPosition():sendMagicEffect(CONST_ME_POFF)
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
		
		-- Verifica se vítima tem PVP OFF
		local victimPvp = victim:getStorageValue(PVP_STORAGE)
		if victimPvp == 1 then
			attacker:sendCancelMessage(victim:getName() .. " está em modo pacífico e não pode ser atacado!")
			attacker:getPosition():sendMagicEffect(CONST_ME_POFF)
			return RETURNVALUE_YOUMAYNOTATTACKTHISCREATURE
		end
	end
	-- ============================================
	-- SISTEMA PVP ON/OFF - FIM
	-- ============================================

	if not IsRetroPVP() or PARTY_PROTECTION ~= 0 then
		if self:isPlayer() and target:isPlayer() then
			local party = self:getParty()
			if party then
				local targetParty = target:getParty()
				if targetParty and targetParty == party then
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
				end
			end
		end
	end

	if not IsRetroPVP() or ADVANCED_SECURE_MODE ~= 0 then
		if self:isPlayer() and target:isPlayer() then
			if self:hasSecureMode() then
				return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
			end
		end
	end

	self:addEventStamina(target)
	return true
end

function Creature:onChangeOutfit(outfit)
	if self:isPlayer() then
		local familiarLookType = self:getFamiliarLooktype()
		if familiarLookType ~= 0 then
			for _, summon in pairs(self:getSummons()) do
				if summon:getType():familiar() then
					if summon:getOutfit().lookType ~= familiarLookType then
						summon:setOutfit({ lookType = familiarLookType })
					end
					break
				end
			end
		end
	end
	return true
end

function Creature:onDrainHealth(attacker, typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary)
	if not self then
		return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
	end

	if not attacker then
		return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
	end

	return typePrimary, damagePrimary, typeSecondary, damageSecondary, colorPrimary, colorSecondary
end