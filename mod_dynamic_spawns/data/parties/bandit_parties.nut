
local parties = [
	{
		ID = "BanditRoamers",
		HardMin = 5,
		DefaultFigure = "figure_bandit_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Bandit.Frontline", RatioMin = 0.00, RatioMax = 0.50},
			{ ID = "Bandit.Ranged", RatioMin = 0.45, RatioMax = 1.00},
			{ ID = "Bandit.Dogs", RatioMin = 0.00, RatioMax = 0.45}
		]
	},
	{
		ID = "BanditScouts",
		HardMin = 7,
		DefaultFigure = "figure_bandit_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Bandit.Frontline", RatioMin = 0.50, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Bandit.Ranged", RatioMin = 0.00, RatioMax = 0.40},
			{ ID = "Bandit.Dogs", RatioMin = 0.00, RatioMax = 0.20}
		]
	},
	{
		ID = "BanditRaiders",
		HardMin = 5,
		DefaultFigure = "figure_bandit_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Bandit.Frontline", RatioMin = 0.50, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Bandit.Ranged", RatioMin = 0.00, RatioMax = 0.35},
			{ ID = "Bandit.Elite", RatioMin = 0.00, RatioMax = 0.35, StartingResourceMin = 320},
			{ ID = "Bandit.Boss", RatioMin = 0.00, RatioMax = 0.11, StartingResourceMin = 150, DeterminesFigure = true},
		]
	},
	{
		ID = "BanditDefenders",
		HardMin = 5,
		DefaultFigure = "figure_bandit_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Bandit.Frontline", RatioMin = 0.50, RatioMax = 1.00},
			{ ID = "Bandit.Ranged", RatioMin = 0.00, RatioMax = 0.25},
			{ ID = "Bandit.Elite", RatioMin = 0.00, RatioMax = 0.35, StartingResourceMin = 320},
			{ ID = "Bandit.Boss", RatioMin = 0.0, RatioMax = 0.11, StartingResourceMin = 150}
		]
	},
	{
		ID = "BanditBoss",
		HardMin = 9,
		DefaultFigure = "figure_bandit_04",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Bandit.Frontline", RatioMin = 0.50, RatioMax = 1.00},
			{ ID = "Bandit.Ranged", RatioMin = 0.00, RatioMax = 0.25},
			{ ID = "Bandit.Elite", RatioMin = 0.00, RatioMax = 0.35, StartingResourceMin = 320},
			{ ID = "Bandit.Boss", RatioMin = 0.01, RatioMax = 0.11}				// One boss is always guaranteed
		]
	},
	{
		ID = "BanditsDisguisedAsDirewolves",
		HardMin = 3,
		DefaultFigure = "figure_werewolf_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Bandit.DisguisedDirewolf" }
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
