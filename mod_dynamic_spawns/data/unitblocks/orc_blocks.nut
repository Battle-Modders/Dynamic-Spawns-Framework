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

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
