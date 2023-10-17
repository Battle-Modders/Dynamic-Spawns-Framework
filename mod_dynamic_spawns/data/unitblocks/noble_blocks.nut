local unitBlocks = [
	{
		ID = "Noble.Frontline",
		UnitDefs = [{ BaseID = "Noble.Footman" }]
	},
	{
		ID = "Noble.Backline",
		UnitDefs = [{ BaseID = "Noble.Billman" }]
	},
	{
		ID = "Noble.Ranged",
		UnitDefs = [{ BaseID = "Noble.Arbalester" }]
	},
	{
		ID = "Noble.Flank",
		UnitDefs = [{ BaseID = "Noble.ArmoredWardog" }]
	},
	{
		ID = "Noble.Support",
		UnitDefs = [{ BaseID = "Noble.StandardBearer" }],
		StartingResourceMin = 200	// In Vanilla they appear in a group of 240 cost
	},
	{
		ID = "Noble.Officer",
		UnitDefs = [{ BaseID = "Noble.Sergeant" }],
		StartingResourceMin = 200	// In Vanilla they appear in a group of 235 cost in noble caravans
	},
	{
		ID = "Noble.Elite",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Noble.Zweihander" }],
			[1, { BaseID = "Noble.Knight" }]
		]),
		StartingResourceMin = 325	// In Vanilla they appear in a group of 235 cost in noble caravans
	},

// Caravan
	{
		ID = "Noble.Donkeys",
		UnitDefs = [{ BaseID = "Noble.CaravanDonkey" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
