// Redirect Vanilla Spawn function to our dynamic version
// Note: This will potentially skip hooks from other mods when they execute their code at the end of this vanilla function


// Generate a list of Units from _partyList given _resources resources and then add them to the party _worldParty
local oldAssignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = function( _worldParty, _partyList, _resources, _weightMode = 1 )
{
	if (::DynamicSpawns.Static.isDynamicParty(_partyList))    // check whether _partyList is a dynamic list or rather do we have already defined dynamic behavior for that?
	{
		// ::logWarning("Sucessful redirect to custom assignTroops");
		return ::DynamicSpawns.Static.assignTroops(_worldParty, _partyList, _resources);
	}
	return oldAssignTroops(_worldParty, _partyList, _resources, _weightMode);
}

// Generate a list of Units from _partyList given _resource resources, add them to the existing party _into but under a different faction _faction
local oldAddUnitsToCombat = ::Const.World.Common.addUnitsToCombat;
::Const.World.Common.addUnitsToCombat = function( _into, _partyList, _resources, _faction, _minibossify = 0 )
{
	if (::DynamicSpawns.Static.isDynamicParty(_partyList))    // check whether _partyList is a dynamic list or rather do we have already defined dynamic behavior for that?
	{
		return ::DynamicSpawns.Static.addTroops(_into, _partyList, _resources, _faction, _minibossify);
	}
	return oldAddUnitsToCombat(_worldParty, _partyList, _resources, _faction, _minibossify);
}
