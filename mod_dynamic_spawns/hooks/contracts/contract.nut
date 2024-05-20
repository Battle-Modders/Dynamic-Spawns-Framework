::DynamicSpawns.MH.hook("scripts/contracts/contract", function(q)
{
	// Generate additional troops, given a _party and _resources, and add those to a _worldParty.
	// Note: This hook will potentially skip hooks from other mods when they execute their code at the end of this vanilla function
	q.addUnitsToEntity = @(__original) function( _worldParty, _party, _resources )
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

		return __original(_worldParty, _party, _resources);
	}
});
