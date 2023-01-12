
local parties = [
    {
        ID = "Barbarians",
        UpgradeChance = 1.0,
        HardMin = 6,
        DefaultFigure = "figure_wildman_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Barbarian.Frontline", 	RatioMin = 0.60, RatioMax = 1.00, DeterminesFigure = true },				// Vanilla: doesn't care about size
            { ID = "Barbarian.Support", 	RatioMin = 0.05, RatioMax = 0.07 },					// Vanilla: Start spawning in armies of 15+; At 24+ a second drummer spawns
            { ID = "Barbarian.Dogs", 		RatioMin = 0.00, RatioMax = 0.17 },						// Vanilla: Start spawning in armies of 6+
            { ID = "Barbarian.Beastmaster", RatioMin = 0.00, RatioMax = 0.11 }		// Vanilla: Start spawning in armies of 7+ (singular case) but more like 9+
        ]
    },
    {
        ID = "BarbarianHunters",
        UpgradeChance = 1.0,
        HardMin = 5,
        DefaultFigure = "figure_wildman_01",
        MovementSpeedMult = 1.1,	// In vanilla this is not defined (which means its 1.0)
        VisibilityMult = 1.0,
        VisionMult = 1.1,			// In vanilla this is not defined (which means its 1.0)
        UnitBlocks = [
            { ID = "Barbarian.HunterFrontline", RatioMin = 0.60, RatioMax = 1.0, DeterminesFigure = true },
            { ID = "Barbarian.Dogs", 			RatioMin = 0.20, RatioMax = 0.45 }
        ]
    },
    {
        ID = "BarbarianKing",
        DefaultFigure = "figure_wildman_06",
		StaticUnits = [
			"Barbarian.King"
		]
    }

    // SubParties
	{
		ID = "OneUnhold"
		HardMin = 1,
		HardMax = 1,
		UnitBlocks = [
			{ ID = "Barbarian.Unholds"}
		]
	},
	{
		ID = "TwoUnhold"
		HardMin = 2,
		HardMax = 2,
		UnitBlocks = [
			{ ID = "Barbarian.Unholds"}
		]
	},
	{
		ID = "OneFrostUnhold"
		HardMin = 1,
		HardMax = 1,
		UnitBlocks = [
			{ ID = "Barbarian.UnholdsFrost"}
		]
	},
	{
		ID = "TwoFrostUnhold"
		HardMin = 2,
		HardMax = 2,
		UnitBlocks = [
			{ ID = "Barbarian.UnholdsFrost"}
		]
	}
]

foreach(party in parties)
{
    local partyObj = ::new(::DSF.Class.Party).init(party);
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}

