local unitBlocks = [
	{
		ID = "Scourge.Boss",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Undead.SkeletonPriestH" }],
			[1, { BaseID = "Undead.SkeletonPriestHH" }],
			[1, { BaseID = "Undead.NecromancerYK" }],
			[1, { BaseID = "Undead.NecromancerKK" }]
		])
	},
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
