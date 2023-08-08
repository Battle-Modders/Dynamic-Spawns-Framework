local unitBlocks = [
	{
		ID = "Noble.Frontline",
		UnitDefs = [{ ID = "Noble.Footman" }]
	},
	{
		ID = "Noble.Backline",
		UnitDefs = [{ ID = "Noble.Billman" }]
	},
	{
		ID = "Noble.Ranged",
		UnitDefs = [{ ID = "Noble.Arbalester" }]
	},
	{
		ID = "Noble.Flank",
		UnitDefs = [{ ID = "Noble.ArmoredWardog" }]
	},
	{
		ID = "Noble.Support",
		UnitDefs = [{ ID = "Noble.StandardBearer" }],
		StartingResourceMin = 240	// In Vanilla they appear in a group of 240 cost
	},
	{
		ID = "Noble.Officer",
		UnitDefs = [{ ID = "Noble.Sergeant" }],
		StartingResourceMin = 235	// In Vanilla they appear in a group of 235 cost in noble caravans
	},
	{
		ID = "Noble.Elite",
		IsRandom = true,
		UnitDefs = [{ ID = "Noble.Zweihander" }, { ID = "Noble.Knight" }],
		StartingResourceMin = 325	// In Vanilla they appear in a group of 235 cost in noble caravans
	},

// Caravan
	{
		ID = "Noble.Donkeys",
		UnitDefs = [{ ID = "Noble.CaravanDonkey" }]
	}
]

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
