// Public functions that are meant to be used by other mods
::DynamicSpawns.Public <- {};

/**
 * Register a dynamic party so it can be used for spawning
 *
 * If a dynamic party with that ID already exists then it will be overwritten
 *
 * @param _partyDef table containing at least the entries "ID" and either "StaticUnitIDs" or "UnitBlockDefs"
 */
 ::DynamicSpawns.Public.registerParty <- function( _partyDef )
{
	foreach (key, value in _partyDef)
	{
		if (!(key in ::DynamicSpawns.Class.Party))
		{
			throw "Invalid key " + key + " in partyDef"
		}
	}
	_partyDef.setdelegate(::DynamicSpawns.__partyMeta);

	::DynamicSpawns.Parties.LookupMap[partyObj.ID] <- _partyDef;

	// We also place a reference of our dynmic party in the vanilla spawn table so our hooks can redirect the spawn behaviors accordingly
	if (_partyDef.ID in ::Const.World.Spawn)
	{
		// We just insert our DynamicParty reference into the very first entry of that array. This is a dirty solution but the best one for now to stay backwards compatible with vanilla
		::Const.World.Spawn[_partyDef.ID][0].DynamicParty <- _partyDef;		// We don't care if we insert a new object or overwrite an existing entry
	}
	else
	{
		::Const.World.Spawn[_partyDef.ID] <- [
			{
				DynamicParty = _partyDef
			}
		];
	}
}

/**
 * Register a dynamic unit block so it can be referenced by parties for spawning
 *
 * If a unit block with that ID already exists then it will be overwritten
 *
 * @param _unitBlockDef table containing at least the entries "ID" and "UnitDefs"
 */
 ::DynamicSpawns.Public.registerUnitBlock <- function( _unitBlockDef )
{
	foreach (key, value in ::DynamicSpawns.Class.UnitBlock)
	{
		if (!(key in _unitBlockDef))
			throw "Invalid key " + key + " in _unitBlockDef";
	}
	_unitBlockDef.setdelegate(::DynamicSpawns.__unitBlockMeta);
	::DynamicSpawns.UnitBlocks.LookupMap[_unitBlockDef.ID] <- _unitBlockDef;
}

/**
 * Register a dynamic unit so it can be referenced by unit blocks for spawning
 *
 * If a unit with that ID already exists then it will be overwritten
 *
 * @param _unitDef table containing at least the entries "ID", "Troop" and "Cost"
 */
::DynamicSpawns.Public.registerUnit <- function( _unitDef )
{
	foreach (key, value in ::DynamicSpawns.Class.Unit)
	{
		if (!(key in _unitDef))
			throw "Invalid key " + key + " in _unitDef";
	}
	_unitDef.setdelegate(::DynamicSpawns.__unitMeta);
	::DynamicSpawns.Units.LookupMap[_unitDef.ID] <- _unitDef;
}

/**
 * Return a dynamic party object.
 *
 * @param _partyID of the party
 * @return reference to the party object if it exists, or null if it doesn't exist
 */
::DynamicSpawns.Public.getParty <- function( _partyID )
{
	if (_partyID in ::DynamicSpawns.Parties.LookupMap)
	{
		return ::DynamicSpawns.Parties.LookupMap[_partyID];
	}
	else
	{
		return null;
	}
}

/**
 * Return a dynamic unit block object.
 *
 * @param _unitBlockID of the unit block
 * @return reference to the unit block object if it exists, or null if it doesn't exist
 */
::DynamicSpawns.Public.getUnitBlock <- function( _unitBlockID )
{
	if (_unitBlockID in ::DynamicSpawns.UnitBlocks.LookupMap)
	{
		return ::DynamicSpawns.UnitBlocks.LookupMap[_unitBlockID];
	}
	else
	{
		return null;
	}
}

/**
 * Return a dynamic unit object.
 *
 * @param _unitID of the unit block
 * @return reference to the unit object if it exists, or null if it doesn't exist
 */
::DynamicSpawns.Public.getUnit <- function( _unitID )
{
	if (_unitID in ::DynamicSpawns.Units.LookupMap)
	{
		return ::DynamicSpawns.Units.LookupMap[_unitID];
	}
	else
	{
		return null;
	}
}



