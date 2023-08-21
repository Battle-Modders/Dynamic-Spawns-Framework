// This Combines Units from spawnlist_zombies and spawnlist_undead

local units = [
// Zombies
	{
		ID = "Undead.Zombie",
		Troop = "Zombie",
		Figure = "figure_zombie_01",       // Exclusiv
		Cost = 6
	},
	{
		ID = "Undead.ZombieYeoman",
		Troop = "Zombie",
		Figure = "figure_zombie_02",
		Cost = 12
	},
	{
		ID = "Undead.ZombieNomad",
		Troop = "ZombieNomad",
		Figure = "figure_zombie_03",
		Cost = 12
	},
	{
		ID = "Undead.FallenHero",     // Fallen Hero
		Troop = "ZombieKnight",
		Figure = "figure_zombie_03",
		Cost = 24
	},
	{
		ID = "Undead.Necromancer",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],    // In Vanilla 02 is only used for Scourge Spawns. But there they still use 01 randomly aswell
		Cost = 30
	},

// Necromancer with Bodyguards
	{
		ID = "Undead.NecromancerY",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 12,
		SubPartyDef = {ID = "SubPartyYeoman"}
	},
	{
		ID = "Undead.NecromancerK",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 24,
		SubPartyDef = {ID = "SubPartyKnight"}
	},
	{
		ID = "Undead.NecromancerYK",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 12 + 24,
		SubPartyDef = {ID = "SubPartyYeomanKnight"}
	},
	{
		ID = "Undead.NecromancerKK",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 24 + 24,
		SubPartyDef = {ID = "SubPartyKnightKnight"}
	},

// Necromancer with Nomad Bodyguards
	{
		ID = "Undead.NecromancerN",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 12,
		SubPartyDef = { ID = "SubPartyNomad", HardMin = 1, HardMax = 1 }
	},
	{
		ID = "Undead.NecromancerNN",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 12 + 12,
		SubPartyDef = { ID = "SubPartyNomad", HardMin = 2, HardMax = 2 }
	},
	{
		ID = "Undead.NecromancerNNN",
		Troop = "Necromancer",
		Figure = ["figure_necromancer_01", "figure_necromancer_02"],
		Cost = 30 + 12 + 12 + 12,
		SubPartyDef = { ID = "SubPartyNomad", HardMin = 3, HardMax = 3 }
	}

// Bodyguards for Necromancer
	{
		ID = "Undead.YeomanBodyguard",
		Troop = "ZombieYeomanBodyguard",
		Figure = "figure_zombie_02",
		Cost = 12
	},
	{
		ID = "Undead.ZombieNomadBodyguard",
		Troop = "ZombieNomadBodyguard",
		Figure = "figure_zombie_03",
		Cost = 12
	},
	{
		ID = "Undead.FallenHeroBodyguard",
		Troop = "ZombieKnightBodyguard",
		Figure = "figure_zombie_03",
		Cost = 24
	},

// Ghosts
	{
		ID = "Undead.Ghost",
		Troop = "Ghost",
		Figure = "figure_ghost_01",     // Exclusiv
		Cost = 20
	},

// Skeletons
	{
		ID = "Undead.SkeletonLight",
		Troop = "SkeletonLight",
		Figure = "figure_skeleton_01",      // Exclusiv
		Cost = 13
	},
	{
		ID = "Undead.SkeletonMedium",
		Troop = "SkeletonMedium",
		Figure = "figure_skeleton_02",
		Cost = 20
	},
	{
		ID = "Undead.SkeletonMediumPolearm",
		Troop = "SkeletonMediumPolearm",
		Figure = "figure_skeleton_02",
		Cost = 25
	},
	{
		ID = "Undead.SkeletonHeavy",
		Troop = "SkeletonHeavy",
		Figure = "figure_skeleton_03",
		Cost = 35
	},
	{
		ID = "Undead.SkeletonHeavyPolearm",
		Troop = "SkeletonHeavyPolearm",
		Figure = "figure_skeleton_03",
		Cost = 35
	},
	{
		ID = "Undead.SkeletonPriest",
		Troop = "SkeletonHeavy",
		Figure = "figure_skeleton_04",
		Cost = 40
	},
	{
		ID = "Undead.SkeletonPriestH",
		Troop = "Necromancer",
		Figure = "figure_skeleton_04",
		Cost = 30 + 12,
		SubPartyDef = {ID = "SubPartyYeoman"}
	},
	{
		ID = "Undead.SkeletonPriestHH",
		Troop = "Necromancer",
		Figure = "figure_skeleton_04",
		Cost = 30 + 24,
		SubPartyDef = {ID = "SubPartyKnight"}
	},

// Bodyguards for Priests
	{
		ID = "Undead.SkeletonHeavyBodyguard",
		Troop = "SkeletonHeavyBodyguard",
		Figure = "figure_zombie_03",
		Cost = 30
	},

// Vampire
	{
		ID = "Undead.VampireLOW",
		Troop = "VampireLOW",
		Figure = "figure_vampire_01",       // Exclusiv
		Cost = 30
	},
	{
		ID = "Undead.Vampire",
		Troop = "Vampire",
		Figure = "figure_vampire_02",       // Exclusiv
		Cost = 40
	}
]

foreach (unitDef in units)
{
	::DynamicSpawns.Public.registerUnit(unitDef);
}
