this.party <- inherit(::MSU.BBClass.Empty, {
	m = {
	// Required Parameter
		ID = null,
		UnitBlockDefs = [],	// Array of Tables that require atleast 'ID' of the used UnitBlocks. Other parameter will overwrite those in the referenced UnitBLock

	// Optional Parameter
		UpgradeChance = 0.5,	// Chance that this Party will upgrade a unit instead of spawning a new unit when IdealSize is reached
		StaticUnitIDs = [],		// Array of UnitIDs that are forced to spawn if the Resources allow it. Can have multiples of the same unit. They consume resources
		DefaultResources = 0,	// If the SpawnProcess is started without ResourceAmount it will use the value defined here. E.g. when spawning SubParties

		// Guards
		HardMin = 0,		// Smallest army size that is allowed for this party to even make sense. Ressources are disregarded while trying to satisfy this. Could maybe be set to 1 be default
		HardMax = 9000,		// Greatest army size that is allowed for this party to even make sense. All spawning (not upgrading) is stopped when this is reached

		// Vanilla Properties of a Party
		DefaultFigure = "",			// This Figure will be used if the spawned units couldnt provide a better fitting one
		MovementSpeedMult = 1.0,	// How fast does this party move on the world map
		VisibilityMult = 1.0,		// How hard is it to spot this party
		VisionMult = 1.0,			// How far can this party see

	// Private
		// During Spawnprocess only
		UnitBlocks = [],		// Array of cloned UnitBlock-Objects
		StaticUnits = []		// Array of cloned Unit-Objects
	},

	function create()
	{
	}

	function init( _partyDef )
	{
		this.m.ID = _partyDef.ID;
		// this.m.DefaultFigure = _partyDef.DefaultFigure;

		foreach (key, value in _partyDef)
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

	// Returns a copy of this party except Def-Arrays. Those must be provided by _partyDef is required
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

		// Copy all data provided by the _partyDef (e.g. custom HardMin/HardMax) into the clone
		if (_partyDef != null) clonedParty.init(_partyDef);

		// Create clones of all UnitBlocks needed for this
		this.m.UnitBlocks = [];
		foreach (unitBlockDef in this.m.UnitBlockDefs)
		{
			local unitBlock = ::DynamicSpawns.UnitBlocks.findById(unitBlockDef.ID).getClone(unitBlockDef);
			clonedParty.m.UnitBlocks.push(unitBlock);
		}

		// Create clones of all Static units needed for this
		foreach ( staticUnitID in this.m.StaticUnitIDs)
		{
			local staticUnit = ::DynamicSpawns.Units.findById(staticUnitID).getClone();
			clonedParty.m.StaticUnits.push(staticUnit.getClone());
		}

		return clonedParty;
	}

	function getFigure( _spawnProcess )
	{
		local priciestFigure = this.m.DefaultFigure;
		if (typeof this.m.DefaultFigure == "array") priciestFigure = this.m.DefaultFigure[::Math.rand(0, this.m.DefaultFigure.len() - 1)];
		local figurePrice = -9000;
		foreach (unitBlock in this.getUnitBlocks())
		{
			if (unitBlock.m.DeterminesFigure == false) continue;

			foreach (unit in unitBlock.getUnits())
			{
				if (unit.getFigure() == "") continue;
				if (unit.getCost() <= figurePrice) continue;
				if (_spawnProcess.getUnitCount(unit.getID(), unitBlock.getID()) == 0) continue;

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

	function spawn( _resources, _customHardMin = -1, _customHardMax = -1 )
	{
		// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
		local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
		spawnProcess.init({ID = this.getID()}, _resources, _customHardMin, _customHardMax);
		return spawnProcess.spawn();
	}

	// Returns an unsigned integer that will be used during this spawnProcess as IdealSize
	function generateIdealSize( _spawnProcess, _isLocation )
	{
		local idealSize = this.getReferencedBrotherAmount();
		if (_isLocation) idealSize *= 1.5;
		return ::Math.ceil(idealSize);
	}

	function getReferencedBrotherAmount()
	{
		if (("Assets" in ::World) == false) return 12;	// fix for when we test this framework in the main menu

		local referencedAmount = ::World.getPlayerRoster().getAll().len();
		referencedAmount = ::Math.min(referencedAmount, ::World.Assets.getBrothersMaxInCombat());
		referencedAmount = ::Math.max(referencedAmount, 6);
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

	function onBeforeSpawnStart( _spawnProcess )
	{
		// We remove all UnitBlocks that can't ever spawn in the first place to improve performance
		local unitBlockArray = this.getUnitBlocks();
		for (local i = unitBlockArray.len() - 1; i >= 0; i--)
		{
			if (unitBlockArray[i].isValid(_spawnProcess) == false) unitBlockArray.remove(i);
		}

		foreach (unitBlock in this.getUnitBlocks())
		{
			unitBlock.onBeforeSpawnStart( _spawnProcess );
		}
	}

	function onSpawnEnd( _spawnProcess )
	{
		foreach (unitBlock in this.getUnitBlocks())
		{
			unitBlock.onSpawnEnd( _spawnProcess );
		}
	}

});

