local supremeCube = Action()

local config = {
    storage = 9007,
    cooldown = 10,
    towns = {
        { name = "Adventure Island", teleport = Position(32210, 32300, 6) },
        { name = "Ab'Dendriel", teleport = Position(32732, 31634, 7) },
        { name = "Ankrahmun", teleport = Position(33194, 32853, 8) },
        { name = "Carlin", teleport = Position(32360, 31782, 7) },
        { name = "Darashia", teleport = Position(33213, 32454, 1) },
        { name = "Edron", teleport = Position(33217, 31814, 8) },
        { name = "Farmine", teleport = Position(33023, 31521, 11) },
        { name = "Issavi", teleport = Position(33921, 31477, 5) },
        { name = "Kazordoon", teleport = Position(32649, 31925, 11) },
        { name = "Krailos", teleport = Position(33657, 31665, 8) },
        { name = "Liberty Bay", teleport = Position(32317, 32826, 7) },
        { name = "Marapur", teleport = Position(33842, 32853, 7) },
        { name = "Port Hope", teleport = Position(32594, 32745, 7) },
        { name = "Rathleton", teleport = Position(33594, 31899, 6) },
        { name = "Roshamuul", teleport = Position(33513, 32363, 6) },
        { name = "Svargrond", teleport = Position(32212, 31132, 7) },
        { name = "Thais", teleport = Position(32369, 32241, 7) },
        { name = "Venore", teleport = Position(32957, 32076, 7) },
        { name = "Yalahar", teleport = Position(32787, 31276, 7) },
        { name = "-------BOSSES------"},
        { name = "Abyssador", teleport = Position(32990, 31911, 12) },
        { name = "Ahau", teleport = Position(34039, 31716, 10) },
        { name = "Amenef the Burning", teleport = Position(33819, 31773, 10) },
        { name = "An Observer Eye", teleport = Position(32815, 32903, 14) },
        { name = "Ancient Spawn of Morgathlha", teleport = Position(33695, 32388, 15) },
        { name = "Anmothra", teleport = Position(32630, 32329, 7) },
        { name = "Anomaly", teleport = Position(32248, 31248, 14) },
        { name = "Arachir The Ancient One", teleport = Position(32961, 32387, 12) },
        { name = "Arbaziloth", teleport = Position(34033, 32368, 14) },
        { name = "Armenius", teleport = Position(32860, 31321, 7) },
        { name = "Arthei", teleport = Position(32953, 31443, 2) },
        { name = "Atab", teleport = Position(34010, 31584, 10) },
        { name = "Bakragore (rotten final)", teleport = Position(33073, 32401, 15) },
        { name = "Boreth", teleport = Position(32940, 31481, 2) },
        { name = "Brain Head", teleport = Position(31968, 32325, 10) },
        { name = "Brokul", teleport = Position(33522, 31468, 15) }, 
        { name = "Chagorz (rotten)", teleport = Position(33074, 32363, 15) },
        { name = "Count Vlarkorth", teleport = Position(33457, 31409, 13) },
        { name = "Deathstrike", teleport = Position(32999, 31918, 10) },
        { name = "Desporr", teleport = Position(33264, 31058, 13) },
        { name = "Drume", teleport = Position(32462, 32508, 7) },
        { name = "Duke Krule", teleport = Position(33456, 31499, 13) },
        { name = "Earl Osam", teleport = Position(33518, 31438, 13) },  
        { name = "Eradicator", teleport = Position(32334, 31291, 14) },
        { name = "Essence of Malice", teleport = Position(33096, 31963, 15) },
        { name = "Faceless Bane", teleport = Position(33637, 32559, 13) },
        { name = "Ferumbras Mortal Shell", teleport = Position(33267, 31476, 14) },
        { name = "Foreshock", teleport = Position(32183, 31253, 14) },
        { name = "Ghulosh", teleport = Position(32746, 32768, 10) },
        { name = "Gnomevil", teleport = Position(33011, 31939, 11) },
        { name = "Gorzindel", teleport = Position(32746, 32744, 10) },
        { name = "Goshnar Megalomania", teleport = Position(33611, 31430, 10) },
        { name = "Goshnars Cruelty", teleport = Position(33856, 31884, 5) },
        { name = "Goshnars Greed", teleport = Position(33937, 31217, 11) },
        { name = "Goshnars Hatred", teleport = Position(33779, 31599, 14) },
        { name = "Goshnars Malice", teleport = Position(34022, 31091, 11) },
        { name = "Goshnars Spite", teleport = Position(33950, 31109, 8) },
        { name = "Grand Master Oberon", teleport = Position(33297, 31287, 9) },
        { name = "Ichgahal (rotten)", teleport = Position(32971, 32333, 15) },
        { name = "Irgix the Flimsy", teleport = Position(33492, 31400, 8) },
        { name = "Jaul", teleport = Position(33561, 31233, 11) },
        { name = "King Zelos", teleport = Position(33490, 31546, 13) },
        { name = "Kusuma", teleport = Position(33711, 32775, 5) },
        { name = "Lady Tenebris", teleport = Position(32902, 31631, 14) },
        { name = "Leiden", teleport = Position(33125, 31950, 15) },
        { name = "Lersatio", teleport = Position(32967, 31460, 2) },
        { name = "Lloyd", teleport = Position(32759, 32877, 14) },
        { name = "Lokathmor", teleport = Position(32720, 32744, 10) },
        { name = "Lord Azaram", teleport = Position(33424, 31497, 13) },
        { name = "Lord Retro", teleport = Position(33514, 31053, 15) },
        { name = "Magma Bubble", teleport = Position(33669, 32932, 15) },
        { name = "Marziel", teleport = Position(32940, 31460, 2) },
        { name = "Mazoran", teleport = Position(33593, 32648, 14) },
        { name = "Mazzinor", teleport = Position(32720, 32768, 10) },
        { name = "Megasylvan Yselda", teleport = Position(32576, 32503, 12) },
        { name = "Melting Frozen Horror", teleport = Position(32302, 31095, 14) },
        { name = "Minibosses Werelion", teleport = Position(33123, 32232, 12) },
        { name = "Mitmah Vanguard", teleport = Position(34050, 31435, 11) },
        { name = "Murcion (rotten)", teleport = Position(32972, 32363, 15) },
        { name = "Neferi the Spy", teleport = Position(33886, 31477, 6) },
        { name = "Obujos", teleport = Position(33451, 31306, 11) },
        { name = "Outburst", teleport = Position(32207, 31291, 14) },
        { name = "Plagirath", teleport = Position(33231, 31501, 13) },
        { name = "Plague/Alptra/Malofur/Izcandar", teleport = Position(32204, 32023, 13) },
        { name = "Prince Drazzak", teleport = Position(33613, 32364, 11) },
        { name = "Ragiaz", teleport = Position(33455, 32358, 13) },
        { name = "Ratmiral Blackwhiskers", teleport = Position(33890, 31198, 7) },
        { name = "Razzagorn", teleport = Position(33386, 32453, 14) },
        { name = "Rupture", teleport = Position(32309, 31255, 14) },
        { name = "Scarlet Etzel", teleport = Position(33395, 32662, 6) },
        { name = "Shulgrax", teleport = Position(33435, 32791, 13) },
        { name = "Sir Baeloc / Sir Nictros", teleport = Position(33425, 31408, 13) },
        { name = "Sister Hetai", teleport = Position(33883, 31467, 9) },
        { name = "Sugar Daddy", teleport = Position(33397, 32203, 9) },
        { name = "Sugar Mommy", teleport = Position(33455, 32137, 9) },
        { name = "Tanjis", teleport = Position(33665, 31270, 11) },
        { name = "Tarbaz", teleport = Position(33416, 32850, 11) },
        { name = "Tentugly's Head", teleport = Position(33793, 31389, 6) },
        { name = "The Armored Voidborn", teleport = Position(33178, 31845, 15) },
        { name = "The Baron from Below", teleport = Position(33827, 32174, 14) },
        { name = "The Brainstealer", teleport = Position(32536, 31122, 15) },
        { name = "The Count of the Core", teleport = Position(33777, 32194, 14) },
        { name = "The Dread Maiden", teleport = Position(33741, 31503, 14) },
        { name = "The Duke of the Depths", teleport = Position(33830, 32128, 14) },
        { name = "The Enraged Thorn Knight", teleport = Position(32657, 32885, 14) },
        { name = "The False God", teleport = Position(33161, 31900, 15) },
        { name = "The Fear Feaster", teleport = Position(33736, 31467, 14) },
        { name = "The Last Lore Keeper", teleport = Position(32019, 32852, 14) },
        { name = "The Mega Magmaoid", teleport = Position(32533, 31149, 15) },
        { name = "The Monster", teleport = Position(33812, 32587, 12) },
        { name = "The Nightmare Beast", teleport = Position(32206, 32070, 15) },
        { name = "The Pale Worm", teleport = Position(33769, 31504, 13) },
        { name = "The Percht Queen", teleport = Position(33793, 31102, 9) },
        { name = "The Primal Menace", teleport = Position(33555, 32751, 14) },
        { name = "The Sandking", teleport = Position(33505, 32230, 10) },
        { name = "The Scourge of Oblivion", teleport = Position(32674, 32736, 11) },
        { name = "The Sinister Hermit", teleport = Position(33114, 31887, 15) },
        { name = "The Source of Corruption", teleport = Position(33075, 31867, 15) },
        { name = "The Time Guardian", teleport = Position(33010, 31667, 14) },
        { name = "The Unwelcome", teleport = Position(33744, 31537, 14) },
        { name = "Timira", teleport = Position(33805, 32700, 8) },
        { name = "Unaz the Mean", teleport = Position(33566, 31477, 8) },
        { name = "Urmahlullu", teleport = Position(33920, 31623, 8) },
        { name = "Vermiath (rotten)", teleport = Position(33074, 32335, 15) },
        { name = "Vladrukh", teleport = Position(32953, 31464, 15) },
        { name = "Vok the Freakish", teleport = Position(33509, 31452, 9) },
        { name = "World Devourer", teleport = Position(32272, 31382, 14) },
        { name = "Zamulosh", teleport = Position(33681, 32740, 11) },
        
        
    

    }
}

