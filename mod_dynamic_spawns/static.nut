::DynamicSpawns.Static <- {};
::DynamicSpawns.Static.assignTroops <- function( _worldParty, _party, _resources, _minibossify = 0 )
{
	_resources *= ::MSU.Math.randf( 0.8, 1.0 );

	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
	spawnProcess.init({ID = _party.getID()}, _resources);
	local spawnedUnits = spawnProcess.spawn();

	_worldParty.setMovementSpeed(spawnProcess.getParty().m.MovementSpeedMult * ::Const.World.MovementSettings.Speed);
	_worldParty.setVisibilityMult(spawnProcess.getParty().m.VisibilityMult);
	_worldParty.setVisionRadius(spawnProcess.getParty().m.VisionMult * ::Const.World.Settings.Vision);
	_worldParty.getSprite("body").setBrush(spawnProcess.getParty().Body);

	foreach (unit in spawnedUnits)
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getEntityType()]}, false, _minibossify);
	}
	_worldParty.updateStrength();

	return spawnProcess.getParty();	// We can return whatever as long as it has an entry called 'Body' that has the correct Body-ID
}

// Similar to assignTroops but doesn't apply the parties properties
// In Vanilla this function is part of the contract.nut (without _faction feature)
// and part of world_entity_common.nut function addUnitsToCombat (here it supports _faction)
::DynamicSpawns.Static.addTroops <- function( _worldParty, _party, _resources, _faction = null, _minibossify = 0 )
{
	_resources *= ::MSU.Math.randf( 0.8, 1.0 );

	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
	spawnProcess.init({ID = _party.getID()}, _resources, _worldParty.isLocation());
	local spawnedUnits = spawnProcess.spawn();

	foreach (unit in spawnedUnits)
	{
		local addedTroop = ::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getEntityType()]}, false, _minibossify);
		if (_faction != null) addedTroop.Faction = _faction;	// optionally overwrite the faction of this troop
	}
	_worldParty.updateStrength();
}

::DynamicSpawns.Static.isDynamicParty <- function( _party )
{
	return ((typeof _party == "table") && ("spawn" in _party));
}
