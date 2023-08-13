
local parties = [
	{
		ID = "Barbarians",
		HardMin = 6,
		DefaultFigure = "figure_wildman_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Barbarian.Frontline", 	RatioMin = 0.60, RatioMax = 1.00, DeterminesFigure = true },	// Vanilla: doesn't care about size
			{ ID = "Barbarian.Support", 	RatioMin = 0.00, RatioMax = 0.07, ReqPartySize = 10, StartingResourceMin = 200 },			// Vanilla: Start spawning in armies of 15+; At 24+ a second drummer spawns
			{ ID = "Barbarian.Dogs", 		RatioMin = 0.00, RatioMax = 0.15, ReqPartySize = 5 },		// Vanilla: Start spawning in armies of 6+
			{ ID = "Barbarian.Beastmaster", RatioMin = 0.00, RatioMax = 0.10, ReqPartySize = 5, StartingResourceMin = 195 }		// Vanilla: Start spawning in armies of 7+ (singular case) but more like 9+
		]
	},
	{
		ID = "BarbarianHunters",
		HardMin = 5,
		DefaultFigure = "figure_wildman_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Barbarian.HunterFrontline", RatioMin = 0.60, RatioMax = 1.0, DeterminesFigure = true },
			{ ID = "Barbarian.Dogs", 			RatioMin = 0.20, RatioMax = 0.45 }
		]
	},
	{
		ID = "BarbarianKing",
		DefaultFigure = "figure_wildman_06",
		StaticUnitIDs = [
			"Barbarian.King"
		]
	},

	// SubParties
	{
		ID = "OneUnhold",
		HardMin = 1,
		HardMax = 1,
		UnitBlockDefs = [
			{ ID = "Barbarian.Unholds"}
		]
	},
	{
		ID = "TwoUnhold",
		HardMin = 2,
		HardMax = 2,
		UnitBlockDefs = [
			{ ID = "Barbarian.Unholds"}
		]
	},
	{
		ID = "OneFrostUnhold",
		HardMin = 1,
		HardMax = 1,
		UnitBlockDefs = [
			{ ID = "Barbarian.UnholdsFrost"}
		]
	},
	{
		ID = "TwoFrostUnhold",
		HardMin = 2,
		HardMax = 2,
		UnitBlockDefs = [
			{ ID = "Barbarian.UnholdsFrost"}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}

