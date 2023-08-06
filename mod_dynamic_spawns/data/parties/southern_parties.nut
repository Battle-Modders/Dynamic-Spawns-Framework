
local parties = [
    {
        ID = "Southern",
        UpgradeChance = 1.0,
        HardMin = 5,
        // HardMax = 40,
        DefaultFigure = "figure_southern_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlockDefs = [
            { ID = "Southern.Frontline",    RatioMin = 0.50, RatioMax = 0.90, DeterminesFigure = true},			// Vanilla: doesn't care about size
            { ID = "Southern.Backline",     RatioMin = 0.10, RatioMax = 0.40 },				// Vanilla: doesn't care about size
            { ID = "Southern.Ranged",       RatioMin = 0.00, RatioMax = 0.30 },		// Vanilla: doesn't care about size
            { ID = "Southern.Assassins",    RatioMin = 0.00, RatioMax = 0.13, ReqPartySize = 7 },		// Vanilla: Start spawning at 8+
            { ID = "Southern.Officers",     RatioMin = 0.01, RatioMax = 0.08, ReqPartySize = 14, DeterminesFigure = true},		// Vanilla: Start spawning at 15+
            { ID = "Southern.Siege",        RatioMin = 0.00, RatioMax = 0.07, ReqPartySize = 18 }		// Vanilla: Start spawning at 19+
        ]
    },
    {
        ID = "CaravanSouthern",
        UpgradeChance = 1.0,
        HardMin = 10,
        DefaultFigure = "cart_03",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
        StaticUnitIDs = [
            "Southern.CaravanDonkey"
        ],
        UnitBlockDefs = [
            { ID = "Southern.Frontline",        RatioMin = 0.15, RatioMax = 1.00 },
            { ID = "Southern.Slaves",           RatioMin = 0.00, RatioMax = 0.25 },
            { ID = "Southern.Backline",         RatioMin = 0.10, RatioMax = 0.40 },
            { ID = "Southern.Officers",         RatioMin = 0.00, RatioMax = 0.08, ReqPartySize = 14 },
            { ID = "Southern.CaravanDonkeys",   RatioMin = 0.01, RatioMax = 0.12, ReqPartySize = 14 }   // Vanilla: Second starts spawning at 14, then 16+
        ]
        // In Vanilla this party is also able to spawn just with mercenaries. But this is so rare that I chose to not try to mirror that behavior here
    },
    {
        ID = "CaravanSouthernEscort",   // For Contract Escort missions
        UpgradeChance = 1.0,
        HardMin = 2,
        DefaultFigure = "cart_03",
		MovementSpeedMult = 0.5,
		VisibilityMult = 1.0,
		VisionMult = 0.25,
        StaticUnitIDs = [
            "Southern.CaravanDonkey"
        ],
        UnitBlockDefs = [
            { ID = "Southern.Frontline",        RatioMin = 0.35, RatioMax = 1.00 },
            // { ID = "Southern.Slaves",           RatioMin = 0.00, RatioMax = 0.25 },     // This is new. I find Slaves seen as a trade good a nice touch for player escorted southern caravans
            { ID = "Southern.CaravanDonkeys",   RatioMin = 0.35, RatioMax = 0.50, ReqPartySize = 3 }
        ]
        // In Vanilla this party is also able to spawn just with mercenaries. But this is so rare that I chose to not try to mirror that behavior here
    },
    {
        ID = "Slaves",
        UpgradeChance = 1.0,
        HardMin = 6,
        DefaultFigure = "figure_slave_01",
		MovementSpeedMult = 0.66,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlockDefs = [
            { ID = "Southern.Slaves",           RatioMin = 0.00, RatioMax = 1.00 }
        ]
    },
    {
        ID = "NorthernSlaves",
        UpgradeChance = 1.0,
        HardMin = 6,
        DefaultFigure = "figure_slave_01",
		MovementSpeedMult = 0.66,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlockDefs = [
            { ID = "Human.Slaves",           RatioMin = 0.00, RatioMax = 1.00 }
        ]
    },
    {
        ID = "Assassins",
        UpgradeChance = 1.0,
        HardMin = 3,
        DefaultFigure = "figure_southern_01",
		MovementSpeedMult = 1.00,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
        UnitBlockDefs = [
            { ID = "Southern.Assassins",           RatioMin = 0.00, RatioMax = 1.00 }
        ]
    },

    // SubParties
    {
        ID = "MortarEngineers"
		HardMin = 2,
		HardMax = 2,
        UnitBlockDefs = [
            { ID = "Southern.Engineer"}
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DynamicSpawns.Class.Party).init(party);
    ::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}

