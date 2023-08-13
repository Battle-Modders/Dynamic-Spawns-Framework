local unitBlocks = [
	{
		ID = "Greenskin.GoblinsFoot",
		UnitDefs = [{ ID = "Goblin.Skirmisher" }, { ID = "Goblin.Ambusher" }],
		IsRandom = true
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
