::DynamicSpawns.Class.Party <- class extends ::DynamicSpawns.Class.Spawnable
{
	Categories = null;
	// Required Parameter
	UnitBlockDefs = null;	// Array of Tables that require atleast 'ID' of the used UnitBlocks. Other parameter will overwrite those in the referenced UnitBLock

	// Optional Parameter
	UpgradeChance = null;	// Chance that this Party will upgrade a unit instead of spawning a new unit when IdealSize is reached
	StaticUnitDefs = null;	// Array of unitdefs that are forced to spawn if the Resources allow it. Can have multiples of the same unit. They consume resources
	DefaultResources = null;	// If the SpawnProcess is started without ResourceAmount it will use the value defined here. E.g. when spawning SubParties

	// Vanilla Properties of a Party
	DefaultFigure = null;			// This Figure will be used if the spawned units couldnt provide a better fitting one
	MovementSpeedMult = null;	// How fast does this party move on the world map
	VisibilityMult = null;		// How hard is it to spot this party
	VisionMult = null;			// How far can this party see

	// Private
	// During Spawnprocess only
	__UnitBlocks = null;		// Array of cloned UnitBlock-Objects
	__StaticUnits = null;		// Array of cloned Unit-Objects
	__SubParties = null;

	constructor( _partyDef )
	{
		this.ID = "";

		this.UpgradeChance = 0.75;
		this.DefaultResources = 0;

		this.DefaultFigure = "";
		this.MovementSpeedMult = 1.0;
		this.VisibilityMult = 1.0;
		this.VisionMult = 1.0;

		this.copyDataFromDef(_partyDef);
	}

	function getSubParties()
	{
		return this.__SubParties;
	}

	function setSpawnProcess( _spawnProcess )
	{
		base.setSpawnProcess(_spawnProcess);
		foreach (unitBlock in this.__UnitBlocks)
		{
			unitBlock.setSpawnProcess(_spawnProcess);
		}
		foreach (unit in this.__StaticUnits)
		{
			unit.setSpawnProcess(_spawnProcess);
		}
	}

	function init()
	{
		if (this.UnitBlockDefs == null) this.__UnitBlocks = [];
		else
		{
			this.__UnitBlocks = array(this.UnitBlockDefs.len());
			foreach (i, unitBlockDef in this.UnitBlockDefs)
			{
				this.__UnitBlocks[i] = ::DynamicSpawns.__getObjectFromDef(unitBlockDef, ::DynamicSpawns.UnitBlocks);
			}
		}

		if (this.StaticUnitDefs == null) this.__StaticUnits = [];
		else
		{
			this.__StaticUnits = array(this.StaticUnitDefs.len());
			foreach (i, staticUnitDef in this.StaticUnitDefs)
			{
				this.__StaticUnits[i] = ::DynamicSpawns.__getObjectFromDef(staticUnitDef, ::DynamicSpawns.Units);
			}
		}

		this.__SubParties = [];
		if (this.Categories != null)
		{
			foreach (id, categoryDef in this.Categories)
			{
				local category = ::DynamicSpawns.__getObjectFromDef(categoryDef, ::DynamicSpawns.Parties);
				category.ID = id;
				this.__SubParties.push(category);
			}
		}

		return this;
	}

	function getFigure( _spawnProcess )
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
		return this.ID;
	}

	// returns an array of unitblock objects
	function getUnitBlocks()
	{
		return this.__UnitBlocks;
	}

	// returns an array of def-tables
	function getUnitBlockDefs()
	{
		return this.UnitBlockDefs;
	}

	function spawn( _resources, _customHardMin = -1, _customHardMax = -1 )
	{
		// ::logWarning("Spawning the party '" + this.ID + "' with '" + _resources + "' Resources");
		return ::DynamicSpawns.Class.SpawnProcess(this, _resources, _customHardMin, _customHardMax).spawn();
	}

	// Returns an unsigned integer that will be used during this spawnProcess as IdealSize
	function generateIdealSize( _isLocation = false )
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
		return this.HardMin;
	}

	function getHardMax()
	{
		return this.HardMax;
	}

	function getUpgradeChance()
	{
		return this.UpgradeChance;
	}

	function getStaticUnits()
	{
		return this.__StaticUnits;
	}

	// Returns false if there is a reason why this party is not allowed to spawn a unit anymore.
	function canSpawn()
	{
		if (this.__SpawnProcess.getTotal() >= this.getHardMax()) return false;

		// RatioMax is ignored if we do not satisfy the RatioMin yet
		if (!this.satisfiesRatioMin())
			return true;

		if (!this.isWithinRatioMax()) return false;

		foreach (subparty in this.getSubParties())
		{
			if (subparty.canSpawn()) return true;
		}
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

		foreach (category in this.__SubParties)
		{
			category.onBeforeSpawnStart();
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
	}

	// Returns true if the ratio of this would still be below its defined RatioMax if it was to spawn the next unit
	function isWithinRatioMax()
	{
		local mainSpawnProcess = this.__SpawnProcess.getMainSpawnProcess();
		if (mainSpawnProcess == null)
			return true;

		local referencedTotal = ::Math.max(mainSpawnProcess.getTotal() + 1.0, mainSpawnProcess.getParty().getHardMin());
		local maxAllowed = ::Math.round(this.RatioMax * referencedTotal);
		return (mainSpawnProcess.getCategoryTotal(this.getID()) < maxAllowed);
	}

	// Returns true if the ratio of this would still be above its defined RatioMin if it was to spawn the next unit
	function satisfiesRatioMin()
	{
		local mainSpawnProcess = this.__SpawnProcess.getMainSpawnProcess();
		if (mainSpawnProcess == null)
			return true;

		local referencedTotal = mainSpawnProcess.getTotal() + 1;
		if (mainSpawnProcess.getTotal() + 1 < mainSpawnProcess.getParty().getHardMin())
		{
			referencedTotal = mainSpawnProcess.getParty().getHardMin();
		}

		local minRequired = ::Math.ceil(referencedTotal * this.RatioMin);	// Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the ReqPartySize or StartingResourceMin alongside that to prevent small parties from spawning exotic units.

		return (mainSpawnProcess.getCategoryTotal(this.getID()) >= minRequired);
	}

	function getUpgradeWeight()
	{
		local ret = 0;
		foreach (unitBlock in this.getUnitBlocks())
		{
			local weight = unitBlock.getUpgradeWeight();
			if (weight > ret) ret = weight;
		}
		foreach (subParty in this.__SubParties)
		{
			local weight = subParty.getUpgradeWeight();
			if (weight > ret) ret = weight;
		}
		return ret;
	}

	function canUpgrade()
	{
		foreach (unitBlock in this.getUnitBlocks())
		{
			if (unitBlock.canUpgrade())
				return true;
		}
		foreach (subParty in this.__SubParties)
		{
			if (subParty.canUpgrade())
				return true;
		}
		return false;
	}
};
