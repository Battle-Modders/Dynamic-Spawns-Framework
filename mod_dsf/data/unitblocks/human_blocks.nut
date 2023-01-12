::DSF.Data.UnitBlocks <- [
	{
		ID = "Mercenary.Frontline",
		Units = [{ ID = "Human.MercenaryLOW" }, { ID = "Human.Mercenary" }]
	},
	{
		ID = "Mercenary.Ranged",
		Units = [{ ID = "Human.MercenaryRanged" }]
	},
	{
		ID = "Mercenary.Elite",
		Units = [{ ID = "Human.MasterArcher" }, { ID = "Human.HedgeKnight" }, { ID = "Human.Swordmaster" }]
	},
	{
		ID = "Human.BountyHunter",
		Units = [{ ID = "Human.BountyHunter" }]
	},
	{
		ID = "Human.BountyHunterRanged",
		Units = [{ ID = "Human.BountyHunterRanged" }]
	},
	{
		ID = "Human.Wardogs",
		Units = [{ ID = "Human.Wardog" }]
	},
	{
		ID = "Human.Slaves",
		Units = [{ ID = "Human.Slave" }]
	},

// Civilians
	{
		ID = "Human.CultistAmbush",
		Units = [{ ID = "Human.CultistAmbush" }]
	},
	{
		ID = "Human.Peasants",
		Units = [{ ID = "Human.Peasant" }]
	},
	{
		ID = "Human.SouthernPeasants",
		Units = [{ ID = "Human.SouthernPeasant" }]
	},
	{
		ID = "Human.PeasantsArmed",
		Units = [{ ID = "Human.PeasantArmed" }]
	},

// Caravans
	{
		ID = "Human.CaravanDonkeys",
		Units = [{ ID = "Human.CaravanDonkey" }]
	},
	{
		ID = "Human.CaravanHands",
		Units = [{ ID = "Human.CaravanHand" }]
	},
	{
		ID = "Human.CaravanGuards",
		Units = [{ ID = "Human.CaravanGuard" }, { ID = "Human.Mercenary" }]		// In Vanilla they also allow ranged mercenaries here
	},

// Militia
	{
		ID = "Human.MilitiaFrontline",
		Units = [{ ID = "Human.Militia" }, { ID = "Human.MilitiaVeteran" }]
	},
	{
		ID = "Human.MilitiaRanged",
		Units = [{ ID = "Human.MilitiaRanged" }]
	},
	{
		ID = "Human.MilitiaCaptain",
		Units = [{ ID = "Human.MilitiaCaptain" }]
	}
]

foreach (block in ::DSF.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DSF.Class.UnitBlock).init(block);
	::DSF.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
