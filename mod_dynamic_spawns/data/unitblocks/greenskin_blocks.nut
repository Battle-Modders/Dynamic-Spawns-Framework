local unitBlocks = [
	{
		ID = "Greenskin.GoblinsFoot",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Goblin.Skirmisher" }],
			[1, { BaseID = "Goblin.Ambusher" }]
		])
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
