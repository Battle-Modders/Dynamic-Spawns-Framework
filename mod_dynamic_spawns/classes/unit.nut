::DynamicSpawns.Class.Unit <- class extends ::DynamicSpawns.Class.Spawnable
{
	// Required Parameter
	Troop = null;		// String-IDs referencing entities from ::Const.World.Spawn.Troops table
	Cost = null;				// Cost of spawning this unit

	// Optional Parameter
	// SubParty
	SubPartyDef = null;				// abilty to optionally spawn an additional party. Most commonly body guards or operators

	// Vanilla Properties of a Party
	Figure = null;	// A party consisting of this unit as its highest costing unit, will be represented by this figure

	// Private
	// During Spawnprocess only
	__SubParty = null;		// Cloned Party-Object

	constructor( _unitDef )
	{
		this.ID = "";
		this.Troop = null;
		this.Cost = 1;

		this.SubPartyDef = {};

		this.Figure = "";

		this.__SubParty = null;

		this.copyDataFromDef(_unitDef);
	}

	function setSpawnProcess( _spawnProcess )
	{
		base.setSpawnProcess(_spawnProcess);
		if (this.__SubParty != null) this.__SubParty.setSpawnProcess(_spawnProcess);
	}

	function init()
	{
		if (this.SubPartyDef.len() != 0)
		{
			this.__SubParty = ::DynamicSpawns.__getObjectFromDef(this.SubPartyDef, ::DynamicSpawns.Parties);
		}
		return this;
	}

	function getID()
	{
		return this.ID;
	}

	function getSubParty()
	{
		return this.__SubParty;
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
};
