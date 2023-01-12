::DSF.Data.UnitDefs <- [
	{
		ID = "Thrall",
		EntityType = "BarbarianThrall",
		Cost = 12,
        Figure = "figure_wildman_01"
	},
	{
		ID = "Marauder",
		EntityType = "BarbarianMarauder",
		Cost = 25,
        Figure = "figure_wildman_02"
	},
	{
		ID = "Chosen",
		EntityType = "BarbarianChosen",
		Cost = 35,
        Figure = "figure_wildman_03"
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
		Cost = 55,
        Figure = "figure_unhold_01"     // Not really needed as barbarian unholds never determin their Figure in Vanilla
	},
	{
		ID = "UnholdFrost",
		EntityType = "BarbarianUnholdFrost",
		Cost = 75,
        Figure = "figure_unhold_02"     // Not really needed as barbarian unholds never determin their Figure in Vanilla
	},
	{
		ID = "BeastmasterU",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 55,
		SubParty = "OneUnhold"
	},
	{
		ID = "BeastmasterUU",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 55 + 55,
		SubParty = "TwoUnhold"
	},
	{
		ID = "BeastmasterF",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75,
		SubParty = "OneFrostUnhold"
	},
	{
		ID = "BeastmasterFF",
		EntityType = "BarbarianBeastmaster",	// Usually it's 1 Beastmaster for 1-2 Unholds. In one case vanilla spawns 3 Unholds for one Beastmaster. And in one case Vanilla spawns 3 Beastmaster for 4 Unholds. I would disregard these.
		Cost = 15 + 75 + 75,
		SubParty = "TwoFrostUnhold"
	}
]

foreach (unit in ::DSF.Data.UnitDefs)
{
    local unitObj = ::new(::DSF.Class.Unit).init(unit);
	::DSF.Units.LookupMap[unitObj.m.ID] <- unitObj;
	// ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
