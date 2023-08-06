::DynamicSpawns.Data.UnitDefs <- [
    {
        ID = "Southern.Conscript",
        EntityType = "Conscript",
        Cost = 20,
        Figure = "figure_southern_01"
    },
    {
        ID = "Southern.Conscript_Polearm",
        EntityType = "ConscriptPolearm",
        Cost = 15
    },
    {
        ID = "Southern.Officer",
        EntityType = "Officer",
        Cost = 25,
        Figure = "figure_southern_02"
    },
    {
        ID = "Southern.Gunner",
        EntityType = "Gunner",
        Cost = 20
    },
    {
        ID = "Southern.Engineer",
        EntityType = "Engineer",
        Cost = 10
    },
    {
        ID = "Southern.Mortar",
        EntityType = "Mortar",
        Cost = 20,
        SubPartyDef = "MortarEngineers"
    },
    {
        ID = "Southern.Assassin",
        EntityType = "Assassin",
        Cost = 35
    },
    {
        ID = "Southern.Slave",
        EntityType = "Slave",
        Cost = 7
    },

// Caravans
    {
        ID = "Southern.CaravanDonkey",
        EntityType = "SouthernDonkey",
        Figure = "cart_02",
        Cost = 10      // 0 in Vanilla
    }
]

foreach (unit in ::DynamicSpawns.Data.UnitDefs)
{
    local unitObj = ::new(::DynamicSpawns.Class.Unit).init(unit);
	::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
	// ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
