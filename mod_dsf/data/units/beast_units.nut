::DSF.Data.UnitDefs <- [
        {
            ID = "Beast.Direwolf",
            EntityType = "Direwolf",
            Cost = 20
        },
        {
            ID = "Beast.DirewolfHIGH",
            EntityType = "DirewolfHIGH",
            Cost = 25
        },
        {
            ID = "Beast.GhoulLOW",
            EntityType = "GhoulLOW",
            Cost = 9
        },
        {
            ID = "Beast.Ghoul",
            EntityType = "Ghoul",
            Cost = 19
        },
        {
            ID = "Beast.GhoulHIGH",
            EntityType = "Ghoul",
            Cost = 30
        },
        {
            ID = "Beast.Lindwurm",
            EntityType = "Lindwurm",
            Cost = 90
        },
        {
            ID = "Beast.Unhold",
            EntityType = "Unhold",
            Cost = 50
        },
        {
            ID = "Beast.UnholdFrost",
            EntityType = "UnholdFrost",
            Cost = 60
        },
        {
            ID = "Beast.UnholdBog",
            EntityType = "UnholdBog",
            Cost = 50
        },
        {
            ID = "Beast.Spider",
            EntityType = "Spider",
            Cost = 12
        },
        {
            ID = "Beast.Alp",
            EntityType = "Alp",
            Cost = 30
        },
        {
            ID = "Beast.Hexe",
            EntityType = "Hexe",
            Cost = 50
        },
        {
            ID = "Beast.Schrat",
            EntityType = "Schrat",
            Cost = 70
        },
        {
            ID = "Beast.Kraken",
            EntityType = "Kraken",
            Cost = 200
        },
        {
            ID = "Beast.Hyena",
            EntityType = "Hyena",
            Cost = 20
        },
        {
            ID = "Beast.HyenaHIGH",
            EntityType = "HyenaHIGH",
            Cost = 25
        },
        {
            ID = "Beast.Serpent",
            EntityType = "Serpent",
            Cost = 20
        },
        {
            ID = "Beast.SandGolem",
            EntityType = "SandGolem",
            Cost = 13
        },
        {
            ID = "Beast.SandGolemMEDIUM",
            EntityType = "SandGolemMEDIUM",
            Cost = 42   // 35 in Vanilla, 3 Small Golems should cost slightly less than 1 Medium Golem because they always spend their first turn action morphing
        },
        {
            ID = "Beast.SandGolemHIGH",
            EntityType = "SandGolemHIGH",
            Cost = 129   // 70 in Vanilla
        }

    ]


    foreach (unit in ::DSF.Data.UnitDefs)
    {
        local unitObj = ::new(::DSF.Class.Unit).init(unit);
        ::DSF.Units.LookupMap[unitObj.m.ID] <- unitObj;
        // ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
    }
