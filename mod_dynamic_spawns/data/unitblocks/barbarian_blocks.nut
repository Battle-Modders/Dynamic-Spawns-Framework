local unitBlocks = [
	{
		ID = "Barbarian.Frontline",
		Units = [{ ID = "Barbarian.Thrall" }, { ID = "Barbarian.Marauder" }, { ID = "Barbarian.Chosen" }]
	},
	{
		ID = "Barbarian.Support",
		Units = [{ ID = "Barbarian.Drummer" }],
		MinStartingResource = 200	// In Vanilla they start appearing in a group of 210 cost alongside 15 thralls

	},
	{
		ID = "Barbarian.Dogs",
		Units = [{ ID = "Barbarian.Warhound" }]
	},
	{
		ID = "Barbarian.Beastmaster",
		Units = [{ ID = "Barbarian.BeastmasterU" }, { ID = "Barbarian.BeastmasterF" }, { ID = "Barbarian.BeastmasterUU" }, { ID = "Barbarian.BeastmasterFF" }],
		MinStartingResource = 200	// In Vanilla they appear in a group of 195 cost
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

foreach (block in unitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
