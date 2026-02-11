taskOptions = {
	bonusReward = 65001, -- storage bonus reward
	bonusRate = 2, -- rate bonus reward
	taskBoardPositions = {
	    {x = 32360, y = 32240, z = 7},
	    {x = 32359, y = 32240, z = 7},
        {x = 32201, y = 32299, z = 5},
		{x = 32201, y = 32300, z = 5},
		{x = 32200, y = 32300, z = 5},
		{x = 32202, y = 32300, z = 5},
		{x = 32200, y = 32299, z = 5},
		{x = 32202, y = 32299, z = 5},
		{x = 32202, y = 32298, z = 5},
		{x = 32200, y = 32298, z = 5},
    },
	selectLanguage = 1, -- options: 1 = pt_br or 2 = english
	uniqueTask = false, -- alterado para permitir multiplas tarefas
	maxSimultaneousTasks = 3, -- nova opcao para controlar o maximo de tarefas simultaneas
	uniqueTaskStorage = 65002,
	taskCountStorage = 65003 -- novo storage para contar tarefas ativas
}

task_pt_br = {
	exitButton = "Fechar",
	confirmButton = "Validar",
	cancelButton = "Anular",
	returnButton = "Voltar",
	title = "BEM VINDO AO QUADRO DE TASK",
	missionError = "Task esta em andamento ou ela ja foi concluida.",
	uniqueMissionError = "Voce so pode fazer uma task por vez.",
	tooManyTasksError = "Voce ja tem o maximo de 3 tarefas ativas. Complete ou cancele uma antes de iniciar outra.", -- Nova mensagem
	missionErrorTwo = "Voce concluiu a task!! Parabens",
	missionErrorTwoo = "\nAqui estao suas recompensas:",
	choiceText = "- Experiencia: ",
	messageAcceptedText = "Voce aceitou essa task!",
	messageDetailsText = "Detalhes da task:",
	choiceMonsterName = "Task: ",
	choiceMonsterRace = "Monstros: ",
	choiceMonsterKill = "Kills: ",
	choiceEveryDay = "Repetir: Todos os dias",
	choiceRepeatable = "Repetir: Sempre",
	choiceOnce = "Repetir: Apenas uma vez",
	choiceReward = "Recompensas:",
	messageAlreadyCompleteTask = "Voce ja concluiu essa task amigo.",
	choiceCancelTask = "Voce cancelou essa task.",
	choiceCancelTaskError = "Voce nao pode cancelar essa task, porque ela ja foi concluida ou nao foi iniciada.",
	choiceBoardText = "Escolha uma TASK e use os botoes abaixo:",
	choiceRewardOnHold = "Resgatar Recompensa",
	choiceDailyConclued = "Diaria Concluida",
	choiceConclued = "Concluida",
	messageTaskBoardError = "O quadro de task esta muito longe ou esse nao e o quadro de task correto.",
	messageCompleteTask = "Parabens voce terminou essa task! \nRetorne para o quadro de tasks e pegue sua recompensa.",
}

