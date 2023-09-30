::DynamicSpawns.Class.Party <- class extends ::DynamicSpawns.Class.Spawnable
{
	UnitBlockDefs = null;
	StaticUnitDefs = null;

	UpgradeChance = 0.75;
	DefaultResources = 0;

	StaticUnitIDs = null;

	DefaultFigure = "";			// This Figure will be used if the spawned units couldnt provide a better fitting one
	MovementSpeedMult = 1.0;	// How fast does this party move on the world map
	VisibilityMult = 1.0;		// How hard is it to spot this party
	VisionMult = 1.0;			// How far can this party see

	__UnitBlocks = null;
	__StaticUnits = null;

	// Initialize the party by creating UnitBlocks and StaticUnits from UnitBlockDefs and StaticUnitIDs
	function init()
	{
		// Create clones of all UnitBlocks needed for this
		this.__UnitBlocks = array(this.UnitBlockDefs.len());
		foreach (i, unitBlockDef in this.UnitBlockDefs)
		{
			if (!("ID" in unitBlockDef))
			{
				::DynamicSpawns.Static.registerUnitBlock(unitBlockDef);
			}
			local block = ::DynamicSpawns.UnitBlocks.findById(unitBlockDef.ID).getClone(unitBlockDef, false);
			block.setSpawnProcess(this.__SpawnProcess);
			block.init();
			this.__UnitBlocks[i] = block;
		}

		if (this.StaticUnitDefs == null) this.__StaticUnits = [];
		else
		{
			this.__StaticUnits = array(this.StaticUnitDefs.len());
			foreach (i, staticUnitDef in this.StaticUnitDefs)
			{
				if (!("ID" in staticUnitDef))
				{
					::DynamicSpawns.Static.registerUnit(staticUnitDef);
				}
				local unit = ::DynamicSpawns.Units.findById(staticUnitDef.ID).getClone(staticUnitDef, false);
				unit.setSpawnProcess(this.__SpawnProcess);
				unit.init();
				this.__StaticUnits[i] = unit;
			}
		}

		return this;
	}

	// Returns a copy of this party except Def-Arrays. Those must be provided by _partyDef is required
	function getClone( _partyDef = null, _initialize = true )
	{
		local clonedParty = clone this;

		if (_partyDef != null)
		{
			// Copy all data provided by the _partyDef (e.g. custom HardMin/HardMax) into the clone
			foreach (key, value in _partyDef)
			{
				clonedParty[key] = value;
			}
		}

		if (_initialize)
			clonedParty.init();

		return clonedParty;
	}

	function getUpgradeChance()
	{
		return this.UpgradeChance;
	}

	function getStaticUnits()
	{
		return this.__StaticUnits;
	}

	// returns an array of def-tables
	function getUnitBlockDefs()
	{
		return this.UnitBlockDefs;
	}

	// returns an array of unitblock objects
	function getUnitBlocks()
	{
		return this.__UnitBlocks;
	}

	function getFigure()
	{
		local priciestFigure = this.DefaultFigure;
		if (typeof this.DefaultFigure == "array") priciestFigure = this.DefaultFigure[::Math.rand(0, this.DefaultFigure.len() - 1)];
		local figurePrice = -9000;
		foreach (unitBlock in this.getUnitBlocks())
		{
			if (unitBlock.DeterminesFigure == false) continue;

			foreach (unit in unitBlock.getUnits())
			{
				if (unit.getFigure() == "") continue;
				if (unit.getCost() <= figurePrice) continue;
				if (this.__SpawnProcess.getUnitCount(unit.getID(), unitBlock.getID()) == 0) continue;

				priciestFigure = unit.getFigure();
				figurePrice = unit.getCost();
			}
		}
		if (priciestFigure == "") ::MSU.Exception.InvalidValue( "Figure cant be an empty string. Provide a DefaultFigure for this Party or make sure UnitBlocks with DeterminesFigure=True actually spawn units" )
		return priciestFigure;
	}

	function spawn( _resources, _customHardMin = -1, _customHardMax = -1 )
	{
		// ::logWarning("Spawning the party '" + this.ID + "' with '" + _resources + "' Resources");
		local spawnProcess = ::DynamicSpawns.Class.SpawnProcess({ID = this.getID()}, _resources, _customHardMin, _customHardMax);
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

	// Returns false if there is a reason why this party is not allowed to spawn anymore. This function only checks for a small subset of all possible reasons.
	// Checks only against HardMax and HardMin
	function canSpawn()
	{
		if (this.__SpawnProcess.getTotal() >= this.getHardMax()) return false;

		// Atleast one of our unitBlocks must be able to spawn units
		foreach (unitBlock in this.getUnitBlocks())
		{
			if (unitBlock.canSpawn()) return true;
		}
		return false;
	}

	function onBeforeSpawnStart()
	{
		// We remove all UnitBlocks that can't ever spawn in the first place to improve performance
		local unitBlockArray = this.getUnitBlocks();
		for (local i = unitBlockArray.len() - 1; i >= 0; i--)
		{
			if (unitBlockArray[i].isValid() == false) unitBlockArray.remove(i);
		}

		foreach (unitBlock in this.getUnitBlocks())
		{
			unitBlock.onBeforeSpawnStart();
		}
	}

	function onSpawnEnd()
	{
		foreach (unitBlock in this.getUnitBlocks())
		{
			unitBlock.onSpawnEnd();
		}
		this.__StaticUnits = null;
		this.__UnitBlocks = null;
	}
};
