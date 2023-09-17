local unitBlocks = [
	{
		ID = "Barbarian.Frontline",
		UnitDefs = [{ ID = "Barbarian.Thrall" }, { ID = "Barbarian.Marauder", StartingResourceMin = 125 }, { ID = "Barbarian.Chosen", StartingResourceMin = 200 }]
	},
	{
		ID = "Barbarian.Support",
		UnitDefs = [{ ID = "Barbarian.Drummer" }],
		StartingResourceMin = 200	// In Vanilla they start appearing in a group of 210 cost alongside 15 thralls

	},
	{
		ID = "Barbarian.Dogs",
		UnitDefs = [{ ID = "Barbarian.Warhound" }]
	},
	{
		ID = "Barbarian.Beastmaster",
		UnitDefs = [{ ID = "Barbarian.BeastmasterU" }, { ID = "Barbarian.BeastmasterF" }, { ID = "Barbarian.BeastmasterUU" }, { ID = "Barbarian.BeastmasterFF" }],
		StartingResourceMin = 200	// In Vanilla they appear in a group of 195 cost
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

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
