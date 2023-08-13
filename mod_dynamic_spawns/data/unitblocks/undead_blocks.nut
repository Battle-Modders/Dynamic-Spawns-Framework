local unitBlocks = [
	{
		ID = "Undead.Frontline",
		UnitDefs = [
			{ ID = "Undead.SkeletonLight" },
			{ ID = "Undead.SkeletonMedium" },
			{ ID = "Undead.SkeletonHeavy" }
		]
	},
	{
		ID = "Undead.Backline",
		UnitDefs = [
			{ ID = "Undead.SkeletonMediumPolearm" },
			{ ID = "Undead.SkeletonHeavyPolearm" }
		]
	},
	{
		ID = "Undead.Boss",
		UnitDefs = [
			{ ID = "Undead.SkeletonPriestH" },
			{ ID = "Undead.SkeletonPriestHH" }
		]
	},
	{
		ID = "Undead.SkeletonHeavyBodyguard",
		UnitDefs = [
			{ ID = "Undead.SkeletonHeavyBodyguard" }
		]
	},
	{
		ID = "Undead.Vampire",
		UnitDefs = [
			{ ID = "Undead.VampireLOW" },
			{ ID = "Undead.Vampire" }
		]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
