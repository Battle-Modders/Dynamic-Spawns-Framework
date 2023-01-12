::DSF.Data.UnitDefs <- [
    {
        ID = "Conscript",
        EntityType = "Conscript",
        Cost = 20,
        Figure = "figure_southern_01"
    },
    {
        ID = "Conscript++",
        EntityType = "Conscript++",
        Cost = 30
    },
    {
        ID = "Conscript_Polearm",
        EntityType = "Conscript_Polearm",
        Cost = 15
    },
    {
        ID = "Conscript_Polearm++",
        EntityType = "Conscript_Polearm++",
        Cost = 23
    },
    {
        ID = "Officer",
        EntityType = "Officer",
        Cost = 25,
        Figure = "figure_southern_02"
    },
    {
        ID = "Officer++",
        EntityType = "Officer++",
        Cost = 38
    },
    {
        ID = "Gunner",
        EntityType = "Gunner",
        Cost = 20
    },
    {
        ID = "Gunner++",
        EntityType = "Gunner++",
        Cost = 30
    },
    {
        ID = "Engineer",
        EntityType = "Engineer",
        Cost = 10
    },
    {
        ID = "Mortar",
        EntityType = "Mortar",
        Cost = 20,
        SubParty = "MortarEngineers"
    },
    {
        ID = "Assassin",
        EntityType = "Assassin",
        Cost = 35
    },
    {
        ID = "Assassin++",
        EntityType = "Assassin++",
        Cost = 53
    }
]

foreach (unit in ::DSF.Data.UnitDefs)
{
    local unitObj = ::new(::DSF.Class.Unit).init(unit);
	::DSF.Units.LookupMap[unitObj.m.ID] <- unitObj;
	// ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
