// A Unit assumes the following:
// - It will never have any DynamicSpawnables
::DynamicSpawns.Class.Unit <- class extends ::DynamicSpawns.Class.Spawnable
{
	Figure = "";
	Troop = "";
	Cost = 1.0;

	__Instances = null; // Each spawn of this unit is kept as an instance here. This is for being able to spawn/despawn individual instances which may vary due to spawns from their __StaticSpawnables
	__UnitContainer = null;

	function init()
	{
		this.__Instances = [];
		base.init();
		return this;
	}	

	function hasAffordableSpawn( _resources = null )
	{
		_resources = _resources == null ? this.getResources() : _resources;
		if (this.__StaticSpawnables.len() == 0)
		{
			return this.getCost() < _resources;
		}

		if (this.__ChosenSpawn != null && this.isAffordable(_resources))
		{
			return true;
		}

		this.__ChosenSpawn = null;
		this.chooseSpawn();
		return this.isAffordable(_resources);
	}

	function spawn()
	{
		return this.spawnUnit();
	}

	function chooseSpawn()
	{
		if (this.__ChosenSpawn != null)
			return this.__ChosenSpawn;

		if (this.__StaticSpawnables.len() == 0)
		{
			this.__ChosenSpawn = clone this;
			this.__ChosenSpawn.__UnitContainer = this.weakref();
			this.__ChosenSpawn.__Instances = [this.__ChosenSpawn];
			return this.__ChosenSpawn;
		}

		local wasLogging = ::DynamicSpawns.Const.Logging
		::DynamicSpawns.Const.Logging = false;
		local detailedLogging = ::DynamicSpawns.Const.DetailedLogging;
		::DynamicSpawns.Const.DetailedLogging = false;
		local s = clone this;
		s.init();
		s.__Instances.push(s);
		s.__UnitContainer = this.weakref();
		foreach (spawnable in s.__StaticSpawnables)
		{
			spawnable.spawn();
		}
		::DynamicSpawns.Const.Logging = wasLogging;
		::DynamicSpawns.Const.DetailedLogging = detailedLogging;
		this.__ChosenSpawn = s;
		return s;
	}

	function chooseUpgrade()
	{
		if (this.__ChosenUpgrade != null)
			return this.__ChosenUpgrade;

		if (this.__Instances.len() != 0)
		{
			this.__ChosenUpgrade = ::MSU.Array.rand(this.__Instances);
			return this.__ChosenUpgrade;
		}
	}

	function spawnUnit()
	{
		if (this.__UnitContainer != null)
		{
			return this.__UnitContainer.spawnUnit();
		}

		this.chooseSpawn();
		if (this.__ChosenSpawn != null)
		{
			this.__Instances.push(this.__ChosenSpawn);
			this.addResources(-this.__ChosenSpawn.getWorth());
			if (::DynamicSpawns.Const.DetailedLogging)
			{
				local unit = this.__ChosenSpawn;
				::DynamicSpawns.Indent++;
				::logInfo(format("%sSpawned %s worth %.1f resources. Remaining resources: %.1f. Chain: %s", ::DynamicSpawns.getIndent(), unit.getLogName(), unit.getWorth(), unit.getResources(), this.getLogNameChain()));
				::DynamicSpawns.Indent--;
				if (this.__StaticSpawnables.len() != 0)
				{
					unit.printToLog();
				}
			}
			local ret = this.__ChosenSpawn;
			if (this.__StaticSpawnables.len() != 0)
			{
				this.__ChosenSpawn = null;
			}
			return ret;
		}
	}

	function upgradeUnit()
	{
		if (this.__UnitContainer != null)
		{
			return this.__UnitContainer.upgradeUnit();
		}

		this.chooseUpgrade();
		local spawn = ::MSU.Array.removeByValue(this.__Instances, this.__ChosenUpgrade);
		this.__ChosenUpgrade = null;

		this.addResources(spawn.getWorth());

		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sDespawned %s worth %.1f resources. Remaining resources: %.1f. Chain: %s", ::DynamicSpawns.getIndent(), spawn.getLogName(), spawn.getWorth(), this.getResources(), this.getLogNameChain()));
			::DynamicSpawns.Indent--;
		}
		return spawn;
	}

	function getSpawnedUnits()
	{
		local ret = base.getSpawnedUnits();
		ret.extend(this.__Instances);
		return ret;
	}

	function getUnits()
	{
		local ret = [];
		foreach (unit in this.getSpawnedUnits())
		{
			if (unit == this) ret.push(this);
			else ret.extend(unit.getUnits());
		}
		return ret;
	}

	function getWorth()
	{
		local ret = 0.0;
		foreach (unit in this.getUnits())
		{
			ret += unit.getCost();
		}
		return ret;
	}

	function getTotal()
	{
		return this.__Instances.len().tofloat();
	}

	function getCost()
	{
		return this.Cost;
	}

	function canUpgrade()
	{
		return false;
	}

	function clear()
	{
		this.__Instances.clear();
	}

	function getPredictedWorth()
	{
		if (this.__UnitContainer != null)
			return this.getWorth();

		if (this.__StaticSpawnables.len() == 0)
			return this.getCost();

		this.chooseSpawn();
		return this.__ChosenSpawn.getWorth();
	}

	function getUpgradeWeight()
	{
		local ret = this.getTotal();
		if (this.__ParentSpawnable != null)
			ret += 3 * (this.__ParentSpawnable.__DynamicSpawnables.len() - 1 - this.__ParentSpawnable.__DynamicSpawnables.find(this));
		return ret * (1.0 / ::Math.pow(this.getCost(), 2));
	}

	function getTroop()
	{
		return this.Troop;
	}

	function getFigure()
	{
		return typeof this.Figure == "array" ? this.Figure[::Math.rand(0, this.Figure.len() -1)] : this.Figure;
	}

	function printToLog()
	{
		if (!::DynamicSpawns.Const.Logging)
			return;

		if (this.__Instances.len() == 0)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%s%s : 0 (0.0%%) (Worth: 0.0)", ::DynamicSpawns.getIndent(), this.getLogName()));
			::DynamicSpawns.Indent--;
			return;
		}

		if (this.__Instances[0] == this)
		{
			base.printToLog();
		}
		else
		{
			::DynamicSpawns.Indent++;

			local worth = this.getWorth();
			local numUnits = this.getUnits().len();
			if (numUnits == this.__Instances.len())
			{
				::logInfo(format("%s%s : %i (%.1f%%) (Worth: %.1f, %.1f%%)", ::DynamicSpawns.getIndent(), this.getLogName(), numUnits, (numUnits / this.__ParentSpawnable.getTotal()) * 100, worth, 100 * worth / this.__ParentSpawnable.getWorth()));
			}
			else
			{
				::logInfo(format("%s%s : %i (%.1f%%) + %i (Worth: %.1f, %.1f%%)", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal(), (this.getTotal() / this.__ParentSpawnable.getTotal()) * 100, numUnits - 1, worth, 100 * worth / this.__ParentSpawnable.getWorth()));
			}

			foreach (inst in this.__Instances)
			{
				if (inst.getUnits().len() > 1)
					inst.printToLog();
			}

			::DynamicSpawns.Indent--;
		}
	}
}
