::DSF.Data.UnitBlocks <- [
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
		Units = [{ ID = "Nomad.Executioner" }, { ID = "Nomad.DesertStalker" }, { ID = "DesertDevil" }]
	}
]

foreach (block in ::DSF.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DSF.Class.UnitBlock).init(block);
	::DSF.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
