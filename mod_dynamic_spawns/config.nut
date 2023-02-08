
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
	Unit = "scripts/mods/mod_dynamic_spawns/classes/unit",
	UnitBlock = "scripts/mods/mod_dynamic_spawns/classes/unit_block",
	SpawnProcess = "scripts/mods/mod_dynamic_spawns/classes/spawn_process",
	Party = "scripts/mods/mod_dynamic_spawns/classes/party"
};
