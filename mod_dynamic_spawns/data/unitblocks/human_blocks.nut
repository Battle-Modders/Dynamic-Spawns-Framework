local unitBlocks = [
	{
		ID = "Mercenary.Frontline",
		UnitDefs = [{ BaseID = "Human.MercenaryLOW" }, { BaseID = "Human.Mercenary" }]
	},
	{
		ID = "Mercenary.Ranged",
		UnitDefs = [{ BaseID = "Human.MercenaryRanged" }]
	},
	{
		ID = "Mercenary.Elite",
		UnitDefs = ::MSU.Class.WeightedContainer([
			[1, { BaseID = "Human.MasterArcher" }],
			[1, { BaseID = "Human.HedgeKnight" }],
			[1, { BaseID = "Human.Swordmaster" }]
		]),
		StartingResourceMin = 286	// In Vanilla MasterArcher appear in a group of 286 cost
	},
	{
		ID = "Human.BountyHunter",
		UnitDefs = [{ BaseID = "Human.BountyHunter" }]
	},
	{
		ID = "Human.BountyHunterRanged",
		UnitDefs = [{ BaseID = "Human.BountyHunterRanged" }]
	},
	{
		ID = "Human.Wardogs",
		UnitDefs = [{ BaseID = "Human.Wardog" }]
	},
	{
		ID = "Human.Slaves",
		UnitDefs = [{ BaseID = "Human.Slave" }]
	},

// Civilians
	{
		ID = "Human.CultistAmbush",
		UnitDefs = [{ BaseID = "Human.CultistAmbush" }]
	},
	{
		ID = "Human.Peasants",
		UnitDefs = [{ BaseID = "Human.Peasant" }]
	},
	{
		ID = "Human.SouthernPeasants",
		UnitDefs = [{ BaseID = "Human.SouthernPeasant" }]
	},
	{
		ID = "Human.PeasantsArmed",
		UnitDefs = [{ BaseID = "Human.PeasantArmed" }]
	},

// Caravans
	{
		ID = "Human.CaravanDonkeys",
		UnitDefs = [{ BaseID = "Human.CaravanDonkey" }]
	},
	{
		ID = "Human.CaravanHands",
		UnitDefs = [{ BaseID = "Human.CaravanHand" }]
	},
	{
		ID = "Human.CaravanGuards",
		UnitDefs = [{ BaseID = "Human.CaravanGuard" }, { BaseID = "Human.Mercenary" }]		// In Vanilla they also allow ranged mercenaries here
	},

// Militia
	{
		ID = "Human.MilitiaFrontline",
		UnitDefs = [{ BaseID = "Human.Militia" }, { BaseID = "Human.MilitiaVeteran" }]
	},
	{
		ID = "Human.MilitiaRanged",
		UnitDefs = [{ BaseID = "Human.MilitiaRanged" }]
	},
	{
		ID = "Human.MilitiaCaptain",
		UnitDefs = [{ BaseID = "Human.MilitiaCaptain" }],
		StartingResourceMin = 144	// In Vanilla they appear in a group of 144 cost
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
