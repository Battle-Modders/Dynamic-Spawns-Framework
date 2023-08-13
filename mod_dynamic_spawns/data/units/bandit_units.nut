local units = [
// Bandits
	{
		ID = "Bandit.Thug",
		EntityType = "BanditThug",
		Figure = "figure_bandit_02",
		Cost = 9
	},
	{
		ID = "Bandit.Wardog",
		EntityType = "Wardog",
		Cost = 10
	},
	{
		ID = "Bandit.Poacher",
		EntityType = "BanditMarksmanLOW",
		Figure = "figure_bandit_01",
		Cost = 12
	},
	{
		ID = "Bandit.Marksman",
		EntityType = "BanditMarksman",
		Cost = 15
	},
	{
		ID = "Bandit.RaiderLOW",
		EntityType = "BanditRaiderLOW",
		Figure = "figure_bandit_03",
		Cost = 16
	},
	{
		ID = "Bandit.Raider",
		EntityType = "BanditRaider",
		Figure = "figure_bandit_03",
		Cost = 20
	},
	{
		ID = "Bandit.Leader",
		EntityType = "BanditLeader",
		Figure = "figure_bandit_04",
		Cost = 25
	},
	{
		ID = "Bandit.RaiderWolf",
		EntityType = "BanditRaiderWolf",
		Cost = 25
	}

// Bandits in Vanilla make also use of "Elite" troops but those are already defined in the human_units.nut
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
