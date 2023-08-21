local units = [
	{
		ID = "Goblin.SkirmisherLOW",
		Troop = "GoblinSkirmisherLOW",
		Figure = "figure_goblin_01",
		Cost = 10
	},
	{
		ID = "Goblin.Skirmisher",
		Troop = "GoblinSkirmisher",
		Figure = "figure_goblin_01",
		Cost = 15
	},
	{
		ID = "Goblin.AmbusherLOW",
		Troop = "GoblinAmbusherLOW",
		Figure = "figure_goblin_02",
		Cost = 15
	},
	{
		ID = "Goblin.Ambusher",
		Troop = "GoblinAmbusher",
		Figure = "figure_goblin_02",
		Cost = 20
	},
	{
		ID = "Goblin.Wolfrider",
		Troop = "GoblinWolfrider",
		Figure = "figure_goblin_05",
		Cost = 20
	},
	{
		ID = "Goblin.Overseer",
		Troop = "GoblinOverseer",
		Figure = "figure_goblin_04",
		Cost = 35
	},
	{
		ID = "Goblin.Shaman",
		Troop = "GoblinShaman",
		Figure = "figure_goblin_03",
		Cost = 35
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
