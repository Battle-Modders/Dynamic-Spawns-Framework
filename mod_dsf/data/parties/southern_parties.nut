
local parties = [
    {
        ID = "SouthernArmy",
        UpgradeChance = 1.0,
        HardMin = 7,
        // HardMax = 40,
        DefaultFigure = "figure_southern_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0
        UnitBlocks = [
            { ID = "Southern.Frontline", RatioMin = 0.50, RatioMax = 0.9, DeterminesFigure = true},			// Vanilla: doesn't care about size
            { ID = "Southern.Backline", RatioMin = 0.1, RatioMax = 0.4 },				// Vanilla: doesn't care about size
            { ID = "Southern.Ranged", RatioMin = 0.1, RatioMax = 0.3 },		// Vanilla: doesn't care about size
            { ID = "Southern.Assassin", RatioMin = 0.0, RatioMax = 0.12},		// Vanilla: Start spawning at 8+
            { ID = "Southern.Officer", RatioMin = 0.07, RatioMax = 0.07, DeterminesFigure = true},		// Vanilla: Start spawning at 15+
            { ID = "Southern.Siege", RatioMin = 0.00, RatioMax = 0.07}		// Vanilla: Start spawning at 19+
        ]
    },
    {
        ID = "SouthernArmyWithLeader",
        UpgradeChance = 1.0,
        HardMin = 7,
        // HardMax = 40,,
        DefaultFigure = "figure_southern_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        StaticUnits = [
            "Officer++",
            "Officer++",
            "Assassin++"
        ],
        UnitBlocks = [
            { ID = "Southern.Frontline", RatioMin = 0.50, RatioMax = 0.9 },			// Vanilla: doesn't care about size
            { ID = "Southern.Backline", RatioMin = 0.1, RatioMax = 0.4 },				// Vanilla: doesn't care about size
            { ID = "Southern.Ranged", RatioMin = 0.1, RatioMax = 0.3 },		// Vanilla: doesn't care about size
            { ID = "Southern.Assassin", RatioMin = 0.0, RatioMax = 0.12},		// Vanilla: Start spawning at 8+
            { ID = "Southern.Officer", RatioMin = 0.07, RatioMax = 0.07},		// Vanilla: Start spawning at 15+
            { ID = "Southern.Siege", RatioMin = 0.00, RatioMax = 0.07}		// Vanilla: Start spawning at 19+
        ]
    },

    // SubParties
    {
        ID = "MortarEngineers"
		HardMin = 2,
		HardMax = 2,
        UnitBlocks = [
            { ID = "Southern.Engineer"}
        ]
    }
]

foreach(party in parties)
{
    local partyObj = ::new(::DSF.Class.Party).init(party);
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}

