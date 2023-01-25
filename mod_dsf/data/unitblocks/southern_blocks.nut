::DynamicSpawns.Data.UnitBlocks <- [
	{
		ID = "Southern.Frontline",
		//Units = [{ ID = "Conscript" }, { ID = "Conscript++" }]
		Units = [{ ID = "Southern.Conscript" }]
	},
	{
		ID = "Southern.Backline",
		//Units = [{ ID = "Conscript_Polearm" }, { ID = "Conscript_Polearm++" }]
		Units = [{ ID = "Southern.Conscript_Polearm" }]
	},
	{
		ID = "Southern.Assassins",
		// Units = [{ ID = "Assassin" }, { ID = "Assassin++" }]
		Units = [{ ID = "Southern.Assassin" }]
	},
	{
		ID = "Southern.Officers",
		//Units = [{ ID = "Officer" }, { ID = "Officer++" }]
		Units = [{ ID = "Southern.Officer" }]
	},
	{
		ID = "Southern.Ranged",
		//Units = [{ ID = "Gunner" }, { ID = "Gunner++" }]
		Units = [{ ID = "Southern.Gunner" }]
	},
	{
		ID = "Southern.Siege",
		Units = [{ ID = "Southern.Mortar" }]
	},
	{
		ID = "Southern.Engineer",
		Units = [{ ID = "Southern.Engineer" }]
	},
	{
		ID = "Southern.Slaves",
		Units = [{ ID = "Southern.Slave" }]
	},

// Caravan
	{
		ID = "Southern.CaravanDonkeys",
		Units = [{ ID = "Southern.CaravanDonkey" }]
	}
]

foreach (block in ::DynamicSpawns.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
