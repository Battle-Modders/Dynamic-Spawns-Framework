::DSS.Data.UnitBlocks <- [
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
	},
   
    // Southern Army
	{
		ID = "Southern.Frontline",
		//Units = [{ ID = "Conscript" }, { ID = "Conscript++" }]
		Units = [{ ID = "Conscript" }]
	},
	{
		ID = "Southern.Backline",
		//Units = [{ ID = "Conscript_Polearm" }, { ID = "Conscript_Polearm++" }]
		Units = [{ ID = "Conscript_Polearm" }]
	},
	{
		ID = "Southern.Assassin",
		// Units = [{ ID = "Assassin" }, { ID = "Assassin++" }]
		Units = [{ ID = "Assassin" }]
	},
	{
		ID = "Southern.Officer",
		//Units = [{ ID = "Officer" }, { ID = "Officer++" }]
		Units = [{ ID = "Officer" }]
	},
	{
		ID = "Southern.Ranged",
		//Units = [{ ID = "Gunner" }, { ID = "Gunner++" }]
		Units = [{ ID = "Gunner" }]
	},
	{
		ID = "Southern.Siege",
		Units = [{ ID = "Mortar" }]
	},
	{
		ID = "Southern.Engineer",
		Units = [{ ID = "Engineer" }]
	}
]

foreach (block in ::DSS.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DSS.Class.UnitBlock).init(block);
	::DSS.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}