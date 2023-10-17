local unitBlocks = [
	{
		ID = "Bandit.Frontline",
		UnitDefs = [
			{ BaseID = "Bandit.Thug", StartingResourceMax = 320 }, 	// Thugs stop spawning alltogether by the time that Hedgeknights appear
			{ BaseID = "Bandit.RaiderLOW", StartingResourceMin = 100, StartingResourceMax = 175 },
			{ BaseID = "Bandit.Raider", StartingResourceMin = 175, }]
	},
	{
		ID = "Bandit.Ranged",
		UnitDefs = [{ BaseID = "Bandit.Poacher" }, { BaseID = "Bandit.Marksman", StartingResourceMin = 100 }]
	},
	{
		ID = "Bandit.Dogs",
		UnitDefs = [{ BaseID = "Human.Wardog" }]
	},
	{
		ID = "Bandit.Elite",
		StartingResourceMin = 320,
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Human.MasterArcher" }],
			[1, { BaseID = "Human.HedgeKnight" }],
			[1, { BaseID = "Human.Swordmaster" }]
		])
	},
	{
		ID = "Bandit.Boss",
		UnitDefs = [{ BaseID = "Bandit.Leader" }]
	},
	{
		ID = "Bandit.DisguisedDirewolf",
		UnitDefs = [{ BaseID = "Bandit.RaiderWolf" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
