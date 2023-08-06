local parties = [
	{
		ID = "UndeadScourge",
		HardMin = 8,
		DefaultFigure = "figure_skeleton_01",
		MovementSpeedMult = 0.9,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Zombie.Frontline", 	RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 		RatioMin = 0.00, RatioMax = 0.13, ReqPartySize = 13},
			{ ID = "Zombie.Ghost", 		RatioMin = 0.00, RatioMax = 0.12, ReqPartySize = 18},
			{ ID = "Beast.Ghouls", 		RatioMin = 0.00, RatioMax = 0.20, ReqPartySize = 20},	// Vanilla does not spawn T3 Ghouls. We allow it here
			{ ID = "Undead.Frontline", 	RatioMin = 0.15, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Undead.Backline", 	RatioMin = 0.09, RatioMax = 0.35, DeterminesFigure = true},
			{ ID = "Scourge.Boss", 		RatioMin = 0.00, RatioMax = 0.12, DeterminesFigure = true, ReqPartySize = 17, MinStartingResource = 350},
			{ ID = "Undead.Vampire", 	RatioMin = 0.00, RatioMax = 0.11, DeterminesFigure = true, ReqPartySize = 18},
		]
	}
]

foreach(party in parties)
{
	local partyObj = ::new(::DynamicSpawns.Class.Party).init(party);
	::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

	::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}
