::mods_hookBaseClass("contracts/contract", function(o)
{
	while(!("EmployerID" in o.m)) o = o[o.SuperName]; // find the base class

	// Generate additional troops, given a _party and _resources, and add those to a _worldParty.
	// Note: This hook will potentially skip hooks from other mods when they execute their code at the end of this vanilla function
	local oldAddUnitsToEntity = o.addUnitsToEntity;
	o.addUnitsToEntity = function( _worldParty, _party, _resources )
	{
		local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_party);
		if (dynamicParty != null)    // a dynamicParty was found!
		{
			return ::DynamicSpawns.Static.addUnitsToEntity(_worldParty, dynamicParty, _resources);
		}
		else
		{
			return oldAddUnitsToEntity(_worldParty, _party, _resources);
		}
	}
});
