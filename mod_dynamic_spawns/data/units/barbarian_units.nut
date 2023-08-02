::DynamicSpawns.Data.UnitDefs <- [
	{
		ID = "Barbarian.Thrall",
		EntityType = "BarbarianThrall",
        Figure = "figure_wildman_01",
		Cost = 12
	},
	{
		ID = "Barbarian.Marauder",
		EntityType = "BarbarianMarauder",
        Figure = "figure_wildman_02",
		Cost = 25
	},
	{
		ID = "Barbarian.Chosen",
		EntityType = "BarbarianChampion",
        Figure = "figure_wildman_03",
		Cost = 35,
		MinStartingResource = 170
	},
	{
		ID = "Barbarian.Drummer",
		EntityType = "BarbarianDrummer",
		Cost = 20
	},
	{
		ID = "Barbarian.King",
		EntityType = "BarbarianChosen",		// Weird Vanilla Naming Scheme
        Figure = "figure_wildman_06",
		Cost = 45
	},
	{
		ID = "Barbarian.Warhound",
		EntityType = "Warhound",
		Cost = 10
	},
	{
		ID = "Barbarian.Unhold",
		EntityType = "BarbarianUnhold",
		Cost = 55,
        Figure = "figure_unhold_01"     // Not really needed as barbarian unholds never determin their Figure in Vanilla
	},
	{
		ID = "Barbarian.UnholdFrost",
		EntityType = "BarbarianUnholdFrost",
		Cost = 75,
        Figure = "figure_unhold_02"     // Not really needed as barbarian unholds never determin their Figure in Vanilla
	},
	{
		ID = "Barbarian.BeastmasterU",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 55,
		SubParty = "OneUnhold"
	},
	{
		ID = "Barbarian.BeastmasterUU",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 55 + 55,
		SubParty = "TwoUnhold"
	},
	{
		ID = "Barbarian.BeastmasterF",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75,
		SubParty = "OneFrostUnhold"
	},
	{
		ID = "Barbarian.BeastmasterFF",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75 + 75,
		SubParty = "TwoFrostUnhold"
	}
]

foreach (unit in ::DynamicSpawns.Data.UnitDefs)
{
    local unitObj = ::new(::DynamicSpawns.Class.Unit).init(unit);
	::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
	// ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
