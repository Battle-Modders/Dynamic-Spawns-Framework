::DSF.Data.UnitDefs <- [

// Barbarians
	{
		ID = "Thrall",
		EntityType = "BarbarianThrall",
		Cost = 12
	},
	{
		ID = "Marauder",
		EntityType = "BarbarianMarauder",
		Cost = 25
	},
	{
		ID = "Chosen",
		EntityType = "BarbarianChosen",
		Cost = 35
	},
	{
		ID = "Drummer",
		EntityType = "BarbarianDrummer",	
		Cost = 20
	},
	{
		ID = "Warhound",
		EntityType = "Warhound",
		Cost = 10
	},
	{
		ID = "Unhold",
		EntityType = "BarbarianUnhold",
		Cost = 55
	},
	{
		ID = "UnholdFrost",
		EntityType = "BarbarianUnholdFrost",
		Cost = 75
	},
	{
		ID = "BeastmasterU",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 55,
		Party = "OneUnhold" 
	},
	{
		ID = "BeastmasterUU",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 55 + 55,
		Party = "TwoUnhold" 
	},
	{
		ID = "BeastmasterF",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75,
		Party = "OneFrostUnhold" 
	},
	{
		ID = "BeastmasterFF",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75 + 75,
		Party = "TwoFrostUnhold" 
	},

// Southern Army
    {
        ID = "Conscript",
        EntityType = "Conscript",
        Cost = 20
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
        Cost = 25
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
        Party = "MortarEngineers" 
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
