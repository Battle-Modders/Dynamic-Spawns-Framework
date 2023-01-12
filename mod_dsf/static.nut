::DSF.Static <- {};
::DSF.Static.assignTroops <- function( _worldParty, _party, _resources, _opposingParty = null, _customHardMin = -1, _customHardMax = -1 )
{
	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DSF.Class.SpawnProcess);
	spawnProcess.init(_party, _resources, _opposingParty, _customHardMin, _customHardMax);
	local spawnedUnits = spawnProcess.spawn();

	foreach( unit in spawnedUnits )
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getEntityType()]}, false);
	}
	_worldParty.updateStrength();

	return _party;	// We can return whatever as long as it has an entry called 'Body' that has the correct Body-ID
}

::DSF.Static.isParty <- function( _party )
{
	return ((typeof _party == "table") && ("spawn" in _party));
}

::DSF.Static.getExpectedNPCWorldSize <- function( _party )
{
    return 15;
}
