::DynamicSpawns.Class.Spawnable <- class
{
	ID = "";

	StaticDefs = null;
	DynamicDefs = null;

	RatioMin = 0.00;
	RatioMax = 1.00;
	ExclusionChance = 0.0;
	DeterminesFigure = true;

	HardMin = 0;
	HardMax = 9000;
	PartySizeMin = 0;
	PartySizeMax = 9000;
	StartingResourceMin = 0.0;
	StartingResourceMax = 100000.0;
	DaysMin = 0;
	DaysMax = 900000;
	StrengthMin = 0;
	StrengthMax = 900000;

	// These are standalone spawnables that will perform a full spawn independently.
	__StaticSpawnables = null;
	// These are dependent spawnables that compete for spawning or upgrading during a
	// cycle. The winner spawns/upgrades one unit in that cycle.
	__DynamicSpawnables = null;

	__ResourcesSource = null; // This has to be an instance of Party
	__ParentSpawnable = null; // The spawnable that this spawnable was initialized by

	__ChosenSpawn = null;
	__ChosenUpgrade = null;

	constructor( _def )
	{
		this.StaticDefs = {};
		this.DynamicDefs = {};
		this.copyDataFromDef(_def);
	}

	function spawnMinUnits()
	{
		foreach (s in this.__DynamicSpawnables)
		{
			s.spawnMinUnits();
		}

		local t = this.getTotal();
		while (t++ < this.getHardMin() && this.canSpawn())
		{
			this.spawnUnit();
			this.__ChosenSpawn = null;
		}
	}

	function setResourcesSource( _spawnable )
	{
		this.__ResourcesSource = _spawnable.weakref();
		foreach (s in this.__DynamicSpawnables)
		{
			s.setResourcesSource(_spawnable);
		}
	}

	function getResources()
	{
		// ::logInfo("getResources: " + this.getLogNameChain());
		return this.__ResourcesSource.getResources();
	}

	function addResources( _amount )
	{
		if (this.__ResourcesSource != null)
			this.__ResourcesSource.__Resources += _amount;
	}

	function init()
	{
		this.__StaticSpawnables = [];
		foreach (spawnableType, defs in this.StaticDefs)
		{
			foreach (def in defs)
			{
				local obj = ::DynamicSpawns.__getObjectFromDef(def, ::DynamicSpawns[spawnableType]);
				obj.__ParentSpawnable = this.weakref();
				this.__StaticSpawnables.push(obj);
			}
		}

		this.__DynamicSpawnables = [];
		foreach (spawnableType, defs in this.DynamicDefs)
		{
			foreach (def in defs)
			{
				local obj = ::DynamicSpawns.__getObjectFromDef(def, ::DynamicSpawns[spawnableType]);
				obj.__ParentSpawnable = this.weakref();
				this.__DynamicSpawnables.push(obj);
			}
		}
		return this;
	}

	function isIgnoringCost()
	{
		return this.getTotal() < this.getHardMin() || (this.__ResourcesSource != this && this.getParentSpawnable().isIgnoringCost());
	}

	function copyDataFromDef( _def )
	{
		foreach (key, value in _def)
		{
			if (key == "Class" || key == "BaseID") continue;
			if (key == "ReqPartySize") key = "PartySizeMin";
			this[key] = value;
		}
	}

	// Virtual - children must overwrite and provide custom logic
	function spawn()
	{
		return this;
	}

	// Virtual - children must overwrite and provide custom logic
	function chooseSpawn()
	{
	}

	// Virtual - children must overwrite and provide custom logic
	function chooseUpgrade()
	{
	}

	function spawnUnit()
	{
		return this.chooseSpawn().spawnUnit();
	}

	function upgradeUnit()
	{
		return this.chooseUpgrade().upgradeUnit();
	}

	function setParty( _party )
	{
		this.__Party = _party == null ? null : _party.weakref();
	}

	function getTopSpawnable()
	{
		return this.__ParentSpawnable == null ? this : this.__ParentSpawnable.getTopSpawnable();
	}

	function getParentSpawnable()
	{
		return this.__ParentSpawnable;
	}

	function getSpawnable( _id )
	{
		local function parseId( _idToParse )
		{
			local idx = _idToParse.find("(in"); // find the (instance 0x233e234f) suffix and remove it
			return idx != null && idx != 0 ? _idToParse.slice(0, idx) : _idToParse;
		}

		local parsedId = parseId(_id);

		foreach (spawnable in this.__DynamicSpawnables)
		{
			if (parseId(spawnable.getID()) == parsedId)
				return spawnable;

			local s = spawnable.getSpawnable(_id);
			if (s != null)
				return s;
		}

		foreach (spawnable in this.__StaticSpawnables)
		{
			if (parseId(spawnable.getID()) == parsedId)
				return spawnable;

			local s = spawnable.getSpawnable(_id);
			if (s != null)
				return s;
		}
	}

	function getSpawnedUnits()
	{
		local ret = [];
		foreach (spawnable in this.__StaticSpawnables)
		{
			ret.extend(spawnable.getSpawnedUnits());
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			ret.extend(spawnable.getSpawnedUnits());
		}
		return ret;
	}

	// We could use this.getSpawnedUnits.len() and that would fulfill DRY principle
	// but that requires instantiating many arrays, so this is more "performant"
	function getTotal()
	{
		local ret = 0.0;
		foreach (spawnable in this.__StaticSpawnables)
		{
			ret += spawnable.getTotal();
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			ret += spawnable.getTotal();
		}
		return ret;
	}

	function getUnits()
	{
		local ret = [];
		foreach (unit in this.getSpawnedUnits())
		{
			ret.extend(unit.getUnits());
		}
		return ret;
	}

	function getWorth()
	{
		local ret = 0.0;
		foreach (spawnable in this.__StaticSpawnables)
		{
			ret += spawnable.getWorth();
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			ret += spawnable.getWorth();
		}
		return ret;
	}

	// Will this spawnable remain within the RatioMax if it were to spawn 1 more unit and parent total were to go up by 1
	function isWithinRatioMax( _total = null )
	{
		if (this.getParentSpawnable() == null)
			return true;

		local referencedTotal = ::Math.max(this.getParentSpawnable().getTotal() + 1, this.getParentSpawnable().getHardMin());
		local total = _total == null ? this.getTotal() : _total;
		// It should be `total + 1 <=` but we're dealing with integers here so `total <` is more efficient
		return total < ::Math.round(referencedTotal * this.getRatioMax());
	}

	// Does this spawnable satisfy its RatioMax with its current/given total
	function satisfiesRatioMax( _total = null )
	{
		if (this.getParentSpawnable() == null)
			return true;

		local referencedTotal = ::Math.max(this.getParentSpawnable().getTotal(), this.getParentSpawnable().getHardMin());
		local total = _total == null ? this.getTotal() : _total;
		return total <= ::Math.round(referencedTotal * this.getRatioMax());
	}

	// Does this spawnable satisfy its RatioMin with its current/given total
	function satisfiesRatioMin( _total = null, _parentTotal = null )
	{
		if (this.getParentSpawnable() == null)
			return true;

		local ratio = this.getRatioMin();
		if (ratio == 0.0)
			return true;

		local parentTotal = _parentTotal == null ? this.getParentSpawnable().getTotal() : _parentTotal;

		if (parentTotal == 0)
			return false;

		local total = _total == null ? this.getTotal() : _total;

		return total >= ::Math.ceil(parentTotal * ratio); // Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the PartySizeMin or StartingResourceMin alongside that to prevent small parties from spawning exotic units.
	}

	function getSpawnWeight()
	{
		// Forced to spawn if below RatioMin
		if (!this.satisfiesRatioMin())
			return -1;

		// Spawnables are more weighted to spawn the further they are from their maximum possible units
		local referencedTotal = ::Math.max(this.getParentSpawnable().getTotal() + 1, this.getParentSpawnable().getHardMin());
		local maxUnits = ::Math.min(this.getHardMax(), ::Math.ceil(this.getRatioMax() * referencedTotal));
		return maxUnits - this.getTotal();
	}

	function getUpgradeWeight()
	{
		local ret = 0;
		foreach (spawnable in this.__DynamicSpawnables)
		{
			ret += spawnable.getUpgradeWeight();
		}
		return ret;
	}

	function isAffordable( _resources = null )
	{
		if (this.isIgnoringCost())
		{
			return true;
		}

		return (_resources == null ? this.getResources() : _resources) >= this.getPredictedWorth();
	}

	function canSpawn()
	{
		local t = this.getTotal();
		if (t < this.getHardMin())
			return true;

		return t < this.getHardMax() && (!this.satisfiesRatioMin() || this.isWithinRatioMax());
	}

	function canUpgrade()
	{
		foreach (spawnable in this.__DynamicSpawnables)
		{
			if (spawnable.canUpgrade())
				return true;
		}

		return false;
	}

	function getPlayerStrength()
	{
		if (!("State" in ::World)  || ::World.State == null) return 100.0;		// fix for when we test this framework in the main menu
		return ::World.State.getPlayer().getStrength();		// This is cleaner but may be a bit inefficient compared to reading this value out once and saving it in a variable
	}

	function getTopParty()
	{
		return this.getTopSpawnable();
	}

	function getParty()
	{
		return this.__ResourcesSource;
	}

	function isValid()
	{
		local playerStrength = ::Math.round(this.getPlayerStrength());
		if (playerStrength < this.getStrengthMin() || playerStrength > this.getStrengthMax())
			return false;

		local topPartyStartingResources = ::Math.round(this.getTopSpawnable().getStartingResources());
		if (topPartyStartingResources < this.getStartingResourceMin() || topPartyStartingResources > this.getStartingResourceMax())
			return false;

		local days = ::World.getTime().Days;
		if (days < this.getDaysMin() || days > this.getDaysMax())
			return false;

		return true;
	}

	function determinesFigure()
	{
		return this.DeterminesFigure;
	}

	function getID()
	{
		return this.ID;
	}

	function getHardMin()
	{
		return this.HardMin;
	}

	function getHardMax()
	{
		return this.HardMax;
	}

	function getRatioMin()
	{
		return this.RatioMin;
	}

	function getRatioMax()
	{
		return this.RatioMax;
	}

	function getExclusionChance()
	{
		return this.ExclusionChance;
	}

	function getPartySizeMin()
	{
		return this.PartySizeMin;
	}

	function getPartySizeMax()
	{
		return this.PartySizeMax;
	}

	function getStartingResourceMin()
	{
		return this.StartingResourceMin;
	}

	function getStartingResourceMax()
	{
		return this.StartingResourceMax;
	}

	function getDaysMin()
	{
		return this.DaysMin;
	}

	function getDaysMax()
	{
		return this.DaysMax;
	}

	function getStrengthMin()
	{
		return this.StrengthMin;
	}

	function getStrengthMax()
	{
		return this.StrengthMax;
	}

	function clear()
	{
		foreach (s in this.__StaticSpawnables)
		{
			s.clear();
		}
		foreach (s in this.__DynamicSpawnables)
		{
			s.clear();
		}
	}

	function getPredictedWorth()
	{
		this.chooseSpawn();
		return this.__ChosenSpawn == null ? 0 : this.__ChosenSpawn.getPredictedWorth();
	}

	function excludeSpawnables()
	{
		local softExclude = ::DynamicSpawns.Tests.IsTesting;
		for (local i = this.__DynamicSpawnables.len() - 1; i >= 0; i--)
		{
			local spawnable = this.__DynamicSpawnables[i];
			if (::MSU.Math.randf(0.0, 1.0) < spawnable.getExclusionChance() || !spawnable.isValid())
			{
				if (softExclude)
				{
					spawnable.HardMax = 0;
					spawnable.HardMin = 0;
				}
				else
				{
					this.__DynamicSpawnables.remove(i);
				}
			}
			else
			{
				spawnable.excludeSpawnables();
			}
		}
	}

	function clear()
	{
		foreach (s in this.__StaticSpawnables)
		{
			s.clear();
		}
		foreach (s in this.__DynamicSpawnables)
		{
			s.clear();
		}
	}

	function callOnBeforeSpawnStart()
	{
		this.onBeforeSpawnStart();
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.callOnBeforeSpawnStart();
		}
	}

	function hasAffordableSpawn( _resources = null )
	{
		this.chooseSpawn();
		return this.__ChosenSpawn != null && this.__ChosenSpawn.isAffordable(_resources);
	}

	function callOnSpawnEnd()
	{
		this.onSpawnEnd();
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.callOnSpawnEnd();
		}
	}

	function callOnCycle( _cycler )
	{
		this.onCycle(_cycler);
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.callOnCycle(_cycler);
		}
	}

	// Only called by Parties on their DynamicSpawnables
	function onBeforeSpawnStart()
	{
	}

	// Only called by Parties on their DynamicSpawnables
	function onSpawnEnd()
	{
	}

	// Only called by Parties on their DynamicSpawnables
	function onCycle( _cycler )
	{
	}

	function printToLog()
	{
		if (!::DynamicSpawns.Const.Logging)
			return;

		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.printToLog();
		}
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.printToLog();
		}
	}

	function getLogName()
	{
		local idx = this.getID().find("(in"); // find the (instance 0x233e234f) suffix and remove it
		return idx == null || idx == 0 ? this.getID() : this.getID().slice(0, idx);
	}

	function getLogNameChain()
	{
		if (this.getParentSpawnable() == null)
			return format("%s (%i)", this.getLogName(), this.getTotal());

		local arr = [];
		local p = this;
		while (p.getParentSpawnable() != null)
		{
			local t = p.getTotal();
			arr.push(format("%s (%i, %.2f)", p.getLogName(), t, t.tofloat() / p.getParentSpawnable().getTotal()));
			p = p.getParentSpawnable();
		}
		arr.push(format("%s (%i)", p.getLogName(), p.getTotal()));

		arr.reverse();

		return arr.reduce(@(_a, _b) _a + " | " + _b);
	}
}
