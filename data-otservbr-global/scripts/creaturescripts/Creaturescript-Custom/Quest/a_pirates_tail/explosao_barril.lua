local piratArtilleristThink = CreatureEvent("PiratArtilleristThink")
local cooldownTime = 3 -- Tempo de recarga em segundos
local storageKey = 65033 -- Chave de armazenamento única para armazenar o último tempo de ataque

function piratArtilleristThink.onThink(creature)
    if creature:getName():lower() == "pirat artillerist" then
        local currentTime = os.time()
        local lastAttackTime = creature:getStorageValue(storageKey)

        -- Se nenhum ataque foi feito ainda ou o cooldown passou
        if lastAttackTime == -1 or (currentTime - lastAttackTime >= cooldownTime) then
            local artilleristPosition = creature:getPosition()
            local shootEffect = CONST_ANI_FIRE -- Efeito de projétil
            local effect = CONST_ME_FIREAREA -- Efeito de impacto
            local damageAmount = 150 -- Dano a ser aplicado
            local attackRange = 8 -- Alcance máximo do ataque

            -- Função para encontrar a criatura 'Rum Barrel' dentro do alcance especificado
            local function findNearbyRumBarrel(position, radius)
                local nearbyCreatures = Game.getSpectators(position, false, false, radius, radius, radius, radius)
                for _, target in ipairs(nearbyCreatures) do
                    if target:isMonster() and target:getName():lower() == "rum barrel" then
                        return target
                    end
                end
                return nil
            end

            -- Encontrar a criatura 'Rum Barrel' próxima
            local rumBarrel = findNearbyRumBarrel(artilleristPosition, attackRange)
            if rumBarrel then
                -- Obter a posição do Rum Barrel
                local barrelPosition = rumBarrel:getPosition()

                -- Verificar se o Rum Barrel está dentro do alcance de ataque
                if artilleristPosition:getDistance(barrelPosition) <= attackRange then
                    -- Disparar o efeito de magia do Pirat Artillerist para o Rum Barrel
                    creature:say("Firing!", TALKTYPE_MONSTER_SAY) -- Mensagem opcional quando ataca
                    artilleristPosition:sendDistanceEffect(barrelPosition, shootEffect)
                    -- Aplicar o efeito de impacto na posição do Rum Barrel
                    barrelPosition:sendMagicEffect(effect)
                    -- Aplicar dano ao Rum Barrel
                    rumBarrel:addHealth(-damageAmount)
                    -- Atualizar o tempo do último ataque no armazenamento
                    creature:setStorageValue(storageKey, currentTime)
                end
            end
        end
    end
    return true
end

piratArtilleristThink:register()
