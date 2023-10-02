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
		StartingResourceMin = 200	// In Vanilla they appear in a group of 240 cost
	},
	{
		ID = "Noble.Officer",
		UnitDefs = [{ ID = "Noble.Sergeant" }],
		StartingResourceMin = 200	// In Vanilla they appear in a group of 235 cost in noble caravans
	},
	{
		ID = "Noble.Elite",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { ID = "Noble.Zweihander" }],
			[1, { ID = "Noble.Knight" }]
		]),
		StartingResourceMin = 325	// In Vanilla they appear in a group of 235 cost in noble caravans
	},

// Caravan
	{
		ID = "Noble.Donkeys",
		UnitDefs = [{ ID = "Noble.CaravanDonkey" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
