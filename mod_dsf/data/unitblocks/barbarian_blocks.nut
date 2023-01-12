::DSF.Data.UnitBlocks <- [
    // Barbarians
	{
		ID = "Barbarian.Frontline",
		Units = [{ ID = "Thrall" }, { ID = "Marauder" }, { ID = "Chosen" }]
	},
	{
		ID = "Barbarian.Support",
		Units = [{ ID = "Drummer" }]
	},
	{
		ID = "Barbarian.Flank",
		Units = [{ ID = "Warhound" }]
	},
	{
		ID = "Barbarian.Beastmaster",
		Units = [{ ID = "BeastmasterU" }, { ID = "BeastmasterF" }, { ID = "BeastmasterUU" }, { ID = "BeastmasterFF" }]
	},
	{
		ID = "Barbarian.Unhold",
		Units = [{ ID = "Unhold" }]
	},
	{
		ID = "Barbarian.UnholdFrost",
		Units = [{ ID = "UnholdFrost" }]
	}
]

foreach (block in ::DSF.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DSF.Class.UnitBlock).init(block);
	::DSF.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
