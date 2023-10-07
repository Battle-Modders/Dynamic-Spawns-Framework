::DynamicSpawns.Class.Spawnable <- class
{
	ID = null;
	HardMin = 0;
	HardMax = 9000;
	RatioMin = 0.00;
	RatioMax = 1.00;
	ReqPartySize = 0;
	StartingResourceMin = 0.0;
	StartingResourceMax = 100000.0;
	DaysMin = 0;
	DaysMax = 900000;
	StrengthMin = 0;
	StrengthMax = 900000;

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

	function getReqPartySize()
	{
		return this.ReqPartySize;
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

	function copyDataFromDef( _def )
	{
		foreach (key, value in _def)
		{
			if (key == "Class") continue;
			this[key] = value;
		}
	}

	// Returns true if this can theortically spawn during this spawn proccess
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

	function canSpawn()
	{
		return true;
	}

	function isWithinRatioMax()
	{
		return true;
	}

	function satisfiesRatioMin()
	{
		return true;
	}
};
