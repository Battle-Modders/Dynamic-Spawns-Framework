::DynamicSpawns.Class.Unit <- {
// Required Parameter
	ID = null,
	Troop = null,		// String-IDs referencing entities from ::Const.World.Spawn.Troops table
	Cost = 1,				// Cost of spawning this unit

// Optional Parameter
	// SubParty
	SubPartyDef = {},				// abilty to optionally spawn an additional party. Most commonly body guards or operators

	// Guards for isValid()			// This Unit is only able to spawn if ...
	StrengthMin = 0,				// ... the Playerstrength is at least this value
	StrengthMax = 900000,			// ... the Playerstrength is at most this value
	StartingResourceMin = 0,		// ... the StartingResources of the current SpawnProcess is at least this value
	StartingResourceMax = 900000,	// ... the StartingResources of the current SpawnProcess is at most this value
	DaysMin = 0,					// ... ::World.getTime().Days is at least this value
	DaysMax = 900000,				// ... ::World.getTime().Days is at most this value

	// Vanilla Properties of a Party
	Figure = "",	// A party consisting of this unit as its highest costing unit, will be represented by this figure

// Private
	// During Spawnprocess only
	SubParty = null		// Cloned Party-Object

	// Create SubParty from SubPartyDef
	function init()
	{
		// Just gotta be careful to not cause an infinite recursion here
		if (this.SubPartyDef.len() != 0)
		{
			this.SubParty = ::DynamicSpawns.Parties.findById(this.SubPartyDef.ID).getClone(this.SubPartyDef);
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
				clonedBlock[key] = value;
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

	function canSpawn( _spawnProcess, _bonusResources = 0 )		// _bonusResources are used if you want to upgrade unit-A into unit-B. In those cases you have the resources from unit-A available in addition
	{
		if (_bonusResources == 0)	// We only allow ignoring of Cost if for considering new units to spawn
		{
			if (!_spawnProcess.isIgnoringCost() && (_spawnProcess.getResources()) < this.getCost()) return false;
		}
		else	// Upgrading of units
		{
			if ((_spawnProcess.getResources() + _bonusResources) < this.getCost()) return false;
		}

		return true;
	}

	// Returns true if this Block can theortically spawn a unit during this spawn proccess
	// This is done by checking variables which never change during the spawn process
	function isValid( _spawnProcess )
	{
		if (::Math.round(_spawnProcess.getPlayerStrength()) < this.StrengthMin) return false;
		if (::Math.round(_spawnProcess.getPlayerStrength()) > this.StrengthMax) return false;
		if (::Math.round(_spawnProcess.getStartingResources()) < this.StartingResourceMin) return false;
		if (::Math.round(_spawnProcess.getStartingResources()) > this.StartingResourceMax) return false;
		if (_spawnProcess.getWorldDays() < this.DaysMin) return false;
		if (_spawnProcess.getWorldDays() > this.DaysMax) return false;

		return true;
	}

};
