::DSF.Static <- {};
::DSF.Static.assignTroops <- function( _worldParty, _party, _resources, _opposingParty = null, _customHardMin = -1, _customHardMax = -1 )
{
	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DSF.Class.SpawnProcess);
	spawnProcess.init(_party, _resources, _opposingParty, _customHardMin, _customHardMax);
	local spawnedUnits = spawnProcess.spawn();

	_worldParty.setMovementSpeed(_party.m.MovementSpeedMult * ::Const.World.MovementSettings.Speed);
	_worldParty.setVisibilityMult(_party.m.VisibilityMult);
	_worldParty.setVisionRadius(_party.m.VisionMult * ::Const.World.Settings.Vision);
	_worldParty.getSprite("body").setBrush(_party.Body);

	foreach (unit in spawnedUnits)
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getEntityType()]}, false);
	}
	_worldParty.updateStrength();

	return _party;	// We can return whatever as long as it has an entry called 'Body' that has the correct Body-ID
}

// Similar to assignTroops but doesn't apply the parties properties
// In Vanilla this function is part of the contract.nut
::DSF.Static.addTroops <- function( _worldParty, _party, _resources, _opposingParty = null, _customHardMin = -1, _customHardMax = -1 )
{
	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DSF.Class.SpawnProcess);
	spawnProcess.init(_party, _resources, _opposingParty, _customHardMin, _customHardMax);
	local spawnedUnits = spawnProcess.spawn();

	foreach (unit in spawnedUnits)
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getEntityType()]}, false);
	}
	_worldParty.updateStrength();
}

::DSF.Static.isDynamicParty <- function( _party )
{
	return ((typeof _party == "table") && ("spawn" in _party));
}

::DSF.Static.getExpectedNPCWorldSize <- function( _party )
{
    return 15;
}
