local unitBlocks = [
	// Purebred Beasts
	{
		ID = "Beast.Direwolves",
		UnitDefs = [{ ID = "Beast.Direwolf" }, { ID = "Beast.DirewolfHIGH" }]
	},
	{
		ID = "Beast.GhoulLowOnly",
		UnitDefs = [{ ID = "Beast.GhoulLOW" }]
	},
	{
		ID = "Beast.Ghouls",
		UnitDefs = [{ ID = "Beast.GhoulLOW" }, { ID = "Beast.Ghoul" }, { ID = "Beast.GhoulHIGH" }]
	},
	{
		ID = "Beast.Lindwurms",
		UnitDefs = [{ ID = "Beast.Lindwurm" }]
	},
	{
		ID = "Beast.Unholds",
		UnitDefs = [{ ID = "Beast.Unhold" }]
	},
	{
		ID = "Beast.UnholdsFrost",
		UnitDefs = [{ ID = "Beast.UnholdFrost" }]
	},
	{
		ID = "Beast.UnholdsBog",
		UnitDefs = [{ ID = "Beast.UnholdBog" }]
	},
	{
		ID = "Beast.Spiders",
		UnitDefs = [{ ID = "Beast.Spider" }]
	},
	{
		ID = "Beast.Alps",
		UnitDefs = [{ ID = "Beast.Alp" }]
	},
	{
		ID = "Beast.Schrats",
		UnitDefs = [{ ID = "Beast.Schrat" }]
	},
	// Vanilla Kraken skipped at this point
	{
		ID = "Beast.Hyenas",
		UnitDefs = [{ ID = "Beast.Hyena" }, { ID = "Beast.HyenaHIGH" }]
	},
	{
		ID = "Beast.Serpents",
		UnitDefs = [{ ID = "Beast.Serpent" }]
	},
	{
		ID = "Beast.SandGolems",
		UnitDefs = [{ ID = "Beast.SandGolem" }, { ID = "Beast.SandGolemMEDIUM" }, { ID = "Beast.SandGolemHIGH" }]
	},

// Mixed Beasts
	{
		ID = "Beast.HexenNoBodyguards",
		UnitDefs = [{ ID = "Beast.Hexe" }]
	},
	{
		ID = "Beast.HexenWithBodyguards",
		UnitDefs = [{ ID = "Beast.Hexe" }, { ID = "Beast.HexeOneSpider" }, { ID = "Beast.HexeTwoSpider" }, { ID = "Beast.HexeOneDirewolf" }, { ID = "Beast.HexeTwoDirewolf" }]
	},
	{
		ID = "Beast.HexenNoSpiders",
		UnitDefs = [{ ID = "Beast.Hexe" }, { ID = "Beast.HexeOneDirewolf" }, { ID = "Beast.HexeTwoDirewolf" }]
	},
	{
		ID = "Beast.HexenBandits",    // Spawn in HexenFights
		UnitDefs = [{ ID = "Bandit.Raider" }]
	},
	{
		ID = "Beast.HexenBanditsRanged",    // Spawn in HexenFights. In Vanilla they only ever spawn a single marksman alongside several raiders. Never more
		UnitDefs = [{ ID = "Bandit.Marksman" }]
	},

// Bodyguards
	{
		ID = "Beast.SpiderBodyguards",
		UnitDefs = [{ ID = "Bandit.SpiderBodyguard" }]
	},
	{
		ID = "Beast.DirewolfBodyguards",
		UnitDefs = [{ ID = "Bandit.DirewolfBodyguard" }]
	}
]

foreach (block in unitBlocks)
{
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(block);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
}
