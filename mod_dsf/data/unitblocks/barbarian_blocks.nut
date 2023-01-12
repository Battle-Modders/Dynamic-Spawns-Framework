::DSF.Data.UnitBlocks <- [
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

foreach (block in ::DSF.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DSF.Class.UnitBlock).init(block);
	::DSF.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
