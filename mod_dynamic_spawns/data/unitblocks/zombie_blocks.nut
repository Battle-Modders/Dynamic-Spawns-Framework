local unitBlocks = [
	{
		ID = "Zombie.Frontline",
		UnitDefs = [{ BaseID = "Undead.Zombie" }, { BaseID = "Undead.ZombieYeoman" }, { BaseID = "Undead.FallenHero" }]
	},
	{
		ID = "Zombie.Light",
		UnitDefs = [{ BaseID = "Undead.Zombie" }]
	},
	{
		ID = "Zombie.Elite",
		UnitDefs = [{ BaseID = "Undead.FallenHero" }]
	},
	{
		ID = "Zombie.Southern",
		UnitDefs = [{ BaseID = "Undead.ZombieNomad" }]
	},
	{
		ID = "Zombie.Necromancer",
		UnitDefs = [{ BaseID = "Undead.Necromancer" }]
	},
	{
		ID = "Zombie.NecromancerWithBodyguards",
		UnitDefs = [
			{ BaseID = "Undead.NecromancerY" },
			{ BaseID = "Undead.NecromancerK" },
			{ BaseID = "Undead.NecromancerYK" },
			{ BaseID = "Undead.NecromancerKK" }
		]
	},
	{
		ID = "Zombie.NecromancerWithNomads",
		UnitDefs = [
			{ BaseID = "Undead.NecromancerN" },
			{ BaseID = "Undead.NecromancerNN" },
			{ BaseID = "Undead.NecromancerNNN" }
		]
	},
	{
		ID = "Zombie.Ghost",
		UnitDefs = [{ BaseID = "Undead.Ghost" }]
	},
	{
		ID = "Zombie.ZombieNomadBodyguard",
		UnitDefs = [
			{ BaseID = "Undead.ZombieNomadBodyguard" }
		]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
