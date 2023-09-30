::DynamicSpawns.Class.Unit <- class extends ::DynamicSpawns.Class.Spawnable
{
// Required Parameter
	Troop = null;	// String-IDs referencing entities from ::Const.World.Spawn.Troops table
	Cost = 1;				// Cost of spawning this unit

// Optional Parameter
	// SubParty
	SubPartyDef = null;				// abilty to optionally spawn an additional party. Most commonly body guards or operators

	// Guards for isValid()			// This Unit is only able to spawn if ...
	StrengthMin = 0;				// ... the Playerstrength is at least this value
	StrengthMax = 900000;			// ... the Playerstrength is at most this value
	DaysMin = 0;					// ... ::World.getTime().Days is at least this value
	DaysMax = 900000;				// ... ::World.getTime().Days is at most this value

	// Vanilla Properties of a Party
	Figure = "";	// A party consisting of this unit as its highest costing unit, will be represented by this figure

// Private
	// During Spawnprocess only
	SubParty = null;		// Cloned Party-Object

	__SpawnProcess = null;

	// Create SubParty from SubPartyDef
	function init()
	{
		// Just gotta be careful to not cause an infinite recursion here
		if (this.SubPartyDef != null)
		{
			if (!("ID" in this.SubPartyDef))
			{
				::DynamicSpawns.Static.registerParty(this.SubPartyDef);
			}
			local party = ::DynamicSpawns.Parties.findById(this.SubPartyDef.ID).getClone(this.SubPartyDef, false);
			party.setSpawnProcess(this.__SpawnProcess);
			party.init();
			this.SubParty = party;
		}

		return this;
	}

	// Returns a copy of this unit (except that arrays and tables)
	function getClone( _unitDef = null, _initialize = true )
	{
		local clonedUnit = clone this

		if (_unitDef != null)
		{
			// Copy all data provided by the _unitDef
			foreach (key, value in _unitDef)
			{
				clonedUnit[key] = value;
			}
		}

		if (_initialize)
			clonedUnit.init();

		return clonedUnit;
	}

	function getID()
	{
		return this.ID;
	}

	function getSubParty()
	{
		return this.SubParty;
	}

	function getSubPartyDef()
	{
		return this.SubPartyDef;
	}

	function getTroop()
	{
		return this.Troop;
	}

	function getCost()
	{
		return this.Cost;
	}

	function getFigure()
	{
		if (typeof this.Figure == "string") return this.Figure;
		return this.Figure[::Math.rand(0, this.Figure.len() - 1)];
	}

	function canSpawn( _bonusResources = 0 )		// _bonusResources are used if you want to upgrade unit-A into unit-B. In those cases you have the resources from unit-A available in addition
	{
		if (_bonusResources == 0)	// We only allow ignoring of Cost if for considering new units to spawn
		{
			if (!this.__SpawnProcess.isIgnoringCost() && (this.__SpawnProcess.getResources()) < this.getCost()) return false;
		}
		else	// Upgrading of units
		{
			if ((this.__SpawnProcess.getResources() + _bonusResources) < this.getCost()) return false;
		}

		return true;
	}

	// Returns true if this Block can theortically spawn a unit during this spawn proccess
	// This is done by checking variables which never change during the spawn process
	function isValid()
	{
		if (::Math.round(this.__SpawnProcess.getPlayerStrength()) < this.StrengthMin) return false;
		if (::Math.round(this.__SpawnProcess.getPlayerStrength()) > this.StrengthMax) return false;
		if (::Math.round(this.__SpawnProcess.getStartingResources()) < this.StartingResourceMin) return false;
		if (::Math.round(this.__SpawnProcess.getStartingResources()) > this.StartingResourceMax) return false;
		if (this.__SpawnProcess.getWorldDays() < this.DaysMin) return false;
		if (this.__SpawnProcess.getWorldDays() > this.DaysMax) return false;

		return true;
	}

};
