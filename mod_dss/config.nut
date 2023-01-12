
::DSS.UnitBlocks <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DSS.Parties <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DSS.Units <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}	
}

::DSS.Const.printn <- function( _string )
{
	print(_string + "\n");
}

::DSS.Const.randfloat <- function( _max )
{
	return 1.0 * _max * rand() / RAND_MAX;
}

::DSS.Const.randint <- function( _max )
{
	return ::DSS.Const.randfloat(_max).tointeger();
}

::DSS.Data <- {};

::DSS.Class <- {
	Unit = "mod_dss/classes/unit",
	UnitBlock = "mod_dss/classes/unit_block",
	SpawnProcess = "mod_dss/classes/spawn_process",
	Party = "mod_dss/classes/party"
};