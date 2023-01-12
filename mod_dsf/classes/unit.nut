this.unit <- {
	m = {
		ID = null,
		EntityType = null,		// ID of a vanilla entity that will spawn
		Cost = 0,		// Cost of spawning this troop
		StrengthMin = 0.0,
		StrengthMax = -1.0,
		Party = null		// abilty to optionally spawn an additional party
	}

	function create()
	{
	}

    function init( _unit )
	{
		this.m.ID = _unit.ID;

		foreach (key, value in _unit)
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

	function getParty()
	{
		return this.m.Party;
	}

	function getEntityType()
	{
		return this.m.EntityType;
	}

	function getCost()
	{
		return this.m.Cost;
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
