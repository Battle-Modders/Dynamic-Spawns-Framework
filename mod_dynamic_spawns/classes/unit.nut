this.unit <- inherit(::MSU.BBClass.Empty, {
	m = {
		ID = null,
		EntityType = null,		// String-IDs referencing entities from ::Const.World.Spawn.Troops table
		Cost = 0,		// Cost of spawning this unit
		SubPartyDef = {},		// abilty to optionally spawn an additional party. Most commonly body guards or operators

		// Guards
		StrengthMin = 0.0,		// The Playerstrength must be at least this value for this Unit to be able to spawn
		StrengthMax = 900000.0,
		MinStartingResource = 0,		// The initial resource amount that the spawnProcess started with must have been higher than this value
		MaxStartingResource = 900000	// The initial resource amount that the spawnProcess started with must have been lower than this value

		// Vanilla Properties of a Party
		Figure = "",	// A party consisting of this unit as its highest costing unit, will be represented by this figure

		// During Spawnprocess only
		SubParty = null		// Cloned Party-Object. Is only filled during a spawning process
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

	// Returns a copy of this unit (except that arrays and tables)
	function getClone( _unitDef = null )
	{
		local clonedUnit = ::new(::DynamicSpawns.Class.Unit);

		// Copy all member variables from this unit to its clone
		foreach (key, value in this.m)
		{
			// We skip arrays for now as they would only arrive as references which is not real cloning
			if (typeof value == "array") continue;
			// We skip tables for now as they would only arrive as references which is not real cloning
			if (typeof value == "table") continue;

			clonedUnit.m[key] = value;
		}

		// Copy all data provided by the _unitDef (e.g. custom resource cost) into the clone
		if (_unitDef != null)
		{
			foreach (key, value in _unitDef)
			{
				if (typeof value == "function")
				{
					clonedUnit[key] = value;
				}
				else
				{
					clonedUnit.m[key] = value;
				}
			}
		}

		// Continue with the SubParty if it exists. Just gotta be careful to not cause an infinite recursion here
		if (this.m.SubPartyDef.len() != 0)
		{
			this.m.SubParty = ::DynamicSpawns.Parties.findById(this.m.SubPartyDef.ID).getClone(this.m.SubPartyDef);
		}

		return clonedUnit;
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
		if (_spawnProcess.getStartingResources() < this.m.MinStartingResource) return false;
		if (_spawnProcess.getStartingResources() > this.m.MaxStartingResource) return false;
		if (_spawnProcess.getPlayerStrength() < this.getStrengthMin()) return false;
		if (_spawnProcess.getPlayerStrength() > this.getStrengthMax()) return false;

		if (!_spawnProcess.isIgnoringCost() && (_spawnProcess.getResources() + _bonusResources) < this.getCost()) return false;


		return true;
	}


});
