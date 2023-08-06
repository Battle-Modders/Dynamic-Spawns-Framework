local unitBlocks = [
	{
		ID = "Scourge.Boss",
		IsRandom = true,
		UnitDefs = [
			{ ID = "Undead.SkeletonPriestH" },
			{ ID = "Undead.SkeletonPriestHH" },
			{ ID = "Undead.NecromancerYK" },
			{ ID = "Undead.NecromancerKK" }
		]
	},
]

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
