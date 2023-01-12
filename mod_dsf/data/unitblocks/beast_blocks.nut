::DSF.Data.UnitBlocks <- [
    // Purebred Beasts
	{
		ID = "Beast.Direwolves",
		Units = [{ ID = "Beast.Direwolf" }, { ID = "Beast.DirewolfHIGH" }]
	},
	{
		ID = "Beast.Ghouls",
		Units = [{ ID = "Beast.GhoulLOW" }, { ID = "Beast.Ghoul" }, { ID = "Beast.GhoulHIGH" }]
	},
	{
		ID = "Beast.Lindwurms",
		Units = [{ ID = "Beast.Lindwurm" }]
	},
	{
		ID = "Beast.Unholds",
		Units = [{ ID = "Beast.Unhold" }]
	},
	{
		ID = "Beast.UnholdsFrost",
		Units = [{ ID = "Beast.UnholdFrost" }]
	},
	{
		ID = "Beast.UnholdsBog",
		Units = [{ ID = "Beast.UnholdBog" }]
	},
	{
		ID = "Beast.Spiders",
		Units = [{ ID = "Beast.Spider" }]
	},
	{
		ID = "Beast.Alps",
		Units = [{ ID = "Beast.Alp" }]
	},
	{
		ID = "Beast.Schrats",
		Units = [{ ID = "Beast.Schrat" }]
	},
    // Vanilla Kraken skipped at this point
	{
		ID = "Beast.Hyenas",
		Units = [{ ID = "Beast.Hyena" }, { ID = "Beast.HyenaHIGH" }]
	},
	{
		ID = "Beast.Serpents",
		Units = [{ ID = "Beast.Serpent" }]
	},
	{
		ID = "Beast.SandGolems",
		Units = [{ ID = "Beast.SandGolem" }, { ID = "Beast.SandGolemMEDIUM" }, { ID = "Beast.SandGolemHIGH" }]
	},

// Mixed Beasts
	{
		ID = "Beast.HexenNoBodyguards",
		Units = [{ ID = "Beast.Hexe" }]
	},
	{
		ID = "Beast.HexenWithBodyguards",
		Units = [{ ID = "Beast.Hexe" }, { ID = "Beast.HexeOneSpider" }, { ID = "Beast.HexeTwoSpider" }, { ID = "Beast.HexeOneDirewolf" }, { ID = "Beast.HexeTwoDirewolf" }]
	},
	{
		ID = "Beast.HexenNoSpiders",
		Units = [{ ID = "Beast.Hexe" }, { ID = "Beast.HexeOneDirewolf" }, { ID = "Beast.HexeTwoDirewolf" }]
	},
	{
		ID = "Beast.HexenBandits",    // Spawn in HexenFights
		Units = [{ ID = "Bandit.Raider" }]
	},
	{
		ID = "Beast.HexenBanditsRanged",    // Spawn in HexenFights. In Vanilla they only ever spawn a single marksman alongside several raiders. Never more
		Units = [{ ID = "Bandit.Marksman" }]
	},
]

foreach (block in ::DSF.Data.UnitBlocks)
{
    local unitBlockObj = ::new(::DSF.Class.UnitBlock).init(block);
	::DSF.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
