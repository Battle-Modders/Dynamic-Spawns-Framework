local parties = [
    {
        ID = "Noble",
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_noble_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Noble.Frontline",   RatioMin = 0.35, RatioMax = 1.00, DeterminesFigure = true },
            { ID = "Noble.Backline",    RatioMin = 0.08, RatioMax = 0.35 },
            { ID = "Noble.Ranged",      RatioMin = 0.08, RatioMax = 0.28 },
            { ID = "Noble.Flank",       RatioMin = 0.00, RatioMax = 0.08 },
            { ID = "Noble.Support",     RatioMin = 0.05, RatioMax = 0.07, DeterminesFigure = true },
            { ID = "Noble.Officer",     RatioMin = 0.00, RatioMax = 0.08, DeterminesFigure = true },
            { ID = "Noble.Elite",       RatioMin = 0.00, RatioMax = 0.30, DeterminesFigure = true }
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DSF.Class.Party).init(party);
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}
