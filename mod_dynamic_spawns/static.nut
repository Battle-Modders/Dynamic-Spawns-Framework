::DynamicSpawns.Static <- {};
::DynamicSpawns.Static.assignTroops <- function( _worldParty, _party, _resources, _minibossify = 0 )
{
	_resources *= ::MSU.Math.randf( 0.8, 1.0 );

	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
	spawnProcess.init({ID = _party.getID()}, _resources);
	local spawnedUnits = spawnProcess.spawn();

	local party = spawnProcess.getParty();
	local body = party.getFigure(spawnProcess);

	_worldParty.setMovementSpeed(party.m.MovementSpeedMult * ::Const.World.MovementSettings.Speed);
	_worldParty.setVisibilityMult(party.m.VisibilityMult);
	_worldParty.setVisionRadius(party.m.VisionMult * ::Const.World.Settings.Vision);
	_worldParty.getSprite("body").setBrush(body);

	foreach (unit in spawnedUnits)
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getTroop()]}, false, _minibossify);
	}
	_worldParty.updateStrength();

	// We can return whatever as long as it is a table with an entry called 'Body' that has the correct Body-ID
	return {Body = body};
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
		local addedTroop = ::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getTroop()]}, false, _minibossify);
		if (_faction != null) addedTroop.Faction = _faction;	// optionally overwrite the faction of this troop
	}
	_worldParty.updateStrength();
}

// add an array of units to an unit array in a given combat
// This is mostly used for contracts scripting a battle
::DynamicSpawns.Static.addUnitsToCombat <- function( _combatUnitArray, _party, _resources, _faction, _minibossify = 0 )
{

	_resources *= ::MSU.Math.randf( 0.8, 1.0 );

	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
	spawnProcess.init({ID = _party.getID()}, _resources, false);

	foreach (unit in spawnProcess.spawn())
	{
		local troopTemplate = ::Const.World.Spawn.Troops[unit.getTroop()];
		local unit = clone troopTemplate;

		// The following code is an exact copy of how vanilla does this in their 'function addUnitsToCombat'
		unit.Faction <- _faction;
		unit.Name <- "";

		if (unit.Variant > 0)
		{
			if (!::Const.DLC.Wildmen || ::Math.rand(1, 100) > unit.Variant + _minibossify + (::World.getTime().Days > 90 ? 0 : -1))
			{
				unit.Variant = 0;
			}
			else
			{
				unit.Strength = ::Math.round(unit.Strength * 1.35);
				unit.Variant = ::Math.rand(1, 255);

				if ("NameList" in troopTemplate.Type)
				{
					unit.Name = this.generateName(troopTemplate.Type.NameList) + (troopTemplate.Type.TitleList != null ? " " + troopTemplate.Type.TitleList[::Math.rand(0, troopTemplate.Type.TitleList.len() - 1)] : "");
				}
			}
		}

		_combatUnitArray.push(unit);
	}
}

// @return reference to a dynamic Party if it exists within the given vanilla spawnlist, or null otherwise
::DynamicSpawns.Static.retrieveDynamicParty <- function( _vanillaPartyList )
{
	if (typeof _vanillaPartyList != "array") return null;
	if (_vanillaPartyList.len() == 0) return null;
	if (!("DynamicParty" in _vanillaPartyList[0])) return null;

	if (::DynamicSpawns.Static.isDynamicParty(_vanillaPartyList[0].DynamicParty))
	{
		return _vanillaPartyList[0].DynamicParty;
	}
	else
	{
		return null;
	}
}

::DynamicSpawns.Static.isDynamicParty <- function( _party )
{
	if (typeof _party != "table") return false;

	// We just check for any random member from our Party-Class to be present here
	return ("getUnitBlockDefs" in _party);
}

// Check all Parties, UnitBlocks and Units for consistency. Print Errors into the log if there are surface level problems
// @return the amount of warnings or errors generated
::DynamicSpawns.Static.consistencyCheck <- function()
{
	local logsGenerated = 0;

	::logInfo("Checking " + ::DynamicSpawns.Parties.LookupMap.len() + " parties, " + ::DynamicSpawns.UnitBlocks.LookupMap.len() + " blocks and " + ::DynamicSpawns.Units.LookupMap.len() + " units for consistency...");

	// Check all currently registered Parties
	foreach (partyObj in ::DynamicSpawns.Parties.LookupMap)
	{
		if (partyObj.getUnitBlockDefs().len() == 0 && partyObj.m.StaticUnitIDs.len() == 0)
		{
			::logError("The Party '" + partyObj.getID() + "' has no units or blocks defined for it. It will not produce any units!");
			logsGenerated++;
		}
		if (partyObj.getHardMax() <= 0)
		{
			::logError("The Party '" + partyObj.getID() + "' has HardMax of 0! It will not produce any units!");
			logsGenerated++;
		}
	}

	// Check all currently registered Unit Blocks
	foreach (unitBlockObj in ::DynamicSpawns.UnitBlocks.LookupMap)
	{
		if (unitBlockObj.getUnitDefs().len() == 0)
		{
			::logWarning("The UnitBlock '" + unitBlockObj.getID() + "' has no units defined for it. It will never produce any units!");
			logsGenerated++;
		}
		if (unitBlockObj.m.RatioMax <= 0.0)
		{
			::logWarning("The UnitBlock '" + unitBlockObj.getID() + "' has a RatioMax of 0 or less! It will never produce any units!");
			logsGenerated++;
		}
	}

	// Check all currently registered Units
	foreach (unitObj in ::DynamicSpawns.Units.LookupMap)
	{
		local entityType = unitObj.getEntityType();
		if (entityType == null)
		{
			::logWarning("The Unit '" + unitObj.getID() + "' has no Troop defined for it. It will never produce any units!");
			logsGenerated++;
		}
	}

	return logsGenerated;
}
