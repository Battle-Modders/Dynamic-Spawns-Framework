local parties = [
	{
		ID = "GreenskinHorde",
		HardMin = 9,
		DefaultFigure = "figure_orc_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Greenskin.GoblinsFoot", RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ ID = "Goblin.Flank", 			RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ ID = "Goblin.Boss", 			RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 350, DeterminesFigure = true},

			{ ID = "Orc.Young", 			RatioMin = 0.00, RatioMax = 0.80, DeterminesFigure = true},
			{ ID = "Orc.Warrior", 			RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ ID = "Orc.Berserker", 		RatioMin = 0.00, RatioMax = 0.33, DeterminesFigure = true},
			{ ID = "Orc.Boss", 				RatioMin = 0.00, RatioMax = 0.07, StartingResourceMin = 350, DeterminesFigure = true}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
