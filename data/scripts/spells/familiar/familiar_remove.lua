local spell = Spell("instant")
local spellId = 1000

-- Ligue para inspecionar nomes dos seus summons no jogo (ajuda a depurar).
local DEBUG = false

-- Tokens que ajudam a identificar o familiar mesmo com nomes alternativos/traducoes
local FAMILIAR_TOKENS = {
    ["Knight"] = {"knight", "elite"},
    ["Elite Knight"] = {"knight", "elite"},
    ["Druid"] = {"druid", "elder", "nature"},
    ["Elder Druid"] = {"druid", "elder", "nature"},
    ["Paladin"] = {"paladin", "royal", "divine"},
    ["Royal Paladin"] = {"paladin", "royal", "divine"},
    ["Sorcerer"] = {"sorcerer", "master", "arcane"},
    ["Master Sorcerer"] = {"sorcerer", "master", "arcane"},
    ["Monk"] = {"monk", "exalted"},
    ["Exalted Monk"] = {"monk", "exalted"},
}

-- Nome "esperado" (se existir exatamente assim, removemos direto)
local FAMILIAR_NAME_BY_VOCATION = {
    ["Knight"] = "Knight Familiar",
    ["Elite Knight"] = "Knight Familiar",
    ["Druid"] = "Druid Familiar",
    ["Elder Druid"] = "Druid Familiar",
    ["Paladin"] = "Paladin Familiar",
    ["Royal Paladin"] = "Paladin Familiar",
    ["Sorcerer"] = "Sorcerer Familiar",
    ["Master Sorcerer"] = "Sorcerer Familiar",
    ["Monk"] = "Monk Familiar",
    ["Exalted Monk"] = "Monk Familiar",
}

local function isTargetFamiliarName(name, tokens)
    local n = name:lower()
    if not n:find("familiar") then
        return false
    end
    for _, tok in ipairs(tokens) do
        if n:find(tok) then
            return true
        end
    end
    return false
end

function spell.onCastSpell(player, variant)
    local vocName = player:getVocation():getName()
    local tokens = FAMILIAR_TOKENS[vocName]
    local expectedName = FAMILIAR_NAME_BY_VOCATION[vocName]

    if not tokens then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sua vocacao nao pode usar este feitico.")
        return false
    end

    local summons = player:getSummons() or {}

    if DEBUG then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "DEBUG: Voc=" .. vocName .. " | Summons=" .. #summons)
        for i, s in ipairs(summons) do
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, ("DEBUG: #%d name=%s"):format(i, s:getName()))
        end
    end

    -- Passo 1: tentativa por nome exato (case-insensitive)
    if expectedName then
        local expectedLower = expectedName:lower()
        for _, s in ipairs(summons) do
            if s:getName():lower() == expectedLower then
                s:getPosition():sendMagicEffect(CONST_ME_POFF)
                s:remove()
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, expectedName .. " foi removido.")
                return true
            end
        end
    end

    -- Passo 2: identificar por tokens (aceita nomes alternativos, ex.: "Divine Familiar", etc.)
    for _, s in ipairs(summons) do
        if isTargetFamiliarName(s:getName(), tokens) then
            local removedName = s:getName()
            s:getPosition():sendMagicEffect(CONST_ME_POFF)
            s:remove()
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, removedName .. " foi removido.")
            return true
        end
    end

    -- Passo 3 (fallback): se tiver apenas 1 summon e contiver "familiar", remover
    if #summons == 1 and summons[1]:getName():lower():find("familiar") then
        local removedName = summons[1]:getName()
        summons[1]:getPosition():sendMagicEffect(CONST_ME_POFF)
        summons[1]:remove()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, removedName .. " foi removido.")
        return true
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem um " .. (expectedName or "Familiar") .. " invocado.")
    return false
end

spell:group("support")
spell:id(spellId)
spell:name("Remove Familiar")
spell:words("utevo gran res remove")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_KNIGHT_FAMILIAR)
spell:level(200)
spell:mana(1000)
spell:cooldown(0)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation(
    "knight;true", "elite knight;true",
    "druid;true", "elder druid;true",
    "paladin;true", "royal paladin;true",
    "sorcerer;true", "master sorcerer;true",
    "monk;true", "exalted monk;true"
)
spell:register()
