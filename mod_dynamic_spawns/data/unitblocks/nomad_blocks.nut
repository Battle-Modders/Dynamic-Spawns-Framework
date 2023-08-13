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
		IsRandom = true,
		UnitDefs = [{ ID = "Nomad.Executioner" }, { ID = "Nomad.DesertStalker" }, { ID = "Nomad.DesertDevil" }],
		StartingResourceMin = 350	// In Vanilla Executioner appear in a group of 350 cost
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
