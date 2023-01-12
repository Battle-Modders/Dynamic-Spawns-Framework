local parties = [
    {
        ID = "Cultist",
        UpgradeChance = 1.0,
        HardMin = 4,
        DefaultFigure = "figure_civilian_03",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Human.CultistAmbush", RatioMin = 0.00, RatioMax = 1.00}
        ]
    },
    {
        ID = "Peasants",
        UpgradeChance = 1.0,
        HardMin = 3,
        DefaultFigure = "figure_civilian_01",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
        UnitBlocks = [
            { ID = "Human.Peasants", RatioMin = 0.00, RatioMax = 1.00}
        ]
    },
    {
        ID = "PeasantsArmed",
        UpgradeChance = 1.0,
        HardMin = 3,
        DefaultFigure = "figure_civilian_01",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
        UnitBlocks = [
            { ID = "Human.PeasantsArmed", RatioMin = 0.00, RatioMax = 1.00}
        ]
    },
    {
        ID = "PeasantsSouthern",
        UpgradeChance = 1.0,
        HardMin = 3,
        DefaultFigure = "figure_civilian_06",
		MovementSpeedMult = 0.75,
		VisibilityMult = 1.0,
		VisionMult = 0.75,
        UnitBlocks = [
            { ID = "Human.SouthernPeasants", RatioMin = 0.00, RatioMax = 1.00}
        ]
    },
    {
        ID = "BountyHunters",
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_bandit_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Human.BountyHunter", RatioMin = 0.60, RatioMax = 1.00},
            { ID = "Human.BountyHunterRanged", RatioMin = 0.15, RatioMax = 0.30},
            { ID = "Human.Wardogs", RatioMin = 0.05, RatioMax = 0.15}
        ]
    },
    {
        ID = "Mercenaries",
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_bandit_03",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Mercenary.Frontline", RatioMin = 0.60, RatioMax = 1.00},
            { ID = "Mercenary.Ranged", RatioMin = 0.12, RatioMax = 0.30},
            { ID = "Mercenary.Elite", RatioMin = 0.07, RatioMax = 0.17},
            { ID = "Human.Wardogs", RatioMin = 0.00, RatioMax = 0.12}
        ]
    },
    {
        ID = "Militia",
        UpgradeChance = 1.0,
        HardMin = 6,
        DefaultFigure = ["figure_militia_01", "figure_militia_02"],
		MovementSpeedMult = 0.9,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Human.MilitiaFrontline",    RatioMin = 0.60, RatioMax = 1.00},
            { ID = "Human.MilitiaRanged",       RatioMin = 0.12, RatioMax = 0.35},
            { ID = "Human.MilitiaCaptain",      RatioMin = 0.09, RatioMax = 0.09}
        ]
    },
    {
        ID = "Caravan",
        UpgradeChance = 1.0,
        HardMin = 4,
        DefaultFigure = "cart_02",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
        StaticUnits = [
            "Human.CaravanDonkey"
        ],
        UnitBlocks = [
            { ID = "Human.CaravanDonkeys",  RatioMin = 0.17, RatioMax = 0.22},
            { ID = "Human.CaravanHands",    RatioMin = 0.35, RatioMax = 0.80},
            { ID = "Human.CaravanGuards",   RatioMin = 0.15, RatioMax = 0.55}
        ]
    },
    {
        ID = "CaravanEscort",   // Caravans spawned for player escort contract
        UpgradeChance = 1.0,
        HardMin = 3,
        DefaultFigure = "cart_02",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
        StaticUnits = [
            "Human.CaravanDonkey"
        ],
        UnitBlocks = [
            { ID = "Human.CaravanDonkeys",  RatioMin = 0.35, RatioMax = 0.40},
            { ID = "Human.CaravanHands",    RatioMin = 0.50, RatioMax = 0.85}
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DSF.Class.Party).init(party);
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}