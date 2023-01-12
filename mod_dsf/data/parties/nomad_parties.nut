
local parties = [
    {
        ID = "NomadRoamers",
        UpgradeChance = 1.0,
        HardMin = 6,
        DefaultFigure = "figure_nomad_01",  // Icon for Cutthroats
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Nomad.Frontline",    RatioMin = 0.50, RatioMax = 0.80, DeterminesFigure = true },
            { ID = "Nomad.Ranged",       RatioMin = 0.15, RatioMax = 0.50, DeterminesFigure = true }
        ]
    },
    {
        ID = "NomadRaiders",
        UpgradeChance = 1.0,
        HardMin = 4,
        DefaultFigure = "figure_nomad_01",  // Icon for Cutthroats
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Nomad.Frontline",       RatioMin = 0.25, RatioMax = 1.00, DeterminesFigure = true },
            { ID = "Nomad.Ranged",          RatioMin = 0.00, RatioMax = 0.35, DeterminesFigure = true },
            { ID = "Nomad.Leader",          RatioMin = 0.07, RatioMax = 0.09, DeterminesFigure = true },  // They spawn as early as with 7 troops in vanilla. But 2 only start spawning in 23+
            { ID = "Nomad.Elite",           RatioMin = 0.04, RatioMax = 0.11, DeterminesFigure = true }
        ]
    },
    {
        ID = "NomadDefenders",
        UpgradeChance = 1.0,
        HardMin = 4,
        DefaultFigure = "figure_nomad_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Nomad.Frontline",       RatioMin = 0.25, RatioMax = 1.00, DeterminesFigure = true },
            { ID = "Nomad.Ranged",          RatioMin = 0.00, RatioMax = 0.35, DeterminesFigure = true },
            { ID = "Nomad.Leader",          RatioMin = 0.07, RatioMax = 0.09, DeterminesFigure = true },
            { ID = "Nomad.Elite",           RatioMin = 0.04, RatioMax = 0.11, DeterminesFigure = true }
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DSF.Class.Party).init(party);
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}

