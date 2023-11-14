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

	constructor( _unitBlockDef )
	{
		this.ID = "";
		this.UnitDefs = [];
		this.DeterminesFigure = false;

		this.__LookupMap = {};

		this.copyDataFromDef(_unitBlockDef);
	}

	function setSpawnProcess( _spawnProcess )
	{
		base.setSpawnProcess(_spawnProcess);
		foreach (unit in this.__Units)
		{
			unit.setSpawnProcess(_spawnProcess);
		}
	}

	function doCycle( _forceSpawn = false, _forceUpgrade = false )
	{
		if (_forceSpawn) this.spawnUnit();
		else if (_forceUpgrade) this.upgradeUnit();
		return true;
	}

	function init()
	{
		this.__Units = ::DynamicSpawns.Class.WeightedArray();

		if (this.UnitDefs instanceof ::MSU.Class.WeightedContainer)
		{
			foreach (unitDef, weight in this.UnitDefs)
			{
				local unit = ::DynamicSpawns.__getObjectFromDef(unitDef, ::DynamicSpawns.Units);
				this.__Units.add(unit, weight);
				this.__LookupMap[unit.getID()] <- unit;
			}
		}
		else
		{
			foreach (i, unitDef in this.UnitDefs)
			{
				local unit = ::DynamicSpawns.__getObjectFromDef(unitDef, ::DynamicSpawns.Units);
				this.__Units.add(unit, 1)
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
	function canSpawn()
	{
		if (this.__SpawnProcess.getTotal() < this.ReqPartySize) return false;
		if (this.__SpawnProcess.getBlockTotal(this.getID()) >= this.getHardMax()) return false;

		// RatioMax is ignored if we do not satisfy the RatioMin yet
		if (this.satisfiesRatioMin() && !this.isWithinRatioMax()) return false;

		// Atleast one of our referenced units is able to spawn
		foreach (unit in this.__Units)
		{
			if (unit.canSpawn()) return true;
		}

		return false;
	}

	// Returns true if the ratio of this unitblock would still be below its defined RatioMax if it was to spawn the next unit
	function isWithinRatioMax()
	{
		local referencedTotal = ::Math.max(this.__SpawnProcess.getTotal() + 1.0, this.__SpawnProcess.getParty().getHardMin());
		local maxAllowed = ::Math.round(this.RatioMax * referencedTotal);
		return (this.__SpawnProcess.getBlockTotal(this.getID()) < maxAllowed);
	}

	// Returns true if the ratio of this unitblock would still be above its defined RatioMin if it was to spawn the next unit
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
		if (this.isRandom())
		{
			local possibleSpawns = ::MSU.Class.WeightedContainer();
			foreach(unit in this.getUnits())
			{
				if (unit.canSpawn()) possibleSpawns.add(unit, this.getUnits().getWeight(unit));
			}
			chosenUnit = possibleSpawns.roll();
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
		if (this.isRandom()) return;	// This should never happen because the canUpgrade check already returns false in these cases

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
					if (this.__Units[j].canSpawn(this.__Units[i].getCost()))
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
		if (this.isRandom()) return false;		// A UnitBlock that is purely random does not support an upgrade system

		for (local i = 0; i < this.__Units.len() - 1; i++)
		{
			if (this.__SpawnProcess.getUnitCount(this.__Units[i].getID(), this.getID()) > 0)
			{
				for (local j = i + 1; j < this.__Units.len(); j++)	// This requires the unit list to be sorted by cost
				{
					if (this.__Units[j].canSpawn(this.__Units[i].getCost())) return true;
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
	}
};
