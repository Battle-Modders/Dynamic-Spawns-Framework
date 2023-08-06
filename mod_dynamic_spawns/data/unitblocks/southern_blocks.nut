local unitBlocks = [
	{
		ID = "Southern.Frontline",
		//UnitDefs = [{ ID = "Conscript" }, { ID = "Conscript++" }]
		UnitDefs = [{ ID = "Southern.Conscript" }]
	},
	{
		ID = "Southern.Backline",
		//UnitDefs = [{ ID = "Conscript_Polearm" }, { ID = "Conscript_Polearm++" }]
		UnitDefs = [{ ID = "Southern.Conscript_Polearm" }]
	},
	{
		ID = "Southern.Assassins",
		// UnitDefs = [{ ID = "Assassin" }, { ID = "Assassin++" }]
		UnitDefs = [{ ID = "Southern.Assassin" }]
	},
	{
		ID = "Southern.Officers",
		//UnitDefs = [{ ID = "Officer" }, { ID = "Officer++" }]
		UnitDefs = [{ ID = "Southern.Officer" }],
		MinStartingResource = 250	// In Vanilla they appear in a group of 250 cost
	},
	{
		ID = "Southern.Ranged",
		//UnitDefs = [{ ID = "Gunner" }, { ID = "Gunner++" }]
		UnitDefs = [{ ID = "Southern.Gunner" }]
	},
	{
		ID = "Southern.Siege",
		UnitDefs = [{ ID = "Southern.Mortar" }],
		MinStartingResource = 340	// In Vanilla they appear in a group of 340 cost
	},
	{
		ID = "Southern.Engineer",
		UnitDefs = [{ ID = "Southern.Engineer" }]
	},
	{
		ID = "Southern.Slaves",
		UnitDefs = [{ ID = "Southern.Slave" }]
	},

// Caravan
	{
		ID = "Southern.CaravanDonkeys",
		UnitDefs = [{ ID = "Southern.CaravanDonkey" }]
	}
]

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