taskConfiguration = {
{name = "Minotaur", color = 40, total = 5000, type = "once", storage = 190000, storagecount = 190001, 
	rewards = {
	{5804, 1},
	{62218, 10},
	{20313, 1}, -- exercise box
	{"exp", 1000000},
	},
	races = {
		"Minotaur",
		"Minotaur Archer",
		"Minotaur Mage",
		"Minotaur Guard",
	},
},

{name = "Dragon", color = 40, total = 1000, type = "once", storage = 190002, storagecount = 190003, 
	rewards = {
	{3043, 10},
	{62218, 10},
	{5908, 1},
	{"exp", 1500000},
	},
	races = {
		"Dragon",
		"Dragon Hatchling",
	},
},

{name = "Dragon Lord", color = 40, total = 2000, type = "once", storage = 190004, storagecount = 190005, 
	rewards = {
	{3043, 15},
	{62218, 15},
	{5919, 1},
	{"exp", 1500000},
	},
	races = {
		"Dragon Lord",
		"Dragon Lord Hatchling",
	},
},

{name = "Rotworm", color = 40, total = 250, type = "once", storage = 190006, storagecount = 190007, 
	rewards = {
	{3043, 10},
	{62218, 10},
	{"exp", 100000},
	},
	races = {
		"Rotworm",
		"Carrion Worm",
		"White Pale",
		"Rotworm Queen",
	},
},

{name = "Amazon", color = 40, total = 1000, type = "once", storage = 190008, storagecount = 190009, 
	rewards = { 
	{"exp", 1500000},
	{62218, 10},
	{3394, 1},
	{3437, 1}, --- amazon shield
	},
	races = {
		"Amazon",
		"Valkyrie",
		"Xenia",
		"Witch",
	},
},

{name = "Valkyrie", color = 40, total = 500, type = "once", storage = 190010, storagecount = 190011, 
	rewards = { 
	{62218, 15},
	{"exp", 100000},
	{3393, 1}, --- amazon helmet
	},
	races = {
		"Amazon",
		"Valkyrie",
		"Xenia",
	},
},

{name = "Cultist Carlin", color = 40, total = 10000, type = "once", storage = 190104, storagecount = 190105, 
	rewards = { 
	{"exp", 10000000},
	{20313, 1}, -- exercise box
	{62218, 20},
	{3043, 20},
	},
	races = {
		"Cult Enforcer",
		"Cult Believer",
		"Cult Scholar",
		"Vile Grandmaster",
		"Renegade Knight",
		"Vicious Squire",
	},		
},

{name = "Feyrist", color = 40, total = 2500, type = "once", storage = 190012, storagecount = 190013, 
	rewards = { 
	{20270, 1},
	{20272, 1},
	{"exp", 1500000},
	{62218, 15},
	},
	races = {
		"Weakened Frazzlemaw",
		"Enfeebled Silencer",
	},
},

{name = " Roshamuul", color = 40, total = 2500, type = "once", storage = 190014, storagecount = 190015, 
	rewards = { 
	{22516, 1},
	{22721, 1},
	{3043, 30},
	{"exp", 1500000},
	{62218, 15},
	},
	races = {
		"Frazzlemaw",
		"Memory Of A Frazzlemaw",
		"Guzzlemaw",
		"Mawhawk",
		"Sight of Surrender",
		"Silencer",
		"Shock Head",
	},
},

{name = "Deepling Hunt", color = 40, total = 2500, type = "once", storage = 190016, storagecount = 190017, 
	rewards = { 
	{14142, 1}, ---foxtail
	{"exp", 10000000},
	{62218, 15},
	},
	races = {
		"Deepling Guard",
		"Deepling Warrior",
		"Deepling Scout",
		"Deepling Tyrant",
		"Deepling Elite",
		"Deepling Spellsinger",
	},
},

{name = "Roshamuul II", color = 40, total = 10000, type = "once", storage = 190018, storagecount = 190019, 
	rewards = { 
	{20273, 1}, 
	{20313, 1}, -- exercise box
	{"exp", 1000000},
	{62218, 15},
	{3043, 15},
	},
	races = {
		"Frazzlemaw",
		"Memory Of A Frazzlemaw",
		"Guzzlemaw",
		"Mawhawk",
		"Sight of Surrender",
		"Silencer",
		"Shock Head",
	},
},

{name = "Banuta Hunt", color = 40, total = 2500, type = "daily", storage = 190020, storagecount = 190021, 
	rewards = {
	{"exp", 1000000},
	{62218, 15},
	{3043, 10},
	},
	races = {
		"Medusa",
		"Serpent Spawn",
		"Hydra",
		"Giant Spider",
		"Behemoth",
		"Nightmare",
		"Phantasm",
	},
},

{name = "Demon", color = 40, total = 6666, type = "once", storage = 190022, storagecount = 190023, 
	rewards = { 
	{3387, 1}, ---demon helmet
	{3388, 1}, ---demon armor
	{3389, 1}, ---demon legs
	{22118, 100}, ---demon legs
	{62218, 50},
	
	},
	races = {
		"Demon",
	},
},

{name = "Hero Cave", color = 40, total = 3000, type = "once", storage = 190024, storagecount = 190025, 
	rewards = { 
	{"exp", 1000000},
	{62144, 1},
	{62218, 15},
	{3398, 1}, -- dwarven legs
	
	},
	races = {
		"Hero",
		"Necromancer",
		"Vicious Squire",
		"Blood Priest",
		"Renegade Knight",
		"Vile Grandmaster",
	},
},

-- {name = "Cloak Of Terror", color = 40, total = 1000, type = "daily", storage = 190026, storagecount = 190027, 
	-- rewards = { 
	-- {"exp", 30000000},
	-- },
	-- races = {
		-- "Cloak Of Terror",
	-- },
-- },

-- {name = "Vibrant Phantom", color = 40, total = 1000, type = "daily", storage = 190028, storagecount = 190029, 
	-- rewards = { 
	-- {"exp", 30000000},
	-- },
	-- races = {
		-- "Vibrant Phantom",
	-- },
-- },

-- {name = "Courage Leech", color = 40, total = 1000, type = "daily", storage = 190030, storagecount = 190031, 
	-- rewards = { 
	-- {"exp", 30000000},
	-- },
	-- races = {
		-- "Courage Leech",
	-- },
-- },

-- {name = "Brachiodemon", color = 40, total = 1000, type = "daily", storage = 190032, storagecount = 190033, 
	-- rewards = { 
	-- {"exp", 30000000},
	-- },
	-- races = {
		-- "Brachiodemon",
	-- },
-- },

-- {name = "Infernal Demon", color = 40, total = 5000, type = "once", storage = 190034, storagecount = 190035, 
	-- rewards = { 
	-- {34109, 2},
	-- },
	-- races = {
		-- "Infernal Demon",
	-- },
-- },

-- {name = "Infernal Phantom", color = 40, total = 1000, type = "daily", storage = 190036, storagecount = 190037, 
	-- rewards = { 
	-- {"exp", 30000000},
	-- },
	-- races = {
		-- "Infernal Phantom",
	-- },
-- },

{name = "Juggernaut", color = 40, total = 2500, type = "once", storage = 190038, storagecount = 190039, 
	rewards = { 
	{3422, 1}, --- great shield
	{16244, 1}, --- music box
	{62218, 50},
	{20313, 1}, -- exercise box
	{"exp", 5000000},
	},
	races = {
		"Juggernaut",
	},
},

{name = "Asura Palace Hunt", color = 40, total = 3500, type = "daily", storage = 190040, storagecount = 190041, 
	rewards = { 
	{"exp", 1000000},
	{62218, 10},
	{3043, 10},
	},
	races = {
		"Dawnfire Asura",
		"Frost Flower Asura",
		"Hellspawn",
		"Midnight Asura",
		"True Dawnfire Asura",
		"True Frost Flower Asura",
		"True Midnight Asura",

	},
},

{name = "Girtablilu Warrior", color = 40, total = 5000, type = "once", storage = 190042, storagecount = 190043, 
	rewards = {   
	{"exp", 3000000},
	{62218, 20},
	{3043, 20},
	},
	races = {
		"Girtablilu Warrior",
	},
},

{name = "Dark Carnisylvan", color = 40, total = 3500, type = "once", storage = 190044, storagecount = 190045, 
	rewards = { 
	{"exp", 5000000},
	{62218, 20},
	{61616, 1},
	{3396, 1},
	},
	races = {
		"Dark Carnisylvan",
		"Poisonous Carnisylvan",
		"Hulking Carnisylvan",
	},
},

{name = "Lion Sanctum", color = 40, total = 3500, type = "once", storage = 190046, storagecount = 190047, 
	rewards = { 
	{"exp", 3000000},
	{62218, 20},
	{61873, 1},
	{3043, 15},
	},
	races = {
		"White Lion",
		"Werelion",
		"Werelioness",
	},
},
	
{name = "Zao Hunt", color = 40, total = 12000, type = "once", storage = 190048, storagecount = 190049, 
	rewards = { 
	{"exp", 3000000},
	{62218, 20},
	{20313, 1}, -- exercise box
	{3043, 15},
	},
	races = {
		"Lizard Chosen",
		"Lizard High Guard",
		"Lizard Legionnaire",
		"Lizard Dragon Priest",
		"Ghastly Dragon",
		"Draken Elite",
		"Draken Abomination",
		"Draken Warmaster",
		"Draken Spellweaver",
		"Lizard Zaogun",
	},	
},

{name = "Weremonsters Hunt", color = 40, total = 2500, type = "once", storage = 190050, storagecount = 190051, 
	rewards = { 
	{"exp", 3000000},
	{62218, 20},
	{22083, 100},
	{22062, 1}, -- werewolf helmet
	{3043, 12},
	},
	races = {
		"Werebear",
		"Wereboar",
		"Werehyaena",
		"Werebadger",
		"Werehyaena Shaman",
		"Werefox",
		"werewolf",
	},
},
	
{name = "Oramond Hunt", color = 40, total = 2500, type = "once", storage = 190052, storagecount = 190053, 
	rewards = { 
	{"exp", 3000000},
	{62218, 15},
	{22721, 10}, ---golden token
	{22516, 20}, ---silver token
	{3043, 10},
	},
	races = {
		"Worm Priestess",
		"Blood Beast",
		"Minotaur Hunter",
		"Mooh'Tah Warrior",
	},
},
	
{name = "Hive Hunt", color = 40, total = 2500, type = "once", storage = 190054, storagecount = 190055, 
	rewards = { 
	{"exp", 5000000},
	{62218, 15},
	{3043, 30},
	{3397, 1},
	},
	races = {
		"Hive Overseer",
		"Insectoid Worker",
		"Kollos",
		"Ladybug",
		"Spidris Elite",
		"Spitter",
		"Waspoid",
		"Swarmer",
	},		
},

{name = "Glooth Bandits", color = 40, total = 2500, type = "once", storage = 190056, storagecount = 190057, 
	rewards = { 
	{"exp", 2000000},
	{62218, 30},
	{62144, 1},
	{3043, 20},
	},
	races = {
		"Glooth Bandit",
		"Glooth Brigand",
	},		
},

{name = "Western Oramond Hunt", color = 40, total = 2500, type = "once", storage = 190058, storagecount = 190059, 
	rewards = { 
	{"exp", 3000000},
	{62218, 15},
	{22721, 10}, ---golden token
	{22516, 20}, ---silver token
	{3043, 20},
	},
	races = {
		"Rot Elemental",
		"Devourer",
		"Glooth Blob",
	},		
},

{name = "Minotaur Hills Hunt", color = 40, total = 2500, type = "once", storage = 190060, storagecount = 190061, 
	rewards = { 
	{"exp", 3000000},
	{62218, 15},
	{22721, 10}, ---golden token
	{22516, 20}, ---silver token
	{3043, 15},
	},
	races = {
		"Minotaur Amazon",
		"Moohtant",
		"Execowtioner",
	},		
},

{name = "Warzone 3", color = 40, total = 2500, type = "once", storage = 190062, storagecount = 190063, 
	rewards = { 
	{"exp", 5000000},
	{62218, 15},
	{22721, 10}, ---golden token
	{22516, 20}, ---silver token
	{3043, 30},
	},
	races = {
		"Ironblight",
		"Orewalker",
		"Cliff Strider",
		"Lost Berserker",
	},		
},

{name = "Warzone 4-6", color = 40, total = 2500, type = "once", storage = 190064, storagecount = 190065, 
	rewards = { 
	{"exp", 8000000},
	{62218, 20},
	{22721, 10}, ---golden token
	{22516, 20}, ---silver token
	{3043, 30},
	},
	races = {
		"Diremaw",
		"Cave Devourer",
		"Deepworm",
		"Lava Lurker",
		"High Voltage Elemental",
		"Humongous Fungus",
		"Lost Exile",
		"Tunnel Tyrant",
	},		
},

{name = "Falcon Bastion Hunt", color = 40, total = 2500, type = "once", storage = 190066, storagecount = 190067, 
	rewards = { 
	{"exp", 10000000},
	{62218, 30},
	{3043, 40},
	},
	races = {
		"Falcon Knight",
		"Falcon Paladin",
		"Preceptor Lazare",
		"Grand Canon Dominus",
		"Grand Chaplain Gaunder",
	},		
},

{name = "Ogre Hunt", color = 40, total = 2500, type = "once", storage = 190068, storagecount = 190069, 
	rewards = { 
	{"exp", 10000000},
	{62218, 30},
	{3043, 15},
	},
	races = {
		"Ogre Sage",
		"Ogre Ruffian",
		"Ogre Rowdy",
		"Ogre Shaman",
	},		
},

{name = "Summer Dream Court", color = 40, total = 2500, type = "daily", storage = 190070, storagecount = 190071, 
	rewards = { 
	{"exp", 10000000},
	{62218, 15},
	{3043, 20},
	},
	races = {
		"Crazed Summer Rearguard",
		"Crazed Summer Vanguard",
		"Insane Siren",
		"Arachnophobica",
		"Thanatursus",
		"Lacewing Moth",
	},		
},

{name = "Court of Winter", color = 40, total = 2500, type = "daily", storage = 190072, storagecount = 190073, 
	rewards = { 
	{"exp", 10000000},
	{62218, 15},
	{3043, 20},
	},
	races = {
		"Crazed Winter Vanguard",
		"Crazed Winter Rearguard",
		"Soul-Broken Harbinger",
		"Hibernal Moth",
	},		
},

{name = "Issavi / Kilmaresh", color = 40, total = 3500, type = "daily", storage = 190074, storagecount = 190075, 
	rewards = { 
	{"exp", 10000000},
	{62218, 15},
	{3043, 20},
	},
	races = {
		"Priestess of the Wild Sun",
		"Black Sphinx Acolyte",
		"Burning Gladiator",
		"Sphinx",
		"Crypt Warden",
		"Gryphon",
		"Young Goanna",
		"Adult Goanna",
		"Feral Sphinx",
		"Manticore",
		"Lamassu",
	},		
},

{name = "Cobra Bastion", color = 40, total = 3500, type = "once", storage = 190076, storagecount = 190077, 
	rewards = { 
	{"exp", 10000000},
	{62218, 30},
	{31631, 1}, --cobra amulet
	},
	races = {
		"Cobra Assassin",
		"Cobra Vizier",
		"Cobra Scout",
	},		
},

{name = "Marapur Turtles", color = 40, total = 2500, type = "once", storage = 190078, storagecount = 190079, 
	rewards = { 
	{"exp", 10000000},
	{62218, 20},
	{3043, 20},
	},
	races = {
		"Two-Headed Turtle",
		"Foam Stalker",
	},		
},

{name = "Warzone 5", color = 40, total = 2500, type = "once", storage = 190078, storagecount = 190079, 
	rewards = { 
	{"exp", 10000000},
	{62218, 25},
	{3043, 30},
	},
	races = {
		"Drillworm",
		"Chasm Spawn",
		"Elder Wyrm",
	},		
},

{name = "Spectre Hunt", color = 40, total = 2500, type = "daily", storage = 190080, storagecount = 190081, 
	rewards = { 
	{"exp", 3000000},
	{62218, 20},
	{3043, 10},
	},
	races = {
		"Burster Spectre",
		"Ripper Spectre",
		"Gazer Spectre",
	},		
},

{name = "Marapur Hunt", color = 40, total = 2500, type = "once", storage = 190082, storagecount = 190083, 
	rewards = { 
	{"exp", 10000000},
	{62218, 25},
	},
	races = {
		"Naga Warrior",
		"Naga Archer",
		"Makara",
	},		
},

{name = "Deathlings Hunt", color = 40, total = 2500, type = "once", storage = 190084, storagecount = 190085, 
	rewards = { 
	{"exp", 10000000},
	{62218, 25},
	},
	races = {
		"Deathling Scout",
		"Deathling Spellsinger",
	},		
},

{name = "Prision Hunt", color = 40, total = 2500, type = "once", storage = 190086, storagecount = 190087, 
	rewards = { 
	{"exp", 10000000},
	{62218, 25},
	{61873, 1},
	},
	races = {
		"Choking Fear",
		"Demon Outcast",
		"Retching Horror",
		"Dark Torturer",
		"Blightwalker",
	},		
},

{name = "Usurper Hunt", color = 40, total = 2500, type = "once", storage = 190088, storagecount = 190089, 
	rewards = { 
	{"exp", 10000000},
	{62218, 25},
	},
	races = {
		"Usurper Warlock",
		"Usurper Knight",
		"Usurper Archer",
	},		
},

{name = "Asura Vaults Hunt", color = 40, total = 2000, type = "once", storage = 190090, storagecount = 190091, 
	rewards = { 
	{"exp", 10000000},
	{62218, 25},
	{61756, 3}, -- charm
	},
	races = {
		"True Dawnfire Asura",
		"True Midnight Asura",
		"True Frost Flower Asura",
	},		
},

{name = "Oskayaat Hunt", color = 40, total = 3500, type = "once", storage = 190092, storagecount = 190093, 
	rewards = { 
	{"exp", 5000000},
	{62218, 15},
	{43901, 1},
	},
	races = {
		"Cunning Werepanther",
		"Feral Werecrocodile",
		"Werecrocodile",
		"Werepanther",
		"Weretiger",
		"White Weretiger",
	},		
},

{name = "Library Hunt", color = 40, total = 4000, type = "once", storage = 190094, storagecount = 190095, 
	rewards = { 
	{"exp", 9000000},
	{62218, 20},
	{28791, 1},
	},
	races = {
		"Cursed Book",
		"Biting Book",
		"Animated Feather",
		"Dark Knowledge",
		"Energetic Book",
		"Energuardian of Tales",
		"Brain Squid",
		"Flying Book",
		"Guardian of Tales",
		"Ghulosh' Deathgaze",
		"Knowledge Elemental",
		"The Book of Death",
		"Rage Squid",
		"Squid Warden",
		"Burning Book",
		"Icecold Book",
	},		
},

{name = "Ingol Hunt", color = 40, total = 3500, type = "once", storage = 190096, storagecount = 190097, 
	rewards = { 
	{"exp", 9000000},
	{62218, 20},
	},
	races = {
		"Boar Man",
		"Carnivostrich",
		"Crape Man",
		"Harpy",
		"Liodile",
		"Rhindeer",
	},		
},

{name = "Soul War Hunt", color = 40, total = 20000, type = "once", storage = 190098, storagecount = 190099, 
	rewards = { 
	{"exp", 30000000},
	{34109, 1}, ---bag you desire
	},
	races = {
		"Sorcerer's Apparition",
		"Bony Sea Devil",
		"Paladin's Apparition",
		"Druid's Apparition",
		"Brachiodemon",
		"Capricious Phantom",
		"Cloak of Terror",
		"Distorted Phantom",
		"Courage Leech",
		"Infernal Phantom",
		"Hazardous Phantom",
		"Many Faces",
		"Mean Maw",
		"Mould Phantom",
		"Rotten Golem",
		"Spiteful Spitter",
		"Turbulent Elemental",
		"Vibrant Phantom",
		"Branchy Crawler",
		"Infernal Demon",
	},		
},

{name = "Gnomprona Hunt", color = 40, total = 10000, type = "once", storage = 190100, storagecount = 190101, 
	rewards = { 
	{"exp", 8000000},
	{62218, 20},
	{39546, 1},
	},
	races = {
		"Hulking Prehemoth",
		"Gore Horn",
		"Gorerilla",
		"Emerald Tortoise",
		"Mantosaurus",
		"Noxious Ripptor",
		"Fungosaurus",
		"Sulphider",
		"Nighthunter",
		"Stalking Stalk",
		"Sulphur Spouter",
		"Undertaker",
	},		
},

{name = "20 Years a Cook Hunt", color = 40, total = 4000, type = "once", storage = 190102, storagecount = 190103, 
	rewards = { 
	{"exp", 8000000},
	{62218, 100},
	{3043, 100},
	},
	races = {
		"Wardragon",
		"Dragolisk",
		"Mega Dragon",
		"Bulltaur Alchemist",
		"Bulltaur Brute",
		"Bulltaur Forgepriest",
	},		
},


}

