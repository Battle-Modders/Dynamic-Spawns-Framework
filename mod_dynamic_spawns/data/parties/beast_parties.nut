local parties = [
	{
		ID = "Direwolves",
		HardMin = 3,
		DefaultFigure = "figure_werewolf_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Lindwurms", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.UnholdsFrost", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Spiders", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Alps", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00}
		]
	},
	{
		ID = "HexenAndMore",
		HardMin = 1,
		DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		StaticUnitIDs = [
			"Beast.Hexe"    // This one has no Bodyguards, which is not perfect because sometimes the only Hexe spawns with bodyguards in vanilla
		],
		UnitBlockDefs = [
			{ ID = "Beast.HexenWithBodyguards", RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 300 },
			{ ID = "Beast.Spiders", RatioMin = 0.00, RatioMax = 1.00 },
			{ ID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00 },
			{ ID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 300 },
			{ ID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 },
			{ ID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 250 },
			{ ID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00 },
			{ ID = "Beast.HexenBandits", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 },
			{ ID = "Beast.HexenBanditsRanged", RatioMin = 0.00, RatioMax, StartingResourceMin = 200 = 0.13 }
		]
	},
	{
		ID = "HexenAndNoSpiders",
		HardMin = 1,
		DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		StaticUnitIDs = [
			"Beast.Hexe"    // This one has no Bodyguards, which is not perfect because sometimes the only Hexe spawns with bodyguards in vanilla
		],
		UnitBlockDefs = [
			{ ID = "Beast.HexenNoSpiders", RatioMin = 0.00, RatioMax = 0.13, StartingResourceMin = 300 },
			{ ID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 80 },
			{ ID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 300 },
			{ ID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 },
			{ ID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 250 },
			{ ID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00 },
			{ ID = "Beast.HexenBandits", RatioMin = 0.00, RatioMax = 1.00, StartingResourceMin = 200 }
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
			{ ID = "Beast.HexenNoBodyguards", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Hyenas", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.Serpents", RatioMin = 0.00, RatioMax = 1.00}
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
			{ ID = "Beast.SandGolems", RatioMin = 0.00, RatioMax = 1.00}
		]
	}

	// SubParties
	{
		ID = "SpiderBodyguards",
		UnitBlockDefs = [
			{ ID = "Beast.SpiderBodyguards"}
		]
	},
	{
		ID = "DirewolfBodyguards",
		UnitBlockDefs = [
			{ ID = "Beast.DirewolfBodyguards"}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
