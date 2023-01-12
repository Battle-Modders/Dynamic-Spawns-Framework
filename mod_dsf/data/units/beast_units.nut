::DSF.Data.UnitDefs <- [
        {
            ID = "Beast.Direwolf",
            EntityType = "Direwolf",
            Figure = "figure_werewolf_01",
            Cost = 20
        },
        {
            ID = "Beast.DirewolfHIGH",
            EntityType = "DirewolfHIGH",
            Figure = "figure_werewolf_01",
            Cost = 25
        },
        {
            ID = "Beast.GhoulLOW",
            EntityType = "GhoulLOW",
            Figure = "figure_ghoul_01",
            Cost = 9
        },
        {
            ID = "Beast.Ghoul",
            EntityType = "Ghoul",
            Figure = "figure_ghoul_01",
            Cost = 19
        },
        {
            ID = "Beast.GhoulHIGH",
            EntityType = "Ghoul",
            Figure = "figure_ghoul_02",     // I don't know if a 'figure_ghoul_03' exists
            Cost = 30
        },
        {
            ID = "Beast.Lindwurm",
            EntityType = "Lindwurm",
            Figure = "figure_lindwurm_01",
            Cost = 90
        },
        {
            ID = "Beast.Unhold",
            EntityType = "Unhold",
            Figure = "figure_unhold_01",
            Cost = 50
        },
        {
            ID = "Beast.UnholdFrost",
            EntityType = "UnholdFrost",
            Figure = "figure_unhold_02",
            Cost = 60
        },
        {
            ID = "Beast.UnholdBog",
            EntityType = "UnholdBog",
            Figure = "figure_unhold_03",
            Cost = 50
        },
        {
            ID = "Beast.Spider",
            EntityType = "Spider",
            Figure = "figure_spider_01",
            Cost = 12
        },
        {
            ID = "Beast.Alp",
            EntityType = "Alp",
            Figure = "figure_alp_01",
            Cost = 30
        },
        {
            ID = "Beast.Schrat",
            EntityType = "Schrat",
            Figure = "figure_schrat_01",
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
            Figure = "figure_hyena_01",
            Cost = 20
        },
        {
            ID = "Beast.HyenaHIGH",
            EntityType = "HyenaHIGH",
            Figure = "figure_hyena_01",
            Cost = 25
        },
        {
            ID = "Beast.Serpent",
            EntityType = "Serpent",
            Figure = "figure_serpent_01",
            Cost = 20
        },
        {
            ID = "Beast.SandGolem",
            EntityType = "SandGolem",
            Figure = "figure_golem_01",
            Cost = 13
        },
        {
            ID = "Beast.SandGolemMEDIUM",
            EntityType = "SandGolemMEDIUM",
            Figure = "figure_golem_01",
            Cost = 42   // 35 in Vanilla, 3 Small Golems should cost slightly less than 1 Medium Golem because they always spend their first turn action morphing
        },
        {
            ID = "Beast.SandGolemHIGH",
            EntityType = "SandGolemHIGH",
            Figure = "figure_golem_02",    // I don't know if a 'figure_golem_03' exists
            Cost = 129   // 70 in Vanilla, -!!-
        }
        // Possible Hexen
        {
            ID = "Beast.Hexe",      // Without Bodyguards
            EntityType = "Hexe",
            Figure = "figure_hexe_01",
            Cost = 50
        },
        {
            ID = "Beast.HexeOneSpider",
            EntityType = "Hexe",
            Figure = "figure_hexe_01",
            Cost = 50 + 12 + 12,
            SubParty = "OneSpiderBodyguard"
        },
        {
            ID = "Beast.HexeTwoSpider",
            EntityType = "Hexe",
            Figure = "figure_hexe_01",
            Cost = 50 + 12 + 12,
            SubParty = "TwoSpiderBodyguard"
        },
        {
            ID = "Beast.HexeOneDirewolf",
            EntityType = "Hexe",
            Figure = "figure_hexe_01",
            Cost = 50 + 25,
            SubParty = "OneDirewolfBodyguard"
        },
        {
            ID = "Beast.HexeTwoDirewolf",
            EntityType = "Hexe",
            Figure = "figure_hexe_01",
            Cost = 50 + 25 + 25,
            SubParty = "TwoDirewolfBodyguard"
        },

    ]


    foreach (unit in ::DSF.Data.UnitDefs)
    {
        local unitObj = ::new(::DSF.Class.Unit).init(unit);
        ::DSF.Units.LookupMap[unitObj.m.ID] <- unitObj;
        // ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
    }