-- Restante das configuracoes de tarefas permanece inalterado...
-- [O restante do seu codigo de configuracao permanece identico]


squareWaitTime = 5000
taskQuestLog = 65000 -- A storage so you get the quest log
dailyTaskWaitTime = 20 * 60 * 60 

-- Nova funcao para contar tarefas ativas
function Player.getActiveTasks(self)
    local player = self
    if not player then
        return 0
    end
    
    local count = 0
    for _, data in pairs(taskConfiguration) do
        if player:hasStartedTask(data.storage) then
            count = count + 1
        end
    end
    
    return count
end

function Player.getCustomActiveTasksName(self)
local player = self
	if not player then
		return false
	end
local tasks = {}
	for i, data in pairs(taskConfiguration) do
		if player:getStorageValue(data.storagecount) ~= -1 then
		tasks[#tasks + 1] = data.name
		end
	end
	return #tasks > 0 and tasks or false
end


function getTaskByStorage(storage)
	for i, data in pairs(taskConfiguration) do
		if data.storage == tonumber(storage) then
			return data
		end
	end
	return false
end

function getTaskByMonsterName(name)
	for i, data in pairs(taskConfiguration) do
		for _, dataList in ipairs(data.races) do
		if dataList:lower() == name:lower() then
			return data
		end
		end
	end
	return false
end

function Player.startTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if player:getStorageValue(taskQuestLog) == -1 then
		player:setStorageValue(taskQuestLog, 1)
	end
	player:setStorageValue(storage, player:getStorageValue(storage) + 1)
	player:setStorageValue(data.storagecount, 0)
	
	-- Atualizar contagem de tarefas ativas
	local taskCount = player:getActiveTasks()
	player:setStorageValue(taskOptions.taskCountStorage, taskCount)
	
	return true
end

function Player.canStartCustomTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if data.type == "daily" then
		return os.time() >= player:getStorageValue(storage)
	elseif data.type == "once" then
		return player:getStorageValue(storage) == -1
	elseif data.type[1] == "repeatable" and data.type[2] ~= -1 then
		return player:getStorageValue(storage) < (data.type[2] - 1)
	else
		return true
	end
end

function Player.endTask(self, storage, prematurely)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
end
	if prematurely then
		if data.type == "daily" then
			player:setStorageValue(storage, -1)
		else
			player:setStorageValue(storage, player:getStorageValue(storage) - 1)
	end
	else
		if data.type == "daily" then
			player:setStorageValue(storage, os.time() + dailyTaskWaitTime)
		end
	end
	player:setStorageValue(data.storagecount, -1)
	
	-- Atualizar contagem de tarefas ativas
	local taskCount = math.max(0, player:getActiveTasks() - 1)
	player:setStorageValue(taskOptions.taskCountStorage, taskCount)
	
	return true
end

function Player.hasStartedTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	return player:getStorageValue(data.storagecount) ~= -1
end


function Player.getTaskKills(self, storage)
local player = self
	if not player then
		return false
	end
	return player:getStorageValue(storage)
end

function Player.addTaskKill(self, storage, count)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	local kills = player:getTaskKills(data.storagecount)
	if kills >= data.total then
		return false
	end
	if kills + count >= data.total then
		if taskOptions.selectLanguage == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, task_pt_br.messageCompleteTask)
		else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] You have finished this task! To claim your rewards, return to the quest board and claim your reward.")
		end
		return player:setStorageValue(data.storagecount, data.total)
	end
		player:say('Task: '..data.name ..' - ['.. kills + count .. '/'.. data.total ..']', TALKTYPE_MONSTER_SAY)
		return player:setStorageValue(data.storagecount, kills + count)
end