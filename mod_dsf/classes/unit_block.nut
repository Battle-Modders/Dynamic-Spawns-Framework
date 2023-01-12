// A group of similar units that upgrade into one another
this.unit_block <- {
	m = {
        ID = null,
        Units = [],         // Spawnable units
        LookupMap = null,
        IsStatic = null,
        ReqSize = 0,         // This Unit will only be able to spawn if the amount of already spawned troops is greater or equal to ReqSize
		PartMin = 0.0,		// This UnitBlock is forced to spawn troops until this percentage compared to total troops is satisfied. Rounded down currently
		PartMax = 1.0		// If an additional spawned troop would put this unitBlocks percentage over this value compared to total troop, then it returns false
	}

	function create()
	{
	}

    function init( _unitBlock )
	{
		this.m.LookupMap = {};
		this.m.ID = _unitBlock.ID;		
		this.m.Units = [];
		this.m.IsStatic = false;
		if ("ReqSize" in _unitBlock) this.m.ReqSize = _unitBlock.ReqSize;
		if ("PartMin" in _unitBlock) this.m.PartMin = _unitBlock.PartMin;
		if ("PartMax" in _unitBlock) this.m.PartMax = _unitBlock.PartMax;
		this.addUnits(_unitBlock.Units);		
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

	function getPartMin()
	{
		return this.m.PartMin;
	}

	function getReqSize()
	{
		return this.m.ReqSize;
	}

	function getPartMax()
	{
		return this.m.PartMax;
	}

	function getAverageCost()	// Average cost over all unit types in this block
	{
		local cost = 0.0;
		foreach(unit in this.getUnits())
		{
			cost += unit.getCost();
		}
		if(this.getUnits().len() == 0) return cost;
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

	// Returns amount of units in this block that are stronger than _unit (in terms of cost)
	function getStrongerUnitCount( _unit )
	{
		local count = 0
		foreach(unit in this.getUnits())
		{
			if(unit.getCost() > _unit.getCost()) count++;
		}
		return count;
	}

	function genUpgradeWeight( _spawnedUnits )
	{
		local weight = 0;
		foreach(unit in _spawnedUnits)
		{
			weight += this.getStrongerUnitCount(unit);
		}
		return weight;
	}

	function getUnit( _id )
	{
		return this.m.LookupMap[_id];
	}

	function spawnUnit(_spawnProcess, _playerStrength, _availableResources = -1 )
	{
		foreach (unit in this.m.Units)
		{
			if (unit.canSpawn(_playerStrength, _availableResources))
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

	function upgradeUnit( _spawnProcess, _playerStrength, _availableResources = -1 )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the highest tier
		for (local i = 0; i < this.m.Units.len() - 1; i++)
		{
			local id = this.m.Units[i].getID();
			local count = _spawnProcess.getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i + 1; j < this.m.Units.len(); j++)
				{
					if (this.m.Units[j].canSpawn(_playerStrength, _availableResources + this.m.Units[i].getCost()))
					{
						ids.add({ID = id, UpgradeID = this.m.Units[j].getID()}, count);
						break;
					}
				}
			}			
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();
			_spawnProcess.decrementUnit(roll.ID, this.getID());
			_spawnProcess.incrementUnit(roll.UpgradeID, this.getID());

			local consumedResources = this.m.LookupMap[roll.UpgradeID].getCost() - this.m.LookupMap[roll.ID].getCost();
			_spawnProcess.consumeResources(consumedResources);
			if (!::DSF.Const.Benchmark && ::DSF.Const.DetailedLogging ) ::logInfo("**Upgrading - Block: " + this.getID() + " - Unit: " + this.m.LookupMap[roll.ID].getEntityType() + " (Cost: " + this.m.LookupMap[roll.ID].getCost() + ") to " + this.m.LookupMap[roll.UpgradeID].getEntityType() + " (Cost: " + this.m.LookupMap[roll.UpgradeID].getCost() + ")**\n");
		}
	}

	function downgradeUnit( _party )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the bottom most tier
		for (local i = this.m.Units.len() - 1; i > 0; i--)
		{
			local id = this.m.Units[i].getID();
			local count = _party.getSpawnInfo().getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i; j >= 0; j--)
				{
					if (this.m.Units[j].canSpawn(_party)) ids.add({ID = id, DowngradeID = this.m.Units[i-1].getID()}, count);
				}
				
			} 
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();

			_party.getSpawnInfo().addResources(this.m.LookupMap[roll.ID].Cost);
			_party.getSpawnInfo().decrementUnit(roll.ID, this.getID());

			_party.getSpawnInfo().incrementUnit(roll.DowngradeID, this.getID());
			_party.getSpawnInfo().consumeResources(this.m.LookupMap[roll.DowngradeID].Cost);

			::logInfo("!! Downgrading - Block: " + this.getID() + " - Unit: " + roll.ID + " (Cost: " + this.m.LookupMap[roll.ID].Cost + ") to " + roll.DowngradeID + " (Cost: " + this.m.LookupMap[roll.DowngradeID].Cost + ") !!\n");

			return true;
		}

		return false;
	}

	function canSpawn( _totalSpawned, _playerStrength, _availableResources = -1 )
	{
		if (_totalSpawned < this.m.ReqSize) return false;

		foreach (unit in this.m.Units)
		{
			if (unit.canSpawn( _playerStrength, _availableResources )) return true;
		}

		return false;
	}

	// _spawnInfo is Array of Arrays which counts the spawned troops in this spawnprocess
	function canUpgrade( _spawnInfo, _playerStrength, _availableResources = -1)
	{
		for (local i = 0; i < this.m.Units.len() - 1; i++)
		{
			local resources = (_availableResources == -1) ? -1 : _availableResources + this.m.Units[i].getCost();
			if (_spawnInfo[this.getID()][this.m.Units[i].getID()] > 0)
			{
				for (local j = i + 1; j < this.m.Units.len(); j++)	// This requires the unit list to be sorted by cost
				{
					if (this.m.Units[j].canSpawn(_playerStrength, resources)) return true;
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