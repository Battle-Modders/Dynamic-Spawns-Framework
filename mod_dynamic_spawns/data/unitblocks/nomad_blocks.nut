local unitBlocks = [
	{
		ID = "Nomad.Frontline",
		UnitDefs = [{ BaseID = "Nomad.Cutthroat" }, { BaseID = "Nomad.Outlaw" }]
	},
	{
		ID = "Nomad.Ranged",
		UnitDefs = [{ BaseID = "Nomad.Slinger" }, { BaseID = "Nomad.Archer" }]
	},
	{
		ID = "Nomad.Leader",
		UnitDefs = [{ BaseID = "Nomad.Leader" }],
		StartingResourceMin = 170	// In Vanilla they appear in a group of 170 cost
	},
	{
		ID = "Nomad.Elite",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Nomad.Executioner" }],
			[1, { BaseID = "Nomad.DesertStalker" }],
			[1, { BaseID = "Nomad.DesertDevil" }]
		]),
		StartingResourceMin = 350	// In Vanilla Executioner appear in a group of 350 cost
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
