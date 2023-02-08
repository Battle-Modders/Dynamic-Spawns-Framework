// This Combines Units from spawnlist_zombies and spawnlist_undead

::DynamicSpawns.Data.UnitDefs <- [
// Zombies
    {
        ID = "Undead.Zombie",
        EntityType = "Zombie",
        Figure = "figure_zombie_01",       // Exclusiv
        Cost = 6
    },
    {
        ID = "Undead.ZombieYeoman",
        EntityType = "Zombie",
        Figure = "figure_zombie_02",
        Cost = 12
    },
    {
        ID = "Undead.ZombieNomad",
        EntityType = "ZombieNomad",
        Figure = "figure_zombie_03",
        Cost = 12
    },
    {
        ID = "Undead.FallenHero",     // Fallen Hero
        EntityType = "ZombieKnight",
        Figure = "figure_zombie_03",
        Cost = 24
    },
    {
        ID = "Undead.Necromancer",
        EntityType = "Necromancer",
        Figure = ["figure_necromancer_01", "figure_necromancer_02"],    // In Vanilla 02 is only used for Scourge Spawns. But there they still use 01 randomly aswell
        Cost = 30
    },

// Bodyguards for Necromancer
    {
        ID = "Undead.YeomanBodyguard",
        EntityType = "ZombieYeomanBodyguard",
        Figure = "figure_zombie_02",
        Cost = 12
    },
    {
        ID = "Undead.ZombieNomadBodyguard",
        EntityType = "ZombieNomadBodyguard",
        Figure = "figure_zombie_03",
        Cost = 12
    },
    {
        ID = "Undead.FallenHeroBodyguard",
        EntityType = "ZombieKnightBodyguard",
        Figure = "figure_zombie_03",
        Cost = 24
    },

// Ghosts
    {
        ID = "Undead.Ghost",
        EntityType = "Ghost",
        Figure = "figure_ghost_01",     // Exclusiv
        Cost = 20
    },

// Skeletons
    {
        ID = "Undead.SkeletonLight",
        EntityType = "SkeletonLight",
        Figure = "figure_skeleton_01",      // Exclusiv
        Cost = 13
    },
    {
        ID = "Undead.SkeletonMedium",
        EntityType = "SkeletonMedium",
        Figure = "figure_skeleton_02",
        Cost = 20
    },
    {
        ID = "Undead.SkeletonMediumPolearm",
        EntityType = "SkeletonMediumPolearm",
        Figure = "figure_skeleton_02",
        Cost = 25
    },
    {
        ID = "Undead.SkeletonHeavy",
        EntityType = "SkeletonHeavy",
        Figure = "figure_skeleton_03",
        Cost = 35
    },
    {
        ID = "Undead.SkeletonHeavyPolearm",
        EntityType = "SkeletonHeavyPolearm",
        Figure = "figure_skeleton_03",
        Cost = 35
    },
    {
        ID = "Undead.SkeletonPriest",
        EntityType = "SkeletonHeavy",
        Figure = "figure_skeleton_04",
        Cost = 40
    },

// Bodyguards for Priests
    {
        ID = "Undead.SkeletonHeavyBodyguard",
        EntityType = "SkeletonHeavyBodyguard",
        Figure = "figure_zombie_03",
        Cost = 30
    },

// Vampire
    {
        ID = "Undead.VampireLOW",
        EntityType = "VampireLOW",
        Figure = "figure_vampire_01",       // Exclusiv
        Cost = 30
    },
    {
        ID = "Undead.Vampire",
        EntityType = "Vampire",
        Figure = "figure_vampire_02",       // Exclusiv
        Cost = 40
    }
]

foreach (unit in ::DynamicSpawns.Data.UnitDefs)
{
    local unitObj = ::new(::DynamicSpawns.Class.Unit).init(unit);
    ::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
    // ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
