local units = [
	{
		ID = "Southern.Conscript",
		Troop = "Conscript",
		Cost = 20,
		Figure = "figure_southern_01"
	},
	{
		ID = "Southern.Conscript_Polearm",
		Troop = "ConscriptPolearm",
		Cost = 15
	},
	{
		ID = "Southern.Officer",
		Troop = "Officer",
		Cost = 25,
		Figure = "figure_southern_02",
		StartingResourceMin = 250 // In Vanilla they appear in a group of 250 cost
	},
	{
		ID = "Southern.Gunner",
		Troop = "Gunner",
		Cost = 20
	},
	{
		ID = "Southern.Engineer",
		Troop = "Engineer",
		Cost = 10
	},
	{
		ID = "Southern.Mortar",
		Troop = "Mortar",
		Cost = 20,
		SubPartyDef = {ID = "MortarEngineers"}
	},
	{
		ID = "Southern.Assassin",
		Troop = "Assassin",
		Cost = 35
	},
	{
		ID = "Southern.Slave",
		Troop = "Slave",
		Cost = 7
	},

// Caravans
	{
		ID = "Southern.CaravanDonkey",
		Troop = "SouthernDonkey",
		Figure = "cart_02",
		Cost = 10      // 0 in Vanilla
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
