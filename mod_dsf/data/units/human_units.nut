::DSF.Data.UnitDefs <- [
// Civilians
    {
        ID = "Human.Peasant",
        EntityType = "Peasant",
        Cost = 10,
        Figure = "figure_civilian_01"
    },
    {
        ID = "Human.PeasantArmed",
        EntityType = "PeasantArmed",
        Cost = 10,
        Figure = "figure_civilian_01"
    },
    {
        ID = "Human.SouthernPeasant",
        EntityType = "SouthernPeasant",
        Cost = 10
    },
    {
        ID = "Human.CultistAmbush",
        EntityType = "CultistAmbush",
        Cost = 15,
        Figure = "figure_civilian_03"
    },

// Caravans
    {
        ID = "Human.CaravanHand",
        EntityType = "CaravanHand",
        Cost = 10
    },
    {
        ID = "Human.CaravanGuard",
        EntityType = "CaravanGuard",
        Cost = 14
    },
    {
        ID = "Human.CaravanDonkey",
        EntityType = "CaravanDonkey",
        Cost = 10,      // 0 in Vanilla
        Figure = "cart_02"
    },

// Militia
    {
        ID = "Human.Militia",
        EntityType = "Militia",
        Cost = 10
    },
    {
        ID = "Human.MilitiaRanged",
        EntityType = "MilitiaRanged",
        Cost = 10
    },
    {
        ID = "Human.MilitiaVeteran",
        EntityType = "MilitiaVeteran",
        Cost = 15   // Vanilla 12
    },
    {
        ID = "Human.MilitiaCaptain",
        EntityType = "MilitiaCaptain",
        Cost = 20
    },

// Mercenaries
    {
        ID = "Human.BountyHunter",
        EntityType = "BountyHunter",
        Cost = 25
    },
    {
        ID = "Human.BountyHunterRanged",
        EntityType = "BountyHunterRanged",
        Cost = 20
    },
    {
        ID = "Human.Wardog",
        EntityType = "Wardog",
        Cost = 8
    },

    {
        ID = "Human.MercenaryLOW",
        EntityType = "MercenaryLOW",
        Cost = 18
    },
    {
        ID = "Human.Mercenary",
        EntityType = "Mercenary",
        Cost = 25
    },
    {
        ID = "Human.MercenaryRanged",
        EntityType = "MercenaryRanged",
        Cost = 25
    },
    {
        ID = "Human.MasterArcher",
        EntityType = "MasterArcher",
        Cost = 40
    },
    {
        ID = "Human.HedgeKnight",
        EntityType = "HedgeKnight",
        Cost = 40
    },
    {
        ID = "Human.Swordmaster",
        EntityType = "Swordmaster",
        Cost = 40
    }
]

/*
While there are ["figure_militia_01", "figure_militia_02"] it seems like they are just variations of the same tier of figure and interchangable.
*/

foreach (unit in ::DSF.Data.UnitDefs)
{
    local unitObj = ::new(::DSF.Class.Unit).init(unit);
    ::DSF.Units.LookupMap[unitObj.m.ID] <- unitObj;
    // ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
