local parties = [
    {
        ID = "Direwolves",
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        StaticUnits = [
            "Beast.Hexe"    // This one has no Bodyguards, which is not perfect because sometimes the only Hexe spawns with bodyguards in vanilla
        ],
        UnitBlockDefs = [
            { ID = "Beast.HexenWithBodyguards", RatioMin = 0.08, RatioMax = 0.13 },
            { ID = "Beast.Spiders", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.HexenBandits", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.HexenBanditsRanged", RatioMin = 0.00, RatioMax = 0.13 }
        ]
    },
    {
        ID = "HexenAndNoSpiders",
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_hexe_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        StaticUnits = [
            "Beast.Hexe"    // This one has no Bodyguards, which is not perfect because sometimes the only Hexe spawns with bodyguards in vanilla
        ],
        UnitBlockDefs = [
            { ID = "Beast.HexenNoSpiders", RatioMin = 0.08, RatioMax = 0.13 },
            { ID = "Beast.Ghouls", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Schrats", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Unholds", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.UnholdsBog", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.Direwolves", RatioMin = 0.00, RatioMax = 1.00 },
            { ID = "Beast.HexenBandits", RatioMin = 0.00, RatioMax = 1.00 }
        ]
    },
    {
        ID = "Hexen",
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
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
        UpgradeChance = 1.0,
        HardMin = 3,
        DefaultFigure = "figure_golem_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlockDefs = [
            { ID = "Beast.SandGolems", RatioMin = 0.00, RatioMax = 1.00}
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DynamicSpawns.Class.Party).init(party);
    ::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}
