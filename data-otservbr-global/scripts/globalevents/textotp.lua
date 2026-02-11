local config = {
    interval = 6000,
    texts = {
        { pos = Position(973, 975, 7), text = "Templo", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --TEMPLO THAIS ADVERNTUR
        { pos = Position(32210, 32292, 6), text = "Templo", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --TEMPLO THAIS ADVERNTUR
        { pos = Position(32209, 32292, 6), text = "Templo", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --TEMPLO THAIS ADVERNTUR
        { pos = Position(17077, 17121, 4), text = "Templo", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --TEMPLO THAIS SALA BOSS
        { pos = Position(32373, 32236, 7), text = "Sell Loot, Supply e Forge", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --ADVENTURS
        { pos = Position(32365, 32236, 7), text = "Treiners e Roletas", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --DIVERSOS TEMPLO THAIS
        { pos = Position(1228, 867, 8), text = "Exit", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } }, --TEMPLO SALA PRINCIPAL
        { pos = Position(32360, 32239, 7), text = "Tasks", effects = { 171, 171 } }, 
        { pos = Position(1228, 859, 8), text = "ROLETAS", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
        { pos = Position(1225, 862, 8), text = "Dummy", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		 { pos = Position(1231, 862, 8), text = "Treiners", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		 { pos = Position({x = 32376, y = 32239, z = 7}), text = "Reward", effects = { 171, 171 } },
		 { pos = Position({x = 32344, y = 32222, z = 6}), text = "Reward", effects = { 171, 171 } },
		{ pos = Position(33627, 31422, 10), text = "Mirrored Nightmare", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33624, 31422, 10), text = "Furious Crater", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		-- { pos = Position(32321, 32244, 9), text = "Parabens!! Voce Terminou a Quest escolha seu item", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33621, 31422, 10), text = "Ebb and Flow", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33618, 31422, 10), text = "Rotten Wasteland", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33615, 31422, 10), text = "Claustrophobic Inferno", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33611, 31430, 10), text = "Boss Final", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(33192, 31691, 14), text = "Para Acessar e Preciso Pisar Pelo Menos 1 Trono Da Poi", effects = { CONST_ME_TELEPORT, CONST_ME_DRAWBLOOD } },
		{ pos = Position(32375, 32213, 7), text = "Hunted System", effects = { CONST_ME_DRAWBLOOD } },
		{ pos = Position(32201, 32304, 5), text = "Hunted System", effects = { CONST_ME_DRAWBLOOD } },

    }
}

local textOnMap = GlobalEvent("TextOnMap")

function textOnMap.onThink(interval)
    local player = Game.getPlayers()[1]
    if not player then
        return true
    end

    for k, info in pairs(config.texts) do
        player:say(info.text, TALKTYPE_MONSTER_SAY, false, nil, info.pos)
        info.pos:sendMagicEffect(info.effects[math.random(1, #info.effects)])
    end
    return true
end

textOnMap:interval(config.interval)
textOnMap:register()