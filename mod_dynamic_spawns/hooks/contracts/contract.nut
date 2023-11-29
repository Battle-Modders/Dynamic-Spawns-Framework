::mods_hookBaseClass("contracts/contract", function(o)
{
	o = o[o.SuperName];

	// Generate additional troops, given a _party and _resources, and add those to a _worldParty.
	// Note: This hook will potentially skip hooks from other mods when they execute their code at the end of this vanilla function
	local addUnitsToEntity = o.addUnitsToEntity;
	o.addUnitsToEntity = function( _worldParty, _party, _resources )
	{
		local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_party, _resources);
		if (dynamicParty != null)
		{
			dynamicParty.__IsLocation = _worldParty.isLocation();
			dynamicParty.spawn(_resources);

			_party = [
				{
					Cost = _resources,
					Troops = dynamicParty.getTroops()
				}
			];
		}

		return addUnitsToEntity(_worldParty, _party, _resources);
	}
});
