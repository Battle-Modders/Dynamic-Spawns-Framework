::DynamicSpawns.Data.UnitDefs <- [
		{
			ID = "Goblin.SkirmisherLOW",
			EntityType = "GoblinSkirmisherLOW",
			Figure = "figure_goblin_01",
			Cost = 10
		},
		{
			ID = "Goblin.Skirmisher",
			EntityType = "GoblinSkirmisher",
			Figure = "figure_goblin_01",
			Cost = 15
		},
		{
			ID = "Goblin.AmbusherLOW",
			EntityType = "GoblinAmbusherLOW",
			Figure = "figure_goblin_02",
			Cost = 15
		},
		{
			ID = "Goblin.Ambusher",
			EntityType = "GoblinAmbusher",
			Figure = "figure_goblin_02",
			Cost = 20
		},
		{
			ID = "Goblin.Wolfrider",
			EntityType = "GoblinWolfrider",
			Figure = "figure_goblin_05",
			Cost = 20
		},
		{
			ID = "Goblin.Overseer",
			EntityType = "GoblinOverseer",
			Figure = "figure_goblin_04",
			Cost = 35,
			MinStartingResource = 240		// In vanilla this is 241
		},
		{
			ID = "Goblin.Shaman",
			EntityType = "GoblinShaman",
			Figure = "figure_goblin_03",
			Cost = 35
			MinStartingResource = 280		// In vanilla this is 281
		}
	]


	foreach (unit in ::DynamicSpawns.Data.UnitDefs)
	{
		local unitObj = ::new(::DynamicSpawns.Class.Unit).init(unit);
		::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
		// ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
	}
