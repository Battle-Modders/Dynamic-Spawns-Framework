local parties = [
	{
		ID = "Noble",
		HardMin = 5,
		DefaultFigure = "figure_noble_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Noble.Frontline",   RatioMin = 0.35, RatioMax = 1.00, DeterminesFigure = true },
			{ BaseID = "Noble.Backline",    RatioMin = 0.01, RatioMax = 0.35 },
			{ BaseID = "Noble.Ranged",      RatioMin = 0.01, RatioMax = 0.28 },
			{ BaseID = "Noble.Flank",       RatioMin = 0.00, RatioMax = 0.12 },
			{ BaseID = "Noble.Support",     RatioMin = 0.01, RatioMax = 0.07, DeterminesFigure = true, ReqPartySize = 10 },    // Vanilla: Bannerman start spawning at 14
			{ BaseID = "Noble.Officer",     RatioMin = 0.00, RatioMax = 0.08, DeterminesFigure = true, ReqPartySize = 8 },    // Vanilla: First sergeant spawns at 9, next one 12 and then 15+; Second one spawns at 27+
			{ BaseID = "Noble.Elite",       RatioMin = 0.00, RatioMax = 0.30, DeterminesFigure = true }
		]
	},
	{
		ID = "NobleCaravan",
		HardMin = 7,
		DefaultFigure = "cart_01",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticUnitDefs = [
			{ BaseID = "Human.CaravanDonkey" }      // Makes it much easier to get a good ratio
		],
		UnitBlockDefs = [
			{ BaseID = "Noble.Frontline",   RatioMin = 0.35, RatioMax = 1.00},
			{ BaseID = "Noble.Backline",    RatioMin = 0.08, RatioMax = 0.35},
			{ BaseID = "Noble.Ranged",      RatioMin = 0.08, RatioMax = 0.28},
			{ BaseID = "Noble.Officer",     RatioMin = 0.00, RatioMax = 0.08, ReqPartySize = 10 },  // Vanilla: spawns at 12, at 15 and at 18 once respectively
			{ BaseID = "Noble.Elite",       RatioMin = 0.00, RatioMax = 0.40 },
			{ BaseID = "Noble.Donkeys",     RatioMin = 0.01, RatioMax = 0.08, ReqPartySize = 13 }   // Vanilla: second donkey spawns at 14+
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
