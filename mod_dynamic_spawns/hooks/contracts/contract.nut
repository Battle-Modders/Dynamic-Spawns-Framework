// Redirect Vanilla addUnitsToEntity function to our remake
// Note: This will potentially skip hooks from other mods when they execute their code at the end of this vanilla function

::mods_hookBaseClass("contracts/contract", function(o)
{
	while(!("EmployerID" in o.m)) o = o[o.SuperName]; // find the base class

	// Generate a list of Units from _partyList given _resources resources and then add them to the party _worldParty
	local oldAddUnitsToEntity = o.addUnitsToEntity;
	o.addUnitsToEntity = function( _worldParty, _party, _resources )
	{
		local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_party);
		if (dynamicParty != null)    // a dynamicParty was found!
		{
			return ::DynamicSpawns.Static.addTroops(_worldParty, dynamicParty, _resources);
		}
		else
		{
			return oldAddUnitsToEntity(_worldParty, _party, _resources);
		}
	}
});
