local units = [
	{
		ID = "Orc.YoungLOW",
		Troop = "OrcYoungLOW",
		Figure = "figure_orc_01",       // I assume this is OrcYoung without Armor and without Helmet
		Cost = 13
	},
	{
		ID = "Orc.Young",
		Troop = "OrcYoung",
		Figure = ["figure_orc_02", "figure_orc_06"],       // I assume this is OrcYoung only with Helmet (02) and OrcYoung only with Armor (06)
		Cost = 16
	},
	{
		ID = "Orc.Berserker",
		Troop = "OrcBerserker",
		Figure = "figure_orc_03"        // I'm sure this is OrcBerserker
		Cost = 25
	},
	{
		ID = "Orc.WarriorLOW",
		Troop = "OrcWarriorLOW",
		Figure = "figure_orc_04"        // I'm sure this is OrcWarrior
		Cost = 30
	},
	{
		ID = "Orc.Warrior",
		Troop = "OrcWarrior",
		Figure = "figure_orc_04",       // I'm sure this is OrcWarrior
		Cost = 40
	},
	{
		ID = "Orc.Warlord",
		Troop = "OrcWarlord",
		Figure = "figure_orc_05",       // I'm sure this is OrcWarlord
		Cost = 50
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
