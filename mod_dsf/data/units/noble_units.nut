::DSF.Data.UnitDefs <- [
        {
            ID = "Noble.Footman",
            EntityType = "Footman",
            Cost = 20
        },
        {
            ID = "Noble.Billman",
            EntityType = "Billman",
            Cost = 15
        },
        {
            ID = "Noble.Arbalester",
            EntityType = "Arbalester",
            Cost = 20
        },
        {
            ID = "Noble.ArmoredWardog",
            EntityType = "ArmoredWardog",
            Cost = 8
        },
        {
            ID = "Noble.StandardBearer",
            EntityType = "StandardBearer",
            Cost = 20,
            Figure = "figure_noble_02"
        },
        {
            ID = "Noble.Sergeant",
            EntityType = "Sergeant",
            Cost = 25,
            Figure = "figure_noble_02"
        },
        {
            ID = "Noble.Zweihander",
            EntityType = "Greatsword",
            Cost = 25
        },
        {
            ID = "Noble.Knight",
            EntityType = "Knight",
            Cost = 35,
            Figure = "figure_noble_03"
        }
    ]

    foreach (unit in ::DSF.Data.UnitDefs)
    {
        local unitObj = ::new(::DSF.Class.Unit).init(unit);
        ::DSF.Units.LookupMap[unitObj.m.ID] <- unitObj;
        // ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
    }
