local unitBlocks = [
	{
		ID = "Undead.Frontline",
		UnitDefs = [
			{ ID = "Undead.SkeletonLight" },
			{ ID = "Undead.SkeletonMedium", StartingResourceMin = 125 },
			{ ID = "Undead.SkeletonHeavy", StartingResourceMin = 175 }
		]
	},
	{
		ID = "Undead.Backline",
		UnitDefs = [
			{ ID = "Undead.SkeletonMediumPolearm", StartingResourceMin = 125 },
			{ ID = "Undead.SkeletonHeavyPolearm", StartingResourceMin = 175 }
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
