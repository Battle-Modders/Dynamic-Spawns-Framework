// A group of similar units that upgrade into one another
::DynamicSpawns.Class.UnitBlock <- class extends ::DynamicSpawns.Class.Spawnable
{
	UnitDefs = null;
	DeterminesFigure = false;	// If true then the spawned troops from this Block are in the race for the final Figure of the spawned party
	IsRandom = false;

	DaysMin = 0;
	DaysMax = 90000;

	// During Spawnprocess only
	__LookupMap = null;
	__Units = null;		// Array of cloned Unit-Objects

	// Create Units from UnitDefs
	function init()
	{
		this.__LookupMap = {};
		this.__Units = [];
		// Create clones of all Units needed for this
		this.__Units = array(this.UnitDefs.len());
		foreach (i, unitDef in this.UnitDefs)
		{
			if (!("ID" in unitDef))
			{
				::DynamicSpawns.Static.registerUnit(unitDef);
			}
			local unit = ::DynamicSpawns.Units.findById(unitDef.ID).getClone(unitDef, false);
			unit.setSpawnProcess(this.__SpawnProcess);
			unit.init();
			this.__Units[i] = unit;
			this.__LookupMap[unit.getID()] <- unit;
		}

		// Add cloned units to the cloned objects LookupMap
		// this.addUnits(this.getUnits());

		return this;
	}

	// Returns a copy of this unitBlock (except that arrays and tables)
	function getClone( _unitBlockDef = null, _initialize = true )
	{
		local clonedBlock = clone this;

		if (_unitBlockDef != null)
		{
			// Copy all data provided by the _unitBlockDef
			foreach (key, value in _unitBlockDef)
			{
				clonedBlock[key] = value;
			}
		}

		if (_initialize)
			clonedBlock.init();

		return clonedBlock;
	}

	function getUnits()
	{
		return this.__Units;
	}

	function getUnitDefs()
	{
		return this.UnitDefs;
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

	function addUnits( _units )
	{
		foreach (unit in _units)
		{
			this.__LookupMap[unit.getID()] <- unit;
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
	function getUpgradeWeight()
	{
		local weight = 0;
		foreach (unit in this.__SpawnProcess.getUnits(this.getID()))
		{
			weight += this.getStrongerUnitTypeCount(unit);
		}
		return weight;
	}

	function getUnit( _id )
	{
		return this.__LookupMap[_id];
	}

	// Returns true if this Block is allowed to spawn another unit and atleast one of its units is also able to be spawned
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function canSpawn()
	{
		if (this.__SpawnProcess.getTotal() < this.ReqPartySize) return false;

		// RatioMax is ignored if we do not satisfy the RatioMin yet
		if (this.satisfiesRatioMin() && !this.isWithinRatioMax()) return false;

		// Atleast one of our referenced units is able to spawn
		foreach (unit in this.__Units)
		{
			if (unit.canSpawn()) return true;
		}

		return false;
	}

	// Returns true if this Block can theortically spawn a unit during this spawn proccess
	// This is done by checking variables which never change during the spawn process
	function isValid()
	{
		if (::Math.round(this.__SpawnProcess.getStartingResources()) < this.StartingResourceMin) return false;
		if (::Math.round(this.__SpawnProcess.getStartingResources()) > this.StartingResourceMax) return false;
		if (this.__SpawnProcess.getWorldDays() < this.DaysMin) return false;
		if (this.__SpawnProcess.getWorldDays() > this.DaysMax) return false;

		return true;
	}

	// Returns true if the ratio of this unitblock would still be below its defined RatioMax if it was to spawn the next unit
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function isWithinRatioMax()
	{
		local referencedTotal = ::Math.max(this.__SpawnProcess.getTotal() + 1.0, this.__SpawnProcess.getParty().getHardMin());
		local maxAllowed = ::Math.round(this.RatioMax * referencedTotal);
		return (this.__SpawnProcess.getBlockTotal(this.getID()) < maxAllowed);
	}

	// Returns true if the ratio of this unitblock would still be above its defined RatioMin if it was to spawn the next unit
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function satisfiesRatioMin()
	{
		local referencedTotal = this.__SpawnProcess.getTotal() + 1;
		if (this.__SpawnProcess.getTotal() + 1 < this.__SpawnProcess.getParty().getHardMin())
		{
			referencedTotal = this.__SpawnProcess.getParty().getHardMin();
		}

		local minRequired = ::Math.ceil(referencedTotal * this.RatioMin);	// Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the ReqPartySize or StartingResourceMin alongside that to prevent small parties from spawning exotic units.

		return (this.__SpawnProcess.getBlockTotal(this.getID()) >= minRequired);
	}

	function spawnUnit()
	{
		local chosenUnit = null;
		if (this.IsRandom)	// Currently this is implemented non-weighted and purely random
		{
			local possibleSpawns = [];
			foreach(unit in this.getUnits())
			{
				if (unit.canSpawn()) possibleSpawns.push(unit);
			}
			if (possibleSpawns.len() != 0) chosenUnit = possibleSpawns[::Math.rand(0, possibleSpawns.len() - 1)];
		}
		else	// Weakest affordable unit is spawned
		{
			foreach (unit in this.getUnits())
			{
				if (unit.canSpawn())
				{
					chosenUnit = unit;
					break;
				}
			}
		}

		if (chosenUnit == null) return;		// This should not happen

		this.__SpawnProcess.incrementUnit(chosenUnit.getID(), this.getID());
		if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging ) ::logInfo("Spawning - Block: " + this.getID() + " - Unit: " + chosenUnit.getTroop() + " (Cost: " + chosenUnit.getCost() + ")\n");
		this.__SpawnProcess.consumeResources(chosenUnit.getCost());
	}

	function upgradeUnit()
	{
		if (this.IsRandom) return;	// This should never happen because the canUpgrade check already returns false in these cases

		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the highest tier
		for (local i = 0; i < this.__Units.len() - 1; i++)
		{
			local id = this.__Units[i].getID();
			local count = this.__SpawnProcess.getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i + 1; j < this.__Units.len(); j++)	// for loop because the next very unitType could have some requirements (like playerstrength) preventing spawn
				{
					if (this.__Units[j].canSpawn(), this.__Units[i].getCost())
					{
						local weight = count + (this.__Units.len() - i) * 3;	// weight higher for weaker troopTypes and those that already spawned a lot
						ids.add({ID = id, UpgradeID = this.__Units[j].getID()}, weight);
						break;	// We are only interested in the closest possible upgrade path, not all of them
					}
				}

			}
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();
			this.__SpawnProcess.decrementUnit(roll.ID, this.getID());
			this.__SpawnProcess.incrementUnit(roll.UpgradeID, this.getID());
			this.__SpawnProcess.consumeResources(this.__LookupMap[roll.UpgradeID].getCost() - this.__LookupMap[roll.ID].getCost());
			if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging ) ::logInfo("**Upgrading - Block: " + this.getID() + " - Unit: " + this.__LookupMap[roll.ID].getTroop() + " (Cost: " + this.__LookupMap[roll.ID].getCost() + ") to " + this.__LookupMap[roll.UpgradeID].getTroop() + " (Cost: " + this.__LookupMap[roll.UpgradeID].getCost() + ")**\n");
		}
	}

	// _spawnInfo is Array of Arrays which counts the spawned troops in this spawnprocess
	function canUpgrade()
	{
		if (this.IsRandom == true) return false;		// A UnitBlock that is purely random does not support an upgrade system

		for (local i = 0; i < this.__Units.len() - 1; i++)
		{
			if (this.__SpawnProcess.getUnitCount(this.__Units[i].getID(), this.getID()) > 0)
			{
				for (local j = i + 1; j < this.__Units.len(); j++)	// This requires the unit list to be sorted by cost
				{
					if (this.__Units[j].canSpawn(), this.__Units[i].getCost()) return true;
				}
			}
		}

		return false;
	}

	function sort()
	{
		this.__Units.sort(@(a, b) a.getCost() <=> b.getCost());
	}

// Events

	// This is will not be called if this UnitBlock is InValid and was removed by its Party during this spawn process
	function onBeforeSpawnStart()
	{
		// We remove all Units that can't ever spawn in the first place to improve performance
		local unitArray = this.getUnits();
		for (local i = unitArray.len() - 1; i >= 0; i--)
		{
			if (unitArray[i].isValid() == false) unitArray.remove(i);
		}

		this.sort();
	}

	// This is will not be called if this UnitBlock is InValid and was removed by its Party during this spawn process
	function onSpawnEnd()
	{
		this.__Units = null;
		this.__LookupMap = null;
	}
};
