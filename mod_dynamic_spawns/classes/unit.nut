// A Unit assumes the following:
// - It will never have any DynamicSpawnables
::DynamicSpawns.Class.Unit <- class extends ::DynamicSpawns.Class.Spawnable
{
	Figure = "";
	Troop = "";
	Cost = 1.0;

	__Instances = null; // Each spawn of this unit is kept as an instance here. This is for being able to spawn/despawn individual instances which may vary due to spawns from their __StaticSpawnables

	function init()
	{
		this.__Instances = [];
		return base.init();
	}

	function spawn()
	{
		this.__Instances.push(this);
		base.spawn();
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sSpawned %s worth %.1f resources", ::DynamicSpawns.getIndent(), this.getLogName(), this.getWorth()));
			::DynamicSpawns.Indent--;
		}
		return this;
	}

	function spawnUnit()
	{
		local unit = clone this;
		unit.__Instances = [];
		if (this.__StaticSpawnables.len() != 0)
		{
			unit.init();
			unit.setParty(null);
			unit.setParty(this.__Party);
		}
		this.__Instances.push(unit);

		local ret = unit.spawn();
		this.getParty().addResources(-unit.getWorth());
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sSpawned %s worth %.1f resources. Remaining resources: %.1f", ::DynamicSpawns.getIndent(), unit.getLogName(), unit.getWorth(), unit.getParty().getResources()));
			::DynamicSpawns.Indent--;
		}
		return ret;
	}

	function despawnUnit()
	{
		local spawn = this.__Instances.remove(::Math.rand(0, this.__Instances.len() - 1));
		this.getParty().addResources(spawn.getWorth());
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sDespawned %s worth %.1f resources. Remaining resources: %.1f", ::DynamicSpawns.getIndent(), spawn.getLogName(), spawn.getWorth(), this.getParty().getResources()));
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

	function canSpawn( _bonusResources = 0 )
	{
		if (!base.canSpawn())
			return false;

		if (_bonusResources == 0)	// We only allow ignoring of Cost if for considering new units to spawn
		{
			return this.getParty().isIgnoringCost() || this.getPredictedWorth() <= this.getParty().getResources();
		}
		else	// Upgrading of units
		{
			return this.getPredictedWorth() <= this.getParty().getResources() + _bonusResources;
		}
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

	function getPredictedWorth()
	{
		local ret = this.getCost();
		foreach (spawnable in this.__StaticSpawnables)
		{
			ret += spawnable.getPredictedWorth();
		}
		return ret;
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

		::DynamicSpawns.Indent++;

		local numUnits = this.getUnits().len();
		if (numUnits == this.__Instances.len())
		{
			::logInfo(format("%s%s : %i (%.1f%%) (Worth: %.1f)", ::DynamicSpawns.getIndent(), this.getLogName(), numUnits, (numUnits / this.__ParentSpawnable.getTotal()) * 100, this.getWorth()));
		}
		else
		{
			::logInfo(format("%s%s : %i (%.1f%%) + %i (Worth: %.1f)", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal(), (this.getTotal() / this.__ParentSpawnable.getTotal()) * 100, numUnits - 1, this.getWorth()));
		}

		if (this.__Instances[0] != this)
		{
			foreach (inst in this.__Instances)
			{
				if (inst.getUnits().len() > 1)
					inst.printToLog();
			}
		}
		else
		{
			base.printToLog();
		}

		::DynamicSpawns.Indent--;
	}

	function getLogName()
	{
		return this.Troop;
	}
}
