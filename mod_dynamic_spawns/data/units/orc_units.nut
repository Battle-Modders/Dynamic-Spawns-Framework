::DynamicSpawns.Data.UnitDefs <- [
    {
        ID = "Orc.YoungLOW",
        EntityType = "OrcYoungLOW",
        Figure = "figure_orc_01",       // I assume this is OrcYoung without Armor and without Helmet
        Cost = 13
    },
    {
        ID = "Orc.Young",
        EntityType = "OrcYoung",
        Figure = ["figure_orc_02", "figure_orc_06"],       // I assume this is OrcYoung only with Helmet (02) and OrcYoung only with Armor (06)
        Cost = 16
    },
    {
        ID = "Orc.Berserker",
        EntityType = "OrcBerserker",
        Figure = "figure_orc_03"        // I'm sure this is OrcBerserker
        Cost = 25
    },
    {
        ID = "Orc.WarriorLOW",
        EntityType = "OrcWarriorLOW",
        Figure = "figure_orc_04"        // I'm sure this is OrcWarrior
        Cost = 30
    },
    {
        ID = "Orc.Warrior",
        EntityType = "OrcWarrior",
        Figure = "figure_orc_04",       // I'm sure this is OrcWarrior
        Cost = 40
    },
    {
        ID = "Orc.Warlord",
        EntityType = "OrcWarlord",
        Figure = "figure_orc_05",       // I'm sure this is OrcWarlord
        Cost = 50
    }
]

foreach (unit in ::DynamicSpawns.Data.UnitDefs)
{
    local unitObj = ::new(::DynamicSpawns.Class.Unit).init(unit);
    ::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
    // ::logWarning("Added the unit: '" + unitObj.m.ID + "'");
}
