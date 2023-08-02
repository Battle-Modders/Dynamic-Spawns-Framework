this.unit <- inherit(::MSU.BBClass.Empty, {
	m = {
		ID = null,
		EntityType = null,		// String-IDs referencing entities from ::Const.World.Spawn.Troops table
		Cost = 0,		// Cost of spawning this unit
		Figure = "",	// A party consisting of this unit as its highest costing unit, will be represented by this figure
		SubParty = null		// abilty to optionally spawn an additional party. Most commonly body guards or operators

		// Private Guards
		StrengthMin = 0.0,		// The Playerstrength must be at least this value for this Unit to be able to spawn
		StrengthMax = -1.0,
		MinStartingResource = 0.0,		// The initial resource amount that the spawnProcess started with must have been higher than this value
		MaxStartingResource = 900000,	// The initial resource amount that the spawnProcess started with must have been lower than this value
	}

	function create()
	{
	}

    function init( _unitDef )
	{
		this.m.ID = _unitDef.ID;
		this.m.Cost = _unitDef.Cost;
		this.m.EntityType = _unitDef.EntityType;

		foreach (key, value in _unitDef)
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

	function getID()
	{
		return this.m.ID;
	}

	function getSubParty()
	{
		return this.m.SubParty;
	}

	function getEntityType()
	{
		return this.m.EntityType;
	}

	function getCost()
	{
		return this.m.Cost;
	}

	function getFigure()
	{
		if (typeof this.m.Figure == "string") return this.m.Figure;
		return this.m.Figure[::Math.rand(0, this.m.Figure.len() - 1)];
	}

	function getStrengthMin()
	{
		return this.m.StrengthMin;
	}

	function getStrengthMax()
	{
		return this.m.StrengthMax;
	}

	function canSpawn( _spawnProcess, _bonusResources = 0 )		// _bonusResources are used if you want to upgrade unit-A into unit-B. In those cases you have the resources from unit-A available in addition
	{
		if (this.m.MinStartingResource > _spawnProcess.getStartingResources()) return false;
		if (this.m.MaxStartingResource < _spawnProcess.getStartingResources()) return false;

		if (!_spawnProcess.isIgnoringCost() && (_spawnProcess.getResources() + _bonusResources) < this.getCost()) return false;

		if (_spawnProcess.getPlayerStrength()  < this.getStrengthMin()) return false;
		if (this.getStrengthMax() != -1 && _spawnProcess.getPlayerStrength() > this.getStrengthMax()) return false;

		return true;
	}


});
