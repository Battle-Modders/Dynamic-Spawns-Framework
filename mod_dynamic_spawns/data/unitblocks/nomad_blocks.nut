local unitBlocks = [
	{
		ID = "Nomad.Frontline",
		UnitDefs = [{ ID = "Nomad.Cutthroat" }, { ID = "Nomad.Outlaw" }]
	},
	{
		ID = "Nomad.Ranged",
		UnitDefs = [{ ID = "Nomad.Slinger" }, { ID = "Nomad.Archer" }]
	},
	{
		ID = "Nomad.Leader",
		UnitDefs = [{ ID = "Nomad.Leader" }],
		StartingResourceMin = 170	// In Vanilla they appear in a group of 170 cost
	},
	{
		ID = "Nomad.Elite",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { ID = "Nomad.Executioner" }],
			[1, { ID = "Nomad.DesertStalker" }],
			[1, { ID = "Nomad.DesertDevil" }]
		]),
		StartingResourceMin = 350	// In Vanilla Executioner appear in a group of 350 cost
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
