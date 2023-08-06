this.party <- inherit(::MSU.BBClass.Empty, {
	m = {
        ID = null,
        UnitBlockDefs = [],	// Array of Tables that require atleast 'ID' of the used UnitBlocks. Other parameter will overwrite those in the referenced UnitBLock
        // Resources = 0;

        UpgradeChance = 1.0,	// Chance that this Party will upgrade a unit instead of spawning a new unit when IdealSize is reached
        StaticUnits = [],	// Array of UnitObjects that are forced to spawn if the Resources allow it. Can have multiples of the same unit

		// Guards
        HardMin = 0,		// @Darxo: Smallest army size that is allowed for this unit to even make sense. Ressources are disregarded while trying to satisfy this. Could maybe be set to 1 be default
        HardMax = 9000,		// @Darxo: Greatest army size that is allowed for this unit to even make sense. All spawning (not upgrading) is stopped when this is reached

		// Vanilla Properties of a Party
		DefaultFigure = "",		// This Figure will be used if the spawned units couldnt provide a better fitting one
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,

		// During Spawnprocess only
		UnitBlocks = []		// Array of cloned UnitBlock classes. Is only filled during a spawning process
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

		foreach (unitBlock in this.m.UnitBlockDefs)	// Make sure there are default values for these Variables
		{
			if (!("RatioMin" in unitBlock)) unitBlock.RatioMin <- 0.0;
			if (!("RatioMax" in unitBlock)) unitBlock.RatioMax <- 1.0;
			if (!("DeterminesFigure" in unitBlock)) unitBlock.DeterminesFigure <- false;
		}

		this.Body <- this.m.DefaultFigure;	// Because Vanilla expects a Table with this entry

		return this;
	}

	// Returns a copy of this party (except that arrays)
	function getClone( _partyDef = null )
	{
		local clonedParty = ::new(::DynamicSpawns.Class.Party);

		// Copy all member variables from this party to its clone
		foreach (key, value in this.m)
		{
			// We skip arrays for now as they would only arrive as references which is not real cloning
			if (typeof value == "array") continue;

			clonedParty.m[key] = value;
		}

		// Manually copy static unit ids over
		foreach ( staticUnit in this.m.StaticUnits)
		{
			clonedParty.m.StaticUnits.push(staticUnit.getClone());
		}

		// Copy all data provided by the _partyDef (e.g. custom HardMin/HardMax) into the clone
		if (_unitBlockDef != null) clonedParty.init(_partyDef);

		// Create clones of all UnitBlocks needed for this
		this.m.UnitBlocks = [];
		foreach (unitBlockDef in this.m.UnitBlockDefs)
		{
			local unitBlock = ::DynamicSpawns.UnitBlocks.findById(unitBlockDef.ID).getClone(unitBlockDef);
			this.m.UnitBlocks.push(unitBlock);
		}

		// Create clones of all StaticUnits

		return clonedParty;
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

	// returns an array of unitblock objects
	function getUnitBlocks()
	{
		return this.m.UnitBlocks;
	}

	// returns an array of def-tables
	function getUnitBlockDefs()
	{
		return this.m.UnitBlockDefs;
	}

	function spawn( _resources, _opposingParty = null, _customHardMin = -1, _customHardMax = -1 )
	{
		// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
		local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
		spawnProcess.init(this, _resources, _opposingParty, _customHardMin, _customHardMax);
		return spawnProcess.spawn();
	}

	// Returns an unsigned integer. This can be random as this function is called only once during a SpawnProcess
	function generateIdealSize()
	{
		local referencedBrothersAmount = this.getReferencedBrotherAmount();
		referencedBrothersAmount += (::Math.max(2, ::Math.floor(referencedBrothersAmount * 0.3)));
		referencedBrothersAmount + ::Math.rand(-1, 2);	// A little bit of random variance
		return referencedBrothersAmount;
	}

	function getReferencedBrotherAmount()
	{
		local referencedAmount = ::World.getPlayerRoster().getAll().len();
		referencedAmount = ::Math.min(referencedAmount, ::World.Assets.getBrothersScaleMax());
		referencedAmount = ::Math.max(referencedAmount, ::World.Assets.getBrothersScaleMin());
		return referencedAmount;
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

	// Returns false if there is a reason why this party is not allowed to spawn anymore. This function only checks for a small subset of all possible reasons.
	// Checks only against HardMax and HardMin
	function canSpawn( _spawnProcess )
	{
		if (_spawnProcess.getTotal() >= this.getHardMax()) return false;

		// Atleast one of our unitBlocks must be able to spawn units
		foreach (unitBlock in this.getUnitBlocks())
		{
			if (unitBlock.canSpawn(_spawnProcess)) return true;
		}

		return false;

	}

});

