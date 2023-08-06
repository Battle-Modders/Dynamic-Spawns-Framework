local unitBlocks = [
	{
		ID = "Barbarian.Frontline",
		UnitDefs = [{ ID = "Barbarian.Thrall" }, { ID = "Barbarian.Marauder" }, { ID = "Barbarian.Chosen" }]
	},
	{
		ID = "Barbarian.Support",
		UnitDefs = [{ ID = "Barbarian.Drummer" }],
		MinStartingResource = 200	// In Vanilla they start appearing in a group of 210 cost alongside 15 thralls

	},
	{
		ID = "Barbarian.Dogs",
		UnitDefs = [{ ID = "Barbarian.Warhound" }]
	},
	{
		ID = "Barbarian.Beastmaster",
		UnitDefs = [{ ID = "Barbarian.BeastmasterU" }, { ID = "Barbarian.BeastmasterF" }, { ID = "Barbarian.BeastmasterUU" }, { ID = "Barbarian.BeastmasterFF" }],
		MinStartingResource = 200	// In Vanilla they appear in a group of 195 cost
	},
	{
		ID = "Barbarian.HunterFrontline",
		UnitDefs = [{ ID = "Barbarian.Thrall" }]
	},

	{
		ID = "Barbarian.Unholds",
		UnitDefs = [{ ID = "Barbarian.Unhold" }]
	},
	{
		ID = "Barbarian.UnholdsFrost",
		UnitDefs = [{ ID = "Barbarian.UnholdFrost" }]
	}
]

foreach (block in unitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
