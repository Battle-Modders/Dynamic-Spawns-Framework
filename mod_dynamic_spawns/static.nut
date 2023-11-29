// Collection of stateless functions used to implement the hooking
::DynamicSpawns.Static <- {};

/** Return a dynamic party definition given a vanilla party definition
 *
 * @Param _vanillaPartyList object from the vanilla table ::Const.World.Spawn
 *
 * @Param _resources integer which is used to set resources before checking `isValid()` of party variants
 *
 * @Return DSF-Party object if one exists for the given vanilla party list; null if none was set for it
 */
::DynamicSpawns.Static.retrieveDynamicParty <- function( _vanillaPartyList, _resources = null )
{
	if (typeof _vanillaPartyList != "array") return null;
	if (_vanillaPartyList.len() == 0) return null;
	if (!("DynamicSpawnsPartyID" in _vanillaPartyList[0])) return null;

	return this.getRegisteredPartyVariant(_vanillaPartyList[0].DynamicSpawnsPartyID, _resources);
}

/** Return a dynamic party definition given a vanilla party definition
 *
 * @Param _vanillaPartyList object from the vanilla table ::Const.World.Spawn
 *
 * @Param _resources integer which is used to set resources before checking `isValid()` of party variants
 *
 * @Return DSF-Party object if one exists for the given vanilla party list; null if none was set for it
 */
::DynamicSpawns.Static.getRegisteredPartyVariant <- function( _partyID, _resources = null )
{
	local partyDef = ::DynamicSpawns.Parties.findById(_partyID);
	if (partyDef instanceof ::MSU.Class.WeightedContainer)
	{
		// partyDef becomes a string which is an ID of a registered party
		// We assume that at least one variant must be always valid to spawn
		partyDef = partyDef.map(function( _variantDef, _weight ) {
			local party = ::DynamicSpawns.Static.getRegisteredPartyVariant(_variantDef.ID, _resources);
			party.setupResources(_resources);
			return [party.isValid() ? _weight : 0, party.getID()];
		}).roll();
	}
	return ::DynamicSpawns.__getObjectFromDef(partyDef, ::DynamicSpawns.Parties);
}

/** Check whether a dynamic party exists given a vanilla partyList
 *
 * @Param _partyList table containing vanilla party compositions of for the same partyType
 *
 * @Return true if a dynamic party is defined for this vanilla partyList, false otherwise
 */
::DynamicSpawns.Static.isDynamicParty <- function( _partyList )
{
	return _partyList instanceof ::DynamicSpawns.Class.Party;
}
