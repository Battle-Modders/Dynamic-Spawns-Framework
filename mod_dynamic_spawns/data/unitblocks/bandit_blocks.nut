local unitBlocks = [
	{
		ID = "Bandit.Frontline",
		UnitDefs = [
			{ ID = "Bandit.Thug", StartingResourceMax = 320 }, 	// Thugs stop spawning alltogether by the time that Hedgeknights appear
			{ ID = "Bandit.RaiderLOW", StartingResourceMin = 100, StartingResourceMax = 175 },
			{ ID = "Bandit.Raider", StartingResourceMin = 175, }]
	},
	{
		ID = "Bandit.Ranged",
		UnitDefs = [{ ID = "Bandit.Poacher" }, { ID = "Bandit.Marksman", StartingResourceMin = 100 }]
	},
	{
		ID = "Bandit.Dogs",
		UnitDefs = [{ ID = "Human.Wardog" }]
	},
	{
		ID = "Bandit.Elite",
		StartingResourceMin = 320,
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { ID = "Human.MasterArcher" }],
			[1, { ID = "Human.HedgeKnight" }],
			[1, { ID = "Human.Swordmaster" }]
		])
	},
	{
		ID = "Bandit.Boss",
		UnitDefs = [{ ID = "Bandit.Leader" }]
	},
	{
		ID = "Bandit.DisguisedDirewolf",
		UnitDefs = [{ ID = "Bandit.RaiderWolf" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
