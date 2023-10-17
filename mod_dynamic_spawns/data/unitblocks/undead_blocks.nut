local unitBlocks = [
	{
		ID = "Undead.Frontline",
		UnitDefs = [
			{ BaseID = "Undead.SkeletonLight" },
			{ BaseID = "Undead.SkeletonMedium", StartingResourceMin = 125 },
			{ BaseID = "Undead.SkeletonHeavy", StartingResourceMin = 175 }
		]
	},
	{
		ID = "Undead.Backline",
		UnitDefs = [
			{ BaseID = "Undead.SkeletonMediumPolearm", StartingResourceMin = 125 },
			{ BaseID = "Undead.SkeletonHeavyPolearm", StartingResourceMin = 175 }
		]
	},
	{
		ID = "Undead.Boss",
		UnitDefs = [
			{ BaseID = "Undead.SkeletonPriestH" },
			{ BaseID = "Undead.SkeletonPriestHH" }
		]
	},
	{
		ID = "Undead.SkeletonHeavyBodyguard",
		UnitDefs = [
			{ BaseID = "Undead.SkeletonHeavyBodyguard" }
		]
	},
	{
		ID = "Undead.Vampire",
		UnitDefs = [
			{ BaseID = "Undead.VampireLOW" },
			{ BaseID = "Undead.Vampire" }
		]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
