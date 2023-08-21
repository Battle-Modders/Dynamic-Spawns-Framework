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
	local partyObj = ::new(::DynamicSpawns.Class.Party).init(_partyDef);
	::DynamicSpawns.Parties.LookupMap[partyObj.m.ID] <- partyObj;

	// We also place a reference of our dynmic party in the vanilla spawn table so our hooks can redirect the spawn behaviors accordingly
	if (partyObj.m.ID in ::Const.World.Spawn)
	{
		// We just insert our DynamicParty reference into the very first entry of that array. This is a dirty solution but the best one for now to stay backwards compatible with vanilla
		::Const.World.Spawn[partyObj.m.ID][0].DynamicParty <- partyObj;		// We don't care if we insert a new object or overwrite an existing entry
	}
	else
	{
		::Const.World.Spawn[partyObj.m.ID] <- [
			{
				DynamicParty = partyObj
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
	local unitBlockObj = ::new(::DynamicSpawns.Class.UnitBlock).init(_unitBlockDef);
	::DynamicSpawns.UnitBlocks.LookupMap[unitBlockObj.m.ID] <- unitBlockObj;
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
	local unitObj = ::new(::DynamicSpawns.Class.Unit).init(_unitDef);
	::DynamicSpawns.Units.LookupMap[unitObj.m.ID] <- unitObj;
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



