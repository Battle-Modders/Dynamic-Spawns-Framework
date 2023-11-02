local units = [
	{
		ID = "Noble.Footman",
		Troop = "Footman",
		Cost = 20
	},
	{
		ID = "Noble.Billman",
		Troop = "Billman",
		Cost = 15
	},
	{
		ID = "Noble.Arbalester",
		Troop = "Arbalester",
		Cost = 20
	},
	{
		ID = "Noble.ArmoredWardog",
		Troop = "ArmoredWardog",
		Cost = 8
	},
	{
		ID = "Noble.StandardBearer",
		Troop = "StandardBearer",
		Cost = 20,
		Figure = "figure_noble_02",
		StartingResourceMin = 200	// In Vanilla they appear in a group of 240 cost
	},
	{
		ID = "Noble.Sergeant",
		Troop = "Sergeant",
		Cost = 25,
		Figure = "figure_noble_02",
		StartingResourceMin = 200	// In Vanilla they appear in a group of 235 cost in noble caravans
	},
	{
		ID = "Noble.Zweihander",
		Troop = "Greatsword",
		Cost = 25,
		StartingResourceMin = 325	// In Vanilla they appear in a group of 235 cost in noble caravans
	},
	{
		ID = "Noble.Knight",
		Troop = "Knight",
		Cost = 35,
		Figure = "figure_noble_03",
		StartingResourceMin = 325	// In Vanilla they appear in a group of 235 cost in noble caravans
	},

	{   // This already exists under human_units but noble caravans use a different figure
		ID = "Noble.CaravanDonkey",
		Troop = "CaravanDonkey",
		Cost = 10,      // 0 in Vanilla
		Figure = "cart_01"
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
