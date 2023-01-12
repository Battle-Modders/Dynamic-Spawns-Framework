this.party <- {
	m = {
        ID = null,
        UnitBlocks = [],	// Array of Tables that require a 'ID' and optionally 'RatioMin' and 'RatioMax'
        // IdealSize = 5;
        // Resources = 0;
        HardMin = 0,		// @Darxo: Smallest army size that is allowed for this troop to even make sense. Ressources are disregarded while trying to satisfy this. Could maybe be set to 1 be default
        HardMax = -1,		// @Darxo: Greatest army size that is allowed for this troop to even make sense. All spawning (not upgrading) is stopped when this is reached
        UpgradeChance = 1.0,	// Chance that this Party will upgrade a unit instead of spawning a new unit when IdealSize is reached
        StaticUnits = []	// Array of UnitObjects that are forced to spawn if the Resources allow it. Can have multiples of the same unit
    }

	function create()
	{
	}

    function init( _partyDef )
	{
		this.m.ID = _partyDef.ID;

		foreach (key, value in _partyDef)
		{
			if (key == "StaticUnits")	// StaticUnits are passed by their IDs
			{
				foreach (unitID in value)
				{
					this.m.StaticUnits.push(::DSF.Units.findById(unitID));
				}
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

		foreach (unitBlock in this.m.UnitBlocks)	// Make sure there are default values for these Variables
		{
			if(!("RatioMin" in unitBlock)) unitBlock.RatioMin <- 0.0;
			if(!("RatioMax" in unitBlock)) unitBlock.RatioMax <- 1.0;
		}
		return this;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getUnitBlocks()
	{
		return this.m.UnitBlocks;
	}

	function getIdealSize()
	{
		return this.m.IdealSize != null ? this.m.IdealSize : ::World.Roster.getAll().len() * 1.5;
	}

	function getHardMin()
	{
		return this.m.HardMin;
	}

	function getHardMax()
	{
		return this.m.HardMax;
	}

	function getUpgradeChance()
	{
		return this.m.UpgradeChance;
	}

	function getStaticUnits()
	{
		return this.m.StaticUnits;
	}

	// Checks only against HardMax and HardMin
	function canSpawn( _spawnProcess )
	{
		if (_spawnProcess.getTotal() < this.getHardMin()) return true;
		return (this.getHardMax() == -1 || _spawnProcess.getTotal() + 1 <= this.getHardMax());
	}

	// _blockTotal = troop count of this unitBlock; _total = total count of spawned troops; _block = UnitBlock or Table with UnitBlock Id and optional parameter
	function isWithinRatioMax( _spawnProcess, _pBlock )
	{
		local referencedTotal = (_spawnProcess.getTotal() + 1 > this.getHardMin()) ? _spawnProcess.getTotal() + 1 : this.getHardMin();
		local maxAllowed = ::Math.round(_pBlock.RatioMax * referencedTotal);
		return (_spawnProcess.getBlockTotal(_pBlock.ID) < maxAllowed);
	}

	// _blockTotal = troop count of this unitBlock; _total = total count of spawned troops; _block = UnitBlock or Table with UnitBlock Id and optional parameter
	function satisfiesRatioMin( _spawnProcess, _pBlock )
	{
		local referencedTotal = (_spawnProcess.getTotal() + 1 > this.getHardMin()) ? _spawnProcess.getTotal() + 1 : this.getHardMin();		// this is just ::Math.max() function which isn't available here
		local minRequired = ::Math.floor(referencedTotal * _pBlock.RatioMin);	// This floor() strictness is good to prevent exotic spawns in low troop sizes.
		// In return you will sometimes be 1 troop short of the required minimum

		return (_spawnProcess.getBlockTotal(_pBlock.ID) >= minRequired);
	}

};

