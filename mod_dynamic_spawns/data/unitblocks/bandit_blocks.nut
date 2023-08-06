local unitBlocks = [
	{
		ID = "Bandit.Frontline",
		UnitDefs = [{ ID = "Bandit.Thug" }, { ID = "Bandit.RaiderLOW" }, { ID = "Bandit.Raider" }]
	},
	{
		ID = "Bandit.Ranged",
		UnitDefs = [{ ID = "Bandit.MarksmanLOW" }, { ID = "Bandit.Marksman" }]
	},
	{
		ID = "Bandit.Dogs",
		UnitDefs = [{ ID = "Human.Wardog" }]
	},
	{
		ID = "Bandit.Elite",
		UnitDefs = [{ ID = "Human.MasterArcher" }, { ID = "Human.HedgeKnight" }, { ID = "Human.Swordmaster" }]
	},
	{
		ID = "Bandit.Boss",
		UnitDefs = [{ ID = "Bandit.Leader" }]
	},
	{
		ID = "Bandit.DisguisedDirewolf",
		UnitDefs = [{ ID = "Bandit.RaiderWolf" }]
	}
]

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
