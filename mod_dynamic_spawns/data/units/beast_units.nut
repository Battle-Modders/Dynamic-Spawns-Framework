local units = [
	{
		ID = "Beast.Direwolf",
		Troop = "Direwolf",
		Figure = "figure_werewolf_01",
		Cost = 20
	},
	{
		ID = "Beast.DirewolfHIGH",
		Troop = "DirewolfHIGH",
		Figure = "figure_werewolf_01",
		Cost = 25,
		StartingResourceMin = 95		// In Vanilla this is 95
	},
	{
		ID = "Beast.GhoulLOW",
		Troop = "GhoulLOW",
		Figure = "figure_ghoul_01",
		Cost = 9
	},
	{
		ID = "Beast.Ghoul",
		Troop = "Ghoul",
		Figure = "figure_ghoul_01",
		Cost = 19,
		StartingResourceMin = 120	// In vanilla this is 120
	},
	{
		ID = "Beast.GhoulHIGH",
		Troop = "Ghoul",
		Figure = "figure_ghoul_02",     // I don't know if a 'figure_ghoul_03' exists
		Cost = 30,
		StartingResourceMin = 150	// In vanilla this is 120
	},
	{
		ID = "Beast.Lindwurm",
		Troop = "Lindwurm",
		Figure = "figure_lindwurm_01",
		Cost = 90
	},
	{
		ID = "Beast.Unhold",
		Troop = "Unhold",
		Figure = "figure_unhold_01",
		Cost = 50
	},
	{
		ID = "Beast.UnholdFrost",
		Troop = "UnholdFrost",
		Figure = "figure_unhold_02",
		Cost = 60
	},
	{
		ID = "Beast.UnholdBog",
		Troop = "UnholdBog",
		Figure = "figure_unhold_03",
		Cost = 50
	},
	{
		ID = "Beast.Spider",
		Troop = "Spider",
		Figure = "figure_spider_01",
		Cost = 12
	},
	{
		ID = "Beast.Alp",
		Troop = "Alp",
		Figure = "figure_alp_01",
		Cost = 30
	},
	{
		ID = "Beast.Schrat",
		Troop = "Schrat",
		Figure = "figure_schrat_01",
		Cost = 70
	},
	{
		ID = "Beast.Kraken",
		Troop = "Kraken",
		Cost = 200
	},
	{
		ID = "Beast.Hyena",
		Troop = "Hyena",
		Figure = "figure_hyena_01",
		Cost = 20
	},
	{
		ID = "Beast.HyenaHIGH",
		Troop = "HyenaHIGH",
		Figure = "figure_hyena_01",
		Cost = 25,
		StartingResourceMin = 125		// In Vanilla this is 125
	},
	{
		ID = "Beast.Serpent",
		Troop = "Serpent",
		Figure = "figure_serpent_01",
		Cost = 20
	},
	{
		ID = "Beast.SandGolem",
		Troop = "SandGolem",
		Figure = "figure_golem_01",
		Cost = 13
	},
	{
		ID = "Beast.SandGolemMEDIUM",
		Troop = "SandGolemMEDIUM",
		Figure = "figure_golem_01",
		Cost = 42   // 35 in Vanilla, 3 Small Golems should cost slightly less than 1 Medium Golem because they always spend their first turn action morphing
	},
	{	// In Vanilla these never spawn naturally as part of the line-up
		ID = "Beast.SandGolemHIGH",
		Troop = "SandGolemHIGH",
		Figure = "figure_golem_02",    // I don't know if a 'figure_golem_03' exists
		Cost = 129   // 70 in Vanilla, -!!-
	}

	// Possible Hexen
	{
		ID = "Beast.Hexe",      // Without Bodyguards
		Troop = "Hexe",
		Figure = "figure_hexe_01",
		Cost = 50
	},
	{
		ID = "Beast.HexeOneSpider",
		Troop = "Hexe",
		Figure = "figure_hexe_01",
		Cost = 50 + 12,
		SubParty = {ID = "SpiderBodyguards", HardMin = 1, HardMax = 1}
	},
	{
		ID = "Beast.HexeTwoSpider",
		Troop = "Hexe",
		Figure = "figure_hexe_01",
		Cost = 50 + 12 + 12,
		SubParty = {ID = "SpiderBodyguards", HardMin = 2, HardMax = 2}
	},
	{
		ID = "Beast.HexeOneDirewolf",
		Troop = "Hexe",
		Figure = "figure_hexe_01",
		Cost = 50 + 25,
		SubParty = {ID = "DirewolfBodyguards", HardMin = 1, HardMax = 1}
	},
	{
		ID = "Beast.HexeTwoDirewolf",
		Troop = "Hexe",
		Figure = "figure_hexe_01",
		Cost = 50 + 25 + 25,
		SubParty = {ID = "DirewolfBodyguards", HardMin = 2, HardMax = 2}
	},

	// Bodyguards
	{
		ID = "Beast.SpiderBodyguard",
		Troop = "SpiderBodyguard",
		Cost = 12
	},
	{
		ID = "Beast.DirewolfBodyguard",
		Troop = "DirewolfBodyguard",
		Cost = 25
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
