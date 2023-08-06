local unitBlocks = [
	{
		ID = "Mercenary.Frontline",
		UnitDefs = [{ ID = "Human.MercenaryLOW" }, { ID = "Human.Mercenary" }]
	},
	{
		ID = "Mercenary.Ranged",
		UnitDefs = [{ ID = "Human.MercenaryRanged" }]
	},
	{
		ID = "Mercenary.Elite",
		IsRandom = true,
		UnitDefs = [{ ID = "Human.MasterArcher" }, { ID = "Human.HedgeKnight" }, { ID = "Human.Swordmaster" }],
		MinStartingResource = 286	// In Vanilla MasterArcher appear in a group of 286 cost
	},
	{
		ID = "Human.BountyHunter",
		UnitDefs = [{ ID = "Human.BountyHunter" }]
	},
	{
		ID = "Human.BountyHunterRanged",
		UnitDefs = [{ ID = "Human.BountyHunterRanged" }]
	},
	{
		ID = "Human.Wardogs",
		UnitDefs = [{ ID = "Human.Wardog" }]
	},
	{
		ID = "Human.Slaves",
		UnitDefs = [{ ID = "Human.Slave" }]
	},

// Civilians
	{
		ID = "Human.CultistAmbush",
		UnitDefs = [{ ID = "Human.CultistAmbush" }]
	},
	{
		ID = "Human.Peasants",
		UnitDefs = [{ ID = "Human.Peasant" }]
	},
	{
		ID = "Human.SouthernPeasants",
		UnitDefs = [{ ID = "Human.SouthernPeasant" }]
	},
	{
		ID = "Human.PeasantsArmed",
		UnitDefs = [{ ID = "Human.PeasantArmed" }]
	},

// Caravans
	{
		ID = "Human.CaravanDonkeys",
		UnitDefs = [{ ID = "Human.CaravanDonkey" }]
	},
	{
		ID = "Human.CaravanHands",
		UnitDefs = [{ ID = "Human.CaravanHand" }]
	},
	{
		ID = "Human.CaravanGuards",
		UnitDefs = [{ ID = "Human.CaravanGuard" }, { ID = "Human.Mercenary" }]		// In Vanilla they also allow ranged mercenaries here
	},

// Militia
	{
		ID = "Human.MilitiaFrontline",
		UnitDefs = [{ ID = "Human.Militia" }, { ID = "Human.MilitiaVeteran" }]
	},
	{
		ID = "Human.MilitiaRanged",
		UnitDefs = [{ ID = "Human.MilitiaRanged" }]
	},
	{
		ID = "Human.MilitiaCaptain",
		UnitDefs = [{ ID = "Human.MilitiaCaptain" }],
		MinStartingResource = 144	// In Vanilla they appear in a group of 144 cost
	}
]

foreach (block in unitBlocks)
{
    local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
