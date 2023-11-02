local units = [
	{
		ID = "Barbarian.Thrall",
		Troop = "BarbarianThrall",
		Figure = "figure_wildman_01",
		Cost = 12
	},
	{
		ID = "Barbarian.Marauder",
		Troop = "BarbarianMarauder",
		Figure = "figure_wildman_02",
		Cost = 25
	},
	{
		ID = "Barbarian.Chosen",
		Troop = "BarbarianChampion",
		Figure = "figure_wildman_03",
		Cost = 35,
		StartingResourceMin = 170
	},
	{
		ID = "Barbarian.Drummer",
		Troop = "BarbarianDrummer",
		Cost = 20
	},
	{
		ID = "Barbarian.King",
		Troop = "BarbarianChosen",		// Weird Vanilla Naming Scheme
		Figure = "figure_wildman_06",
		Cost = 45
	},
	{
		ID = "Barbarian.Warhound",
		Troop = "Warhound",
		Cost = 10
	},
	{
		ID = "Barbarian.Unhold",
		Troop = "BarbarianUnhold",
		Cost = 55,
		Figure = "figure_unhold_01"     // Not really needed as barbarian unholds never determin their Figure in Vanilla
	},
	{
		ID = "Barbarian.UnholdFrost",
		Troop = "BarbarianUnholdFrost",
		Cost = 75,
		Figure = "figure_unhold_02"     // Not really needed as barbarian unholds never determin their Figure in Vanilla
	},
	{
		ID = "Barbarian.BeastmasterU",
		Troop = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		StartingResourceMin = 200, // In Vanilla they appear in a group of 195 cost,
		Cost = 15 + 55,
		SubPartyDef = {ID = "OneUnhold"}
	},
	{
		ID = "Barbarian.BeastmasterUU",
		Troop = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		StartingResourceMin = 400,
		Cost = 15 + 55 + 55,
		SubPartyDef = {ID = "TwoUnhold"}
	},
	{
		ID = "Barbarian.BeastmasterF",
		Troop = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75,
		StartingResourceMin = 200, // In Vanilla they appear in a group of 195 cost
		SubPartyDef = {ID = "OneFrostUnhold"}
	},
	{
		ID = "Barbarian.BeastmasterFF",
		Troop = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		StartingResourceMin = 430,
		Cost = 15 + 75 + 75,
		SubPartyDef = {ID = "TwoFrostUnhold"}
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
