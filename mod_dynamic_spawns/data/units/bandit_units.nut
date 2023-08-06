::DynamicSpawns.Data.UnitDefs <- [
	// Bandits
		{
			ID = "Bandit.Thug",
			EntityType = "BanditThug",
			Figure = "figure_bandit_02",
			Cost = 9
		},
		{
			ID = "Bandit.Wardog",
			EntityType = "Wardog",
			Cost = 10
		},
		{
			ID = "Bandit.MarksmanLOW",
			EntityType = "BanditMarksmanLOW",
			Cost = 12
		},
		{
			ID = "Bandit.Marksman",
			EntityType = "BanditMarksman",
			Cost = 15
		},
		{
			ID = "Bandit.RaiderLOW",
			EntityType = "BanditRaiderLOW",
			Figure = "figure_bandit_03",
			Cost = 16
		},
		{
			ID = "Bandit.Raider",
			EntityType = "BanditRaider",
			Figure = "figure_bandit_03",
			Cost = 20
		},
		{
			ID = "Bandit.Leader",
			EntityType = "BanditLeader",
			Figure = "figure_bandit_04",
			Cost = 25
		},
		{
			ID = "Bandit.RaiderWolf",
			EntityType = "BanditRaiderWolf",
			Cost = 25
		}

// Bandits in Vanilla make also use of "Elite" troops but those are already defined in the human_units.nut
	]


	foreach (unit in ::DynamicSpawns.Data.UnitDefs)
	{
		local unitObj = ::new(::DynamicSpawns.Class.Unit).init(unit);
		::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
		// ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
	}
