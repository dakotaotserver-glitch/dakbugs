local azaramSoulMove = MoveEvent()

local itemId = 31160
local teleportPosition = Position(33482, 31477, 13)
local returnPosition = Position(33424, 31473, 13)

function azaramSoulMove.onStepIn(creature, item, position, fromPosition)
    if creature and creature:isMonster() and creature:getName() == "Azaram's Soul" then
        if item:getId() == itemId then
            local currentHealth = creature:getHealth()
            local maxHealth = creature:getMaxHealth()
            local newHealth = math.min(currentHealth + 25000, maxHealth) -- Garante que a vida não exceda o máximo
            creature:addHealth(newHealth - currentHealth)
            creature:say("Azaram's Soul regenerates health!", TALKTYPE_MONSTER_SAY)
            position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
            
            item:remove() -- Remove o item do chão
            
            if newHealth >= 100000 then
                -- Remover Azaram's Soul e teletransportar Lord Azaram
                creature:remove()
                
                local lordAzaram = Tile(teleportPosition):getTopCreature()
                if lordAzaram and lordAzaram:isMonster() and lordAzaram:getName() == "Lord Azaram" then
                    local teleportEffectPosition = lordAzaram:getPosition()
                    lordAzaram:teleportTo(returnPosition)
                    lordAzaram:say("I am back!", TALKTYPE_MONSTER_SAY)
                    teleportEffectPosition:sendMagicEffect(CONST_ME_FIREAREA)
                    returnPosition:sendMagicEffect(CONST_ME_FIREAREA)
                end
            end
        end
    end
    return true
end

azaramSoulMove:type("stepin")
azaramSoulMove:id(itemId)
azaramSoulMove:register()
