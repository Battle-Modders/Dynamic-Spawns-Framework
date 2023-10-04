// A group of similar units that upgrade into one another
::DynamicSpawns.Class.UnitBlock <- class extends ::DynamicSpawns.Class.Spawnable
{
	// Required Parameter
	UnitDefs = null;		// Array of Tables that require atleast 'ID' of the used Units. Other parameter will overwrite those in the referenced Units

	// Optional Parameter
	DeterminesFigure = null;	// If true then the spawned troops from this Block are in the race for the final Figure of the spawned party

	// Private
	__LookupMap = null;

	// During Spawnprocess only
	__Units = null;		// Array of cloned Unit-Objects
	__UnitsWeightedContainer = null;

	constructor( _unitBlockDef )
	{
		this.ID = "";
		this.UnitDefs = [];
		this.DeterminesFigure = false;

		this.__LookupMap = {};

		this.copyDataFromDef(_unitBlockDef);
	}

	function init()
	{
		if (this.UnitDefs instanceof ::MSU.Class.WeightedContainer)
		{
			this.__Units = [];
			this.__UnitsWeightedContainer = ::MSU.Class.WeightedContainer();
			foreach (unitDef, weight in this.UnitDefs)
			{
				local unit = ::DynamicSpawns.__getObjectFromDef(unitDef, ::DynamicSpawns.Units);
				this.__Units.push(unit);
				this.__UnitsWeightedContainer.add(unit, weight);
				this.__LookupMap[unit.getID()] <- unit;
			}
		}
		else
		{
			this.__Units = array(this.UnitDefs.len());
			foreach (i, unitDef in this.UnitDefs)
			{
				local unit = ::DynamicSpawns.__getObjectFromDef(unitDef, ::DynamicSpawns.Units);
				this.__Units[i] = unit;
				this.__LookupMap[unit.getID()] <- unit;
			}
		}

		return this;
	}

	function getID()
	{
		return this.ID;
	}

	function getUnits()
	{
		return this.__Units;
	}

	function getUnitDefs()
	{
		return this.UnitDefs;
	}

	function isRandom()
	{
		return this.UnitDefs instanceof ::MSU.Class.WeightedContainer;
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
		return this.__LookupMap[_id];
	}

	// Returns true if this Block is allowed to spawn another unit and atleast one of its units is also able to be spawned
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function canSpawn( _spawnProcess )
	{
		if (_spawnProcess.getTotal() < this.ReqPartySize) return false;

		// RatioMax is ignored if we do not satisfy the RatioMin yet
		if (this.satisfiesRatioMin(_spawnProcess) && !this.isWithinRatioMax(_spawnProcess)) return false;

		// Atleast one of our referenced units is able to spawn
		foreach (unit in this.__Units)
		{
			if (unit.canSpawn(_spawnProcess)) return true;
		}

		return false;
	}

	// Returns true if the ratio of this unitblock would still be below its defined RatioMax if it was to spawn the next unit
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function isWithinRatioMax( _spawnProcess )
	{
		local referencedTotal = ::Math.max(_spawnProcess.getTotal() + 1.0, _spawnProcess.getParty().getHardMin());
		local maxAllowed = ::Math.round(this.RatioMax * referencedTotal);
		return (_spawnProcess.getBlockTotal(this.getID()) < maxAllowed);
	}

	// Returns true if the ratio of this unitblock would still be above its defined RatioMin if it was to spawn the next unit
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function satisfiesRatioMin( _spawnProcess )
	{
		local referencedTotal = _spawnProcess.getTotal() + 1;
		if (_spawnProcess.getTotal() + 1 < _spawnProcess.getParty().getHardMin())
		{
			referencedTotal = _spawnProcess.getParty().getHardMin();
		}

		local minRequired = ::Math.ceil(referencedTotal * this.RatioMin);	// Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the ReqPartySize or StartingResourceMin alongside that to prevent small parties from spawning exotic units.

		return (_spawnProcess.getBlockTotal(this.getID()) >= minRequired);
	}

	function spawnUnit( _spawnProcess )
	{
		local chosenUnit = null;
		if (this.isRandom())	// Currently this is implemented non-weighted and purely random
		{
			local possibleSpawns = ::MSU.Class.WeightedContainer();
			foreach(unit, weight in this.__UnitsWeightedContainer)
			{
				if (unit.canSpawn(_spawnProcess)) possibleSpawns.add(unit, weight);
			}
			chosenUnit = possibleSpawns.roll();
		}
		else	// Weakest affordable unit is spawned
		{
			foreach (unit in this.getUnits())
			{
				if (unit.canSpawn(_spawnProcess))
				{
					chosenUnit = unit;
					break;
				}
			}
		}

		if (chosenUnit == null) return;		// This should not happen

		_spawnProcess.incrementUnit(chosenUnit.getID(), this.getID());
		if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging ) ::logInfo("Spawning - Block: " + this.getID() + " - Unit: " + chosenUnit.getTroop() + " (Cost: " + chosenUnit.getCost() + ")\n");
		_spawnProcess.consumeResources(chosenUnit.getCost());
	}

	function upgradeUnit( _spawnProcess )
	{
		if (this.isRandom()) return;	// This should never happen because the canUpgrade check already returns false in these cases

		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the highest tier
		for (local i = 0; i < this.__Units.len() - 1; i++)
		{
			local id = this.__Units[i].getID();
			local count = _spawnProcess.getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i + 1; j < this.__Units.len(); j++)	// for loop because the next very unitType could have some requirements (like playerstrength) preventing spawn
				{
					if (this.__Units[j].canSpawn(_spawnProcess, this.__Units[i].getCost()))
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
			_spawnProcess.decrementUnit(roll.ID, this.getID());
			_spawnProcess.incrementUnit(roll.UpgradeID, this.getID());
			_spawnProcess.consumeResources(this.__LookupMap[roll.UpgradeID].getCost() - this.__LookupMap[roll.ID].getCost());
			if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging ) ::logInfo("**Upgrading - Block: " + this.getID() + " - Unit: " + this.__LookupMap[roll.ID].getTroop() + " (Cost: " + this.__LookupMap[roll.ID].getCost() + ") to " + this.__LookupMap[roll.UpgradeID].getTroop() + " (Cost: " + this.__LookupMap[roll.UpgradeID].getCost() + ")**\n");
		}
	}

	// _spawnInfo is Array of Arrays which counts the spawned troops in this spawnprocess
	function canUpgrade( _spawnProcess )
	{
		if (this.isRandom()) return false;		// A UnitBlock that is purely random does not support an upgrade system

		for (local i = 0; i < this.__Units.len() - 1; i++)
		{
			if (_spawnProcess.getUnitCount(this.__Units[i].getID(), this.getID()) > 0)
			{
				for (local j = i + 1; j < this.__Units.len(); j++)	// This requires the unit list to be sorted by cost
				{
					if (this.__Units[j].canSpawn(_spawnProcess, this.__Units[i].getCost())) return true;
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
	function onBeforeSpawnStart( _spawnProcess )
	{
		// We remove all Units that can't ever spawn in the first place to improve performance
		local unitArray = this.getUnits();
		for (local i = unitArray.len() - 1; i >= 0; i--)
		{
			if (unitArray[i].isValid(_spawnProcess) == false) unitArray.remove(i);
		}

		this.sort();
	}

	// This is will not be called if this UnitBlock is InValid and was removed by its Party during this spawn process
	function onSpawnEnd( _spawnProcess )
	{
	}
};
