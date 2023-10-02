local unitBlocks = [
	{
		ID = "Goblin.Frontline",
		UnitDefs =
		[
			{ ID = "Goblin.SkirmisherLOW" },
			{ ID = "Goblin.Skirmisher" }
		]
	},
	{
		ID = "Goblin.Ranged",
		UnitDefs = [
			{ ID = "Goblin.AmbusherLOW" },
			{ ID = "Goblin.Ambusher" }
		]
	},
	{
		ID = "Goblin.Flank",
		UnitDefs = [{ ID = "Goblin.Wolfrider" }]
	},
	{
		ID = "Goblin.Boss",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { ID = "Goblin.Overseer" }],
			[1, { ID = "Goblin.Shaman" }]
		])
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
