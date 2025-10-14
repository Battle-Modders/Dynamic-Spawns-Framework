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

	__DynamicSpawnables = null;
	__StaticSpawnables = null;

	__Party = null; // The party this spawnable is a part of. Every spawnable should be part of a party, except the top party which isn't part of any party.
	__ParentSpawnable = null; // The spawnable that this spawnable was initialized by

	constructor( _def )
	{
		this.StaticDefs = {};
		this.DynamicDefs = {};
		this.copyDataFromDef(_def);
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

	function copyDataFromDef( _def )
	{
		foreach (key, value in _def)
		{
			if (key == "Class" || key == "BaseID") continue;
			if (key == "ReqPartySize") key = "PartySizeMin";
			this[key] = value;
		}
	}

	function spawn()
	{
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.spawn();
		}
		return this;
	}

	function getTopParty()
	{
		return this.__Party == null ? this : this.__Party.getTopParty();
	}

	function getParty()
	{
		return this.__Party;
	}

	function getParentSpawnable()
	{
		return this.__ParentSpawnable;
	}

	function setParty( _party )
	{
		if (_party != null && this.__Party != null)
			return;

		this.__Party = _party == null ? null : _party.weakref();
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.setParty(_party);
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.setParty(_party);
		}
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
		local referencedTotal = ::Math.max(this.getParentSpawnable().getTotal(), this.getParentSpawnable().getHardMin()) + 1;
		local total = _total == null ? this.getTotal() : _total;
		return total + 1 <= ::Math.round(referencedTotal * this.getRatioMax());
	}

	// Does this spawnable satisfy its RatioMax with its current/given total
	function satisfiesRatioMax( _total = null )
	{
		local referencedTotal = ::Math.max(this.getParentSpawnable().getTotal(), this.getParentSpawnable().getHardMin());
		local total = _total == null ? this.getTotal() : _total;
		return total <= ::Math.round(referencedTotal * this.getRatioMax());
	}

	// Does this spawnable satisfy its RatioMin with its current/given total
	function satisfiesRatioMin( _total = null )
	{
		local ratio = this.getRatioMin();
		if (ratio == 0.0)
			return true;

		local parentTotal = this.getParentSpawnable().getTotal();

		if (parentTotal == 0)
			return false;

		local total = _total == null ? this.getTotal() : _total;

		return total >= ::Math.ceil(parentTotal * ratio); // Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the PartySizeMin or StartingResourceMin alongside that to prevent small parties from spawning exotic units.
	}

	function getSpawnWeight()
	{
		// Weighted-Spawns: All Spawnables that won't surpass their RatioMax if they were to get the next spawn, compete against each other for a random spawn
		local referencedTotal = ::Math.max(this.getParentSpawnable().getTotal(), this.getParentSpawnable().getHardMin()) + 1;
		local afterSpawnRatio = this.getTotal() / referencedTotal.tofloat();
		return ::Math.maxf(0.0, this.getRatioMax() - afterSpawnRatio);
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

	function canSpawn()
	{
		local total = this.getTotal();
		if (total < this.getHardMin()) return true;
		if (total >= this.getHardMax()) return false;
		if (this.satisfiesRatioMin() && !this.isWithinRatioMax()) return false;
		return true;
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

	function isValid()
	{
		local playerStrength = ::Math.round(this.getPlayerStrength());
		if (playerStrength < this.getStrengthMin() || playerStrength > this.getStrengthMax())
			return false;

		local topPartyStartingResources = ::Math.round(this.getTopParty().getStartingResources());
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

	function getPredictedWorth()
	{
		local resources = this.getParty().getResources();
		local wasLogging = ::DynamicSpawns.Const.Logging
		::DynamicSpawns.Const.Logging = false;
		local detailedLogging = ::DynamicSpawns.Const.DetailedLogging;
		::DynamicSpawns.Const.DetailedLogging = false;
		local ret = (clone this).init().spawn().getWorth();
		if (this.getParty().getResources() < resources)
		{
			this.getParty().addResources(ret);
		}
		::DynamicSpawns.Const.Logging = wasLogging;
		::DynamicSpawns.Const.DetailedLogging = detailedLogging;
		return ret;
	}

	function excludeSpawnables()
	{
		for (local i = this.__DynamicSpawnables.len() - 1; i >= 0; i--)
		{
			local spawnable = this.__DynamicSpawnables[i];
			if (::MSU.Math.randf(0.0, 1.0) < spawnable.getExclusionChance() || !spawnable.isValid())
			{
				this.__DynamicSpawnables.remove(i);
			}
			else
			{
				spawnable.excludeSpawnables();
			}
		}
	}

	function callOnBeforeSpawnStart()
	{
		this.onBeforeSpawnStart();
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.callOnBeforeSpawnStart();
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.callOnBeforeSpawnStart();
		}
	}

	function callOnSpawnEnd()
	{
		this.onSpawnEnd();
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.callOnSpawnEnd();
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.callOnSpawnEnd();
		}
	}

	function callOnCycle( _cycler )
	{
		this.onCycle(_cycler);
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.callOnCycle(_cycler);
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.callOnCycle(_cycler);
		}
	}

	function onBeforeSpawnStart()
	{
	}

	function onSpawnEnd()
	{
	}

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
		local arr = [this.getLogName()];
		local p = this.getParentSpawnable();
		while (p != null)
		{
			arr.push(p.getLogName());
			p = p.getParentSpawnable();
		}
		arr.reverse();
		return arr.reduce(@(_a, _b) _a + "|" + _b);
	}
}
