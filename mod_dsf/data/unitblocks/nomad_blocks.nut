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
		Units = [{ ID = "Nomad.Leader" }]
	},
	{
		ID = "Nomad.Elite",
		IsRandom = true,
		Units = [{ ID = "Nomad.Executioner" }, { ID = "Nomad.DesertStalker" }, { ID = "Nomad.DesertDevil" }]
	}
]

foreach (block in ::DynamicSpawns.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
