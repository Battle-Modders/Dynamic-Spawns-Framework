local units = [
// Bandits
	{
		ID = "Bandit.Thug",
		Troop = "BanditThug",
		Figure = "figure_bandit_02",
		Cost = 9
	},
	{
		ID = "Bandit.Wardog",
		Troop = "Wardog",
		Cost = 10
	},
	{
		ID = "Bandit.Poacher",
		Troop = "BanditMarksmanLOW",
		Figure = "figure_bandit_01",
		Cost = 12
	},
	{
		ID = "Bandit.Marksman",
		Troop = "BanditMarksman",
		Cost = 15
	},
	{
		ID = "Bandit.RaiderLOW",
		Troop = "BanditRaiderLOW",
		Figure = "figure_bandit_03",
		Cost = 16
	},
	{
		ID = "Bandit.Raider",
		Troop = "BanditRaider",
		Figure = "figure_bandit_03",
		Cost = 20
	},
	{
		ID = "Bandit.Leader",
		Troop = "BanditLeader",
		Figure = "figure_bandit_04",
		Cost = 25
	},
	{
		ID = "Bandit.RaiderWolf",
		Troop = "BanditRaiderWolf",
		Cost = 25
	}

// Bandits in Vanilla make also use of "Elite" troops but those are already defined in the human_units.nut
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
