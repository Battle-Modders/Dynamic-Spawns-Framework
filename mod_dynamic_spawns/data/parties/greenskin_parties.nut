local parties = [
	{
		ID = "GreenskinHorde",
		HardMin = 9,
		DefaultFigure = "figure_orc_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Greenskin.GoblinsFoot", RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ BaseID = "Goblin.Flank", 			RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ BaseID = "Goblin.Boss", 			RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 350, DeterminesFigure = true},

			{ BaseID = "Orc.Young", 			RatioMin = 0.00, RatioMax = 0.80, DeterminesFigure = true},
			{ BaseID = "Orc.Warrior", 			RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ BaseID = "Orc.Berserker", 		RatioMin = 0.00, RatioMax = 0.33, DeterminesFigure = true},
			{ BaseID = "Orc.Boss", 				RatioMin = 0.00, RatioMax = 0.07, StartingResourceMin = 350, DeterminesFigure = true}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
