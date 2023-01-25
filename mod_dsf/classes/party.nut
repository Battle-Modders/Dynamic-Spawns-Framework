this.party <- {
	m = {
        ID = null,
        UnitBlocks = [],	// Array of Tables that require a 'ID', 'RatioMin', 'RatioMax' and optionally 'DeterminesFigure'
        // Resources = 0;
        HardMin = 0,		// @Darxo: Smallest army size that is allowed for this troop to even make sense. Ressources are disregarded while trying to satisfy this. Could maybe be set to 1 be default
        HardMax = -1,		// @Darxo: Greatest army size that is allowed for this troop to even make sense. All spawning (not upgrading) is stopped when this is reached
        UpgradeChance = 1.0,	// Chance that this Party will upgrade a unit instead of spawning a new unit when IdealSize is reached
        StaticUnits = [],	// Array of UnitObjects that are forced to spawn if the Resources allow it. Can have multiples of the same unit
		DefaultFigure = ""		// This Figure will be used if the spawned units couldnt provide a better fitting one

		// Vanilla Variables that are required
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
	},

	// Figure that represents this party on the world map. This is always filled at the very end of a spawn-process and uses DefaultFigure by default.
	Body = null,

	function create()
	{
	}

    function init( _partyDef )
	{
		this.m.ID = _partyDef.ID;
		// this.m.DefaultFigure = _partyDef.DefaultFigure;

		foreach (key, value in _partyDef)
		{
			if (key == "StaticUnits")	// StaticUnits are passed by their IDs
			{
				foreach (unitID in value)
				{
					this.m.StaticUnits.push(::DynamicSpawns.Units.findById(unitID));
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
			if (!("RatioMin" in unitBlock)) unitBlock.RatioMin <- 0.0;
			if (!("RatioMax" in unitBlock)) unitBlock.RatioMax <- 1.0;
			if (!("DeterminesFigure" in unitBlock)) unitBlock.DeterminesFigure <- false;
		}

		this.Body <- this.m.DefaultFigure;	// Because Vanilla expects a Table with this entry

		return this;
	}

	function updateFigure( _spawnProcess )
	{
		this.Body = this.getFigure(_spawnProcess);
	}

	function getFigure( _spawnProcess )
	{
		local priciestFigure = this.m.DefaultFigure;
		if (typeof this.m.DefaultFigure == "array") priciestFigure = this.m.DefaultFigure[::Math.rand(0, this.m.DefaultFigure.len() - 1)];
		local figurePrice = -9000;
		foreach (pBlock in this.getUnitBlocks())
		{
			if (pBlock.DeterminesFigure == false) continue;

			local unitBlock = ::DynamicSpawns.UnitBlocks.findById(pBlock.ID);
			foreach (unit in unitBlock.getUnits())
			{
				if (unit.getFigure() == "") continue;
				if (unit.getCost() <= figurePrice) continue;
				if (_spawnProcess.getUnitCount(unit.getID(), pBlock.ID) == 0) continue;

				priciestFigure = unit.getFigure();
				figurePrice = unit.getCost();
			}
		}
		if (priciestFigure == "") ::MSU.Exception.InvalidValue( "Figure cant be an empty string. Provide a DefaultFigure for this Party or make sure UnitBlocks with DeterminesFigure=True actually spawn units" )
		return priciestFigure;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getUnitBlocks()
	{
		return this.m.UnitBlocks;
	}

	function spawn( _resources, _opposingParty = null, _customHardMin = -1, _customHardMax = -1 )
	{
		// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
		local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
		spawnProcess.init(this, _resources, _opposingParty, _customHardMin, _customHardMax);
		return spawnProcess.spawn();
	}

	// Returns an unsigned integer. This can be random as this function is called only once during a SpawnProcess
	// _opposingParty: Party that this party is expected to fight
	function generateIdealSize( _spawnProcess, _opposingPartySize = null )
	{
		if (_opposingPartySize == null) _opposingPartySize = 10;
		return _opposingPartySize * 1.5;
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

