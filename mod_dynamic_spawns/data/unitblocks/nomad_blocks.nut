::DynamicSpawns.Data.UnitBlocks <- [
	{
		ID = "Nomad.Frontline",
		Units = [{ ID = "Nomad.Cutthroat" }, { ID = "Nomad.Outlaw" }]
	},
	{
		ID = "Nomad.Ranged",
		Units = [{ ID = "Nomad.Slinger" }, { ID = "Nomad.Archer" }]
	},
	{
		ID = "Nomad.Leader",
		Units = [{ ID = "Nomad.Leader" }],
		MinStartingResource = 170	// In Vanilla they appear in a group of 170 cost
	},
	{
		ID = "Nomad.Elite",
		IsRandom = true,
		Units = [{ ID = "Nomad.Executioner" }, { ID = "Nomad.DesertStalker" }, { ID = "Nomad.DesertDevil" }],
		MinStartingResource = 350	// In Vanilla Executioner appear in a group of 350 cost
	}
]

foreach (block in ::DynamicSpawns.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
