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

	__SpawnProcess = null;

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

	function setSpawnProcess( _spawnProcess )
	{
		this.__SpawnProcess = _spawnProcess.weakref();
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
