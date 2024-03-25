// Redirect Vanilla Spawn function to our dynamic version
// Note: This will potentially skip hooks from other mods when they execute their code at the end of this vanilla function


// Generate a list of Units from _partyList given _resources resources and then add them to the party _worldParty
// _partyList is always an Array of Tables from the Table "::Const.World.Spawn" in order to stay backwards compatible with Vanilla
local assignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = function( _worldParty, _partyList, _resources, _weightMode = 1 )
{
	_resources *= _weightMode == this.WeightMode.Weakest ? 0.7 : ::MSU.Math.randf(0.7, 1.0); // This accounts for vanilla choosing a random party composition allowing for picking slightly weaker as well

	local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_partyList, _resources);
	if (dynamicParty != null)
	{
		dynamicParty.spawn(_resources);
		_partyList = [
			{
				Cost = _resources,
				Troops = dynamicParty.getTroops(),
				Body = dynamicParty.getFigure()
				VisionMult = dynamicParty.VisionMult,
				VisibilityMult = dynamicParty.VisibilityMult,
				MovementSpeedMult = dynamicParty.MovementSpeedMult
			}
		];
	}
	else
	{
		local name;
		foreach (key, value in ::Const.World.Spawn)
		{
			if (value == _partyList)
			{
				name = key;
				break;
			}
		}
		::logWarning("No dynamic party definition found for this vanilla party: " + name);
		::MSU.Log.printStackTrace();
	}

	return assignTroops(_worldParty, _partyList, _resources, _weightMode);
}

// Generate troops given a partyList and resources and adds those to a given array under a set faction
local addUnitsToCombat = ::Const.World.Common.addUnitsToCombat;
::Const.World.Common.addUnitsToCombat = function( _into, _partyList, _resources, _faction, _minibossify = 0 )
{
	_resources *= ::MSU.Math.randf(0.7, 1.0); // This accounts for vanilla choosing a random party composition allowing for picking slightly weaker as well
	local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(_partyList, _resources);
	if (dynamicParty != null)
	{
		dynamicParty.spawn(_resources);
		_partyList = [
			{
				Cost = _resources,
				Troops = dynamicParty.getTroops()
			}
		];
	}
	else
	{
		::logWarning("No dynamic party definition found for this vanilla party!");
		::MSU.Log.printStackTrace();
	}

	return addUnitsToCombat(_into, _partyList, _resources, _faction, _minibossify);
}
