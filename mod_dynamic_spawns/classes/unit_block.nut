// A UnitBlock assumes the following:
// - It will never have any StaticSpawnables
// - It will have no type other than Units as its DynamicSpawnables
::DynamicSpawns.Class.UnitBlock <- class extends ::DynamicSpawns.Class.Spawnable
{
	TierWidth = 9999; // Specifies the maximum number of tiers that can simultaneously have spawned units
	__WeightedDynamicSpawnables = null;

	function callOnCycle( _cycler )
	{
		base.callOnCycle(_cycler);
		this.__ChosenSpawn = null;
		this.__ChosenUpgrade = null;
	}

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

	function excludeSpawnables()
	{
		base.excludeSpawnables();
		if (this.__WeightedDynamicSpawnables != null)
		{
			local ds = this.__DynamicSpawnables;
			this.__WeightedDynamicSpawnables = this.__WeightedDynamicSpawnables.filter(@(unit, _) ds.find(unit) != null);
		}
	}

	function spawn()
	{
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
		::DynamicSpawns.__stableSort(this.__DynamicSpawnables, @(a, b) a.getCost() <=> b.getCost());
	}

	function upgradeUnit()
	{
		local info = this.chooseUpgrade();
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%sUpgrading %s to %s (Net Cost: %i)", ::DynamicSpawns.getIndent(), info.Unit.getLogName(), info.UpgradeUnit.getLogName(), info.UpgradeUnit.__ChosenSpawn.getWorth() - info.Unit.__ChosenUpgrade.getWorth()));
		}
		info.Unit.upgradeUnit();
		info.UpgradeUnit.spawnUnit();
		if (::DynamicSpawns.Const.DetailedLogging)
		{
			::DynamicSpawns.Indent--;
		}
	}

	function chooseUpgrade()
	{
		if (this.__ChosenUpgrade != null)
			return this.__ChosenUpgrade;

		local choices = ::MSU.Class.WeightedContainer();

		local spawnables = this.__DynamicSpawnables;
		local tiersPresent = this.__DynamicSpawnables.filter(@(_, _u) _u.getTotal() != 0);
		local lowestOnly = tiersPresent.len() >= this.TierWidth;
		if (lowestOnly)
		{
			spawnables = tiersPresent;
		}

		// Ignore the highest tier
		for (local i = 0; i < spawnables.len() - 1; i++)
		{
			local oldUnit = spawnables[i];
			local count = oldUnit.getTotal();
			if (count == 0)
				continue;

			// Upgrading will reduce this unit's count by 1. So we need to ensure that that won't violate its RatioMin or HardMin
			local predictedCount = count - 1;
			if (!oldUnit.satisfiesRatioMin(predictedCount) || predictedCount < oldUnit.getHardMin())
				continue;

			// Look at all the units above my tier and upgrade me to the nearest valid one
			for (local j = i + 1; j < spawnables.len(); j++)
			{
				local newUnit = spawnables[j];
				if (!newUnit.satisfiesRatioMax(newUnit.getTotal() + 1))
					continue;

				if (newUnit.canSpawn() && newUnit.isAffordable(this.getResources() + oldUnit.chooseUpgrade().getWorth()))
				{
					// We delay the calculation of oldUnit.getUpgradeWeight() because in most cases it won't be 0
					// so we only calculate it once we have found a valid upgrade path.
					local upgradeWeight = oldUnit.getUpgradeWeight();
					if (upgradeWeight == 0)
					{
						break;
					}
					// Favor lower tier units to upgrade
					upgradeWeight *= 3 * (spawnables.len() - i);
					choices.add({Unit = oldUnit, UpgradeUnit = newUnit}, upgradeWeight);
					break;	// We are only interested in the closest possible upgrade path, not all of them
				}
			}

			if (lowestOnly && choices.len() != 0)
				break;
		}

		this.__ChosenUpgrade = choices.roll();
		return this.__ChosenUpgrade;
	}

	function chooseSpawn()
	{
		if (this.__ChosenSpawn != null)
			return this.__ChosenSpawn;

		if (this.isRandom())
		{
			this.__ChosenSpawn = this.__WeightedDynamicSpawnables.filter(@(_unit, _) _unit.canSpawn() && _unit.chooseSpawn() != null && _unit.isAffordable()).roll();
		}
		else
		{
			local spawnables = [];
			foreach (i, s in this.__DynamicSpawnables)
			{
				if (s.canSpawn() && s.chooseSpawn() != null)
				{
					// Early return with forcing the choice of a unit below its RatioMin
					if (!s.satisfiesRatioMin())
					{
						this.__ChosenSpawn = s;
						return this.__ChosenSpawn;
					}
					spawnables.push(s);
				}
			}

			foreach (i, s in spawnables)
			{
				if (!this.satisfiesTierWidth(i, spawnables))
					continue;

				this.__ChosenSpawn = s;
				break;
			}
		}

		return this.__ChosenSpawn;
	}

	function satisfiesTierWidth( _idx, _spawnables )
	{
		for (local i = _idx + this.TierWidth; i < _spawnables.len(); i++)
		{
			if (_spawnables[i].getTotal() != 0)
				return false;
		}
		return true;
	}

	function isRandom()
	{
		return this.__WeightedDynamicSpawnables != null;
	}

	function canUpgrade()
	{
		return !this.isRandom() && this.__DynamicSpawnables.len() > 1;
	}

	function printToLog()
	{
		if (!::DynamicSpawns.Const.Logging)
			return;

		::DynamicSpawns.Indent++;
		local worth = this.getWorth();
		::logInfo(format("%s%s : %i (%.1f%%) (Worth: %.1f, %.1f%%):", ::DynamicSpawns.getIndent(), this.getLogName(), this.getTotal().tointeger(), (this.getTotal() / this.__ParentSpawnable.getTotal()) * 100, worth, 100 * worth / this.__ParentSpawnable.getWorth()));

		if (this.getTotal() != 0)
		{
			base.printToLog();
		}

		::DynamicSpawns.Indent--;
	}
}
