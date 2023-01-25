::DynamicSpawns.Data.UnitBlocks <- [
	{
		ID = "Barbarian.Frontline",
		Units = [{ ID = "Barbarian.Thrall" }, { ID = "Barbarian.Marauder" }, { ID = "Barbarian.Chosen" }]
	},
	{
		ID = "Barbarian.Support",
		Units = [{ ID = "Barbarian.Drummer" }]
	},
	{
		ID = "Barbarian.Dogs",
		Units = [{ ID = "Barbarian.Warhound" }]
	},
	{
		ID = "Barbarian.Beastmaster",
		Units = [{ ID = "Barbarian.BeastmasterU" }, { ID = "Barbarian.BeastmasterF" }, { ID = "Barbarian.BeastmasterUU" }, { ID = "Barbarian.BeastmasterFF" }]
	},
	{
		ID = "Barbarian.HunterFrontline",
		Units = [{ ID = "Barbarian.Thrall" }]
	},

	{
		ID = "Barbarian.Unholds",
		Units = [{ ID = "Barbarian.Unhold" }]
	},
	{
		ID = "Barbarian.UnholdsFrost",
		Units = [{ ID = "Barbarian.UnholdFrost" }]
	}
]

foreach (block in ::DynamicSpawns.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
