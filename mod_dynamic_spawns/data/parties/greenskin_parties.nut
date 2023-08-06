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
			{ ID = "Goblin.Boss", 			RatioMin = 0.00, RatioMax = 0.13, MinStartingResource = 350, DeterminesFigure = true},

			{ ID = "Orc.Young", 			RatioMin = 0.00, RatioMax = 0.80, DeterminesFigure = true},
			{ ID = "Orc.Warrior", 			RatioMin = 0.00, RatioMax = 0.50, DeterminesFigure = true},
			{ ID = "Orc.Berserker", 		RatioMin = 0.00, RatioMax = 0.33, DeterminesFigure = true},
			{ ID = "Orc.Boss", 				RatioMin = 0.00, RatioMax = 0.07, MinStartingResource = 350, DeterminesFigure = true}
		]
	}
]

foreach(party in parties)
{
	local partyObj = ::new(::DynamicSpawns.Class.Party).init(party);
	::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

	::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}
