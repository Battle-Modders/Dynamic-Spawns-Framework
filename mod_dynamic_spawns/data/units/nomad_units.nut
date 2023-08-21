local units = [
	{
		ID = "Nomad.Cutthroat",
		Troop = "NomadCutthroat",
		Figure = "figure_nomad_01",     // Official "Cutthroat" figure
		Cost = 12
	},
	{
		ID = "Nomad.Slinger",
		Troop = "NomadSlinger",
		Figure = "figure_nomad_03",     // Seems to be the "Slinger" figure but it may aswell not exist or be used for variations/other entities
		Cost = 12
	},
	{
		ID = "Nomad.Outlaw",
		Troop = "NomadOutlaw",
		Figure = "figure_nomad_02",     // Official "Outlaw" figure
		Cost = 25
	},
	{
		ID = "Nomad.Archer",
		Troop = "NomadArcher",
		Figure = "figure_nomad_04",
		Cost = 15
	},
	{
		ID = "Nomad.Leader",
		Troop = "NomadLeader",
		Figure = "figure_nomad_05",
		Cost = 30
	},
	{
		ID = "Nomad.DesertStalker",
		Troop = "DesertStalker",
		Figure = "figure_nomad_05",
		Cost = 40
	},
	{
		ID = "Nomad.Executioner",
		Troop = "Executioner",
		Figure = "figure_nomad_05",
		Cost = 40
	},
	{
		ID = "Nomad.DesertDevil",
		Troop = "DesertDevil",
		Figure = "figure_nomad_05",
		Cost = 40
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
