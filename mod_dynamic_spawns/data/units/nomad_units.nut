local units = [
	{
		ID = "Nomad.Cutthroat",
		EntityType = "NomadCutthroat",
		Figure = "figure_nomad_01",     // Official "Cutthroat" figure
		Cost = 12
	},
	{
		ID = "Nomad.Slinger",
		EntityType = "NomadSlinger",
		Figure = "figure_nomad_03",     // Seems to be the "Slinger" figure but it may aswell not exist or be used for variations/other entities
		Cost = 12
	},
	{
		ID = "Nomad.Outlaw",
		EntityType = "NomadOutlaw",
		Figure = "figure_nomad_02",     // Official "Outlaw" figure
		Cost = 25
	},
	{
		ID = "Nomad.Archer",
		EntityType = "NomadArcher",
		Figure = "figure_nomad_04",
		Cost = 15
	},
	{
		ID = "Nomad.Leader",
		EntityType = "NomadLeader",
		Figure = "figure_nomad_05",
		Cost = 30
	},
	{
		ID = "Nomad.DesertStalker",
		EntityType = "DesertStalker",
		Figure = "figure_nomad_05",
		Cost = 40
	},
	{
		ID = "Nomad.Executioner",
		EntityType = "Executioner",
		Figure = "figure_nomad_05",
		Cost = 40
	},
	{
		ID = "Nomad.DesertDevil",
		EntityType = "DesertDevil",
		Figure = "figure_nomad_05",
		Cost = 40
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
