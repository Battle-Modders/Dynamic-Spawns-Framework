
::DynamicSpawns.UnitBlocks <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DynamicSpawns.Parties <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DynamicSpawns.Units <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}

::DynamicSpawns.Data <- {};

::DynamicSpawns.Class <- {
	Unit = "mod_dsf/classes/unit",
	UnitBlock = "mod_dsf/classes/unit_block",
	SpawnProcess = "mod_dsf/classes/spawn_process",
	Party = "mod_dsf/classes/party"
};
