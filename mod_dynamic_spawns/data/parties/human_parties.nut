local parties = [
	{
		ID = "Cultist",
		HardMin = 4,
		DefaultFigure = "figure_civilian_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Human.CultistAmbush", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Peasants",
		HardMin = 3,
		DefaultFigure = "figure_civilian_01",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		UnitBlockDefs = [
			{ ID = "Human.Peasants", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "PeasantsArmed",
		HardMin = 3,
		DefaultFigure = "figure_civilian_01",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		UnitBlockDefs = [
			{ ID = "Human.PeasantsArmed", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "PeasantsSouthern",
		HardMin = 3,
		DefaultFigure = "figure_civilian_06",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
		UnitBlockDefs = [
			{ ID = "Human.SouthernPeasants", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "BountyHunters",
		HardMin = 5,
		DefaultFigure = "figure_bandit_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Human.BountyHunter", RatioMin = 0.60, RatioMax = 1.00},
			{ ID = "Human.BountyHunterRanged", RatioMin = 0.15, RatioMax = 0.30},
			{ ID = "Human.Wardogs", RatioMin = 0.05, RatioMax = 0.15}
		]
	},
	{
		ID = "Mercenaries",
		HardMin = 5,
		DefaultFigure = "figure_bandit_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Mercenary.Frontline", RatioMin = 0.60, RatioMax = 1.00},
			{ ID = "Mercenary.Ranged", RatioMin = 0.12, RatioMax = 0.30},
			{ ID = "Mercenary.Elite", RatioMin = 0.10, RatioMax = 0.25, ReqPartySize = 10 },    // Start spawning at 11+. Only exception is HedgeKnight which appears a in a group of 6 aswell
			{ ID = "Human.Wardogs", RatioMin = 0.00, RatioMax = 0.12}
		]
	},
	{
		ID = "Militia",
		HardMin = 6,
		DefaultFigure = "figure_militia_01",	// In vanilla this is either ["figure_militia_01", "figure_militia_02"]
		MovementSpeedMult = 0.9,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Human.MilitiaFrontline",    RatioMin = 0.60, RatioMax = 1.00},
			{ ID = "Human.MilitiaRanged",       RatioMin = 0.12, RatioMax = 0.35},
			{ ID = "Human.MilitiaCaptain",      RatioMin = 0.09, RatioMax = 0.09, ReqPartySize = 12 }   // Vanilla: starts spawning in groups of 13+; Vanilla never spawns more than one
		]
	},
	{
		ID = "Caravan",
		HardMin = 4,
		DefaultFigure = "cart_02",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticUnitDefs = [
			{ ID = "Human.CaravanDonkey" }
		],
		UnitBlockDefs = [
			{ ID = "Human.CaravanDonkeys",  RatioMin = 0.17, RatioMax = 0.20, ReqPartySize = 6 },      // Vanilla: Second Donkey starts spawning at 7+
			{ ID = "Human.CaravanHands",    RatioMin = 0.35, RatioMax = 0.80},
			{ ID = "Human.CaravanGuards",   RatioMin = 0.15, RatioMax = 0.55}
		]
	},
	{
		ID = "CaravanEscort",   // Caravans spawned for player escort contract
		HardMin = 4,
		DefaultFigure = "cart_02",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
		StaticUnitDefs = [
			{ ID = "Human.CaravanDonkey" },      // In vanilla an escorted caravan can also have only a single Donkey. I chose to force 2 donkey every time instead
			{ ID = "Human.CaravanDonkey" }
		],
		UnitBlockDefs = [
			{ ID = "Human.CaravanDonkeys",  RatioMin = 0.15, RatioMax = 0.35, ReqPartySize = 5 },   // Vanilla: Third donkey spawns at 6+
			{ ID = "Human.CaravanHands",    RatioMin = 0.50, RatioMax = 1.00}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
