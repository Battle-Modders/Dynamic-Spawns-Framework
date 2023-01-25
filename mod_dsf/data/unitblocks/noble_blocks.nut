::DynamicSpawns.Data.UnitBlocks <- [
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
		Units = [{ ID = "Noble.StandardBearer" }]
	},
	{
		ID = "Noble.Officer",
		Units = [{ ID = "Noble.Sergeant" }]
	},
	{
		ID = "Noble.Elite",
		IsRandom = true,
		Units = [{ ID = "Noble.Zweihander" }, { ID = "Noble.Knight" }]
	},

// Caravan
	{
		ID = "Noble.Donkeys",
		Units = [{ ID = "Noble.CaravanDonkey" }]
	}
]

foreach (block in ::DynamicSpawns.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
