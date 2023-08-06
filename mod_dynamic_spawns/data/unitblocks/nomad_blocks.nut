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
		MinStartingResource = 170	// In Vanilla they appear in a group of 170 cost
	},
	{
		ID = "Nomad.Elite",
		IsRandom = true,
		UnitDefs = [{ ID = "Nomad.Executioner" }, { ID = "Nomad.DesertStalker" }, { ID = "Nomad.DesertDevil" }],
		MinStartingResource = 350	// In Vanilla Executioner appear in a group of 350 cost
	}
]

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
