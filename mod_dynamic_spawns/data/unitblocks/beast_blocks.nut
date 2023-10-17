local unitBlocks = [
	// Purebred Beasts
	{
		ID = "Beast.Direwolves",
		UnitDefs = [{ BaseID = "Beast.Direwolf" }, { BaseID = "Beast.DirewolfHIGH" }]
	},
	{
		ID = "Beast.GhoulLowOnly",
		UnitDefs = [{ BaseID = "Beast.GhoulLOW" }]
	},
	{
		ID = "Beast.Ghouls",
		UnitDefs = [{ BaseID = "Beast.GhoulLOW" }, { BaseID = "Beast.Ghoul", StartingResourceMin = 125 }, { BaseID = "Beast.GhoulHIGH", StartingResourceMin = 175 }]
	},
	{
		ID = "Beast.Lindwurms",
		UnitDefs = [{ BaseID = "Beast.Lindwurm" }]
	},
	{
		ID = "Beast.Unholds",
		UnitDefs = [{ BaseID = "Beast.Unhold" }]
	},
	{
		ID = "Beast.UnholdsFrost",
		UnitDefs = [{ BaseID = "Beast.UnholdFrost" }]
	},
	{
		ID = "Beast.UnholdsBog",
		UnitDefs = [{ BaseID = "Beast.UnholdBog" }]
	},
	{
		ID = "Beast.Spiders",
		UnitDefs = [{ BaseID = "Beast.Spider" }]
	},
	{
		ID = "Beast.Alps",
		UnitDefs = [{ BaseID = "Beast.Alp" }]
	},
	{
		ID = "Beast.Schrats",
		UnitDefs = [{ BaseID = "Beast.Schrat" }]
	},
	// Vanilla Kraken skipped at this point
	{
		ID = "Beast.Hyenas",
		UnitDefs = [{ BaseID = "Beast.Hyena" }, { BaseID = "Beast.HyenaHIGH" }]
	},
	{
		ID = "Beast.Serpents",
		UnitDefs = [{ BaseID = "Beast.Serpent" }]
	},
	{
		ID = "Beast.SandGolems",
		UnitDefs = [{ BaseID = "Beast.SandGolem" }, { BaseID = "Beast.SandGolemMEDIUM" }, { BaseID = "Beast.SandGolemHIGH" }]
	},

// Mixed Beasts
	{
		ID = "Beast.HexenNoBodyguards",
		UnitDefs = [{ BaseID = "Beast.Hexe" }]
	},
	{
		ID = "Beast.HexenWithBodyguards",
		UnitDefs = [{ BaseID = "Beast.Hexe" }, { BaseID = "Beast.HexeOneSpider" }, { BaseID = "Beast.HexeTwoSpider" }, { BaseID = "Beast.HexeOneDirewolf" }, { BaseID = "Beast.HexeTwoDirewolf" }]
	},
	{
		ID = "Beast.HexenNoSpiders",
		UnitDefs = [{ BaseID = "Beast.Hexe" }, { BaseID = "Beast.HexeOneDirewolf" }, { BaseID = "Beast.HexeTwoDirewolf" }]
	},
	{
		ID = "Beast.HexenBandits",    // Spawn in HexenFights
		UnitDefs = [{ BaseID = "Bandit.Raider" }]
	},
	{
		ID = "Beast.HexenBanditsRanged",    // Spawn in HexenFights. In Vanilla they only ever spawn a single marksman alongside several raiders. Never more
		UnitDefs = [{ BaseID = "Bandit.Marksman" }]
	},

// Bodyguards
	{
		ID = "Beast.SpiderBodyguards",
		UnitDefs = [{ BaseID = "Beast.SpiderBodyguard" }]
	},
	{
		ID = "Beast.DirewolfBodyguards",
		UnitDefs = [{ BaseID = "Beast.DirewolfBodyguard" }]
	}
]

foreach (blockDef in unitBlocks)
{
	::DynamicSpawns.Public.registerUnitBlock(blockDef);
}
