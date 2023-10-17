local unitBlocks = [
	{
		ID = "Barbarian.Frontline",
		UnitDefs = [{ BaseID = "Barbarian.Thrall" }, { BaseID = "Barbarian.Marauder", StartingResourceMin = 125 }, { BaseID = "Barbarian.Chosen", StartingResourceMin = 200 }]
	},
	{
		ID = "Barbarian.Support",
		UnitDefs = [{ BaseID = "Barbarian.Drummer" }],
		StartingResourceMin = 200	// In Vanilla they start appearing in a group of 210 cost alongside 15 thralls

	},
	{
		ID = "Barbarian.Dogs",
		UnitDefs = [{ BaseID = "Barbarian.Warhound" }]
	},
	{
		ID = "Barbarian.Beastmaster",
		UnitDefs = [{ BaseID = "Barbarian.BeastmasterU" }, { BaseID = "Barbarian.BeastmasterF" }, { BaseID = "Barbarian.BeastmasterUU" }, { BaseID = "Barbarian.BeastmasterFF" }],
		StartingResourceMin = 200	// In Vanilla they appear in a group of 195 cost
	},
	{
		ID = "Barbarian.HunterFrontline",
		UnitDefs = [{ BaseID = "Barbarian.Thrall" }]
	},

	{
		ID = "Barbarian.Unholds",
		UnitDefs = [{ BaseID = "Barbarian.Unhold" }]
	},
	{
		ID = "Barbarian.UnholdsFrost",
		UnitDefs = [{ BaseID = "Barbarian.UnholdFrost" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
