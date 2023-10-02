local unitBlocks = [
	{
		ID = "Scourge.Boss",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { ID = "Undead.SkeletonPriestH" }],
			[1, { ID = "Undead.SkeletonPriestHH" }],
			[1, { ID = "Undead.NecromancerYK" }],
			[1, { ID = "Undead.NecromancerKK" }]
		])
	},
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
