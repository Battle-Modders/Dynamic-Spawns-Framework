local unitBlocks = [
	{
		ID = "Goblin.Frontline",
		UnitDefs =
		[
			{ BaseID = "Goblin.SkirmisherLOW" },
			{ BaseID = "Goblin.Skirmisher" }
		]
	},
	{
		ID = "Goblin.Ranged",
		UnitDefs = [
			{ BaseID = "Goblin.AmbusherLOW" },
			{ BaseID = "Goblin.Ambusher" }
		]
	},
	{
		ID = "Goblin.Flank",
		UnitDefs = [{ BaseID = "Goblin.Wolfrider" }]
	},
	{
		ID = "Goblin.Boss",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Goblin.Overseer" }],
			[1, { BaseID = "Goblin.Shaman" }]
		])
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
