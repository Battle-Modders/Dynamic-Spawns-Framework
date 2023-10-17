local unitBlocks = [
	{
		ID = "Orc.Young",
		UnitDefs = [{ BaseID = "Orc.YoungLOW" }, { BaseID = "Orc.Young" }]
	},
	{
		ID = "Orc.Warrior",
		UnitDefs = [{ BaseID = "Orc.WarriorLOW" }, { BaseID = "Orc.Warrior" }]
	},
	{
		ID = "Orc.Berserker",
		UnitDefs = [{ BaseID = "Orc.Berserker" }]
	},
	{
		ID = "Orc.Boss",
		UnitDefs = [{ BaseID = "Orc.Warlord" }],
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
