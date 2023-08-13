local unitBlocks = [
	{
		ID = "Orc.Young",
		UnitDefs = [{ ID = "Orc.YoungLOW" }, { ID = "Orc.Young" }]
	},
	{
		ID = "Orc.Warrior",
		UnitDefs = [{ ID = "Orc.WarriorLOW" }, { ID = "Orc.Warrior" }]
	},
	{
		ID = "Orc.Berserker",
		UnitDefs = [{ ID = "Orc.Berserker" }]
	},
	{
		ID = "Orc.Boss",
		UnitDefs = [{ ID = "Orc.Warlord" }],
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
