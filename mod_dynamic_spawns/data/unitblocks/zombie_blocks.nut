local unitBlocks = [
	{
		ID = "Zombie.Frontline",
		UnitDefs = [{ ID = "Undead.Zombie" }, { ID = "Undead.ZombieYeoman" }]
	},
	{
		ID = "Zombie.Light",
		UnitDefs = [{ ID = "Undead.Zombie" }]
	},
	{
		ID = "Zombie.Elite",
		UnitDefs = [{ ID = "Undead.FallenHero" }]
	},
	{
		ID = "Zombie.Southern",
		UnitDefs = [{ ID = "Undead.ZombieNomad" }]
	},
	{
		ID = "Zombie.Necromancer",
		UnitDefs = [{ ID = "Undead.Necromancer" }]
	},
	{
		ID = "Zombie.NecromancerWithBodyguards",
		UnitDefs = [
			{ ID = "Undead.NecromancerY" },
			{ ID = "Undead.NecromancerK" },
			{ ID = "Undead.NecromancerYK" },
			{ ID = "Undead.NecromancerKK" }
		]
	},
	{
		ID = "Zombie.NecromancerWithNomads",
		UnitDefs = [
			{ ID = "Undead.NecromancerN" },
			{ ID = "Undead.NecromancerNN" },
			{ ID = "Undead.NecromancerNNN" }
		]
	},
	{
		ID = "Zombie.Ghost",
		UnitDefs = [{ ID = "Undead.Ghost" }]
	},
	{
		ID = "Zombie.ZombieNomadBodyguard",
		UnitDefs = [
			{ ID = "Zombie.ZombieNomadBodyguard" }
		]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
