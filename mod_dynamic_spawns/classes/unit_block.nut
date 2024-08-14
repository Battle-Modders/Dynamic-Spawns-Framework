// A UnitBlock assumes the following:
// - It will never have any StaticSpawnables
// - It will have no type other than Units as its DynamicSpawnables
::DynamicSpawns.Class.UnitBlock <- class extends ::DynamicSpawns.Class.Spawnable
{
	TierWidth = 2; // Specifies the maximum number of tiers that can simultaneously have spawned units
	__WeightedDynamicSpawnables = null;

	function init()
	{
		if (this.DynamicDefs.Units instanceof ::MSU.Class.WeightedContainer)
		{
			this.__WeightedDynamicSpawnables = ::MSU.Class.WeightedContainer();
			this.__DynamicSpawnables = [];
			foreach (def, weight in this.DynamicDefs.Units)
			{
				local unit = ::DynamicSpawns.__getObjectFromDef(def, ::DynamicSpawns.Units);
				unit.__ParentSpawnable = this.weakref();
				this.__WeightedDynamicSpawnables.add(unit, weight);
				this.__DynamicSpawnables.push(unit);
			}
			this.__StaticSpawnables = [];
		}
		else
		{
			base.init();
			this.sort();
		}
		return this;
	}

	function onBeforeSpawnStart()
	{
		base.onBeforeSpawnStart();
		if (this.__WeightedDynamicSpawnables != null)
		{
			local ds = this.__DynamicSpawnables;
			this.__WeightedDynamicSpawnables = this.__WeightedDynamicSpawnables.filter(@(unit, _) ds.find(unit) != null);
		}
	}

	function spawn()
	{
		base.spawn();
		this.spawnUnit();
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sSpawned %s worth %f resources", ::DynamicSpawns.getIndent(), this.getLogName(), this.getWorth()));
			::DynamicSpawns.Indent--;
		}
		return this;
	}

	function sort()
	{
		this.__DynamicSpawnables.sort(@(a, b) a.getCost() <=> b.getCost());
	}

	function spawnUnit()
	{
		return this.chooseUnitForSpawn().spawnUnit();
	}

	function upgradeUnit()
	{
		local info = this.chooseUnitForUpgrade();
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sUpgrading %s to %s", ::DynamicSpawns.getIndent(), info.Unit.Troop, info.UpgradeUnit.Troop));
		}
		local despawn = info.Unit.despawnUnit();
		local spawn = info.UpgradeUnit.spawnUnit();
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent--;
		}
	}

	function chooseUnitForUpgrade()
	{
		local choices = ::MSU.Class.WeightedContainer();

		local tiers = 0;
		// Ignore the highest tier
		for (local i = 0; i < this.__DynamicSpawnables.len() - 1 && tiers < this.TierWidth - 1; i++)
		{
			local unit = this.__DynamicSpawnables[i];
			local count = unit.getTotal();
			if (count > 0)
			{
				tiers++;
				for (local j = i + 1; j < this.__DynamicSpawnables.len(); j++)	// for loop because the next very unitType could have some requirements (like playerstrength) preventing spawn
				{
					if (this.__DynamicSpawnables[j].canSpawn(unit.getCost()))
					{
						choices.add({Unit = unit, UpgradeUnit = this.__DynamicSpawnables[j]}, unit.getUpgradeWeight());
						break;	// We are only interested in the closest possible upgrade path, not all of them
					}
				}

			}
		}

		return choices.roll();
	}

	function chooseUnitForSpawn()
	{
		if (this.isRandom())
		{
			return this.__WeightedDynamicSpawnables.filter(@(unit, _) unit.canSpawn()).roll();
		}
		else
		{
			local function satisfiesTierWidth( _index )
			{
				_index += this.TierWidth;
				return _index >= this.__DynamicSpawnables.len() || this.__DynamicSpawnables[_index].getTotal() == 0;
			}
			foreach (i, unit in this.__DynamicSpawnables)
			{
				if (satisfiesTierWidth(i) && unit.canSpawn())
				{
					return unit;
				}
			}
		}
	}

	function isRandom()
	{
		return this.__WeightedDynamicSpawnables != null;
	}

	function canSpawn()
	{
		if (!base.canSpawn())
			return false;

		return this.chooseUnitForSpawn() != null;
	}

	function canUpgrade()
	{
		if (this.isRandom())
			return false;

		return this.chooseUnitForUpgrade() != null;
	}

	function printToLog()
	{
		if (!::DynamicSpawns.Const.Logging)
			return;

		::DynamicSpawns.Indent++;
		::logInfo(format("%s%s : %i (%.1f%%) (Worth: %.1f):", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal().tointeger(), (this.getTotal() / this.__ParentSpawnable.getTotal()) * 100, this.getWorth()));

		base.printToLog();

		::DynamicSpawns.Indent--;
	}
}
