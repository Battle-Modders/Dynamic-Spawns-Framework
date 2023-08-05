local unitBlocks = [
	{
		ID = "Noble.Frontline",
		Units = [{ ID = "Noble.Footman" }]
	},
	{
		ID = "Noble.Backline",
		Units = [{ ID = "Noble.Billman" }]
	},
	{
		ID = "Noble.Ranged",
		Units = [{ ID = "Noble.Arbalester" }]
	},
	{
		ID = "Noble.Flank",
		Units = [{ ID = "Noble.ArmoredWardog" }]
	},
	{
		ID = "Noble.Support",
		Units = [{ ID = "Noble.StandardBearer" }],
		MinStartingResource = 240	// In Vanilla they appear in a group of 240 cost
	},
	{
		ID = "Noble.Officer",
		Units = [{ ID = "Noble.Sergeant" }],
		MinStartingResource = 235	// In Vanilla they appear in a group of 235 cost in noble caravans
	},
	{
		ID = "Noble.Elite",
		IsRandom = true,
		Units = [{ ID = "Noble.Zweihander" }, { ID = "Noble.Knight" }],
		MinStartingResource = 325	// In Vanilla they appear in a group of 235 cost in noble caravans
	},

// Caravan
	{
		ID = "Noble.Donkeys",
		Units = [{ ID = "Noble.CaravanDonkey" }]
	}
]

foreach (block in unitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
