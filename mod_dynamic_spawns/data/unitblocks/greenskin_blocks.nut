local unitBlocks = [
	{
		ID = "Greenskin.GoblinsFoot",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { ID = "Goblin.Skirmisher" }],
			[1, { ID = "Goblin.Ambusher" }]
		])
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
