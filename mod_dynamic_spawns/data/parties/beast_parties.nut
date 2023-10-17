local parties = [
	{
		ID = "Direwolves",
		HardMin = 3,
		DefaultFigure = "figure_werewolf_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Ghouls",
		HardMin = 5,
		DefaultFigure = "figure_ghoul_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Lindwurm",
		HardMin = 1,
		DefaultFigure = "figure_lindwurm_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Lindwurms", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Unhold",
		HardMin = 1,
		DefaultFigure = "figure_unhold_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "UnholdFrost",
		HardMin = 1,
		DefaultFigure = "figure_unhold_02",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.UnholdsFrost", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "UnholdBog",
		HardMin = 1,
		DefaultFigure = "figure_unhold_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Spiders",
		HardMin = 1,
		DefaultFigure = "figure_spider_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Spiders", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Alps",
		HardMin = 3,
		DefaultFigure = "figure_alp_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Alps", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Schrats",
		HardMin = 1,
		DefaultFigure = "figure_schrat_01",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "HexenAndMore",
		HardMin = 1,
		DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		StaticUnitDefs = [
			{ BaseID = "Beast.Hexe" }    // This one has no Bodyguards, which is not perfect because sometimes the only Hexe spawns with bodyguards in vanilla
		],
		UnitBlockDefs = [
			{ BaseID = "Beast.HexenWithBodyguards", RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 300 },
			{ BaseID = "Beast.Spiders", RatioMin = 0.00, RatioMax = 1.00 },
			{ BaseID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00 },
			{ BaseID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 300 },
			{ BaseID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 },
			{ BaseID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 250 },
			{ BaseID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00 },
			{ BaseID = "Beast.HexenBandits", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 },
			{ BaseID = "Beast.HexenBanditsRanged", RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 200 }
		]
	},
	{
		ID = "HexenAndNoSpiders",
		HardMin = 1,
		DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		StaticUnitDefs = [
			{ BaseID = "Beast.Hexe" }    // This one has no Bodyguards, which is not perfect because sometimes the only Hexe spawns with bodyguards in vanilla
		],
		UnitBlockDefs = [
			{ BaseID = "Beast.HexenNoSpiders", RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 300 },
			{ BaseID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 80 },
			{ BaseID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 300 },
			{ BaseID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 },
			{ BaseID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 250 },
			{ BaseID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00 },
			{ BaseID = "Beast.HexenBandits", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 }
		]
	},
	{
		ID = "Hexen",
		HardMin = 1,
		DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.HexenNoBodyguards", RatioMin = 0.00, RatioMax = 1.00}
		]
	},

	// Skipped Kraken
	{
		ID = "Hyenas",
		HardMin = 3,
		DefaultFigure = "figure_hyena_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Hyenas", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "Serpents",
		HardMin = 3,
		DefaultFigure = "figure_serpent_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.Serpents", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "SandGolems",
		HardMin = 3,
		DefaultFigure = "figure_golem_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ BaseID = "Beast.SandGolems", RatioMin = 0.00, RatioMax = 1.00}
		]
	}

	// SubParties
	{
		ID = "SpiderBodyguards",
		UnitBlockDefs = [
			{ BaseID = "Beast.SpiderBodyguards"}
		]
	},
	{
		ID = "DirewolfBodyguards",
		UnitBlockDefs = [
			{ BaseID = "Beast.DirewolfBodyguards"}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
