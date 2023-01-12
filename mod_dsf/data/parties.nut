
local parties = [
    {
        ID = "Barbarians",
        UpgradeChance = 0.75,
        HardMin = 6,
        // HardMax = 30,
        UnitBlocks = [
            { ID = "Barbarian.Frontline", PartMin = 0.60, PartMax = 1.0 },				// Vanilla: doesn't care about size
            { ID = "Barbarian.Support", PartMin = 0.05, PartMax = 0.07 },					// Vanilla: Start spawning in armies of 15+; At 24+ a second drummer spawns
            { ID = "Barbarian.Flank", PartMin = 0.0, PartMax = 0.17 },						// Vanilla: Start spawning in armies of 6+
            { ID = "Barbarian.Beastmaster", PartMin = 0.0, PartMax = 0.11},		// Vanilla: Start spawning in armies of 7+ (singular case) but more like 9+
        ]
    },
    {
        ID = "SouthernArmy",
        UpgradeChance = 0.75,
        HardMin = 7,
        // HardMax = 40,
        UnitBlocks = [
            { ID = "Southern.Frontline", PartMin = 0.50, PartMax = 0.9 },			// Vanilla: doesn't care about size
            { ID = "Southern.Backline", PartMin = 0.1, PartMax = 0.4 },				// Vanilla: doesn't care about size
            { ID = "Southern.Ranged", PartMin = 0.1, PartMax = 0.3 },		// Vanilla: doesn't care about size
            { ID = "Southern.Assassin", PartMin = 0.0, PartMax = 0.12},		// Vanilla: Start spawning at 8+
            { ID = "Southern.Officer", PartMin = 0.07, PartMax = 0.07},		// Vanilla: Start spawning at 15+
            { ID = "Southern.Siege", PartMin = 0.00, PartMax = 0.07}		// Vanilla: Start spawning at 19+
        ]
    },


    // Guards
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
	},
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
    ::DSF.Parties.LookupMap[partyObj.m.ID] <- partyObj;	
}

