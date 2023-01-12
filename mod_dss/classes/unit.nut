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
		this.m.EntityType = _unit.EntityType;
		this.m.Cost = _unit.Cost;

		if("StrengthMin" in _unit) this.m.StrengthMin = _unit.StrengthMin;
		if("StrengthMax" in _unit) this.m.StrengthMax = _unit.StrengthMax;
		if("Party" in _unit) this.m.Party = _unit.Party;
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

	function getGuards()
	{
		return this.m.Guards;
	}

	function canSpawn( _playerStrength, _availableResources = -1)
	{
		// -1 means that the resource cost doesn't matter
		if(_availableResources != -1 && _availableResources < this.getCost()) return false;

		if(_playerStrength < this.getStrengthMin()) return false;
		if(this.getStrengthMax() != -1 && _playerStrength > this.getStrengthMax()) return false;

		return true;
	}


};