local rootkrakenInvulnerability = GlobalEvent("RootkrakenInvulnerability")

-- Posições da área de verificação
local fromPosition = Position(33945, 32026, 11)
local toPosition = Position(33982, 32055, 11)

-- IDs dos itens que alteram a invulnerabilidade
local invulnerableItemId = 42243
local vulnerableItemId = 39949

-- Nomes dos monstros alvo
local monsterNames = {
    ["the rootkraken"] = true,
    ["doctor marrow"] = true
}

local function checkItemsAndSetInvulnerability()
    local invulnerableCount = 0
    local vulnerableCount = 0

    for x = fromPosition.x, toPosition.x do
        for y = fromPosition.y, toPosition.y do
            local tile = Tile(Position(x, y, fromPosition.z))
            if tile then
                local items = tile:getItems()
                if items then
                    for _, item in ipairs(items) do
                        if item:getId() == invulnerableItemId then
                            invulnerableCount = invulnerableCount + 1
                        elseif item:getId() == vulnerableItemId then
                            vulnerableCount = vulnerableCount + 1
                        end
                    end
                end
            end
        end
    end
    
    -- Pegar as criaturas "The Rootkraken" e "Doctor Marrow"
    local spectators = Game.getSpectators(fromPosition, false, false, 37, 37, 37, 37)
    for _, creature in ipairs(spectators) do
        local creatureName = creature:getName():lower()
        if creature:isMonster() and monsterNames[creatureName] then
            if invulnerableCount >= 1 then
                creature:registerEvent("RootkrakenImmunity")
                creature:setStorageValue("rootkraken_vulnerable", -1) -- Invulnerável
                --creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
            elseif vulnerableCount >= 4 then
                creature:unregisterEvent("RootkrakenImmunity")
                creature:setStorageValue("rootkraken_vulnerable", 1) -- Vulnerável
                --creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            end
        end
    end
end

-- Executar verificação a cada 5 segundos
function rootkrakenInvulnerability.onThink(interval)
    checkItemsAndSetInvulnerability()
    return true
end

rootkrakenInvulnerability:interval(1000) -- Verifica a cada 5 segundos
rootkrakenInvulnerability:register()

-- Evento para bloquear dano se "The Rootkraken" ou "Doctor Marrow" estiver invulnerável
local rootkrakenImmunity = CreatureEvent("RootkrakenImmunity")

function rootkrakenImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local creatureName = creature:getName():lower()
    if creature and creature:isMonster() and monsterNames[creatureName] then
        if creature:getStorageValue("rootkraken_vulnerable") == -1 then
            return false
        elseif creature:getStorageValue("rootkraken_vulnerable") == 1 then
            return primaryDamage, primaryType, secondaryDamage, secondaryType
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

rootkrakenImmunity:register()
