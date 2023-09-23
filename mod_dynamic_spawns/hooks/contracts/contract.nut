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
			// Minibossify depending on contract difficulty (copy of vanilla code)
			local minibossify = -99;	// super weak contracts actively prevent spawning of champions
			if (this.getDifficultyMult() >= 1.15)
			{
				minibossify = 5;
			}
			else if (this.getDifficultyMult() >= 0.85)
			{
				minibossify = 0;
			}

			return ::DynamicSpawns.Static.addUnitsToEntity(_worldParty, dynamicParty, _resources, minibossify);
		}
		else
		{
			return oldAddUnitsToEntity(_worldParty, _party, _resources);
		}
	}
});
