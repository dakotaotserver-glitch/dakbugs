local stage = configManager.getNumber(configKeys.FREE_QUEST_STAGE)

local questTable = {
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 2 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 4 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 7 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 9 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 12 },
	{ storageName = "BigfootsBurden.Shooting", storage = Storage.Quest.U9_60.BigfootsBurden.Shooting, storageValue = 5 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 16 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 20 },
	{ storageName = "BigfootsBurden.QuestLine", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLine, storageValue = 23 },
	{ storageName = "BigfootsBurden.QuestLineComplete", storage = Storage.Quest.U9_60.BigfootsBurden.QuestLineComplete, storageValue = 2 },
	{ storageName = "BigfootsBurden.Rank", storage = Storage.Quest.U9_60.BigfootsBurden.Rank, storageValue = 1440 },
	{ storageName = "BigfootsBurden.Warzone1Access", storage = Storage.Quest.U9_60.BigfootsBurden.Warzone1Access, storageValue = 2 },
	{ storageName = "BigfootsBurden.Warzone2Access", storage = Storage.Quest.U9_60.BigfootsBurden.Warzone2Access, storageValue = 2 },
	{ storageName = "BigfootsBurden.Warzone3Access", storage = Storage.Quest.U9_60.BigfootsBurden.Warzone3Access, storageValue = 2 },
	{ storageName = "DangerousDepths.Questline", storage = Storage.Quest.U11_50.DangerousDepths.Questline, storageValue = 10 },
	{ storageName = "DangerousDepths.Access.LavaPumpWarzoneVI", storage = Storage.Quest.U11_50.DangerousDepths.Access.LavaPumpWarzoneVI, storageValue = 10 },
	{ storageName = "DangerousDepths.Access.LavaPumpWarzoneV", storage = Storage.Quest.U11_50.DangerousDepths.Access.LavaPumpWarzoneV, storageValue = 10 },
	{ storageName = "DangerousDepths.Access.LavaPumpWarzoneIV", storage = Storage.Quest.U11_50.DangerousDepths.Access.LavaPumpWarzoneIV, storageValue = 30 },
	{ storageName = "DangerousDepths.Dwarves.Points", storage = Storage.Quest.U11_50.DangerousDepths.Dwarves.Points, storageValue = 15 },
	{ storageName = "DangerousDepths.Scouts.Points", storage = Storage.Quest.U11_50.DangerousDepths.Scouts.Points, storageValue = 15 },
	{ storageName = "DangerousDepths.Gnomes.Points", storage = Storage.Quest.U11_50.DangerousDepths.Gnomes.Points, storageValue = 15 },

	{ storageName = "CultsOfTibia.Questline", storage = Storage.Quest.U11_40.CultsOfTibia.Questline, storageValue = 7 },
	{ storageName = "CultsOfTibia.Minotaurs.JamesfrancisTask", storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.JamesfrancisTask, storageValue = 1 },
	{ storageName = "CultsOfTibia.MotA.AccessDoorInvestigation", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorInvestigation, storageValue = 1 },

	{ storageName = "CultsOfTibia.Minotaurs.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission, storageValue = 1 },
	{ storageName = "CultsOfTibia.Minotaurs.BossTimer", storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.BossTimer, storageValue = 1 },
	{ storageName = "CultsOfTibia.MotA.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, storageValue = 15 },
	{ storageName = "CultsOfTibia.MotA.Stone1", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.Stone1, storageValue = 1 },
	{ storageName = "CultsOfTibia.MotA.Stone2", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.Stone2, storageValue = 1 },
	{ storageName = "CultsOfTibia.MotA.Stone3", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.Stone3, storageValue = 1 },
	{ storageName = "CultsOfTibia.MotA.Answer", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.Answer, storageValue = 1 },
	{ storageName = "CultsOfTibia.MotA.QuestionId", storage = Storage.Quest.U11_40.CultsOfTibia.MotA.QuestionId, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Mission, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.Sulphur", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Sulphur, storageValue = 4 },
	{ storageName = "CultsOfTibia.Barkless.Tar", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Tar, storageValue = 3 },
	{ storageName = "CultsOfTibia.Barkless.Ice", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Ice, storageValue = 3 },
	{ storageName = "CultsOfTibia.Barkless.Objects", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Objects, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.Temp", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Temp, storageValue = 1 },
	{ storageName = "CultsOfTibia.Orcs.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.Orcs.Mission, storageValue = 1 },
	{ storageName = "CultsOfTibia.Orcs.LookType", storage = Storage.Quest.U11_40.CultsOfTibia.Orcs.LookType, storageValue = 1 },
	{ storageName = "CultsOfTibia.Orcs.BossTimer", storage = Storage.Quest.U11_40.CultsOfTibia.Orcs.BossTimer, storageValue = 1 },
	{ storageName = "CultsOfTibia.Life.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.Life.Mission, storageValue = 7 },
	{ storageName = "CultsOfTibia.Life.BossTimer", storage = Storage.Quest.U11_40.CultsOfTibia.Life.BossTimer, storageValue = 1 },
	{ storageName = "CultsOfTibia.Humans.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.Humans.Mission, storageValue = 1 },
	{ storageName = "CultsOfTibia.Humans.Vaporized", storage = Storage.Quest.U11_40.CultsOfTibia.Humans.Vaporized, storageValue = 1 },
	{ storageName = "CultsOfTibia.Humans.Decaying", storage = Storage.Quest.U11_40.CultsOfTibia.Humans.Decaying, storageValue = 1 },
	{ storageName = "CultsOfTibia.Humans.BossTimer", storage = Storage.Quest.U11_40.CultsOfTibia.Humans.BossTimer, storageValue = 1 },
	{ storageName = "CultsOfTibia.Misguided.Mission", storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission, storageValue = 1 },
	{ storageName = "CultsOfTibia.Misguided.Monsters", storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.Monsters, storageValue = 1 },
	{ storageName = "CultsOfTibia.Misguided.Exorcisms", storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.Exorcisms, storageValue = 1 },
	{ storageName = "CultsOfTibia.Misguided.Time", storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.Time, storageValue = 1 },
	{ storageName = "CultsOfTibia.Misguided.BossTimer", storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.BossTimer, storageValue = 1 },
	{ storageName = "CultsOfTibia.Minotaurs.BossAccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.BossAccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Minotaurs.AccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.AccessDoor, storageValue = 1 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 1 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 4 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 7 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 16 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 26 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 29 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 32 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 35 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 38 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 41 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 43 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 46 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 47 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 50 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 55 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 56 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 58 },
	{ storageName = "ExplorerSociety.QuestLine", storage = Storage.Quest.U7_6.ExplorerSociety.QuestLine, storageValue = 61 },
	{ storageName = "ExplorerSociety.CalassaQuest", storage = Storage.Quest.U7_6.ExplorerSociety.CalassaQuest, storageValue = 2 },
	{ storageName = "ForgottenKnowledge.Tomes", storage = Storage.Quest.U11_02.ForgottenKnowledge.Tomes, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.LastLoreKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.LastLoreKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.TimeGuardianKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.TimeGuardianKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.HorrorKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.HorrorKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.DragonkingKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.DragonkingKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.ThornKnightKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.ThornKnightKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.LloydKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.LloydKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.LadyTenebrisKilled", storage = Storage.Quest.U11_02.ForgottenKnowledge.LadyTenebrisKilled, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessMachine", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessMachine, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessLavaTeleport", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessLavaTeleport, storageValue = 1 },
	{ storageName = "BarbarianTest.Questline", storage = Storage.Quest.U8_0.BarbarianTest.Questline, storageValue = 8 },
	{ storageName = "BarbarianTest.Mission01", storage = Storage.Quest.U8_0.BarbarianTest.Mission01, storageValue = 3 },
	{ storageName = "BarbarianTest.Mission02", storage = Storage.Quest.U8_0.BarbarianTest.Mission02, storageValue = 3 },
	{ storageName = "BarbarianTest.Mission03", storage = Storage.Quest.U8_0.BarbarianTest.Mission03, storageValue = 3 },
	{ storageName = "ChildrenOfTheRevolution.Questline", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline, storageValue = 21 },
	{ storageName = "ChildrenOfTheRevolution.Mission00", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission00, storageValue = 2 },
	{ storageName = "ChildrenOfTheRevolution.Mission01", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission01, storageValue = 3 },
	{ storageName = "ChildrenOfTheRevolution.Mission02", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission02, storageValue = 5 },
	{ storageName = "ChildrenOfTheRevolution.Mission03", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission03, storageValue = 3 },
	{ storageName = "ChildrenOfTheRevolution.Mission04", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission04, storageValue = 6 },
	{ storageName = "ChildrenOfTheRevolution.Mission05", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission05, storageValue = 3 },
	{ storageName = "ChildrenOfTheRevolution.SpyBuilding01", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.SpyBuilding01, storageValue = 1 },
	{ storageName = "ChildrenOfTheRevolution.SpyBuilding02", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.SpyBuilding02, storageValue = 1 },
	{ storageName = "ChildrenOfTheRevolution.SpyBuilding03", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.SpyBuilding03, storageValue = 1 },
	{ storageName = "ChildrenOfTheRevolution.StrangeSymbols", storage = Storage.Quest.U8_54.ChildrenOfTheRevolution.StrangeSymbols, storageValue = 1 },
	{ storageName = "DjinnWar.Faction.Greeting", storage = Storage.Quest.U7_4.DjinnWar.Faction.Greeting, storageValue = 2 },
	{ storageName = "DjinnWar.Faction.MaridDoor", storage = Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor, storageValue = 2 },
	{ storageName = "DjinnWar.Faction.EfreetDoor", storage = Storage.Quest.U7_4.DjinnWar.Faction.EfreetDoor, storageValue = 2 },
	{ storageName = "DjinnWar.EfreetFaction.Start", storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Start, storageValue = 1 },
	{ storageName = "DjinnWar.EfreetFaction.Mission01", storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission01, storageValue = 3 },
	{ storageName = "DjinnWar.EfreetFaction.Mission02", storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission02, storageValue = 3 },
	{ storageName = "DjinnWar.EfreetFaction.Mission03", storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03, storageValue = 3 },
	{ storageName = "DjinnWar.MaridFaction.Start", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.Start, storageValue = 1 },
	{ storageName = "DjinnWar.MaridFaction.Mission01", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission01, storageValue = 2 },
	{ storageName = "DjinnWar.MaridFaction.Mission02", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission02, storageValue = 2 },
	{ storageName = "DjinnWar.MaridFaction.RataMari", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.RataMari, storageValue = 2 },
	{ storageName = "DjinnWar.MaridFaction.Mission03", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission03, storageValue = 3 },
	
	{ storageName = "InServiceOfYalahar.Questline", storage = Storage.Quest.U8_4.InServiceOfYalahar.Questline, storageValue = 50 },
	{ storageName = "InServiceOfYalahar.Mission01", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission01, storageValue = 6 },
	{ storageName = "InServiceOfYalahar.Mission02", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission02, storageValue = 8 },
	{ storageName = "InServiceOfYalahar.Mission03", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission03, storageValue = 6 },
	{ storageName = "InServiceOfYalahar.Mission04", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission04, storageValue = 6 },
	{ storageName = "InServiceOfYalahar.Mission05", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission05, storageValue = 8 },
	{ storageName = "InServiceOfYalahar.Mission06", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission06, storageValue = 5 },
	{ storageName = "InServiceOfYalahar.Mission07", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission07, storageValue = 5 },
	{ storageName = "InServiceOfYalahar.Mission08", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission08, storageValue = 4 },
	{ storageName = "InServiceOfYalahar.Mission09", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission09, storageValue = 2 },
	--{ storageName = "InServiceOfYalahar.Mission10", storage = Storage.Quest.U8_4.InServiceOfYalahar.Mission10, storageValue = 4 },
	{ storageName = "InServiceOfYalahar.SideDecision", storage = Storage.Quest.U8_4.InServiceOfYalahar.SideDecision, storageValue = 2 },
	--{ storageName = "InServiceOfYalahar.DoorToReward", storage = Storage.Quest.U8_4.InServiceOfYalahar.DoorToReward, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SewerPipe01", storage = Storage.Quest.U8_4.InServiceOfYalahar.SewerPipe01, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SewerPipe02", storage = Storage.Quest.U8_4.InServiceOfYalahar.SewerPipe02, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SewerPipe03", storage = Storage.Quest.U8_4.InServiceOfYalahar.SewerPipe03, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SewerPipe04", storage = Storage.Quest.U8_4.InServiceOfYalahar.SewerPipe04, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DiseasedDan", storage = Storage.Quest.U8_4.InServiceOfYalahar.DiseasedDan, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DiseasedBill", storage = Storage.Quest.U8_4.InServiceOfYalahar.DiseasedBill, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DiseasedFred", storage = Storage.Quest.U8_4.InServiceOfYalahar.DiseasedFred, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.AlchemistFormula", storage = Storage.Quest.U8_4.InServiceOfYalahar.AlchemistFormula, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.BadSide", storage = Storage.Quest.U8_4.InServiceOfYalahar.BadSide, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.GoodSide", storage = Storage.Quest.U8_4.InServiceOfYalahar.GoodSide, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.MrWestDoor", storage = Storage.Quest.U8_4.InServiceOfYalahar.MrWestDoor, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.MrWestStatus", storage = Storage.Quest.U8_4.InServiceOfYalahar.MrWestStatus, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.TamerinStatus", storage = Storage.Quest.U8_4.InServiceOfYalahar.TamerinStatus, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.MorikSummon", storage = Storage.Quest.U8_4.InServiceOfYalahar.MorikSummon, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.QuaraState", storage = Storage.Quest.U8_4.InServiceOfYalahar.QuaraState, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.QuaraSplasher", storage = Storage.Quest.U8_4.InServiceOfYalahar.QuaraSplasher, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.QuaraSharptooth", storage = Storage.Quest.U8_4.InServiceOfYalahar.QuaraSharptooth, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.QuaraInky", storage = Storage.Quest.U8_4.InServiceOfYalahar.QuaraInky, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.MatrixState", storage = Storage.Quest.U8_4.InServiceOfYalahar.MatrixState, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.NotesPalimuth", storage = Storage.Quest.U8_4.InServiceOfYalahar.NotesPalimuth, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.NotesAzerus", storage = Storage.Quest.U8_4.InServiceOfYalahar.NotesAzerus, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DoorToAzerus", storage = Storage.Quest.U8_4.InServiceOfYalahar.DoorToAzerus, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DoorToBog", storage = Storage.Quest.U8_4.InServiceOfYalahar.DoorToBog, storageValue = 1 },
	--{ storageName = "InServiceOfYalahar.DoorToLastFight", storage = Storage.Quest.U8_4.InServiceOfYalahar.DoorToLastFight, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DoorToMatrix", storage = Storage.Quest.U8_4.InServiceOfYalahar.DoorToMatrix, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.DoorToQuara", storage = Storage.Quest.U8_4.InServiceOfYalahar.DoorToQuara, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.TheWayToYalahar", storage = Storage.Quest.U8_4.InServiceOfYalahar.TheWayToYalahar, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.TownsCounter", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.TownsCounter, storageValue = 5 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.AbDendriel", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.AbDendriel, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.Darashia", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Darashia, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.Venore", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Venore, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.Ankrahmun", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Ankrahmun, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.PortHope", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.PortHope, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.Thais", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Thais, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.LibertyBay", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.LibertyBay, storageValue = 1 },
	{ storageName = "InServiceOfYalahar.SearoutesAroundYalahar.Carlin", storage = Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Carlin, storageValue = 1 },
	{ storageName = "TheHiddenCityOfBeregar.DefaultStart", storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.DefaultStart, storageValue = 1 },
	{ storageName = "TheHiddenCityOfBeregar.GoingDown", storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.GoingDown, storageValue = 1 },
	{ storageName = "TheHiddenCityOfBeregar.WayToBeregar", storage = Storage.Quest.U8_4.TheHiddenCityOfBeregar.WayToBeregar, storageValue = 1 },
	{ storageName = "TheIceIslands.Questline", storage = Storage.Quest.U8_0.TheIceIslands.Questline, storageValue = 40 },
	{ storageName = "TheIceIslands.Mission01", storage = Storage.Quest.U8_0.TheIceIslands.Mission01, storageValue = 3 },
	{ storageName = "TheIceIslands.Mission02", storage = Storage.Quest.U8_0.TheIceIslands.Mission02, storageValue = 5 },
	{ storageName = "TheIceIslands.Mission03", storage = Storage.Quest.U8_0.TheIceIslands.Mission03, storageValue = 3 },
	{ storageName = "TheIceIslands.Mission04", storage = Storage.Quest.U8_0.TheIceIslands.Mission04, storageValue = 2 },
	{ storageName = "TheIceIslands.Mission05", storage = Storage.Quest.U8_0.TheIceIslands.Mission05, storageValue = 6 },
	{ storageName = "TheIceIslands.Mission06", storage = Storage.Quest.U8_0.TheIceIslands.Mission06, storageValue = 8 },
	{ storageName = "TheIceIslands.Mission07", storage = Storage.Quest.U8_0.TheIceIslands.Mission07, storageValue = 3 },
	{ storageName = "TheIceIslands.Mission08", storage = Storage.Quest.U8_0.TheIceIslands.Mission08, storageValue = 4 },
	{ storageName = "TheIceIslands.Mission09", storage = Storage.Quest.U8_0.TheIceIslands.Mission09, storageValue = 2 },
	{ storageName = "TheIceIslands.Mission10", storage = Storage.Quest.U8_0.TheIceIslands.Mission10, storageValue = 2 },
	{ storageName = "TheIceIslands.Mission11", storage = Storage.Quest.U8_0.TheIceIslands.Mission11, storageValue = 2 },
	{ storageName = "TheIceIslands.Mission12", storage = Storage.Quest.U8_0.TheIceIslands.Mission12, storageValue = 6 },
	{ storageName = "TheIceIslands.PickAmount", storage = Storage.Quest.U8_0.TheIceIslands.PickAmount, storageValue = 3 },
	{ storageName = "TheIceIslands.yakchalDoor", storage = Storage.Quest.U8_0.TheIceIslands.yakchalDoor, storageValue = 1 },
	{ storageName = "TheInquisitionQuest.Questline", storage = Storage.Quest.U8_2.TheInquisitionQuest.Questline, storageValue = 25 },
	{ storageName = "TheInquisitionQuest.Mission01", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission01, storageValue = 7 },
	{ storageName = "TheInquisitionQuest.Mission02", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission02, storageValue = 3 },
	{ storageName = "TheInquisitionQuest.Mission03", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission03, storageValue = 6 },
	{ storageName = "TheInquisitionQuest.Mission04", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission04, storageValue = 3 },
	{ storageName = "TheInquisitionQuest.Mission05", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission05, storageValue = 3 },
	{ storageName = "TheInquisitionQuest.Mission06", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission06, storageValue = 3 },
	{ storageName = "TheInquisitionQuest.Mission07", storage = Storage.Quest.U8_2.TheInquisitionQuest.Mission07, storageValue = 1 },
	{ storageName = "TheInquisitionQuest.GrofGuard", storage = Storage.Quest.U8_2.TheInquisitionQuest.GrofGuard, storageValue = 1 },
	{ storageName = "TheInquisitionQuest.KulagGuard", storage = Storage.Quest.U8_2.TheInquisitionQuest.KulagGuard, storageValue = 1 },
	{ storageName = "TheInquisitionQuest.TimGuard", storage = Storage.Quest.U8_2.TheInquisitionQuest.TimGuard, storageValue = 1 },
	{ storageName = "TheInquisitionQuest.WalterGuard", storage = Storage.Quest.U8_2.TheInquisitionQuest.WalterGuard, storageValue = 1 },
	{ storageName = "TheInquisitionQuest.StorkusVampiredust", storage = Storage.Quest.U8_2.TheInquisitionQuest.StorkusVampiredust, storageValue = 1 },
	{ storageName = "TheNewFrontier.Questline", storage = Storage.Quest.U8_54.TheNewFrontier.Questline, storageValue = 29 },
	{ storageName = "TheNewFrontier.Mission01", storage = Storage.Quest.U8_54.TheNewFrontier.Mission01, storageValue = 3 },
	{ storageName = "TheNewFrontier.Mission02[1]", storage = Storage.Quest.U8_54.TheNewFrontier.Mission02[1], storageValue = 4 },
	{ storageName = "TheNewFrontier.Mission03", storage = Storage.Quest.U8_54.TheNewFrontier.Mission03, storageValue = 3 },
	{ storageName = "TheNewFrontier.Mission04", storage = Storage.Quest.U8_54.TheNewFrontier.Mission04, storageValue = 2 },
	{ storageName = "TheNewFrontier.Mission05[1]", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05[1], storageValue = 2 },
	{ storageName = "TheNewFrontier.Mission06", storage = Storage.Quest.U8_54.TheNewFrontier.Mission06, storageValue = 5 },
	{ storageName = "TheNewFrontier.Mission07[1]", storage = Storage.Quest.U8_54.TheNewFrontier.Mission07[1], storageValue = 2 },
	{ storageName = "TheNewFrontier.Mission08", storage = Storage.Quest.U8_54.TheNewFrontier.Mission08, storageValue = 2 },
	{ storageName = "TheNewFrontier.Mission09[1]", storage = Storage.Quest.U8_54.TheNewFrontier.Mission09[1], storageValue = 3 },
	{ storageName = "TheNewFrontier.Mission10[1]", storage = Storage.Quest.U8_54.TheNewFrontier.Mission10[1], storageValue = 2 },
	{ storageName = "TheNewFrontier.Mission10.MagicCarpetDoor", storage = Storage.Quest.U8_54.TheNewFrontier.Mission10.MagicCarpetDoor, storageValue = 1 },
	{ storageName = "TheNewFrontier.TomeofKnowledge", storage = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge, storageValue = 12 },
	{ storageName = "TheNewFrontier.Mission02.Beaver1", storage = Storage.Quest.U8_54.TheNewFrontier.Mission02.Beaver1, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission02.Beaver2", storage = Storage.Quest.U8_54.TheNewFrontier.Mission02.Beaver2, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission02.Beaver3", storage = Storage.Quest.U8_54.TheNewFrontier.Mission02.Beaver3, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission05.KingTibianus", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05.KingTibianus, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission05.Leeland", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05.Leeland, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission05.Angus", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05.Angus, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission05.Wyrdin", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05.Wyrdin, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission05.Telas", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05.Telas, storageValue = 1 },
	{ storageName = "TheNewFrontier.Mission05.Humgolf", storage = Storage.Quest.U8_54.TheNewFrontier.Mission05.Humgolf, storageValue = 1 },
	{ storageName = "TheSecretLibrary.MoTA.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, storageValue = 8 },
	{ storageName = "TheSecretLibrary.MoTA.LeverPermission", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.LeverPermission, storageValue = 1 },
	{ storageName = "TheSecretLibrary.MoTA.FinalBasin", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.FinalBasin, storageValue = 1 },
	{ storageName = "TheSecretLibrary.MoTA.SkullSample", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.SkullSample, storageValue = 1 },
	{ storageName = "TheSecretLibrary.MoTA.YellowGem", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.YellowGem, storageValue = 1 },
	{ storageName = "TheSecretLibrary.MoTA.GreenGem", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.GreenGem, storageValue = 1 },
	{ storageName = "TheSecretLibrary.MoTA.RedGem", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.RedGem, storageValue = 1 },
	{ storageName = "TheShatteredIsles.DefaultStart", storage = Storage.Quest.U7_8.TheShatteredIsles.DefaultStart, storageValue = 3 },
	{ storageName = "TheShatteredIsles.TheGovernorDaughter", storage = Storage.Quest.U7_8.TheShatteredIsles.TheGovernorDaughter, storageValue = 3 },
	{ storageName = "TheShatteredIsles.TheErrand", storage = Storage.Quest.U7_8.TheShatteredIsles.TheErrand, storageValue = 2 },
	{ storageName = "TheShatteredIsles.AccessToMeriana", storage = Storage.Quest.U7_8.TheShatteredIsles.AccessToMeriana, storageValue = 1 },
	{ storageName = "TheShatteredIsles.APoemForTheMermaid", storage = Storage.Quest.U7_8.TheShatteredIsles.APoemForTheMermaid, storageValue = 3 },
	{ storageName = "TheShatteredIsles.ADjinnInLove", storage = Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove, storageValue = 5 },
	{ storageName = "TheShatteredIsles.AccessToLagunaIsland", storage = Storage.Quest.U7_8.TheShatteredIsles.AccessToLagunaIsland, storageValue = 1 },
	{ storageName = "TheShatteredIsles.AccessToGoroma", storage = Storage.Quest.U7_8.TheShatteredIsles.AccessToGoroma, storageValue = 1 },
	{ storageName = "TheShatteredIsles.Shipwrecked", storage = Storage.Quest.U7_8.TheShatteredIsles.Shipwrecked, storageValue = 2 },
	{ storageName = "TheShatteredIsles.DragahsSpellbook", storage = Storage.Quest.U7_8.TheShatteredIsles.DragahsSpellbook, storageValue = 1 },
	{ storageName = "TheShatteredIsles.TheCounterspell", storage = Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell, storageValue = 4 },
	{ storageName = "TheThievesGuildQuest.Questline", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Questline, storageValue = 1 },
	{ storageName = "TheThievesGuildQuest.Mission01", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission01, storageValue = 2 },
	{ storageName = "TheThievesGuildQuest.Mission02", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission02, storageValue = 3 },
	{ storageName = "TheThievesGuildQuest.Mission03", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission03, storageValue = 3 },
	{ storageName = "TheThievesGuildQuest.Mission04", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission04, storageValue = 8 },
	{ storageName = "TheThievesGuildQuest.Mission05", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission05, storageValue = 2 },
	{ storageName = "TheThievesGuildQuest.Mission06", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission06, storageValue = 4 },
	{ storageName = "TheThievesGuildQuest.Mission07", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission07, storageValue = 2 },
	{ storageName = "TheThievesGuildQuest.Mission08", storage = Storage.Quest.U8_2.TheThievesGuildQuest.Mission08, storageValue = 1 },
	{ storageName = "TheTravellingTrader.Mission01", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission01, storageValue = 1 },
	{ storageName = "TheTravellingTrader.Mission01_2", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission01, storageValue = 2 },
	{ storageName = "TheTravellingTrader.Mission02", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission02, storageValue = 5 },
	{ storageName = "TheTravellingTrader.Mission03", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission03, storageValue = 3 },
	{ storageName = "TheTravellingTrader.Mission04", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission04, storageValue = 3 },
	{ storageName = "TheTravellingTrader.Mission05", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission05, storageValue = 3 },
	{ storageName = "TheTravellingTrader.Mission06", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission06, storageValue = 2 },
	{ storageName = "TheTravellingTrader.Mission07", storage = Storage.Quest.U8_1.TheTravellingTrader.Mission07, storageValue = 1 },
	{ storageName = "BarbarianArena.QuestLogGreenhorn", storage = Storage.Quest.U8_0.BarbarianArena.QuestLogGreenhorn, storageValue = 1 },
	{ storageName = "TibiaTales.DefaultStart", storage = Storage.Quest.U8_1.TibiaTales.DefaultStart, storageValue = 1 },
	{ storageName = "TibiaTales.ToAppeaseTheMightyQuest", storage = Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest, storageValue = 1 },
	{ storageName = "12450", storage = 12450, storageValue = 6 },
	{ storageName = "12330", storage = 12330, storageValue = 1 },
	{ storageName = "12332", storage = 12332, storageValue = 13 },
	{ storageName = "12333", storage = 12333, storageValue = 3 },
	{ storageName = "FriendsAndTraders.DefaultStart", storage = Storage.Quest.U7_8.FriendsAndTraders.DefaultStart, storageValue = 1 },
	{ storageName = "FriendsAndTraders.TheSweatyCyclops", storage = Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops, storageValue = 2 },
	{ storageName = "FriendsAndTraders.TheMermaidMarina", storage = Storage.Quest.U7_8.FriendsAndTraders.TheMermaidMarina, storageValue = 2 },
	{ storageName = "FriendsAndTraders.TheBlessedStake", storage = Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake, storageValue = 12 },
	{ storageName = "100157", storage = 100157, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.Questline", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Questline, storageValue = 29 },
	{ storageName = "WrathOfTheEmperor.Mission01", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission01, storageValue = 3 },
	{ storageName = "WrathOfTheEmperor.Mission02", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission02, storageValue = 3 },
	{ storageName = "WrathOfTheEmperor.Mission03", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission03, storageValue = 3 },
	{ storageName = "WrathOfTheEmperor.Mission04", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission04, storageValue = 3 },
	{ storageName = "WrathOfTheEmperor.Mission05", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission05, storageValue = 3 },
	{ storageName = "WrathOfTheEmperor.Mission06", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission06, storageValue = 4 },
	{ storageName = "WrathOfTheEmperor.Mission07", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission07, storageValue = 6 },
	{ storageName = "WrathOfTheEmperor.Mission08", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission08, storageValue = 2 },
	{ storageName = "WrathOfTheEmperor.Mission09", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission09, storageValue = 2 },
	{ storageName = "WrathOfTheEmperor.Mission10", storage = Storage.Quest.U8_6.WrathOfTheEmperor.Mission10, storageValue = 1 },
	{ storageName = "TheApeCity.Started", storage = Storage.Quest.U7_6.TheApeCity.Started, storageValue = 1 },
	{ storageName = "TheApeCity.Questline", storage = Storage.Quest.U7_6.TheApeCity.Questline, storageValue = 18 },
	{ storageName = "BanutaSecretTunnel.DeeperBanutaShortcut", storage = Storage.BanutaSecretTunnel.DeeperBanutaShortcut, storageValue = 1 },
	{ storageName = "OramondQuest.QuestLine", storage = Storage.Quest.U10_50.OramondQuest.QuestLine, storageValue = 1 },
	{ storageName = "OramondQuest.ToTakeRoots.Mission", storage = Storage.Quest.U10_50.OramondQuest.ToTakeRoots.Mission, storageValue = 3000 },
	{ storageName = "DangerousDepths.Questline", storage = Storage.Quest.U11_50.DangerousDepths.Questline, storageValue = 1 },
	{ storageName = "DangerousDepths.Dwarves.Home", storage = Storage.Quest.U11_50.DangerousDepths.Dwarves.Home, storageValue = 2 },
	{ storageName = "DangerousDepths.Dwarves.Subterranean", storage = Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean, storageValue = 2 },
	{ storageName = "DangerousDepths.Gnomes.Measurements", storage = Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements, storageValue = 2 },
	{ storageName = "DangerousDepths.Gnomes.Ordnance", storage = Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance, storageValue = 3 },
	{ storageName = "DangerousDepths.Gnomes.Charting", storage = Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting, storageValue = 2 },
	{ storageName = "DangerousDepths.Scouts.Growth", storage = Storage.Quest.U11_50.DangerousDepths.Scouts.Growth, storageValue = 2 },
	{ storageName = "DangerousDepths.Scouts.Diremaw", storage = Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw, storageValue = 2 },
	{ storageName = "ThreatenedDreams.QuestLine", storage = Storage.Quest.U11_40.ThreatenedDreams.QuestLine, storageValue = 1 },
	{ storageName = "ThreatenedDreams.Mission01[1]", storage = Storage.Quest.U11_40.ThreatenedDreams.Mission01[1], storageValue = 16 },
	{ storageName = "ThreatenedDreams.Mission02.KroazurAccess", storage = Storage.Quest.U11_40.ThreatenedDreams.Mission02.KroazurAccess, storageValue = 1 },
	{ storageName = "AdventurersGuild.QuestLine", storage = Storage.Quest.U9_80.AdventurersGuild.QuestLine, storageValue = 1 },
	{ storageName = "TheGreatDragonHunt.WarriorSkeleton", storage = Storage.Quest.U10_80.TheGreatDragonHunt.WarriorSkeleton, storageValue = 1 },
	{ storageName = "TheGreatDragonHunt.WarriorSkeleton_2", storage = Storage.Quest.U10_80.TheGreatDragonHunt.WarriorSkeleton, storageValue = 2 },
	{ storageName = "TheLostBrotherQuest", storage = Storage.Quest.U10_80.TheLostBrotherQuest, storageValue = 3 },
	{ storageName = "Dawnport.Questline", storage = Storage.Quest.U10_55.Dawnport.Questline, storageValue = 1 },
	{ storageName = "Dawnport.GoMain", storage = Storage.Quest.U10_55.Dawnport.GoMain, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessDeath", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessDeath, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessViolet", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessViolet, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessEarth", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessEarth, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessFire", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessFire, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessIce", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessIce, storageValue = 1 },
	{ storageName = "ForgottenKnowledge.AccessGolden", storage = Storage.Quest.U11_02.ForgottenKnowledge.AccessGolden, storageValue = 1 },
	{ storageName = "GrimvaleQuest.AncientFeudDoors", storage = Storage.Quest.U10_80.GrimvaleQuest.AncientFeudDoors, storageValue = 1 },
	{ storageName = "GrimvaleQuest.AncientFeudShortcut", storage = Storage.Quest.U10_80.GrimvaleQuest.AncientFeudShortcut, storageValue = 1 },
	{ storageName = "KilmareshQuest.AccessDoor", storage = Storage.Quest.U12_20.KilmareshQuest.AccessDoor, storageValue = 1 },
	{ storageName = "KilmareshQuest.Second.Investigating", storage = Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, storageValue = 1 },
	{ storageName = "KilmareshQuest.Sixth.GryphonMask", storage = Storage.Quest.U12_20.KilmareshQuest.Sixth.GryphonMask, storageValue = 1 },
	{ storageName = "KilmareshQuest.Sixth.MirrorMask", storage = Storage.Quest.U12_20.KilmareshQuest.Sixth.MirrorMask, storageValue = 1 },
	{ storageName = "KilmareshQuest.Sixth.IvoryMask", storage = Storage.Quest.U12_20.KilmareshQuest.Sixth.IvoryMask, storageValue = 1 },
	{ storageName = "KilmareshQuest.Sixth.SilverMask", storage = Storage.Quest.U12_20.KilmareshQuest.Sixth.SilverMask, storageValue = 1 },
	{ storageName = "TheOrderOfTheLion.AccessEastSide", storage = Storage.Quest.U12_40.TheOrderOfTheLion.AccessEastSide, storageValue = 1 },
	{ storageName = "TheOrderOfTheLion.AccessSouthernSide", storage = Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide, storageValue = 1 },
	{ storageName = "APiratesTail.TentuglyDoor", storage = Storage.Quest.U12_60.APiratesTail.TentuglyDoor, storageValue = 1 },
	{ storageName = "APiratesTail.RascacoonShortcut", storage = Storage.Quest.U12_60.APiratesTail.RascacoonShortcut, storageValue = 1 },
	{ storageName = "AdventuresOfGalthen.AccessDoor", storage = Storage.Quest.U12_70.AdventuresOfGalthen.AccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.AccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.AccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.TrialAccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.TrialAccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.TarAccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.TarAccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Barkless.BossAccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.BossAccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Life.AccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Life.AccessDoor, storageValue = 1 },
	{ storageName = "CultsOfTibia.Misguided.AccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.AccessDoor, storageValue = 1 },
	--{ storageName = "CultsOfTibia.FinalBoss.AccessDoor", storage = Storage.Quest.U11_40.CultsOfTibia.FinalBoss.AccessDoor, storageValue = 1 },
	{ storageName = "FerumbrasAscension.FirstDoor", storage = Storage.Quest.U10_90.FerumbrasAscension.FirstDoor, storageValue = 1 },
	{ storageName = "FerumbrasAscension.MonsterDoor", storage = Storage.Quest.U10_90.FerumbrasAscension.MonsterDoor, storageValue = 1 },
	{ storageName = "FerumbrasAscension.TarbazDoor", storage = Storage.Quest.U10_90.FerumbrasAscension.TarbazDoor, storageValue = 1 },
	{ storageName = "FerumbrasAscension.HabitatsAccess", storage = Storage.Quest.U10_90.FerumbrasAscension.HabitatsAccess, storageValue = 1 },
	{ storageName = "FerumbrasAscension.TheLordOfTheLiceAccess", storage = Storage.Quest.U10_90.FerumbrasAscension.TheLordOfTheLiceAccess, storageValue = 1 },
	{ storageName = "FerumbrasAscension.Statue", storage = Storage.Quest.U10_90.FerumbrasAscension.Statue, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.AwarnessEmperor", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.AwarnessEmperor, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.BossRoom", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.BossRoom, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.InnerSanctum", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.InnerSanctum, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.Rebel", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Rebel, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.SleepingDragon", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.SleepingDragon, storageValue = 2 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.Wote10", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Wote10, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.Zizzle", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Zizzle, storageValue = 1 },
	{ storageName = "WrathOfTheEmperor.TeleportAccess.Zlak", storage = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Zlak, storageValue = 1 },
	{ storageName = "DjinnWar.EfreetFaction.DoorToLamp", storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.DoorToLamp, storageValue = 1 },
	{ storageName = "DjinnWar.EfreetFaction.DoorToMaridTerritory", storage = Storage.Quest.U7_4.DjinnWar.EfreetFaction.DoorToMaridTerritory, storageValue = 1 },
	{ storageName = "DjinnWar.MaridFaction.DoorToLamp", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.DoorToLamp, storageValue = 1 },
	{ storageName = "DjinnWar.MaridFaction.DoorToEfreetTerritory", storage = Storage.Quest.U7_4.DjinnWar.MaridFaction.DoorToEfreetTerritory, storageValue = 1 },
	{ storageName = "CradleOfMonsters.Access.Ingol", storage = Storage.Quest.U13_10.CradleOfMonsters.Access.Ingol, storageValue = 1 },
	{ storageName = "CradleOfMonsters.Access.LowerIngol", storage = Storage.Quest.U13_10.CradleOfMonsters.Access.LowerIngol, storageValue = 1 },
	{ storageName = "CradleOfMonsters.Access.Monster", storage = Storage.Quest.U13_10.CradleOfMonsters.Access.Monster, storageValue = 1 },
	{ storageName = "CradleOfMonsters.Access.MutatedAbomination", storage = Storage.Quest.U13_10.CradleOfMonsters.Access.MutatedAbomination, storageValue = 1 },
	{ storageName = "TheNewFrontier.SnakeHeadTeleport", storage = Storage.Quest.U8_54.TheNewFrontier.SnakeHeadTeleport, storageValue = 1 },
	{ storageName = "LiquidBlackQuest.Visitor", storage = Storage.Quest.U9_4.LiquidBlackQuest.Visitor, storageValue = 5 },
	{ storageName = "KillingInTheNameOf.BudrikMinos", storage = Storage.Quest.U8_5.KillingInTheNameOf.BudrikMinos, storageValue = 0 },
	{ storageName = "ToOutfoxAFoxQuest.Questline", storage = Storage.Quest.U8_1.ToOutfoxAFoxQuest.Questline, storageValue = 2 },
	{ storageName = "HunterOutfits.HunterMusicSheet01", storage = Storage.Quest.U7_8.HunterOutfits.HunterMusicSheet01, storageValue = 1 },
	{ storageName = "HunterOutfits.HunterMusicSheet02", storage = Storage.Quest.U7_8.HunterOutfits.HunterMusicSheet02, storageValue = 1 },
	{ storageName = "HunterOutfits.HunterMusicSheet03", storage = Storage.Quest.U7_8.HunterOutfits.HunterMusicSheet03, storageValue = 1 },
	{ storageName = "HunterOutfits.HunterMusicSheet04", storage = Storage.Quest.U7_8.HunterOutfits.HunterMusicSheet04, storageValue = 1 },
	{ storageName = "TheIceIslands.NorsemanOutfit", storage = Storage.Quest.U8_0.TheIceIslands.NorsemanOutfit, storageValue = 1 },
	{ storageName = "OutfitQuest.DefaultStart", storage = Storage.OutfitQuest.DefaultStart, storageValue = 1 },
	{ storageName = "HeroRathleton.AccessDoor", storage = Storage.HeroRathleton.AccessDoor, storageValue = 1 },
	{ storageName = "HeroRathleton.AccessTeleport1", storage = Storage.HeroRathleton.AccessTeleport1, storageValue = 1 },
	{ storageName = "HeroRathleton.AccessTeleport2", storage = Storage.HeroRathleton.AccessTeleport2, storageValue = 1 },
	{ storageName = "HeroRathleton.AccessTeleport3", storage = Storage.HeroRathleton.AccessTeleport3, storageValue = 1 },
	{ storageName = "TheHuntForTheSeaSerpent.FishForASerpent", storage = Storage.Quest.U8_2.TheHuntForTheSeaSerpent.FishForASerpent, storageValue = 5 },
	{ storageName = "TheHuntForTheSeaSerpent.QuestLine", storage = Storage.Quest.U8_2.TheHuntForTheSeaSerpent.QuestLine, storageValue = 2 },
	{ storageName = "TheWhiteRavenMonastery.QuestLog", storage = Storage.Quest.U7_24.TheWhiteRavenMonastery.QuestLog, storageValue = 1 },
	{ storageName = "TheWhiteRavenMonastery.Passage", storage = Storage.Quest.U7_24.TheWhiteRavenMonastery.Passage, storageValue = 1 },
	{ storageName = "TheWhiteRavenMonastery.Diary", storage = Storage.Quest.U7_24.TheWhiteRavenMonastery.Diary, storageValue = 2 },
	{ storageName = "TheWhiteRavenMonastery.Door", storage = Storage.Quest.U7_24.TheWhiteRavenMonastery.Door, storageValue = 1 },
	
	

	-- QUESTLINE PRINCIPAL
	{ storageName = "TheDreamCourts.Main.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.Main.Questline, storageValue = 4 },
	{ storageName = "TheDreamCourts.Main.CourtChest", storage = Storage.Quest.U12_00.TheDreamCourts.Main.CourtChest, storageValue = 1 },
	{ storageName = "TheDreamCourts.Main.TheSummerCourt", storage = Storage.Quest.U12_00.TheDreamCourts.Main.TheSummerCourt, storageValue = 1 },
	{ storageName = "TheDreamCourts.Main.TheWinterCourt", storage = Storage.Quest.U12_00.TheDreamCourts.Main.TheWinterCourt, storageValue = 1 },

	-- Burried Catedral (Buried Cathedral)
	{ storageName = "TheDreamCourts.BurriedCatedral.FishingRod",    storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.FishingRod,    storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.EstatueWord",   storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.EstatueWord,   storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.BarrelWord",    storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.BarrelWord,    storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.BedWord",       storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.BedWord,       storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.LakeWord",      storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.LakeWord,      storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.WordCount",     storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount,     storageValue = 5 }, -- máximo de palavras
	{ storageName = "TheDreamCourts.BurriedCatedral.SequenceBooks", storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.SequenceBooks, storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.FacelessTimer", storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.FacelessTimer, storageValue = 1 },
	{ storageName = "TheDreamCourts.BurriedCatedral.FacelessLifes", storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.FacelessLifes, storageValue = 1 },

	-- Haunted House
	{ storageName = "TheDreamCourts.HauntedHouse.Questline",        storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,        storageValue = 6 },
	{ storageName = "TheDreamCourts.HauntedHouse.Cellar",           storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar,           storageValue = 1 },
	{ storageName = "TheDreamCourts.HauntedHouse.Temple",           storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple,           storageValue = 1 },
	{ storageName = "TheDreamCourts.HauntedHouse.Tomb",             storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Tomb,             storageValue = 1 },
	{ storageName = "TheDreamCourts.HauntedHouse.SkeletonContainer",storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.SkeletonContainer,storageValue = 1 },
	{ storageName = "TheDreamCourts.HauntedHouse.IdolCount",        storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.IdolCount,        storageValue = 4 }, -- máximo de ídolos



	-- -- WARD STONES (todos os locais)
	{ storageName = "TheDreamCourts.WardStones.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline, storageValue = 10 },
	{ storageName = "TheDreamCourts.WardStones.Count", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.Count, storageValue = 8 },
	{ storageName = "TheDreamCourts.WardStones.OkolnirStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.OkolnirStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.FoldaStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.FoldaStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.CalassaStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.CalassaStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.FeyristStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.FeyristStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.MerianaStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.MerianaStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.CormayaStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.CormayaStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.PortHopeStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.PortHopeStone, storageValue = 1 },
	{ storageName = "TheDreamCourts.WardStones.CatedralStone", storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.CatedralStone, storageValue = 1 },

	-- -- DREAMSCAR & BOSSES (liberações usuais, pode adaptar conforme client mostrar pendências)
	 { storageName = "TheDreamCourts.DreamScar.Permission", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.Permission, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.BossCount", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount, storageValue = 5 },
	-- { storageName = "TheDreamCourts.DreamScar.MaxxeniusTimer", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.MaxxeniusTimer, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.AlptramunTimer", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.AlptramunTimer, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.PlagueRootTimer", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.PlagueRootTimer, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.IzcandarTimer", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.IzcandarTimer, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.MalofurTimer", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.MalofurTimer, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.NightmareTimer", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.NightmareTimer, storageValue = 1 },
	-- { storageName = "TheDreamCourts.DreamScar.LastBossCurse", storage = Storage.Quest.U12_00.TheDreamCourts.DreamScar.LastBossCurse, storageValue = 1 },
	-- { storageName = "TheDreamCourts.Malofur", storage = Storage.Quest.U12_00.TheDreamCourts.Malofur, storageValue = 1 },

	-- -- Outros possíveis marcadores (ajuste conforme feedback do seu client)
	{ storageName = "TheDreamCourts.UnsafeRelease.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline, storageValue = 3 },
	{ storageName = "TheDreamCourts.UnsafeRelease.HasBait", storage = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.HasBait, storageValue = 1 },
	{ storageName = "TheDreamCourts.UnsafeRelease.GotAxe", storage = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.GotAxe, storageValue = 1 },



	
	
	{ storageName = "TheDreamCourts.TheSevenKeys.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline, storageValue = 2 },
	{ storageName = "TheDreamCourts.TheSevenKeys.Count", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count, storageValue = 7 },
	{ storageName = "TheDreamCourts.TheSevenKeys.RoseBush", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.RoseBush, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.MushRoom", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MushRoom, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.Book", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Book, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.OrcSkull", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.OrcSkull, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.MinotaurSkull", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MinotaurSkull, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.TrollSkull", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.TrollSkull, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.Lock", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Lock, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.DoorMedusa", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.DoorMedusa, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.DoorInvisible", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.DoorInvisible, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.Painting", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Painting, storageValue = 1 },
	{ storageName = "TheDreamCourts.TheSevenKeys.SequenceSkulls", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.SequenceSkulls, storageValue = 1 },
	
	
	
    { storageName = "TheDreamCourts.UnsafeRelease.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Cellar", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Temple", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple, storageValue = 1 },
    { storageName = "TheDreamCourts.HauntedHouse.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, storageValue = 1 },
    { storageName = "TheDreamCourts.BurriedCatedral.WordCount", storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount, storageValue = 3 },
    { storageName = "TheDreamCourts.BurriedCatedral.WordCount", storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount, storageValue = 3 },
    { storageName = "TheDreamCourts.BurriedCatedral.WordCount", storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount, storageValue = 3 },
    { storageName = "TheDreamCourts.TheSevenKeys.DoorMedusa", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.DoorMedusa, storageValue = 1 },
    { storageName = "TheDreamCourts.TheSevenKeys.MushRoom", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MushRoom, storageValue = 2 },
    { storageName = "TheDreamCourts.TheSevenKeys.SequenceSkulls", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.SequenceSkulls, storageValue = 3 },
    { storageName = "TheDreamCourts.TheSevenKeys.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline, storageValue = 2 },
    { storageName = "TheDreamCourts.TheSevenKeys.Questline", storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline, storageValue = 2 },


	
    { storageName = "Quest.U8_0.BarbarianTest.Questline", storage = Storage.Quest.U8_0.BarbarianTest.Questline, storageValue = 8 },
    { storageName = "Quest.U8_0.TheIceIslands.Questline", storage = Storage.Quest.U8_0.TheIceIslands.Questline, storageValue = 30 }, -- (< 30 no script, veja nota)


	
	
	-- -- The Postman Missions
{ storageName = "ThePostmanMissions.Mission01", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission01, storageValue = 6 },
{ storageName = "ThePostmanMissions.Mission02", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission02, storageValue = 3 },
{ storageName = "ThePostmanMissions.Mission03", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission03, storageValue = 3 },
{ storageName = "ThePostmanMissions.Mission04", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission04, storageValue = 2 },
{ storageName = "ThePostmanMissions.Mission05", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission05, storageValue = 4 },
{ storageName = "ThePostmanMissions.Mission06", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission06, storageValue = 13 },
{ storageName = "ThePostmanMissions.Mission07", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission07, storageValue = 9 },
{ storageName = "ThePostmanMissions.Mission08", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission08, storageValue = 3 },
{ storageName = "ThePostmanMissions.Mission09", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission09, storageValue = 4 },
{ storageName = "ThePostmanMissions.Mission10", storage = Storage.Quest.U7_24.ThePostmanMissions.Mission10, storageValue = 3 },
{ storageName = "ThePostmanMissions.Rank", storage = Storage.Quest.U7_24.ThePostmanMissions.Rank, storageValue = 5 },

-- Travelling/Extra/Side tasks (opcional, mas recomendo!)
{ storageName = "ThePostmanMissions.Door", storage = Storage.Quest.U7_24.ThePostmanMissions.Door, storageValue = 1 },
{ storageName = "ThePostmanMissions.TravelCarlin", storage = Storage.Quest.U7_24.ThePostmanMissions.TravelCarlin, storageValue = 1 },
{ storageName = "ThePostmanMissions.TravelEdron", storage = Storage.Quest.U7_24.ThePostmanMissions.TravelEdron, storageValue = 1 },
{ storageName = "ThePostmanMissions.TravelVenore", storage = Storage.Quest.U7_24.ThePostmanMissions.TravelVenore, storageValue = 1 },
{ storageName = "ThePostmanMissions.TravelCormaya", storage = Storage.Quest.U7_24.ThePostmanMissions.TravelCormaya, storageValue = 1 },
{ storageName = "ThePostmanMissions.MeasurementsBenjamin", storage = Storage.Quest.U7_24.ThePostmanMissions.MeasurementsBenjamin, storageValue = 1 },
{ storageName = "ThePostmanMissions.MeasurementsKroox", storage = Storage.Quest.U7_24.ThePostmanMissions.MeasurementsKroox, storageValue = 1 },
{ storageName = "ThePostmanMissions.MeasurementsDove", storage = Storage.Quest.U7_24.ThePostmanMissions.MeasurementsDove, storageValue = 1 },
{ storageName = "ThePostmanMissions.MeasurementsLiane", storage = Storage.Quest.U7_24.ThePostmanMissions.MeasurementsLiane, storageValue = 1 },
{ storageName = "ThePostmanMissions.MeasurementsChrystal", storage = Storage.Quest.U7_24.ThePostmanMissions.MeasurementsChrystal, storageValue = 1 },
{ storageName = "ThePostmanMissions.MeasurementsOlrik", storage = Storage.Quest.U7_24.ThePostmanMissions.MeasurementsOlrik, storageValue = 1 },

	
	
	-- Dark Trails Quest
{ storageName = "DarkTrails.Mission01", storage = Storage.Quest.U10_50.DarkTrails.Mission01, storageValue = 1 },
{ storageName = "DarkTrails.Mission02", storage = Storage.Quest.U10_50.DarkTrails.Mission02, storageValue = 1 },
{ storageName = "DarkTrails.Mission03", storage = Storage.Quest.U10_50.DarkTrails.Mission03, storageValue = 1 },
{ storageName = "DarkTrails.Mission04", storage = Storage.Quest.U10_50.DarkTrails.Mission04, storageValue = 1 },
{ storageName = "DarkTrails.Mission05", storage = Storage.Quest.U10_50.DarkTrails.Mission05, storageValue = 1 },
{ storageName = "DarkTrails.Mission06", storage = Storage.Quest.U10_50.DarkTrails.Mission06, storageValue = 1 },
{ storageName = "DarkTrails.Mission07", storage = Storage.Quest.U10_50.DarkTrails.Mission07, storageValue = 1 },
{ storageName = "DarkTrails.Mission08", storage = Storage.Quest.U10_50.DarkTrails.Mission08, storageValue = 1 },
{ storageName = "DarkTrails.Mission09", storage = Storage.Quest.U10_50.DarkTrails.Mission09, storageValue = 1 },
{ storageName = "DarkTrails.Mission10", storage = Storage.Quest.U10_50.DarkTrails.Mission10, storageValue = 1 },
{ storageName = "DarkTrails.Mission11", storage = Storage.Quest.U10_50.DarkTrails.Mission11, storageValue = 1 },
{ storageName = "DarkTrails.Mission12", storage = Storage.Quest.U10_50.DarkTrails.Mission12, storageValue = 1 },
{ storageName = "DarkTrails.Mission13", storage = Storage.Quest.U10_50.DarkTrails.Mission13, storageValue = 1 },
{ storageName = "DarkTrails.Mission14", storage = Storage.Quest.U10_50.DarkTrails.Mission14, storageValue = 2 }, -- Nota: Esta missão tem valor final 2
{ storageName = "DarkTrails.Mission15", storage = Storage.Quest.U10_50.DarkTrails.Mission15, storageValue = 1 },
{ storageName = "DarkTrails.Mission16", storage = Storage.Quest.U10_50.DarkTrails.Mission16, storageValue = 1 },
{ storageName = "DarkTrails.Mission17", storage = Storage.Quest.U10_50.DarkTrails.Mission17, storageValue = 1 },
{ storageName = "DarkTrails.Mission18", storage = Storage.Quest.U10_50.DarkTrails.Mission18, storageValue = 1 },
{ storageName = "DarkTrails.Mission19", storage = Storage.Quest.U10_50.DarkTrails.Mission19, storageValue = 1 },
{ storageName = "DarkTrails.Outfit", storage = Storage.Quest.U10_50.DarkTrails.Outfit, storageValue = 1 },
{ storageName = "DarkTrails.DoorQuandon", storage = Storage.Quest.U10_50.DarkTrails.DoorQuandon, storageValue = 1 },
{ storageName = "DarkTrails.DoorHideout", storage = Storage.Quest.U10_50.DarkTrails.DoorHideout, storageValue = 1 },
{ storageName = "DarkTrails.RewardSmallNotebook", storage = Storage.Quest.U10_50.DarkTrails.RewardSmallNotebook, storageValue = 1 },
{ storageName = "DarkTrails.Reward05GlothAndBelongings", storage = Storage.Quest.U10_50.DarkTrails.Reward05GlothAndBelongings, storageValue = 1 },
{ storageName = "DarkTrails.Reward10GlothAndBelongings", storage = Storage.Quest.U10_50.DarkTrails.Reward10GlothAndBelongings, storageValue = 1 },
{ storageName = "DarkTrails.OramondTaskProbing", storage = Storage.Quest.U10_50.DarkTrails.OramondTaskProbing, storageValue = 1 },
	
	
	-- Rathleton Quest
{ storageName = "Rathleton.Rank", storage = Storage.Quest.U10_50.Rathleton.Rank, storageValue = 4 }, -- Alterado
{ storageName = "Rathleton.VotingPoints", storage = Storage.Quest.U10_50.Rathleton.VotingPoints, storageValue = 500 }, -- Alterado
{ storageName = "Rathleton.ShortcutVotes", storage = Storage.Quest.U10_50.Rathleton.ShortcutVotes, storageValue = 50 },
{ storageName = "Rathleton.ShortcutMinotaurs", storage = Storage.Quest.U10_50.Rathleton.ShortcutMinotaurs, storageValue = 1 },
{ storageName = "Rathleton.ShortcutFungi", storage = Storage.Quest.U10_50.Rathleton.ShortcutFungi, storageValue = 1 },
{ storageName = "Rathleton.ShortcutCatacombs", storage = Storage.Quest.U10_50.Rathleton.ShortcutCatacombs, storageValue = 1 },
{ storageName = "Rathleton.ShortcutUnlocked", storage = Storage.Quest.U10_50.Rathleton.ShortcutUnlocked, storageValue = 3 }, -- Catacumbas (mais popular)
{ storageName = "Rathleton.DungeonVotes", storage = Storage.Quest.U10_50.Rathleton.DungeonVotes, storageValue = 50 },
{ storageName = "Rathleton.DungeonGolems", storage = Storage.Quest.U10_50.Rathleton.DungeonGolems, storageValue = 1 },
{ storageName = "Rathleton.DungeonMinotaurs", storage = Storage.Quest.U10_50.Rathleton.DungeonMinotaurs, storageValue = 1 },
{ storageName = "Rathleton.DungeonWrath", storage = Storage.Quest.U10_50.Rathleton.DungeonWrath, storageValue = 1 },
{ storageName = "Rathleton.DungeonUnlocked", storage = Storage.Quest.U10_50.Rathleton.DungeonUnlocked, storageValue = 3 }, -- Wrath of Evil (mais popular)
{ storageName = "Rathleton.BossVotes", storage = Storage.Quest.U10_50.Rathleton.BossVotes, storageValue = 50 },
{ storageName = "Rathleton.BossBullwark", storage = Storage.Quest.U10_50.Rathleton.BossBullwark, storageValue = 1 },
{ storageName = "Rathleton.BossLisa", storage = Storage.Quest.U10_50.Rathleton.BossLisa, storageValue = 1 },
{ storageName = "Rathleton.BossGloothFairy", storage = Storage.Quest.U10_50.Rathleton.BossGloothFairy, storageValue = 1 },
{ storageName = "Rathleton.BossUnlocked", storage = Storage.Quest.U10_50.Rathleton.BossUnlocked, storageValue = 3 }, -- Glooth Fairy (mais popular)
{ storageName = "Rathleton.RaidVotes", storage = Storage.Quest.U10_50.Rathleton.RaidVotes, storageValue = 50 },
{ storageName = "Rathleton.RaidMinotaurs", storage = Storage.Quest.U10_50.Rathleton.RaidMinotaurs, storageValue = 1 },
{ storageName = "Rathleton.RaidMechanical", storage = Storage.Quest.U10_50.Rathleton.RaidMechanical, storageValue = 1 },
{ storageName = "Rathleton.RaidWildLife", storage = Storage.Quest.U10_50.Rathleton.RaidWildLife, storageValue = 1 },
{ storageName = "Rathleton.RaidUnlocked", storage = Storage.Quest.U10_50.Rathleton.RaidUnlocked, storageValue = 2 }, -- Mechanical (mais popular)
{ storageName = "Rathleton.AccessSlimeSlide", storage = Storage.Quest.U10_50.Rathleton.AccessSlimeSlide, storageValue = 1 },
{ storageName = "Rathleton.AccessUndergroundGloothFactory", storage = Storage.Quest.U10_50.Rathleton.AccessUndergroundGloothFactory, storageValue = 1 },
{ storageName = "Rathleton.AccessEdronTravel", storage = Storage.Quest.U10_50.Rathleton.AccessEdronTravel, storageValue = 1 },
{ storageName = "Rathleton.AccessVenoreTravel", storage = Storage.Quest.U10_50.Rathleton.AccessVenoreTravel, storageValue = 1 },
{ storageName = "Rathleton.AccessPortHopeTravel", storage = Storage.Quest.U10_50.Rathleton.AccessPortHopeTravel, storageValue = 1 },
{ storageName = "Rathleton.AccessKrailosTravel", storage = Storage.Quest.U10_50.Rathleton.AccessKrailosTravel, storageValue = 1 },
{ storageName = "Rathleton.AccessIssaviTravel", storage = Storage.Quest.U10_50.Rathleton.AccessIssaviTravel, storageValue = 1 },
{ storageName = "Rathleton.AccessTravoraTravel", storage = Storage.Quest.U10_50.Rathleton.AccessTravoraTravel, storageValue = 1 },
{ storageName = "Rathleton.AchievementCommoner", storage = Storage.Quest.U10_50.Rathleton.AchievementCommoner, storageValue = 1 },
{ storageName = "Rathleton.AchievementInhabitant", storage = Storage.Quest.U10_50.Rathleton.AchievementInhabitant, storageValue = 1 },
{ storageName = "Rathleton.AchievementCitizen", storage = Storage.Quest.U10_50.Rathleton.AchievementCitizen, storageValue = 1 },
{ storageName = "Rathleton.AchievementSquire", storage = Storage.Quest.U10_50.Rathleton.AchievementSquire, storageValue = 1 },
{ storageName = "Rathleton.OutfitVotingRecord", storage = Storage.Quest.U10_50.Rathleton.OutfitVotingRecord, storageValue = 511 }, -- Todos os votos registrados
{ storageName = "Rathleton.OutfitAddons", storage = Storage.Quest.U10_50.Rathleton.OutfitAddons, storageValue = 3 }, -- Ambos addons



-- Oramond Quest
{ storageName = "OramondQuest.QuestLine", storage = Storage.Quest.U10_50.OramondQuest.QuestLine, storageValue = 4 }, -- Rank Squire (máximo)
{ storageName = "OramondQuest.VotingPoints", storage = Storage.Quest.U10_50.OramondQuest.VotingPoints, storageValue = 500 }, -- Pontos de votação suficientes

-- To Take Roots
{ storageName = "OramondQuest.ToTakeRoots.Mission", storage = Storage.Quest.U10_50.OramondQuest.ToTakeRoots.Mission, storageValue = 1 },
{ storageName = "OramondQuest.ToTakeRoots.Count", storage = Storage.Quest.U10_50.OramondQuest.ToTakeRoots.Count, storageValue = 5 },
{ storageName = "OramondQuest.ToTakeRoots.Door", storage = Storage.Quest.U10_50.OramondQuest.ToTakeRoots.Door, storageValue = 1 },

-- Probing
{ storageName = "OramondQuest.Probing.Mission", storage = Storage.Quest.U10_50.OramondQuest.Probing.Mission, storageValue = 1 },
{ storageName = "OramondQuest.Probing.MonoDetector", storage = Storage.Quest.U10_50.OramondQuest.Probing.MonoDetector, storageValue = 1 },

-- The Ancient Sewers
{ storageName = "OramondQuest.TheAncientSewers.Mission", storage = Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, storageValue = 1 },
{ storageName = "OramondQuest.TheAncientSewers.Door", storage = Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Door, storageValue = 1 },

-- The Powder of the Stars
{ storageName = "OramondQuest.ThePowderOfTheStars.Mission", storage = Storage.Quest.U10_50.OramondQuest.ThePowderOfTheStars.Mission, storageValue = 1 },

-- Glooth Bandits
{ storageName = "OramondQuest.GloothBandits.Mission", storage = Storage.Quest.U10_50.OramondQuest.GloothBandits.Mission, storageValue = 1 },
{ storageName = "OramondQuest.GloothBandits.CapsuleCount", storage = Storage.Quest.U10_50.OramondQuest.GloothBandits.CapsuleCount, storageValue = 10 },

-- Four Demanding Statues
{ storageName = "OramondQuest.FourDemandingStatues.Mission", storage = Storage.Quest.U10_50.OramondQuest.FourDemandingStatues.Mission, storageValue = 1 },
{ storageName = "OramondQuest.FourDemandingStatues.Statue1", storage = Storage.Quest.U10_50.OramondQuest.FourDemandingStatues.Statue1, storageValue = 1 },
{ storageName = "OramondQuest.FourDemandingStatues.Statue2", storage = Storage.Quest.U10_50.OramondQuest.FourDemandingStatues.Statue2, storageValue = 1 },
{ storageName = "OramondQuest.FourDemandingStatues.Statue3", storage = Storage.Quest.U10_50.OramondQuest.FourDemandingStatues.Statue3, storageValue = 1 },
{ storageName = "OramondQuest.FourDemandingStatues.Statue4", storage = Storage.Quest.U10_50.OramondQuest.FourDemandingStatues.Statue4, storageValue = 1 },

-- Mutated Glooth Plague
{ storageName = "OramondQuest.MutatedGloothPlague.Mission", storage = Storage.Quest.U10_50.OramondQuest.MutatedGloothPlague.Mission, storageValue = 1 },
{ storageName = "OramondQuest.MutatedGloothPlague.SampleCount", storage = Storage.Quest.U10_50.OramondQuest.MutatedGloothPlague.SampleCount, storageValue = 10 },
{ storageName = "OramondQuest.MutatedGloothPlague.GloothConverter", storage = Storage.Quest.U10_50.OramondQuest.MutatedGloothPlague.GloothConverter, storageValue = 1 },

-- Gloud Ship
{ storageName = "OramondQuest.GloudShip.Mission", storage = Storage.Quest.U10_50.OramondQuest.GloudShip.Mission, storageValue = 1 },
{ storageName = "OramondQuest.GloudShip.StrongCloth", storage = Storage.Quest.U10_50.OramondQuest.GloudShip.StrongCloth, storageValue = 1 },
{ storageName = "OramondQuest.GloudShip.AirtightGloo", storage = Storage.Quest.U10_50.OramondQuest.GloudShip.AirtightGloo, storageValue = 1 },
{ storageName = "OramondQuest.GloudShip.FilledGasBag", storage = Storage.Quest.U10_50.OramondQuest.GloudShip.FilledGasBag, storageValue = 1 },

-- Communication Breakdown
{ storageName = "OramondQuest.CommunicationBreakdown.Mission", storage = Storage.Quest.U10_50.OramondQuest.CommunicationBreakdown.Mission, storageValue = 1 },
{ storageName = "OramondQuest.CommunicationBreakdown.DeviceCount", storage = Storage.Quest.U10_50.OramondQuest.CommunicationBreakdown.DeviceCount, storageValue = 5 },

-- Tending Gloothworms
{ storageName = "OramondQuest.TendingGloothworms.Mission", storage = Storage.Quest.U10_50.OramondQuest.TendingGloothworms.Mission, storageValue = 1 },
{ storageName = "OramondQuest.TendingGloothworms.CalibrationStatus", storage = Storage.Quest.U10_50.OramondQuest.TendingGloothworms.CalibrationStatus, storageValue = 1 },
{ storageName = "OramondQuest.TendingGloothworms.FillingStatus", storage = Storage.Quest.U10_50.OramondQuest.TendingGloothworms.FillingStatus, storageValue = 1 },
{ storageName = "OramondQuest.TendingGloothworms.FeedingStatus", storage = Storage.Quest.U10_50.OramondQuest.TendingGloothworms.FeedingStatus, storageValue = 1 },
{ storageName = "OramondQuest.TendingGloothworms.RakingStatus", storage = Storage.Quest.U10_50.OramondQuest.TendingGloothworms.RakingStatus, storageValue = 1 },

-- Nature's Balance
{ storageName = "OramondQuest.NaturesBalance.Mission", storage = Storage.Quest.U10_50.OramondQuest.NaturesBalance.Mission, storageValue = 1 },
{ storageName = "OramondQuest.NaturesBalance.KillCount", storage = Storage.Quest.U10_50.OramondQuest.NaturesBalance.KillCount, storageValue = 50 },

-- Glooth Capsules
{ storageName = "OramondQuest.GloothCapsules.Mission", storage = Storage.Quest.U10_50.OramondQuest.GloothCapsules.Mission, storageValue = 1 },
{ storageName = "OramondQuest.GloothCapsules.DeliveryCount", storage = Storage.Quest.U10_50.OramondQuest.GloothCapsules.DeliveryCount, storageValue = 10 },


-- Blood Brothers Quest - Todas as missões (1-10)
{ storageName = "BloodBrothers.QuestLine", storage = Storage.Quest.U8_4.BloodBrothers.QuestLine, storageValue = 1 },

-- Missões originais (1-4)
{ storageName = "BloodBrothers.Mission01", storage = Storage.Quest.U8_4.BloodBrothers.Mission01, storageValue = 4 },
{ storageName = "BloodBrothers.Mission02", storage = Storage.Quest.U8_4.BloodBrothers.Mission02, storageValue = 2 },
{ storageName = "BloodBrothers.Cookies.Serafin", storage = Storage.Quest.U8_4.BloodBrothers.Cookies.Serafin, storageValue = 1 },
{ storageName = "BloodBrothers.Cookies.Lisander", storage = Storage.Quest.U8_4.BloodBrothers.Cookies.Lisander, storageValue = 1 },
{ storageName = "BloodBrothers.Cookies.Ortheus", storage = Storage.Quest.U8_4.BloodBrothers.Cookies.Ortheus, storageValue = 1 },
{ storageName = "BloodBrothers.Cookies.Maris", storage = Storage.Quest.U8_4.BloodBrothers.Cookies.Maris, storageValue = 1 },
{ storageName = "BloodBrothers.Cookies.Armenius", storage = Storage.Quest.U8_4.BloodBrothers.Cookies.Armenius, storageValue = 1 },
{ storageName = "BloodBrothers.Mission03", storage = Storage.Quest.U8_4.BloodBrothers.Mission03, storageValue = 3 },
{ storageName = "BloodBrothers.Mission04", storage = Storage.Quest.U8_4.BloodBrothers.Mission04, storageValue = 1 },
{ storageName = "BloodBrothers.VengothAccess", storage = Storage.Quest.U8_4.BloodBrothers.VengothAccess, storageValue = 1 },

-- Missões complementares (5-10)
{ storageName = "BloodBrothers.Mission05", storage = Storage.Quest.U8_4.BloodBrothers.Mission05, storageValue = 4 },
{ storageName = "BloodBrothers.Mission06", storage = Storage.Quest.U8_4.BloodBrothers.Mission06, storageValue = 3 },
{ storageName = "BloodBrothers.Mission07", storage = Storage.Quest.U8_4.BloodBrothers.Mission07, storageValue = 4 },
{ storageName = "BloodBrothers.Mission08", storage = Storage.Quest.U8_4.BloodBrothers.Mission08, storageValue = 3 },
{ storageName = "BloodBrothers.Mission09", storage = Storage.Quest.U8_4.BloodBrothers.Mission09, storageValue = 3 },
{ storageName = "BloodBrothers.Mission10", storage = Storage.Quest.U8_4.BloodBrothers.Mission10, storageValue = 3 },

-- Storages adicionais para itens e mecanismos
{ storageName = "BloodBrothers.BloodCrystal", storage = Storage.Quest.U8_4.BloodBrothers.BloodCrystal, storageValue = 1 },
{ storageName = "BloodBrothers.ChargedCrystal", storage = Storage.Quest.U8_4.BloodBrothers.ChargedCrystal, storageValue = 1 },
{ storageName = "BloodBrothers.CastleAccess", storage = Storage.Quest.U8_4.BloodBrothers.CastleAccess, storageValue = 1 },
{ storageName = "BloodBrothers.StrangeCarvings", storage = Storage.Quest.U8_4.BloodBrothers.StrangeCarvings, storageValue = 1 },
{ storageName = "BloodBrothers.Mission02Eggs", storage = Storage.Quest.U8_4.BloodBrothers.Mission02Eggs, storageValue = 10 },

-- Recompensas
{ storageName = "BloodBrothers.VampiricCrest", storage = Storage.Quest.U8_4.BloodBrothers.VampiricCrest, storageValue = 1 },
{ storageName = "BloodBrothers.YalaharianOutfit", storage = Storage.Quest.U8_4.BloodBrothers.YalaharianOutfit, storageValue = 1 },
{ storageName = "BloodBrothers.BloodGoblet", storage = Storage.Quest.U8_4.BloodBrothers.BloodGoblet, storageValue = 1 },



-- Configuração completa para liberar a Grave Danger Quest no freequests.lua

-- Quest principal
{ storageName = "GraveDanger.QuestLine", storage = Storage.Quest.U12_20.GraveDanger.Questline, storageValue = 14 },

-- Missões individuais dos túmulos
{ storageName = "GraveDanger.Graves.Edron", storage = Storage.Quest.U12_20.GraveDanger.Graves.Edron, storageValue = 2 },
{ storageName = "GraveDanger.Graves.DarkCathedral", storage = Storage.Quest.U12_20.GraveDanger.Graves.DarkCathedral, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Ghostlands", storage = Storage.Quest.U12_20.GraveDanger.Graves.Ghostlands, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Cormaya", storage = Storage.Quest.U12_20.GraveDanger.Graves.Cormaya, storageValue = 2 },
{ storageName = "GraveDanger.Graves.FemorHills", storage = Storage.Quest.U12_20.GraveDanger.Graves.FemorHills, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Ankrahmun", storage = Storage.Quest.U12_20.GraveDanger.Graves.Ankrahmun, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Kilmaresh", storage = Storage.Quest.U12_20.GraveDanger.Graves.Kilmaresh, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Vengoth", storage = Storage.Quest.U12_20.GraveDanger.Graves.Vengoth, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Darashia", storage = Storage.Quest.U12_20.GraveDanger.Graves.Darashia, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Thais", storage = Storage.Quest.U12_20.GraveDanger.Graves.Thais, storageValue = 2 },
{ storageName = "GraveDanger.Graves.Orclands", storage = Storage.Quest.U12_20.GraveDanger.Graves.Orclands, storageValue = 2 },
{ storageName = "GraveDanger.Graves.IceIslands", storage = Storage.Quest.U12_20.GraveDanger.Graves.IceIslands, storageValue = 2 },

-- Missão final - The Order of the Cobra
{ storageName = "GraveDanger.Cobra", storage = Storage.Quest.U12_20.GraveDanger.Cobra, storageValue = 2 },

-- Acesso às salas de boss (se houver)
{ storageName = "GraveDanger.Bosses.KingZelosRoom", storage = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Room, storageValue = 1 },
	
	
	
	
	
	-- Configuração para liberar a The Secret Library Quest como free quest
-- Baseado na análise dos storages e estrutura da quest

-- Adicionando as entradas para The Secret Library Quest
-- Asuras
{ storageName = "TheSecretLibrary.Asuras.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.FlammingOrchid", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.FlammingOrchid, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.SkeletonNotes", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.SkeletonNotes, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.StrandHair", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.StrandHair, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.LotusKey", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.LotusKey, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.EyeKey", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.EyeKey, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.ScribbledNotes", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.ScribbledNotes, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.EbonyPiece", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.EbonyPiece, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.PeacockBallad", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.PeacockBallad, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.BlackSkull", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.BlackSkull, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.SilverChimes", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.SilverChimes, storageValue = 1 },
{ storageName = "TheSecretLibrary.Asuras.Fragrance", storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.Fragrance, storageValue = 1 },

-- Falcon Bastion
{ storageName = "TheSecretLibrary.FalconBastion.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline, storageValue = 2 },
{ storageName = "TheSecretLibrary.FalconBastion.KillingBosses", storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, storageValue = 6 },
{ storageName = "TheSecretLibrary.FalconBastion.FalconBastionAccess", storage = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.FalconBastionAccess, storageValue = 1 },

-- Darashia (Desert)
{ storageName = "TheSecretLibrary.Darashia.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, storageValue = 7 },
{ storageName = "TheSecretLibrary.Darashia.FirstTotem", storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FirstTotem, storageValue = 1 },
{ storageName = "TheSecretLibrary.Darashia.SecondTotem", storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.SecondTotem, storageValue = 1 },
{ storageName = "TheSecretLibrary.Darashia.ThirdTotem", storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.ThirdTotem, storageValue = 1 },
{ storageName = "TheSecretLibrary.Darashia.FourthTotem", storage = Storage.Quest.U11_80.TheSecretLibrary.Darashia.FourthTotem, storageValue = 1 },

-- Liquid Death
{ storageName = "TheSecretLibrary.LiquidDeath.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, storageValue = 7 },
{ storageName = "TheSecretLibrary.LiquidDeath.StatueCount", storage = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.StatueCount, storageValue = 9 },

-- -- Museum of Tibian Arts (MoTA)
-- { storageName = "TheSecretLibrary.MoTA.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, storageValue = 1 },
-- { storageName = "TheSecretLibrary.MoTA.FinalBasin", storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.FinalBasin, storageValue = 1 },

-- Small Islands
{ storageName = "TheSecretLibrary.SmallIslands.Questline", storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Questline, storageValue = 1 },
{ storageName = "TheSecretLibrary.SmallIslands.Parchment", storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Parchment, storageValue = 1 },
{ storageName = "TheSecretLibrary.SmallIslands.BoatStages", storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.BoatStages, storageValue = 3 },

-- Quest Log principal
{ storageName = "TheSecretLibrary.Questlog", storage = Storage.Quest.U11_80.TheSecretLibrary.Questlog, storageValue = 1 },
{ storageName = "TheSecretLibrary.LibraryPermission", storage = Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, storageValue = 7 },

	
	
}

-- from Position: (33201, 31762, 1)
-- to Position: (33356, 31309, 4)
local function playerFreeQuestStart(playerId, index)
	local player = Player(playerId)
	if not player then
		return
	end

	for i = 1, 5 do
		index = index + 1
		if not questTable[index] then
			player:sendTextMessage(MESSAGE_LOOK, "Adding free quests completed.")
			player:setStorageValue(Storage.FreeQuests, stage)
			return
		end

		local questData = questTable[index]
		local currentStorageValue = player:getStorageValue(questData.storage)

		if not questData.storage then
			logger.warn("[Freequest System]: error storage for '" .. questData.storageName .. "' is nil for the index")
		elseif currentStorageValue ~= questData.storageValue then
			player:setStorageValue(questData.storage, questData.storageValue)
		elseif currentStorageValue == -1 then
			logger.warn("[Freequest System]: warning Storage '" .. questData.storageName .. "' currently nil for player ID " .. playerId)
		end
	end

	addEvent(playerFreeQuestStart, 500, playerId, index)
end

local freeQuests = CreatureEvent("FreeQuests")

function freeQuests.onLogin(player)
	if not configManager.getBoolean(configKeys.TOGGLE_FREE_QUEST) or player:getStorageValue(Storage.FreeQuests) == stage then
		return true
	end

	player:sendTextMessage(MESSAGE_LOOK, "Adding free acccess quests to your character.")
	addEvent(playerFreeQuestStart, 500, player:getId(), 0)
	-- player:addOutfit(251, 0)
	-- player:addOutfit(252, 0)
	-- player:addOutfit(324, 0)
	-- player:addOutfit(325, 0)

	return true
end

freeQuests:register()
