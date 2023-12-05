::DynamicSpawns.Class.Spawnable <- class
{
	ID = "";

	StaticDefs = null;
	DynamicDefs = null;

	RatioMin = 0.00;
	RatioMax = 1.00;

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

	// Temporary function to test with current Reforged dsf implementation
	function getSpawnProcess()
	{
		return this.getTopParty();
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

	function isWithinRatioMax()
	{
		local referencedTotal = ::Math.max(this.getParty().getTotal() + 1, this.getParty().getHardMin());
		return this.getTotal() < ::Math.round(referencedTotal * this.getRatioMax());
	}

	function satisfiesRatioMin()
	{
		local ratio = this.getRatioMin();
		if (ratio == 0.0)
			return true;

		local partyTotal = this.getParty().getTotal();

		if (partyTotal == 0)
			return false;

		return this.getTotal() >= ::Math.ceil(partyTotal * ratio); // Using ceil here will make any non-zero RatioMin always force atleast 1 of its units into the spawned party.
		// But the alternative is not consequent/good either. The solution is that you should always use the PartySizeMin or StartingResourceMin alongside that to prevent small parties from spawning exotic units.
	}

	function getSpawnWeight()
	{
		// Weighted-Spawns: All Spawnables that won't surpass their RatioMax if they were to get the next spawn, compete against each other for a random spawn
		local referencedTotal = ::Math.max(this.getParty().getTotal() + 1, this.getParty().getHardMin());
		local weight = this.getRatioMax() - this.getTotal() / referencedTotal.tofloat();
		if (weight < 0)
		{
			::logError(format("Spawnable %s in party %s got a negative spawn weight when it is at or above its RatioMax", this.getID(), this.getTopParty().getID()));
		}
		return weight;
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
		local topPartyTotal = this.getTopParty().getTotal();
		if (topPartyTotal < this.getPartySizeMin() || topPartyTotal >= this.getPartySizeMax()) return false;
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
		local ret = (clone this).init().spawn().getWorth();
		if (this.getParty().getResources() < resources)
		{
			this.getParty().addResources(ret);
		}
		::DynamicSpawns.Const.Logging = wasLogging;
		return ret;
	}

	function onBeforeSpawnStart()
	{
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.onBeforeSpawnStart();
		}
		for (local i = this.__DynamicSpawnables.len() - 1; i >= 0; i--)
		{
			if (this.__DynamicSpawnables[i].isValid()) this.__DynamicSpawnables[i].onBeforeSpawnStart();
			else this.__DynamicSpawnables.remove(i);
		}
	}

	function onSpawnEnd()
	{
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.onSpawnEnd();
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.onSpawnEnd();
		}
	}

	function onCycle()
	{
		foreach (spawnable in this.__StaticSpawnables)
		{
			spawnable.onCycle();
		}
		foreach (spawnable in this.__DynamicSpawnables)
		{
			spawnable.onCycle();
		}
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
}
