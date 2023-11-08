// Collection of stateless functions used to implement the hooking
::DynamicSpawns.Static <- {};

/** Generate troops given a dynamic party and resources and add those to a world party.
 * Equivalent to the vanilla function ::Const.World.Common.assignTroops().
 *
 * @Param _worldparty vanilla-party object that we spawn the troops into
 * @Param _dynamicParty DSF-Party object used for the spawning process
 * @Param _resources unsigned integer describing amount of resources available for spending in this spawning process
 *
 * @Return table guaranteed to contain the entry 'Body' having a brush name representing this party
 */
::DynamicSpawns.Static.assignTroops <- function( _worldParty, _dynamicParty, _resources, _minibossify = 0 )
{
	_resources *= ::MSU.Math.randf(0.8, 1.0);	// This accounts for vanilla choosing a random party composition allowing for picking slightly weaker aswell

	local spawnProcess = ::DynamicSpawns.Class.SpawnProcess(_dynamicParty, _resources);
	local spawnedUnits = spawnProcess.spawn();

	local party = spawnProcess.getParty();
	local body = party.getFigure(spawnProcess);

	_worldParty.setMovementSpeed(party.MovementSpeedMult * ::Const.World.MovementSettings.Speed);
	_worldParty.setVisibilityMult(party.VisibilityMult);
	_worldParty.setVisionRadius(party.VisionMult * ::Const.World.Settings.Vision);
	_worldParty.getSprite("body").setBrush(body);

	foreach (unit in spawnedUnits)
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getTroop()]}, false, _minibossify);
	}
	_worldParty.updateStrength();

	// We can return whatever as long as it is a table with an entry called 'Body' that has the correct Body-ID
	return {Body = body};
}

/** Generate additional troops, given a dynamic party and resources, and add those to a world party.
 * Used for hooking the vanilla function addUnitsToEntity() from the contract.nut and createDefenders() from the location.nut
 *
 * @Param _worldparty vanilla-party object that we spawn the troops into
 * @Param _dynamicParty DSF-Party object used for the spawning process
 * @Param _resources unsigned integer describing amount of resources available for spending in this spawning process
 * @Param _miniBossify unsigned bonus chance for every troop in this party to become a champion (if permitted by that troop)
 */
::DynamicSpawns.Static.addUnitsToEntity <- function( _worldParty, _dynamicParty, _resources, _miniBossify = 0 )
{
	_resources *= ::MSU.Math.randf(0.8, 1.0);	// This accounts for the vanilla function picking a random party between 0.7 and 1.0 cost

	// ::logWarning("Spawning the party '" + this.m.ID + "' with '" + _resources + "' Resources");
	local spawnProcess = ::DynamicSpawns.Class.SpawnProcess(_dynamicParty, _resources, _worldParty.isLocation());

	foreach (unit in spawnProcess.spawn())
	{
		::Const.World.Common.addTroop(_worldParty, {Type = ::Const.World.Spawn.Troops[unit.getTroop()]}, false, _miniBossify);
	}
	_worldParty.updateStrength();
}

/** Generate troops given a dynamic party and resources and adds those to a given array
 * Equivalent to the vanilla function ::Const.World.Common.addUnitsToCombat()
 *
 * @Param _combatUnitArray array of generated troops that this function adds its generated troops into
 * @Param _dynamicParty DSF-Party object used for the spawning process
 * @Param _resources unsigned integer describing amount of resources available for spending in this spawning process
 * @Param _faction factionID that all spawned troops will receive
 * @Param _minibossify unsigned integer defining an addtional chance to spawn chapmions
 */
