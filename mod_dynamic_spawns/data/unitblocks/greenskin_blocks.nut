local unitBlocks = [
	{
		ID = "Greenskin.GoblinsFoot",
		Units = [{ ID = "Goblin.Skirmisher" }, { ID = "Goblin.Ambusher" }],
		IsRandom = true
	}
]

foreach (block in unitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
