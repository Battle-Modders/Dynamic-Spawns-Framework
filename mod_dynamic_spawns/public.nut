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
	if ("Variants" in _partyDef)
	{
		if (_partyDef.len() > 2)
		{
			::logError("DynamicSpawns -- _partyDef with ID " + _partyDef.ID + " not registered. Error: PartyDefs with Variants cannot have any key except \'ID\' and \'Variants\'");
			return;
		}

		local hasValidID = false;
		foreach (variant, _ in _partyDef.Variants)
		{
			if (variant.ID == _partyDef.ID + "_0")
			{
				hasValidID = true;
				break;
			}
		}
		if (!hasValidID)
		{
			::logError("DynamicSpawns -- _partyDef with ID " + _partyDef.ID + " not registered. Error: PartyDefs with Variants must have one variant with the same ID as the party with \'_0\' appended to it. Required Variant ID: " + _partyDef.ID + "_0");
			return;
		}

		::DynamicSpawns.Parties.LookupMap[_partyDef.ID] <- _partyDef.Variants;
		foreach (variant, _ in _partyDef.Variants)
		{
			::DynamicSpawns.Public.registerParty(variant);
		}
	}
	else
	{
		::DynamicSpawns.Parties.LookupMap[_partyDef.ID] <- _partyDef;
	}

	::DynamicSpawns.__setClass(::DynamicSpawns.Class.Party, _partyDef);

	// We also place a reference of our dynmic party in the vanilla spawn table so our hooks can redirect the spawn behaviors accordingly
	if (_partyDef.ID in ::Const.World.Spawn)
	{
		// We just insert our DynamicParty reference into the very first entry of that array. This is a dirty solution but the best one for now to stay backwards compatible with vanilla
		::Const.World.Spawn[_partyDef.ID][0].DynamicSpawnsPartyID <- _partyDef.ID;		// We don't care if we insert a new object or overwrite an existing entry
	}
	else
	{
		::Const.World.Spawn[_partyDef.ID] <- [
			{
				DynamicSpawnsPartyID = _partyDef.ID
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
	::DynamicSpawns.__setClass(::DynamicSpawns.Class.UnitBlock, _unitBlockDef);
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
	::DynamicSpawns.__setClass(::DynamicSpawns.Class.Unit, _unitDef);
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