::DynamicSpawns.Static.addUnitsToCombat <- function( _combatUnitArray, _dynamicParty, _resources, _faction, _minibossify = 0 )
{
	_resources *= ::MSU.Math.randf(0.8, 1.0);	// This accounts for vanilla choosing a random party with cost between 0.7 and 1.0 of resources given

	local spawnProcess = ::DynamicSpawns.Class.SpawnProcess(_dynamicParty, _resources, false);

	foreach (unit in spawnProcess.spawn())
	{
		local troopTemplate = ::Const.World.Spawn.Troops[unit.getTroop()];
		local unit = clone troopTemplate;

		// The following code is an exact copy of how vanilla does this in their 'function addUnitsToCombat'
		unit.Faction <- _faction;
		unit.Name <- "";

		if (unit.Variant > 0)
		{
			if (!::Const.DLC.Wildmen || ::Math.rand(1, 100) > unit.Variant + _minibossify + (::World.getTime().Days > 90 ? 0 : -1))
			{
				unit.Variant = 0;
			}
			else
			{
				unit.Strength = ::Math.round(unit.Strength * 1.35);
				unit.Variant = ::Math.rand(1, 255);

				if ("NameList" in troopTemplate.Type)
				{
					unit.Name = ::Const.World.Common.generateName(troopTemplate.Type.NameList) + (troopTemplate.Type.TitleList != null ? " " + troopTemplate.Type.TitleList[::Math.rand(0, troopTemplate.Type.TitleList.len() - 1)] : "");
				}
			}
		}

		_combatUnitArray.push(unit);
	}
}

/** Return a dynamic party definition given a vanilla party definition
 *
 * @Param _vanillaPartyList object from the vanilla table ::Const.World.Spawn
 *
 * @Param _resources integer which is used to set resources before checking `isValid()` of party variants
 *
 * @Return DSF-Party object if one exists for the given vanilla party list; null if none was set for it
 */
::DynamicSpawns.Static.retrieveDynamicParty <- function( _vanillaPartyList, _resources = -1 )
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
::DynamicSpawns.Static.getRegisteredPartyVariant <- function( _partyID, _resources = -1 )
{
	local partyDef = ::DynamicSpawns.Parties.findById(_partyID);
	if (partyDef instanceof ::MSU.Class.WeightedContainer)
	{
		// partyDef becomes a string which is an ID of a registered party
		// We assume that at least one variant must be always valid to spawn
		partyDef = partyDef.map(function( _variantDef, _weight ) {
			local spawnProcess = ::DynamicSpawns.Class.SpawnProcess(::DynamicSpawns.Static.getRegisteredPartyVariant(_variantDef.ID, _resources), _resources);
			return [spawnProcess.getParty().isValid() ? _weight : 0, spawnProcess.getParty().ID];
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

/** Check all Parties, UnitBlocks and Units for consistency. Print Errors into the log if there are surface level problems
 *
 * @Return amount of warnings or errors generated
 */
::DynamicSpawns.Static.consistencyCheck <- function()
{
	local logsGenerated = 0;

	::logInfo("Checking " + ::DynamicSpawns.Parties.LookupMap.len() + " parties, " + ::DynamicSpawns.UnitBlocks.LookupMap.len() + " blocks and " + ::DynamicSpawns.Units.LookupMap.len() + " units for consistency...");

	// Check all currently registered Parties
	foreach (partyObj in ::DynamicSpawns.Parties.LookupMap)
	{
		if (partyObj.getUnitBlockDefs().len() == 0 && partyObj.StaticUnitIDs.len() == 0)
		{
			::logError("The Party '" + partyObj.getID() + "' has no units or blocks defined for it. It will not produce any units!");
			logsGenerated++;
		}
		if (partyObj.getHardMax() <= 0)
		{
			::logError("The Party '" + partyObj.getID() + "' has HardMax of 0! It will not produce any units!");
			logsGenerated++;
		}
	}

	// Check all currently registered Unit Blocks
	foreach (unitBlockObj in ::DynamicSpawns.UnitBlocks.LookupMap)
	{
		if (unitBlockObj.getUnitDefs().len() == 0)
		{
			::logWarning("The UnitBlock '" + unitBlockObj.getID() + "' has no units defined for it. It will never produce any units!");
			logsGenerated++;
		}
		if (unitBlockObj.RatioMax <= 0.0)
		{
			::logWarning("The UnitBlock '" + unitBlockObj.getID() + "' has a RatioMax of 0 or less! It will never produce any units!");
			logsGenerated++;
		}
	}

	// Check all currently registered Units
	foreach (unitObj in ::DynamicSpawns.Units.LookupMap)
	{
		local entityType = unitObj.getTroop();
		if (entityType == null)
		{
			::logWarning("The Unit '" + unitObj.getID() + "' has no Troop defined for it. It will never produce any units!");
			logsGenerated++;
		}
	}

	return logsGenerated;
}