local function supremeCubeMessage(player, effect, message)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
    player:getPosition():sendMagicEffect(effect)
end

function supremeCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local inPz = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
    local inFight = player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)

    if not inPz and inFight then
        supremeCubeMessage(player, CONST_ME_POFF, "You can't use this when you're in a fight.")
        return false
    end

    if player:getStorageValue(config.storage) > os.time() then
        local remainingTime = player:getStorageValue(config.storage) - os.time()
        supremeCubeMessage(player, CONST_ME_POFF, "You can use it again in: " .. remainingTime .. " seconds.")
        return false
    end

    local window = ModalWindow({
        title = "Supreme Cube",
        message = "Select a place to go!",
    })

    for _, town in pairs(config.towns) do
        if town.name then
            window:addChoice(town.name, function(player, button, choice)
                if button.name == "Select" then
                    player:teleportTo(town.teleport, true)
                    supremeCubeMessage(player, CONST_ME_TELEPORT, "Welcome to " .. town.name)
                    player:setStorageValue(config.storage, os.time() + config.cooldown)
                end
                return true
            end)
        end
    end

    -- Opção de teleportar para a casa do jogador
    window:addChoice("House", function(player, button, choice)
        if button.name == "Select" then
            local house = player:getHouse()
            if house then
                player:teleportTo(house:getExitPosition(), true)
                supremeCubeMessage(player, CONST_ME_TELEPORT, "Welcome to your house.")
                player:setStorageValue(config.storage, os.time() + config.cooldown)
            else
                supremeCubeMessage(player, CONST_ME_POFF, "You don't have a house.")
            end
        end
        return true
    end)

    window:addButton("Select")
    window:addButton("Close")
    window:setDefaultEnterButton(0)
    window:setDefaultEscapeButton(1)
    window:sendToPlayer(player)

    return true
end

supremeCube:id(49273)
supremeCube:register()
