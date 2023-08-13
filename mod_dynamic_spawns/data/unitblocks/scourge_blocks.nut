local unitBlocks = [
	{
		ID = "Scourge.Boss",
		IsRandom = true,
		UnitDefs = [
			{ ID = "Undead.SkeletonPriestH" },
			{ ID = "Undead.SkeletonPriestHH" },
			{ ID = "Undead.NecromancerYK" },
			{ ID = "Undead.NecromancerKK" }
		]
	},
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
