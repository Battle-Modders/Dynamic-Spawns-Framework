local parties = [
    {
        ID = "Noble",
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_noble_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlockDefs = [
            { ID = "Noble.Frontline",   RatioMin = 0.35, RatioMax = 1.00, DeterminesFigure = true },
            { ID = "Noble.Backline",    RatioMin = 0.08, RatioMax = 0.35 },
            { ID = "Noble.Ranged",      RatioMin = 0.08, RatioMax = 0.28 },
            { ID = "Noble.Flank",       RatioMin = 0.00, RatioMax = 0.12 },
            { ID = "Noble.Support",     RatioMin = 0.05, RatioMax = 0.07, DeterminesFigure = true, ReqPartySize = 14 },    // Vanilla: Bannerman start spawning at 14
            { ID = "Noble.Officer",     RatioMin = 0.00, RatioMax = 0.08, DeterminesFigure = true, ReqPartySize = 11 },    // Vanilla: First sergeant spawns at 9, next one 12 and then 15+; Second one spawns at 27+
            { ID = "Noble.Elite",       RatioMin = 0.00, RatioMax = 0.30, DeterminesFigure = true }
        ]
    },
    {
        ID = "NobleCaravan",
        UpgradeChance = 1.0,
        HardMin = 7,
        DefaultFigure = "cart_01",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
        StaticUnitIDs = [
            "Human.CaravanDonkey"       // Makes it much easier to get a good ratio
        ],
        UnitBlockDefs = [
            { ID = "Noble.Frontline",   RatioMin = 0.35, RatioMax = 1.00},
            { ID = "Noble.Backline",    RatioMin = 0.08, RatioMax = 0.35},
            { ID = "Noble.Ranged",      RatioMin = 0.08, RatioMax = 0.28},
            { ID = "Noble.Officer",     RatioMin = 0.00, RatioMax = 0.08, ReqPartySize = 12 },  // Vanilla: spawns at 12, at 15 and at 18 once respectively
            { ID = "Noble.Elite",       RatioMin = 0.00, RatioMax = 0.31, ReqPartySize = 5 },
            { ID = "Noble.Donkeys",     RatioMin = 0.07, RatioMax = 0.08, ReqPartySize = 14 }   // Vanilla: second donkey spawns at 14+
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DynamicSpawns.Class.Party).init(party);
    ::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}
