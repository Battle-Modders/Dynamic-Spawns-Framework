local unitBlocks = [
	{
		ID = "Southern.Frontline",
		//UnitDefs = [{ BaseID = "Conscript" }, { BaseID = "Conscript++" }]
		UnitDefs = [{ BaseID = "Southern.Conscript" }]
	},
	{
		ID = "Southern.Backline",
		//UnitDefs = [{ BaseID = "Conscript_Polearm" }, { BaseID = "Conscript_Polearm++" }]
		UnitDefs = [{ BaseID = "Southern.Conscript_Polearm" }]
	},
	{
		ID = "Southern.Assassins",
		// UnitDefs = [{ BaseID = "Assassin" }, { BaseID = "Assassin++" }]
		UnitDefs = [{ BaseID = "Southern.Assassin" }]
	},
	{
		ID = "Southern.Officers",
		//UnitDefs = [{ BaseID = "Officer" }, { BaseID = "Officer++" }]
		UnitDefs = [{ BaseID = "Southern.Officer" }],
		StartingResourceMin = 250	// In Vanilla they appear in a group of 250 cost
	},
	{
		ID = "Southern.Ranged",
		//UnitDefs = [{ BaseID = "Gunner" }, { BaseID = "Gunner++" }]
		UnitDefs = [{ BaseID = "Southern.Gunner" }]
	},
	{
		ID = "Southern.Siege",
		UnitDefs = [{ BaseID = "Southern.Mortar" }],
		StartingResourceMin = 340	// In Vanilla they appear in a group of 340 cost
	},
	{
		ID = "Southern.Engineer",
		UnitDefs = [{ BaseID = "Southern.Engineer" }]
	},
	{
		ID = "Southern.Slaves",
		UnitDefs = [{ BaseID = "Southern.Slave" }]
	},

// Caravan
	{
		ID = "Southern.CaravanDonkeys",
		UnitDefs = [{ BaseID = "Southern.CaravanDonkey" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
