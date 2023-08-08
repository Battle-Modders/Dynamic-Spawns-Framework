local parties = [
	{
		ID = "GoblinRoamers",
		HardMin = 4,
		DefaultFigure = "figure_goblin_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,		// Pure GoblinAmbusher groups have 0.75 here in vanilla
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Goblin.Frontline", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMax = 140, DeterminesFigure = true},
			{ ID = "Goblin.Ranged", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMax = 140, DeterminesFigure = true},
			{ ID = "Goblin.Flank", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 120, DeterminesFigure = true}		// Lategame GoblinRoamer only consist of Riders
		]
	},
	{	// Similar to GoblinRoamer except Scout sizes are capped in vanilla and they more mixed than Roamers. We have no cap in this implementation
		ID = "GoblinScouts",
		HardMin = 4,
		DefaultFigure = "figure_goblin_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,		// Parties that have no Rider have a value of 0.75 here in vanilla
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Goblin.Frontline", 	RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Goblin.Ranged", 	RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Goblin.Flank", 		RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true}
		]
	},
	{
		ID = "GoblinRaiders",
		HardMin = 4,
		DefaultFigure = "figure_goblin_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Goblin.Frontline", RatioMin = 0.35, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Goblin.Ranged", RatioMin = 0.15, RatioMax = 0.50, DeterminesFigure = true},
			{ ID = "Goblin.Flank", RatioMin = 0.00, RatioMax = 0.35, DeterminesFigure = true},
			{ ID = "Goblin.Boss", RatioMin = 0.01, RatioMax = 0.15, StartingResourceMin = 250, DeterminesFigure = true}	// One boss is guaranteed at 250+ resources
	   ]
	},
	{
		ID = "GoblinDefenders",
		HardMin = 4,
		DefaultFigure = "figure_goblin_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Goblin.Frontline", RatioMin = 0.35, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Goblin.Ranged", RatioMin = 0.15, RatioMax = 0.50, DeterminesFigure = true},
			{ ID = "Goblin.Flank", RatioMin = 0.00, RatioMax = 0.35, DeterminesFigure = true},
			{ ID = "Goblin.Boss", RatioMin = 0.01, RatioMax = 0.15, StartingResourceMin = 250, DeterminesFigure = true}	// One boss is guaranteed at 250+ resources
		]
	},
	{
		ID = "GoblinBoss",
		HardMin = 12,
		DefaultFigure = "figure_goblin_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Goblin.Frontline", RatioMin = 0.35, RatioMax = 1.00},
			{ ID = "Goblin.Ranged", RatioMin = 0.15, RatioMax = 0.50},
			{ ID = "Goblin.Flank", RatioMin = 0.00, RatioMax = 0.35},
			{ ID = "Goblin.Boss", RatioMin = 0.01, RatioMax = 0.11, DeterminesFigure = true}	// One boss is always guaranteed
		]
	}
]

foreach(party in parties)
{
	local partyObj = ::new(::DynamicSpawns.Class.Party).init(party);
	::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

	::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}
