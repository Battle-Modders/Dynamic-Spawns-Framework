local unitBlocks = [
	{
		ID = "Bandit.Frontline",
		UnitDefs = [{ ID = "Bandit.Thug" }, { ID = "Bandit.RaiderLOW" }, { ID = "Bandit.Raider" }]
	},
	{
		ID = "Bandit.Ranged",
		UnitDefs = [{ ID = "Bandit.Poacher" }, { ID = "Bandit.Marksman" }]
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

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
