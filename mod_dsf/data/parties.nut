
local parties = [
    {
        ID = "Barbarians",
        UpgradeChance = 1.0,
        HardMin = 6,
        // HardMax = 30,
        UnitBlocks = [
            { ID = "Barbarian.Frontline", RatioMin = 0.60, RatioMax = 1.0 },				// Vanilla: doesn't care about size
            { ID = "Barbarian.Support", RatioMin = 0.05, RatioMax = 0.07 },					// Vanilla: Start spawning in armies of 15+; At 24+ a second drummer spawns
            { ID = "Barbarian.Flank", RatioMin = 0.0, RatioMax = 0.17 },						// Vanilla: Start spawning in armies of 6+
            { ID = "Barbarian.Beastmaster", RatioMin = 0.0, RatioMax = 0.11},		// Vanilla: Start spawning in armies of 7+ (singular case) but more like 9+
        ]
    },
    {
        ID = "SouthernArmy",
        UpgradeChance = 1.0,
        HardMin = 7,
        // HardMax = 40,
        UnitBlocks = [
            { ID = "Southern.Frontline", RatioMin = 0.50, RatioMax = 0.9},			// Vanilla: doesn't care about size
            { ID = "Southern.Backline", RatioMin = 0.1, RatioMax = 0.4 },				// Vanilla: doesn't care about size
            { ID = "Southern.Ranged", RatioMin = 0.1, RatioMax = 0.3 },		// Vanilla: doesn't care about size
            { ID = "Southern.Assassin", RatioMin = 0.0, RatioMax = 0.12},		// Vanilla: Start spawning at 8+
            { ID = "Southern.Officer", RatioMin = 0.07, RatioMax = 0.07},		// Vanilla: Start spawning at 15+
            { ID = "Southern.Siege", RatioMin = 0.00, RatioMax = 0.07}		// Vanilla: Start spawning at 19+
        ]
    },
    {
        ID = "SouthernArmyWithLeader",
        UpgradeChance = 1.0,
        HardMin = 7,
        // HardMax = 40,
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

