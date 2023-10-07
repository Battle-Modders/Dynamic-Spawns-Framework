// Redirect Vanilla Spawn function to our dynamic version
// Note: This will potentially skip hooks from other mods when they execute their code at the end of this vanilla function


// Generate a list of Units from _partyList given _resources resources and then add them to the party _worldParty
// _partyList is always an Array of Tables from the Table "::Const.World.Spawn" in order to stay backwards compatible with Vanilla
local oldAssignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = function( _worldParty, _partyList, _resources, _weightMode = 1 )
{
	local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_partyList, _resources);
	if (dynamicParty != null)    // a dynamicParty was found!
	{
		return ::DynamicSpawns.Static.assignTroops(_worldParty, dynamicParty, _resources);
	}
	else
	{
		return oldAssignTroops(_worldParty, _partyList, _resources, _weightMode);
	}
}

// Generate troops given a partyList and resources and adds those to a given array under a set faction
local oldAddUnitsToCombat = ::Const.World.Common.addUnitsToCombat;
::Const.World.Common.addUnitsToCombat = function( _into, _partyList, _resources, _faction, _minibossify = 0 )
{
	local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_partyList, _resources);
	if (dynamicParty != null)    // a dynamicParty was found!
	{
		return ::DynamicSpawns.Static.addUnitsToCombat(_into, dynamicParty, _resources, _faction, _minibossify);
	}
	else
	{
		::logWarning("No dynamic party definition found for this vanilla party!");
		::MSU.Log.printStackTrace();
		return oldAddUnitsToCombat(_into, _partyList, _resources, _faction, _minibossify);
	}
}
