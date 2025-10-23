// A party can contain all types (Unit, UnitBlock, Party) as DynamicSpawnables and StaticSpawnables
::DynamicSpawns.Class.Party <- class extends ::DynamicSpawns.Class.Spawnable
{
	// Temporary until mods update
	IsUsingTopPartyResources = false;
	IdealSizeLocationMult = 1.5;
	UpgradeChance = 0.75;

	DefaultFigure = "";
	MovementSpeedMult = 1.0;
	VisibilityMult = 1.0;
	VisionMult = 1.0;

	DefaultResources = 0;
	UpgradeFactor = 6.25;

	__Resources = 0;
	__StartingResources = 0;

	__IsLocation = false;

	__SpawnAffordables = null;
	__UpgradeAffordables = null;

	function init()
	{
		base.init();
		this.__SpawnAffordables = ::MSU.Class.WeightedContainer();
		this.__UpgradeAffordables = ::MSU.Class.WeightedContainer();
		return this;
	}

	function callOnCycle( _cycler )
	{
		base.callOnCycle(_cycler);
		this.__ChosenSpawn = null;
		this.__ChosenUpgrade = null;
	}

	function getResources()
	{
		return this.__ResourcesSource == this ? this.__Resources : this.__ResourcesSource.getResources();
	}

	function spawn( _resources = null )
	{
		this.setupResources(_resources);
		this.setResourcesSource(this);

		// Temporary
		this.UpgradeFactor = 100 * this.UpgradeChance.tofloat() / this.generateIdealSize();

		this.callOnBeforeSpawnStart();

		this.excludeSpawnables();

		if (::DynamicSpawns.Const.Logging)
		{
			::DynamicSpawns.Indent++;
			::logWarning(format("%sStarting spawn of %s with resources: %.1f", ::DynamicSpawns.getIndent(), this.getLogNameChain(), this.getStartingResources()));
		}

		foreach (s in this.__StaticSpawnables)
		{
			this.addResources(-s.spawn().getWorth());
		}

		this.spawnMinUnits();

		while (this.canCycle())
		{
			this.doCycle();
		}

		// Check if any spawnable violated its PartySizeMin or PartySizeMax and if yes then remove it from the party
		// and refund its resources. Then do more cycles until the returned resources are used up on other units.
		// While this may now lead to a situation where the PartySizeMin would have been fulfilled, but practically
		// that situation was only achievable by not spawning those particular spawnables, so its fine.
		this.validateSpawn();

		this.callOnSpawnEnd();

		if (::DynamicSpawns.Const.Logging)
		{
			this.printToLog();

			::DynamicSpawns.Indent++;
			::logInfo(format("%sSpawned %s worth %.1f resources (Chain: %s)", ::DynamicSpawns.getIndent(), this.getLogName(), this.getWorth(), this.getLogNameChain()));
			::DynamicSpawns.Indent--;

			::logWarning(format("%sFinished spawn of Party %s. Remaining resources: %.1f", ::DynamicSpawns.getIndent(), this.getLogName(), this.getResources()));
			::DynamicSpawns.Indent--;
		}

		if (this.getTotal() == 0) ::logError(format("The party %s with %.1f resources was not able to spawn even a single unit!", this.getID(), this.getResources()));

		return this;
	}

	function validateSpawn()
	{
		local softExclude = ::DynamicSpawns.Tests.IsTesting;
		local total = this.getTotal();
		local validatePartySize;
		validatePartySize = function( _spawnable, _funcName )
		{
			local spawnables = clone _spawnable.__DynamicSpawnables;
			local mult = _funcName == "getPartySizeMin" ? -1 : 1;
			spawnables.sort(@(_a, _b) mult * _a[_funcName]() <=> mult * _b[_funcName]());

			foreach (i, s in spawnables)
			{
				// ::logInfo("Validating " + _funcName + " " + s.getLogName());
				// ::logInfo("Validating " + s.getLogName() + " " + s.getTotal());
				if (s.getTotal() != 0 && (_funcName == "getPartySizeMin" ? total < s.getPartySizeMin() : total > s.getPartySizeMax()))
				{
					s.addResources(s.getWorth());

					if (::DynamicSpawns.Const.DetailedLogging)
					{
						::logInfo(format("%s%s violated %s so removing it and returning %.1f resources. Remaining resources: %.1f", ::DynamicSpawns.getIndent(), s.getLogName(), _funcName, s.getWorth(), s.getParentSpawnable().getResources()));
					}

					if (softExclude)
					{
						s.clear();
						s.HardMax = 0;
						s.HardMin = 0;
					}
					else
					{
						::MSU.Array.removeByValue(_spawnable.__DynamicSpawnables, s);
					}
					return false;
				}
				else if (!validatePartySize(s, _funcName))
				{
					return false;
				}
			}
			return true;
		}

		while (!validatePartySize(this, "getPartySizeMin"))
		{
			while (this.canCycle())
			{
				this.doCycle();
			}
			total = this.getTotal();
		}

		while (!validatePartySize(this, "getPartySizeMax"))
		{
			while (this.canCycle())
			{
				this.doCycle();
			}
			total = this.getTotal();
		}
	}

	function canCycle()
	{
		if (this.getResources() <= 0 && !this.isIgnoringCost())
			return false;

		if (this.canSpawn())
		{
			this.chooseSpawn();
			if (this.__ChosenSpawn != null && !this.__ChosenSpawn.satisfiesRatioMin())
			{
				return true;
			}
		}

		// If we are at HardMax then ChosenSpawn will be null, which means Upgrading requires no chance roll
		if (this.canUpgrade() && (this.__ChosenSpawn == null || ::MSU.Math.randf(0.0, 1.0) < this.getUpgradeFactor() * this.getTotal() * 0.01))
		{
			this.chooseUpgrade();
			if (this.__ChosenUpgrade != null)
			{
				this.__ChosenSpawn = null;
				return true;
			}
		}

		return this.__ChosenSpawn != null || this.__ChosenUpgrade != null;
	}

	function doCycle()
	{
		// ::logInfo("doCycle " + this.getLogNameChain());
		if (this.__ChosenSpawn != null)
		{
			this.spawnUnit();
		}
		else if (this.__ChosenUpgrade != null)
		{
			this.upgradeUnit();
		}
		else
		{
			::MSU.Log.printData(this);
			throw "tried to run a cycle with no spawnable or upgradeable";
		}

		this.callOnCycle(this);
	}

	function chooseSpawn()
	{
		if (this.__ChosenSpawn != null)
			return this.__ChosenSpawn;

		this.__SpawnAffordables.clear();
		foreach (s in this.__DynamicSpawnables)
		{
			// ::logInfo(s.getLogNameChain());
			// ::logInfo(s.canSpawn());
			// ::logInfo(s.chooseSpawn() != null);
			// ::logInfo(s.isAffordable());
			// ::logInfo(format("%s %s %s %s", s.getLogNameChain(), s.canSpawn() + "", "" + (s.chooseSpawn() != null), "" + s.isAffordable()));
			if (s.canSpawn() && s.hasAffordableSpawn())
			{
				if (!s.satisfiesRatioMin())
				{
					this.__ChosenSpawn = s;
					if (::DynamicSpawns.Const.DetailedLogging) ::logInfo("Doing forced spawn!");
					return this.__ChosenSpawn;
				}
				local weight = s.getSpawnWeight();
				if (weight != 0)
					this.__SpawnAffordables.add(s, weight);
			}
		}

		if (this.__SpawnAffordables.len() != 0)
		{
			// Convert the weighted container into an array with each idx being [weight, spawnable]
			local spawnables = this.__SpawnAffordables.toArray(false);
			// The total that will be after the spawn of 1 unit, therefore we do +1
			local parentTotal = this.getTotal() + 1;
			foreach (pair1 in spawnables)
			{
				foreach (pair2 in spawnables)
				{
					if (pair1 == pair2)
						continue;

					if (!pair2[1].satisfiesRatioMin(null, parentTotal))
					{
						this.__SpawnAffordables.setWeight(pair1[1], pair1[0] * 0.1);
					}
				}
			}

			if (::DynamicSpawns.Const.DetailedLogging)
			{
				local str = format("%sPossible Spawns in %s: ", ::DynamicSpawns.getIndent(), this.getLogName());
				foreach (spawnable, weight in this.__SpawnAffordables) str += spawnable.getLogName() + " (" + weight + "), ";
				::logInfo(str.slice(0, -2));
			}
		}

		this.__ChosenSpawn = this.__SpawnAffordables.roll();
		return this.__ChosenSpawn;
	}

	function chooseUpgrade()
	{
		if (this.__ChosenUpgrade != null)
			return this.__ChosenUpgrade;

		this.__UpgradeAffordables.clear();
		foreach (s in this.__DynamicSpawnables)
		{
			if (s.canUpgrade() && s.chooseUpgrade() != null)
			{
				local weight = s.getUpgradeWeight();
				if (weight != 0)
					this.__UpgradeAffordables.add(s, weight);
			}
		}

		if (this.__UpgradeAffordables.len() != 0 && ::DynamicSpawns.Const.DetailedLogging)
		{
			local str = format("%sPossible Upgrades in %s: ", ::DynamicSpawns.getIndent(), this.getLogName());
			foreach (spawnable, weight in this.__UpgradeAffordables) str += spawnable.getLogName() + " (" + weight + "), ";
			::logInfo(str.slice(0, -2));
		}

		this.__ChosenUpgrade = this.__UpgradeAffordables.roll();
		return this.__ChosenUpgrade;
	}

	function getParty()
	{
		return this.__Party;
	}

	function getDefaultResources()
	{
		return this.DefaultResources;
	}

	function getStartingResources()
	{
		return this.__StartingResources;
	}

	function setupResources( _resources )
	{
		this.__StartingResources = _resources != null ? _resources : this.getDefaultResources();
		// ::logInfo("clamping setupResources " + this.getLogNameChain() + " to " + this.__StartingResources + " topPartyResources: " + this.getParentSpawnable().getResources() + " parentSpawnableWorth: " + this.getParentSpawnable().getWorth());
		this.__Resources = this.__StartingResources;
	}

	function isLocation()
	{
		return this.__IsLocation;
	}

	function getUpgradeFactor()
	{
		return this.UpgradeFactor;
	}

	function generateIdealSize()
	{
		if (!("Assets" in ::World) || ::World.Assets == null) return ::DynamicSpawns.Const.MainMenuIdealSize;	// fix for when we test this framework in the main menu
		return ::Math.max(6, ::Math.min(::World.getPlayerRoster().getSize(), ::World.Assets.getBrothersMaxInCombat()));
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

	function getTroops()
	{
		local ret = [];
		local troops = [];
		foreach (unit in this.getUnits())
		{
			local troop = unit.getTroop();
			local idx = troops.find(troop);
			if (idx == null)
			{
				troops.push(troop);
				ret.push({
					Type = ::Const.World.Spawn.Troops[troop],
					Num = 1
				});
			}
			else
			{
				ret[idx].Num++;
			}
		}

		return ret;
	}

	function getFigure()
	{
		local getUnitsWithFigure;
		getUnitsWithFigure = function( _spawnable )
		{
			local units = [];
			local spawnables = clone _spawnable.__DynamicSpawnables;
			spawnables.extend(_spawnable.__StaticSpawnables);
			foreach (s in spawnables)
			{
				if (!s.determinesFigure())
					continue;

				if (s instanceof ::DynamicSpawns.Class.Unit)
				{
					if (s.getFigure() != "" && s.getTotal() != 0)
						units.push(s);
				}
				else
					units.extend(getUnitsWithFigure(s));
			}
			return units;
		}

		local units = getUnitsWithFigure(this);
		if (units.len() != 0)
		{
			units.sort(@(a, b) a.getCost() <=> b.getCost());
			return units.top().getFigure();
		}

		local ret = typeof this.DefaultFigure == "array" ? this.DefaultFigure[::Math.rand(0, this.DefaultFigure.len() - 1)] : this.DefaultFigure;
		if (ret == "")
				::logError(format("Provide a DefaultFigure for this party (%s) or make sure Spawnables with DeterminesFigure actually spawn units with a defined Figure", this.getLogName()));

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
			local worth = this.getWorth();
			local parentTotal = this.__ParentSpawnable instanceof ::DynamicSpawns.Class.Unit ? this.__ParentSpawnable.getUnits().len() : this.__ParentSpawnable.getTotal();
			::logInfo(format("%s%s : %i (%.1f%%) (Worth: %.1f, %.1f%%)", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal().tointeger(), (this.getTotal() / parentTotal) * 100, worth, 100 * worth / this.__ParentSpawnable.getWorth()));
		}

		if (this.getTotal() != 0)
		{
			base.printToLog();
		}

		::DynamicSpawns.Indent--;
	}
}
