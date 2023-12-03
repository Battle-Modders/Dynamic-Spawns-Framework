// A party can contain all types (Unit, UnitBlock, Party) as DynamicSpawnables and StaticSpawnables
::DynamicSpawns.Class.Party <- class extends ::DynamicSpawns.Class.Spawnable
{
	UpgradeChance = 0.75; // A higher value makes it more likely to upgrade a unit after the party size exceeds IdealSize
	DefaultResources = 0;
	IdealSizeLocationMult = 1.5; // The value generated by generateIdealSize() is multiplied by this value for locations
	IsUsingTopPartyResources = true; // If true then spawns/upgrades in this party consume resources from the top party, otherwise from this party's own resources. Useful for subparties of units.

	DefaultFigure = "";
	MovementSpeedMult = 1.0;
	VisibilityMult = 1.0;
	VisionMult = 1.0;

	__SpawnAffordables = null; // WeightedContainer that is populated during doCycle with spawnables to roll from
	__UpgradeAffordables = null; // WeightedContainer that is populated during doCycle with spawnables to roll from
	__ForcedSpawnable = null; // Used during prepareAffordables to signify a spawnable that should be forced to spawn (typically because of being below its RatioMin)
	__StartingResources = 0; // Starting resources at the start of the spawning process
	__Resources = 0; // Current resources during spawning
	__IdealSize = 6; // The party does not try to upgrade any unit before IdealSize is reached
	__IsLocation = false;

	function init()
	{
		base.init();
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.setParty(this);
		}
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.setParty(this);
		}
		this.__SpawnAffordables = ::MSU.Class.WeightedContainer();
		this.__UpgradeAffordables = ::MSU.Class.WeightedContainer();
		return this;
	}

	function spawn( _resources = null )
	{
		this.setupResources(_resources);
		this.__IdealSize = this.generateIdealSize();
		if (this.__IsLocation) this.__IdealSize *= this.IdealSizeLocationMult;

		this.__SpawnAffordables = ::MSU.Class.WeightedContainer();
		this.__UpgradeAffordables = ::MSU.Class.WeightedContainer();

		if (::DynamicSpawns.Const.Logging)
		{
			::DynamicSpawns.Indent++;
			::logWarning(format("%sStarting spawn of party %s with resources: %.1f", ::DynamicSpawns.getIndent(), this.getID(), this.getStartingResources()));
		}

		this.excludeSpawnables();
		this.callOnBeforeSpawnStart();

		base.spawn();
		while (this.canDoAnotherCycle())
		{
			if (this.__ForcedSpawnable != null)
			{
				if (::DynamicSpawns.Const.DetailedLogging) ::logInfo("Doing forced spawn!");
				this.__ForcedSpawnable.spawnUnit();
				this.__ForcedSpawnable = null;
			}
			else if (this.__UpgradeAffordables.len() > 0 && (this.__SpawnAffordables.len() == 0 || ::MSU.Math.randf(0.0, 1.0) < this.getUpgradeChance() * this.getTotal().tofloat() / this.getIdealSize()))
			{
				if (::DynamicSpawns.Const.DetailedLogging)
				{
					local str = "Possible Upgrades: ";
					foreach (spawnable, weight in this.__UpgradeAffordables)
					{
						str += spawnable.getLogName() + " (" + weight + "), ";
					}
					::logInfo(str.slice(0, -2));
				}

				this.__UpgradeAffordables.roll().upgradeUnit();
			}
			else if (this.__SpawnAffordables.len() > 0)
			{
				if (::DynamicSpawns.Const.DetailedLogging)
				{
					local str = "Possible Spawns: ";
					foreach (spawnable, weight in this.__SpawnAffordables)
					{
						str += spawnable.getLogName() + " (" + weight + "), ";
					}
					::logInfo(str.slice(0, -2));
				}
				this.__SpawnAffordables.roll().spawnUnit();
			}
			else
			{
				throw "tried to run a cycle with no spawnable or upgradeable";
			}

			this.callOnCycle(this);
		}

		this.callOnSpawnEnd();

		this.printToLog();

		if (::DynamicSpawns.Const.Logging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sSpawned %s worth %.1f resources", ::DynamicSpawns.getIndent(), this.getLogName(), this.getWorth()));
			::DynamicSpawns.Indent--;

			::logWarning(format("%sFinished spawn of Party %s. Remaining resources: %.1f", ::DynamicSpawns.getIndent(), this.getID(), this.getResources()));
			::DynamicSpawns.Indent--;
		}

		if (this.getTotal() == 0) ::logError(format("The party %s with %.1f resources was not able to spawn even a single unit!", this.getID(), this.getResources()));

		return this;
	}

	function setupResources( _resources )
	{
		this.__StartingResources = _resources != null ? _resources : this.getDefaultResources();
		this.__Resources = this.__StartingResources;
	}

	// Is false if party is at or above HardMax. Is true if party is below HardMin.
	// Is false between HardMin and HardMax if resources are <= 0 or if there are no affordable spawnables that canSpawn or canUpgrade
	// Is true otherwise
	function canDoAnotherCycle()
	{
		local total = this.getTotal();
		if (total >= this.getHardMax() || (total >= this.getHardMin() && this.getResources() <= 0)) return false;
		this.prepareAffordables(true, this.getTotal() >= this.getIdealSize());
		return this.__ForcedSpawnable != null || this.__SpawnAffordables.len() != 0 || this.__UpgradeAffordables.len() != 0;
	}

	function generateIdealSize()
	{
		if (!("Assets" in ::World)) return ::DynamicSpawns.Const.MainMenuIdealSize;	// fix for when we test this framework in the main menu
		return ::Math.ceil(Math.max(6, ::World.Assets.getBrothersMaxInCombat()));
	}

	function isIgnoringCost()
	{
		return this.getTotal() < this.getHardMin();
	}

	function getDefaultResources()
	{
		return this.DefaultResources;
	}

	function getStartingResources()
	{
		return this.__StartingResources;
	}

	function getIdealSize()
	{
		return this.__IdealSize;
	}

	function getResources()
	{
		if (!this.IsUsingTopPartyResources) return this.__Resources;
		return this.__Party == null ? this.__Resources : this.__Party.getResources();
	}

	function addResources( _amount )
	{
		if (!this.IsUsingTopPartyResources) this.__Resources += _amount;
		else
		{
			if (this.__Party != null) this.__Party.addResources(_amount);
			else this.__Resources += _amount;
		}
	}

	function prepareAffordables( _spawn, _upgrade )
	{
		this.__SpawnAffordables.clear();
		this.__UpgradeAffordables.clear();
		this.__ForcedSpawnable = null;

		foreach (spawnable in this.__DynamicSpawnables)
		{
			if (_spawn && spawnable.canSpawn())
			{
				if (spawnable.satisfiesRatioMin() == false)
				{
					this.__ForcedSpawnable = spawnable;
					return; // Early return for performance because we want to force a spawn that is below its RatioMin
				}
				local weight = spawnable.getSpawnWeight();
				if (weight != 0)
					this.__SpawnAffordables.add(spawnable, weight);
			}

			if (_upgrade && spawnable.canUpgrade())
			{
				local weight = spawnable.getUpgradeWeight();
				if (weight != 0)
					this.__UpgradeAffordables.add(spawnable, weight);
			}
		}
	}

	function spawnUnit()
	{
		this.prepareAffordables(true, false);
		if (this.__ForcedSpawnable != null)
		{
			this.__ForcedSpawnable.spawnUnit();
			this.__ForcedSpawnable = null;
			return;
		}

		if (this.__SpawnAffordables.len() != 0)
			this.__SpawnAffordables.roll().spawnUnit();
	}

	function upgradeUnit()
	{
		this.prepareAffordables(false, true);
		if (this.__UpgradeAffordables.len() != 0)
			this.__UpgradeAffordables.roll().upgradeUnit();
	}

	function canSpawn()
	{
		if (!base.canSpawn())
			return false;
		foreach (spawnable in this.__DynamicSpawnables)
		{
			if (spawnable.canSpawn())
				return true;
		}
		return false;
	}

	function getUpgradeChance()
	{
		return this.UpgradeChance;
	}

	function isLocation()
	{
		return this.getTopParty().__IsLocation;
	}

	function getTroops()
	{
		return this.getUnits().map(@(unit) {Type = ::Const.World.Spawn.Troops[unit.getTroop()], Num = 1});
	}

	function getFigure()
	{
		local ret = "";
		local cost = -9999;
		foreach (unit in this.getSpawnedUnits())
		{
			local figure = unit.getFigure();
			if (figure == "")
				continue;

			local unitCost = unit.getCost();
			if (unitCost > cost)
			{
				cost = unitCost;
				ret = figure;
			}
		}

		if (ret == "")
		{
			ret = typeof this.DefaultFigure == "array" ? this.DefaultFigure[::Math.rand(0, this.DefaultFigure.len() - 1)] : this.DefaultFigure;
			if (ret == "")
				::logError(format("Provide a DefaultFigure for this party (%s) or make sure Units with a defined Figure actually spawn", this.getLogName()));
		}

		return ret;
	}

	function printToLog()
	{
		if (!::DynamicSpawns.Const.Logging)
			return;

		::DynamicSpawns.Indent++;
		if (this.__ParentSpawnable == null)
		{
			::logInfo(format("%s%s : %i (Worth: %.1f)", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal().tointeger(), this.getWorth()));
		}
		else
		{
			local parentTotal = this.__ParentSpawnable instanceof ::DynamicSpawns.Class.Unit ? this.__ParentSpawnable.getUnits().len() - 1 : this.__ParentSpawnable.getTotal();
			::logInfo(format("%s%s : %i (%.1f%%) (Worth: %.1f)", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal().tointeger(), (this.getTotal() / parentTotal) * 100, this.getWorth()));
		}

		base.printToLog();

		::DynamicSpawns.Indent--;
	}
}
