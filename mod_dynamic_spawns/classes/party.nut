// A party can contain all types (Unit, UnitBlock, Party) as DynamicSpawnables and StaticSpawnables
::DynamicSpawns.Class.Party <- class extends ::DynamicSpawns.Class.Spawnable
{
	UpgradeChance = 75;

	DefaultFigure = "";
	MovementSpeedMult = 1.0;
	VisibilityMult = 1.0;
	VisionMult = 1.0;

	DefaultResources = 0;

	__Resources = 0;
	__StartingResources = 0;

	__WorldEntity = null;

	__SpawnAffordables = null;
	__UpgradeAffordables = null;

	function init()
	{
		base.init();
		this.__SpawnAffordables = ::MSU.Class.WeightedContainer();
		this.__UpgradeAffordables = ::MSU.Class.WeightedContainer();
		return this;
	}

	function __getUpgradeChance()
	{
		return this.getUpgradeChance();
	}

	function getUpgradeChance()
	{
		return this.UpgradeChance;
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
		if (this.getParentSpawnable() == null)
		{
			this.validateSpawn();
		}

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

	// TODO: Fix potential RatioMax and RatioMin violation upon removal of violators of PartySizeMin and PartySizeMax
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
		if (this.canUpgrade() && (this.__ChosenSpawn == null || ::Math.rand(1, 100) <= this.__getUpgradeChance()))
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
			local str = format("%sPossible Upgrades (Chance: %.0f%%) in %s: ", ::DynamicSpawns.getIndent(), this.__ChosenSpawn == null ? 100.0 : this.__getUpgradeChance(), this.getLogName());
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
		this.__Resources = this.__StartingResources;
	}

	// This can be null if the party was spawned without a world party defined e.g. testing or scripted combat.
	// Therefore, one should always do a null check before doing further operations on the returned value.
	function getWorldEntity()
	{
		return this.__WorldEntity;
	}

	function setWorldEntity( _entity )
	{
		this.__WorldEntity = _entity;
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
