local parties = [
	{
		ID = "Zombies",
		HardMin = 6,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		UnitBlockDefs = [
			{ ID = "Zombie.Frontline", 	RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 		RatioMin = 0.00, RatioMax = 0.10, StartingResourceMin = 114, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 		RatioMin = 0.00, RatioMax = 0.30, StartingResourceMin = 200, DeterminesFigure = true},		// With 200+ Resources even more Elites can appear
		]
	},
	{
		ID = "Ghosts",
		HardMin = 4,
		DefaultFigure = "figure_ghost_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Zombie.Ghost" }
		]
	},
	{
		ID = "ZombiesAndGhouls",
		HardMin = 8,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		UnitBlockDefs = [
			{ ID = "Zombie.Frontline", 		RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Beast.GhoulLowOnly", 	RatioMin = 0.10, RatioMax = 0.30},
			{ ID = "Zombie.Elite", 			RatioMin = 0.00, RatioMax = 0.10, StartingResourceMin = 150, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 			RatioMin = 0.00, RatioMax = 0.30, StartingResourceMin = 250, DeterminesFigure = true}		// With 250+ Resources even more Elites can appear
		]
	},
	{
		ID = "ZombiesAndGhosts",
		HardMin = 8,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		UnitBlockDefs = [
			{ ID = "Zombie.Frontline", 		RatioMin = 0.00, RatioMax = 1.00, DeterminesFigure = true},
			{ ID = "Zombie.Ghost", 			RatioMin = 0.12, RatioMax = 0.35},
			{ ID = "Zombie.Elite", 			RatioMin = 0.00, RatioMax = 0.10, StartingResourceMin = 150, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 			RatioMin = 0.00, RatioMax = 0.30, StartingResourceMin = 250, DeterminesFigure = true}		// With 250+ Resources even more Elites can appear
		]
	},
	{
		ID = "Necromancer",
		HardMin = 10,
		DefaultFigure = "figure_necromancer_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Zombie.Frontline", 						RatioMin = 0.50, RatioMax = 1.00},
			{ ID = "Zombie.Ghost", 							RatioMin = 0.00, RatioMax = 0.20},
			{ ID = "Zombie.NecromancerWithBodyguards", 		RatioMin = 0.04, RatioMax = 0.09, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 							RatioMin = 0.00, RatioMax = 0.20, StartingResourceMin = 150},
		]
	},
	{
		ID = "NecromancerSouthern",
		HardMin = 4,
		DefaultFigure = "figure_necromancer_01",
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		UnitBlockDefs = [
			{ ID = "Zombie.Southern", 					RatioMin = 0.65, RatioMax = 1.00},
			{ ID = "Zombie.NecromancerWithNomads", 		RatioMin = 0.04, RatioMax = 0.09, DeterminesFigure = true},
			{ ID = "Zombie.Elite", 						RatioMin = 0.00, RatioMax = 0.12, StartingResourceMin = 200},
		]
	},
	{	// Only un-armored zombies
		ID = "ZombiesLight",
		HardMin = 6,
		DefaultFigure = "figure_zombie_01",
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		UnitBlockDefs = [
			{ ID = "Zombie.Light" }
		]
	},

	// SubParties
	{
		ID = "SubPartyYeoman",
		HardMin = 1,
		StaticUnitIDs = [
			"Undead.YeomanBodyguard"
		]
	},
	{
		ID = "SubPartyKnight",
		HardMin = 1,
		StaticUnitIDs = [
			"Undead.FallenHeroBodyguard"
		]
	},
	{
		ID = "SubPartyYeomanKnight",
		HardMin = 2,
		StaticUnitIDs = [
			"Undead.YeomanBodyguard",
			"Undead.FallenHeroBodyguard"
		]
	},
	{
		ID = "SubPartyKnightKnight",
		HardMin = 2,
		StaticUnitIDs = [
			"Undead.FallenHeroBodyguard",
			"Undead.FallenHeroBodyguard"
		]
	},
	{	// The amount is set from outside
		ID = "SubPartyNomad",
		UnitBlockDefs = [
			{
				ID = "Zombie.ZombieNomadBodyguard"
			}
		]
	}
]

foreach(partyDef in parties)
{
	::DynamicSpawns.Public.registerParty(partyDef);
}
