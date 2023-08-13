local parties = [
	{
		ID = "OrcRoamers",
		HardMin = 4,
		DefaultFigure = "figure_orc_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 	RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Orc.Warrior", 	RatioMin = 0.00, RatioMax = 0.09}
		]
	},
	{	// This is currently the same as OrcRoamers. I couldn't spot differences in Vanilla
		ID = "OrcScouts",
		HardMin = 4,
		DefaultFigure = "figure_orc_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 	RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Orc.Warrior", 	RatioMin = 0.00, RatioMax = 0.09}
		]
	},
	{
		ID = "OrcRaiders",
		HardMin = 5,
		DefaultFigure = "figure_orc_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 	RatioMin = 0.15, RatioMax = 1.00, DeterminesFigure = true, StartingResourceMax = 250},
			{ ID = "Orc.Young", 	RatioMin = 0.00, RatioMax = 0.65, DeterminesFigure = true, StartingResourceMin = 250},	// Lategame Parties will have less Young in them
			{ ID = "Orc.Berserker", RatioMin = 0.00, RatioMax = 0.45, DeterminesFigure = true},
			{ ID = "Orc.Warrior", 	RatioMin = 0.00, RatioMax = 0.80, DeterminesFigure = true},
			{ ID = "Orc.Boss", 		RatioMin = 0.00, RatioMax = 0.08, DeterminesFigure = true, StartingResourceMin = 210}		// Vanilla never spawns more than one Boss here
		]
	},
	{
		ID = "OrcDefenders",
		HardMin = 4,
		DefaultFigure = "figure_orc_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 	RatioMin = 0.15, RatioMax = 1.00},
			{ ID = "Orc.Berserker", RatioMin = 0.00, RatioMax = 0.45},
			{ ID = "Orc.Warrior", 	RatioMin = 0.00, RatioMax = 0.80},
			{ ID = "Orc.Boss", 		RatioMin = 0.00, RatioMax = 0.08, StartingResourceMin = 210}		// Vanilla never spawns more than one Boss here
		]
	},
	{
		ID = "OrcBoss",
		HardMin = 8,
		DefaultFigure = "figure_orc_05",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 	RatioMin = 0.15, RatioMax = 0.80},
			{ ID = "Orc.Berserker", RatioMin = 0.00, RatioMax = 0.50},
			{ ID = "Orc.Warrior", 	RatioMin = 0.00, RatioMax = 0.80},
			{ ID = "Orc.Boss", 		RatioMin = 0.01, RatioMax = 0.05}				// Vanilla never spawns more than one Boss here
		]
	},
	{	// In Vanilla these never spawn OrcYoungLOW but here they do
		ID = "YoungOrcsOnly",
		HardMin = 4,		// In Vanilla this is 2 when spawning Berserker only
		DefaultFigure = "figure_orc_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 		DeterminesFigure = true }
		]
	},
	{	// In Vanilla these never spawn OrcYoungLOW but here they do
		ID = "YoungOrcsAndBerserkers",
		HardMin = 3,		// In Vanilla this is 2 when spawning Berserker only
		DefaultFigure = "figure_orc_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Young", 		DeterminesFigure = true },
			{ ID = "Orc.Berserker", 	DeterminesFigure = true }
		]
	},
	{
		ID = "BerserkersOnly",
		HardMin = 2,
		DefaultFigure = "figure_orc_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Orc.Berserker" }
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}

