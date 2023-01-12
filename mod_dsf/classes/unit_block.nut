// A group of similar units that upgrade into one another
this.unit_block <- {
	m = {
        ID = null,
        Units = [],         // Spawnable units
        LookupMap = {},
        IsStatic = false,
        ReqPartySize = 0,         // This Unit will only be able to spawn if the amount of already spawned troops is greater or equal to ReqPartySize
	}

	function create()
	{
	}

    function init( _unitBlockDef )
	{
		this.m.ID = _unitBlockDef.ID;

		foreach (key, value in _unitBlockDef)
		{
			if (key == "Units")
			{
				this.addUnits(value);
				continue;
			}

			if (typeof value == "function")
			{
				this[key] = value;
			}
			else
			{
				this.m[key] = value;
			}
		}
		return this;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getUnits()
	{
		return this.m.Units;
	}

	function getReqPartySize()
	{
		return this.m.ReqPartySize;
	}

	function getAverageCost()	// Average cost over all unit types in this block
	{
		local cost = 0.0;
		foreach (unit in this.getUnits())
		{
			cost += unit.getCost();
		}
		if (this.getUnits().len() == 0) return cost;
		return (cost / this.getUnits().len());
	}

	function addUnit( _unit )
	{
		local unit;
		if ("ID" in _unit)
		{
			unit = ::DSF.Units.findById(_unit.ID);
		}

		this.m.Units.push(unit);
		this.m.LookupMap[unit.getID()] <- unit;
	}

	function addUnits( _units )
	{
		foreach (unit in _units)
		{
			this.addUnit(unit);
		}
	}

	function removeUnit( _id )
	{
		foreach (i, unit in this.m.Units)
		{
			if (unit.ID == _id)
			{
				delete this.m.LookupMap[_id];
				return this.m.Units.remove(i);
			}
		}
	}

	// Returns amount of unitTypes in this block that are stronger than the passed unit (in terms of cost)
	function getStrongerUnitTypeCount( _unit )
	{
		local count = 0
		foreach (unit in this.getUnits())
		{
			if (unit.getCost() > _unit.getCost()) count++;
		}
		return count;
	}

	// This weight is used to randomly roll which UnitBlock should have one of their troops upgrade during that cycle
	function getUpgradeWeight( _spawnProcess )
	{
		local weight = 0;
		foreach (unit in _spawnProcess.getUnits(this.getID()))
		{
			weight += this.getStrongerUnitTypeCount(unit);
		}
		return weight;
	}

	function getUnit( _id )
	{
		return this.m.LookupMap[_id];
	}

	function spawnUnit( _spawnProcess )
	{
		foreach (unit in this.m.Units)
		{
			if (unit.canSpawn(_spawnProcess))
			{
				_spawnProcess.incrementUnit(unit.getID(), this.getID());
				if (!::DSF.Const.Benchmark && ::DSF.Const.DetailedLogging ) ::logInfo("Spawning - Block: " + this.getID() + " - Unit: " + unit.getEntityType() + " (Cost: " + unit.getCost() + ")\n");
				_spawnProcess.consumeResources(unit.getCost());
				break;
			}
		}
	}
/*
	function despawnUnit( _spawnProcess )
	{
		local consumedResources = 0;
		local ids = ::MSU.Class.WeightedContainer();

		foreach (unit in this.m.Units)
		{
			local count = _spawnProcess.getUnitCount(unit.getID(), this.getID());
			if (count > 0) ids.add(unit.ID, count);
		}

		if (ids.len() > 0)
		{
			local despawnID = ids.roll();

			consumedResources = this.m.LookupMap[despawnID].getCost();
			_spawnProcess.decrementUnit(despawnID, this.getID());

			::logInfo("--> Despawning - Block: " + this.getID() + " - Unit: " + ::DSF.Units.findById(despawnID).getEntityType() + " (Cost: " + this.LookupMap[roll.ID].Cost + ") <--\n");
		}

		return consumedResources;
	}
*/

	function upgradeUnit( _spawnProcess )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the highest tier
		for (local i = 0; i < this.m.Units.len() - 1; i++)
		{
			local id = this.m.Units[i].getID();
			local count = _spawnProcess.getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i + 1; j < this.m.Units.len(); j++)	// for loop because the next very unitType could have some requirements (like playerstrength) preventing spawn
				{
					if (this.m.Units[j].canSpawn(_spawnProcess, this.m.Units[i].getCost()))
					{
						local weight = count + (this.m.Units.len() - i) * 3;	// weight higher for weaker troopTypes and those that already spawned a lot
						ids.add({ID = id, UpgradeID = this.m.Units[j].getID()}, weight);
					}
				}

			}
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();
			_spawnProcess.decrementUnit(roll.ID, this.getID());
			_spawnProcess.incrementUnit(roll.UpgradeID, this.getID());
			_spawnProcess.consumeResources(this.m.LookupMap[roll.UpgradeID].getCost() - this.m.LookupMap[roll.ID].getCost());
			if (!::DSF.Const.Benchmark && ::DSF.Const.DetailedLogging ) ::logInfo("**Upgrading - Block: " + this.getID() + " - Unit: " + this.m.LookupMap[roll.ID].getEntityType() + " (Cost: " + this.m.LookupMap[roll.ID].getCost() + ") to " + this.m.LookupMap[roll.UpgradeID].getEntityType() + " (Cost: " + this.m.LookupMap[roll.UpgradeID].getCost() + ")**\n");
		}
	}

	function downgradeUnit( _spawnProcess )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the bottom most tier
		for (local i = this.m.Units.len() - 1; i > 0; i--)
		{
			local id = this.m.Units[i].getID();
			local count = _spawnProcess.getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i; j >= 0; j--)
				{
					if (this.m.Units[j].canSpawn(_spawnProcess)) ids.add({ID = id, DowngradeID = this.m.Units[i-1].getID()}, count);
				}
			}
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();

			_spawnProcess.addResources(this.m.LookupMap[roll.ID].Cost);
			_spawnProcess.decrementUnit(roll.ID, this.getID());

			_spawnProcess.incrementUnit(roll.DowngradeID, this.getID());
			_spawnProcess.consumeResources(this.m.LookupMap[roll.DowngradeID].Cost);

			::logInfo("!! Downgrading - Block: " + this.getID() + " - Unit: " + roll.ID + " (Cost: " + this.m.LookupMap[roll.ID].Cost + ") to " + roll.DowngradeID + " (Cost: " + this.m.LookupMap[roll.DowngradeID].Cost + ") !!\n");

			return true;
		}

		return false;
	}

	function canSpawn( _spawnProcess )
	{
		if (_spawnProcess.getTotal() < this.getReqPartySize()) return false;

		foreach (unit in this.m.Units)
		{
			if (unit.canSpawn( _spawnProcess )) return true;
		}

		return false;
	}

	// _spawnInfo is Array of Arrays which counts the spawned troops in this spawnprocess
	function canUpgrade( _spawnProcess )
	{
		for (local i = 0; i < this.m.Units.len() - 1; i++)
		{
			if (_spawnProcess.getUnitCount(this.m.Units[i].getID(), this.getID()) > 0)
			{
				for (local j = i + 1; j < this.m.Units.len(); j++)	// This requires the unit list to be sorted by cost
				{
					if (this.m.Units[j].canSpawn(_spawnProcess, this.m.Units[i].getCost())) return true;
				}
			}
		}

		return false;
	}

	function sort()
	{
		this.m.Units.sort(@(a, b) a.getCost() <=> b.getCost());
	}

// Events
	function onPartySpawnStart()
	{
		this.sort();
	}

	function onPartySpawnEnd()
	{
	}

};
