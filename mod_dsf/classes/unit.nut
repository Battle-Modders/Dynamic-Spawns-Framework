this.unit <- {
	m = {
		ID = null,
		EntityType = null,		// String-IDs referencing entities from ::Const.World.Spawn.Troops table
		Cost = 0,		// Cost of spawning this unit
		Figure = "",	// A party consisting of this unit as its highest costing unit, will be represented by this figure
		StrengthMin = 0.0,
		StrengthMax = -1.0,
		SubParty = null		// abilty to optionally spawn an additional party. Most commonly body guards or operators
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
		return this.m.Figure;
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
		if (!_spawnProcess.isIgnoringCost() && (_spawnProcess.getResources() + _bonusResources) < this.getCost()) return false;

		if (_spawnProcess.getPlayerStrength()  < this.getStrengthMin()) return false;
		if (this.getStrengthMax() != -1 && _spawnProcess.getPlayerStrength() > this.getStrengthMax()) return false;

		return true;
	}


};
