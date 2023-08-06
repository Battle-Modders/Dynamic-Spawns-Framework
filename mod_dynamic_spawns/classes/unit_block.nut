// A group of similar units that upgrade into one another
this.unit_block <- inherit(::MSU.BBClass.Empty, {
	m = {
	// Required Parameter
		ID = null,
		UnitDefs = [],		// Array of Tables that require atleast 'ID' of the used Units. Other parameter will overwrite those in the referenced Units

	// Optional Parameter
		IsRandom = false,			// A random Block will not upgrade between its troops and instead pick a random one each time
		DeterminesFigure = false,	// If true then the spawned troops from this Block are in the race for the final Figure of the spawned party

		// Guards						// This Unit is only able to spawn if ...
		ReqPartySize = 0,         		// ... the amount of already spawned troops in the current SpawnProcess is at least this value
		MinStartingResource = 0,		// ... the StartingResources of the current SpawnProcess is at least this value
		MaxStartingResource = 900000,	// ... the StartingResources of the current SpawnProcess is at most this value
		MinDays = 0,					// ... ::World.getTime().Days is at least this value
		MaxDays = 900000				// ... ::World.getTime().Days is at most this value

		RatioMin = 0.00,				// If the ratio of already spawned units of this Block is below this value then the SpawnProcess will issue a ForceSpawn
		RatioMax = 1.00,				// This Block can't spawn another unit if that would make the ratio of already spawned units of this Block exceed this value

	// Private
		LookupMap = {},

		// During Spawnprocess only
		Units = []		// Array of cloned Unit-Objects
	}

	function create()
	{
	}

	function init( _unitBlockDef )
	{
		this.m.ID = _unitBlockDef.ID;

		foreach (key, value in _unitBlockDef)
		{
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

	// Returns a copy of this unitBlock (except that arrays and tables)
	function getClone( _unitBlockDef = null )
	{
		local clonedBlock = ::new(::DynamicSpawns.Class.UnitBlock);

		// Copy all member variables from this unitBlock to its clone
		foreach (key, value in this.m)
		{
			// We skip arrays for now as they would only arrive as references which is not real cloning
			if (typeof value == "array") continue;
			// We skip tables for now as they would only arrive as references which is not real cloning
			if (typeof value == "table") continue;

			clonedBlock.m[key] = value;
		}

		// Copy all data provided by the _partyDef (e.g. custom HardMin/HardMax) into the clone
		if (_unitBlockDef != null) clonedBlock.init(_unitBlockDef);

		// Create clones of all Units needed for this
		clonedBlock.m.Units = [];
		foreach (unitDef in this.m.UnitDefs)
		{
			local unit = ::DynamicSpawns.Units.findById(unitDef.ID).getClone(unitDef);
			clonedBlock.m.Units.push(unit);
		}

		// Add cloned units to the cloned objects LookupMap
		clonedBlock.addUnits(clonedBlock.getUnits());

		return clonedBlock;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getUnits()
	{
		return this.m.Units;
	}

	function getUnitDefs()
	{
		return this.m.UnitDefs;
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
			this.m.LookupMap[unit.getID()] <- unit;
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

	// Returns true if this Block is allowed to spawn another unit and atleast one of its units is also able to be spawned
	// _spawnProcess = current spawnprocess reference that includes most important variables
	function canSpawn( _spawnProcess )
	{
		if (_spawnProcess.getStartingResources() < this.m.MinStartingResource) return false;
		if (_spawnProcess.getStartingResources() > this.m.MaxStartingResource) return false;
		if (_spawnProcess.getWorldDays() < this.m.MinDays) return false;
		if (_spawnProcess.getWorldDays() > this.m.MaxDays) return false;
		if (_spawnProcess.getTotal() < this.m.ReqPartySize) return false;

		// RatioMax is ignored if we do not satisfy the RatioMin yet
		if (this.satisfiesRatioMin(_spawnProcess) && !this.isWithinRatioMax(_spawnProcess)) return false;

		// Atleast one of our referenced units is able to spawn
		foreach (unit in this.m.Units)
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
		local maxAllowed = ::Math.round(this.m.RatioMax * referencedTotal);
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

		local minRequired = ::Math.ceil(referencedTotal * this.m.RatioMin);	// Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the ReqPartySize or MinStartingResource alongside that to prevent small parties from spawning exotic units.

		return (_spawnProcess.getBlockTotal(this.getID()) >= minRequired);
	}

	function spawnUnit( _spawnProcess )
	{
		local chosenUnit = null;
		if (this.m.IsRandom)	// Currently this is implemented non-weighted and purely random
		{
			local possibleSpawns = [];
			foreach(unit in this.getUnits())
			{
				if (unit.canSpawn(_spawnProcess)) possibleSpawns.push(unit);
			}
			if (possibleSpawns.len() != 0) chosenUnit = possibleSpawns[::Math.rand(0, possibleSpawns.len() - 1)];
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
		if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging ) ::logInfo("Spawning - Block: " + this.getID() + " - Unit: " + chosenUnit.getEntityType() + " (Cost: " + chosenUnit.getCost() + ")\n");
		_spawnProcess.consumeResources(chosenUnit.getCost());
	}

	function upgradeUnit( _spawnProcess )
	{
		if (this.m.IsRandom) return;	// This should never happen because the canUpgrade check already returns false in these cases

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
			if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging ) ::logInfo("**Upgrading - Block: " + this.getID() + " - Unit: " + this.m.LookupMap[roll.ID].getEntityType() + " (Cost: " + this.m.LookupMap[roll.ID].getCost() + ") to " + this.m.LookupMap[roll.UpgradeID].getEntityType() + " (Cost: " + this.m.LookupMap[roll.UpgradeID].getCost() + ")**\n");
		}
	}

	// _spawnInfo is Array of Arrays which counts the spawned troops in this spawnprocess
	function canUpgrade( _spawnProcess )
	{
		if (this.m.IsRandom == true) return false;		// A UnitBlock that is purely random does not support an upgrade system

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

});
