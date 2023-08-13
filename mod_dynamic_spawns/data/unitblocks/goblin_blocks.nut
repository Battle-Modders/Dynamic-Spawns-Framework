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
		IsRandom = true,
		UnitDefs = [
			{ ID = "Goblin.Overseer" },
			{ ID = "Goblin.Shaman" }
		]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
