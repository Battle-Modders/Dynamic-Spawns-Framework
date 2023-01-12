
local parties = [
    {
        ID = "Barbarians",
        UpgradeChance = 1.0,
        HardMin = 6,
        // HardMax = 30,
        DefaultFigure = "figure_wildman_01",
        MovementSpeedMult = 1.0,
        VisibilityMult = 1.0,
        VisionMult = 1.0,
        UnitBlocks = [
            { ID = "Barbarian.Frontline", RatioMin = 0.60, RatioMax = 1.0, DeterminesFigure = true },				// Vanilla: doesn't care about size
            { ID = "Barbarian.Support", RatioMin = 0.05, RatioMax = 0.07 },					// Vanilla: Start spawning in armies of 15+; At 24+ a second drummer spawns
            { ID = "Barbarian.Flank", RatioMin = 0.0, RatioMax = 0.17 },						// Vanilla: Start spawning in armies of 6+
            { ID = "Barbarian.Beastmaster", RatioMin = 0.0, RatioMax = 0.11},		// Vanilla: Start spawning in armies of 7+ (singular case) but more like 9+
        ]
    }

    // SubParties
	{
		ID = "OneUnhold"
		HardMin = 1,
		HardMax = 1,
		UnitBlocks = [
			{ ID = "Barbarian.Unhold"}
		]
	},
	{
		ID = "TwoUnhold"
		HardMin = 2,
		HardMax = 2,
		UnitBlocks = [
			{ ID = "Barbarian.Unhold"}
		]
	},
	{
		ID = "OneFrostUnhold"
		HardMin = 1,
		HardMax = 1,
		UnitBlocks = [
			{ ID = "Barbarian.UnholdFrost"}
		]
	},
	{
		ID = "TwoFrostUnhold"
		HardMin = 2,
		HardMax = 2,
		UnitBlocks = [
			{ ID = "Barbarian.UnholdFrost"}
		]
	}
]

foreach(party in parties)
{
    local partyObj = ::new(::DSF.Class.Party).init(party);
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj; // Currently only needed for Guard-Parties

    ::Const.World.Spawn[partyObj.m.ID] <- partyObj;     // Overwrites all vanilla party objects that we defined replacements for
}

