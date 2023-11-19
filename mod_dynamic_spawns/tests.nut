// Collection of tests to find errors in the dynamic spawn party definitions early
::DynamicSpawns.Tests <- {
	/** check all Parties, UnitBlocks and Units for consistency. Print Errors into the log if there are surface level problems
	*
	* @Param _printInfo controls whether general information like summaries should be displayed
	* @Param _printWarnings controls whether warnings should be displayed
	* @Return amount of warnings and errors generated and printed
	*/
	function checkAll( _printInfo = true, _printWarnings = true )
	{
		local logsGenerated = 0;

		 if (_printInfo) ::logInfo("Checking " + ::DynamicSpawns.Parties.LookupMap.len() + " parties, " + ::DynamicSpawns.UnitBlocks.LookupMap.len() + " blocks and " + ::DynamicSpawns.Units.LookupMap.len() + " units for consistency...");

		 // check all currently registered Parties
		 foreach (partyKey, partyDef in ::DynamicSpawns.Parties.LookupMap)
		 {
			logsGenerated += ::DynamicSpawns.Tests.checkPartyDef(partyKey, partyDef, _printInfo, _printWarnings);
		 }

		 // check all currently registered Unit Blocks
		 foreach (unitBlockKey, unitBlockDef in ::DynamicSpawns.UnitBlocks.LookupMap)
		 {
			logsGenerated += ::DynamicSpawns.Tests.checkUnitBlockDef(unitBlockKey, unitBlockDef, _printInfo, _printWarnings);
		 }

		 // check all currently registered Units
		 foreach (unitKey, unitDef in ::DynamicSpawns.Units.LookupMap)
		 {
			logsGenerated += ::DynamicSpawns.Tests.checkUnitDef(unitKey, unitDef, _printInfo, _printWarnings);
		 }

		 // check all vanilla parties
		 foreach(vanillyKey, vanillaParty in ::Const.World.Spawn)
		 {
			logsGenerated += ::DynamicSpawns.Tests.checkVanillaParty(vanillyKey, vanillaParty, _printInfo, _printWarnings);
		 }

		 return logsGenerated;
	}

	function checkPartyDef( _partyKey, _partyDef, _printInfo = true, _printWarnings = true )
	{
		local logsGenerated = 0;
		if (_partyDef instanceof ::MSU.Class.WeightedContainer) return logsGenerated;	// We skip all variants because the parties they contain are separate entries in the LookupMap

		// Static Units
		if ("StaticUnitDefs" in _partyDef)
		{
			foreach(unitDef in _partyDef.StaticUnitDefs)
			{
				if ("BaseID" in unitDef && !(unitDef.BaseID in ::DynamicSpawns.Units.LookupMap))
				{
					::logError("Test Error: The Static Unit \"" + unitDef.BaseID + "\" from the party \"" + _partyKey + "\" does not exist!");
					logsGenerated++;
				}
			}
		}

		// Unit Blocks
		if ("UnitBlockDefs" in _partyDef)
		{
			foreach(unitBlockDef in _partyDef.UnitBlockDefs)
			{
				if ("BaseID" in unitBlockDef && !(unitBlockDef.BaseID in ::DynamicSpawns.UnitBlocks.LookupMap))
				{
					::logError("Test Error: The Unit Block \"" + unitBlockDef.BaseID + "\" from the party \"" + _partyKey + "\" does not exist!");
					logsGenerated++;
				}
			}
		}
		return logsGenerated;
	}

	function checkUnitBlockDef( _unitBlockKey, _unitBlockDef, _printInfo = true, _printWarnings = true )
	{
		local logsGenerated = 0;
		if (!("UnitDefs" in _unitBlockDef))
		{
			::logError("Test Error: The UnitBlock \"" + _unitBlockKey + "\" has no units defined for it. It will never produce any units!");
			logsGenerated++;
			return logsGenerated;
		}

		// Unit Defs
		foreach(unitDef in _unitBlockDef.UnitDefs)
		{
			if ("BaseID" in _unitBlockDef && !(_unitBlockDef.BaseID in ::DynamicSpawns.UnitBlocks.LookupMap))
			{
				::logError("Test Error: The Unit \"" + _unitBlockDef.BaseID + "\" from the block \"" + _unitBlockKey + "\" does not exist!");
				logsGenerated++;
			}
		}
		return logsGenerated;
	}

	function checkUnitDef( _unitKey, _unitDef, _printInfo = true, _printWarnings = true )
	{
		local logsGenerated = 0;
		if (!("Troop" in _unitDef))
		{
			::logError("Test Error: The Unit \"" + _unitKey + "\" has no Troop defined for it. It will never produce any units!");
			logsGenerated++;
		}
		return logsGenerated;
	}

	function checkVanillaParty( _vanillyKey, _vanillaParty, _printInfo = true, _printWarnings = true)
	{
		local logsGenerated = 0;
		if (::DynamicSpawns.Static.retrieveDynamicParty(_vanillaParty) == null)
		{
			if (_vanillyKey == "Unit") return logsGenerated;	// This is a special vanilla subtable that is not an actual party
			if (_vanillyKey == "Troops") return logsGenerated;	// This is a special vanilla subtable that is not an actual party
			if (_printWarnings)
			{
				::logWarning("Test Warning: There exists no dynamic party for the vanilla party \"" + _vanillyKey + "\". Its vanilla spawning behavior will be used.");
				logsGenerated++;
			}
		}
		return logsGenerated;
	}

	function spawnWorldParty( _spawn, _resources, _tile = null, _factionType = null )
	{
		if (_tile == null)
		{
			local playerTile = ::World.State.getPlayer().getTile();
			_tile = ::World.getTileSquare(playerTile.SquareCoords.X - 2, playerTile.SquareCoords.Y - 2);
		}
		if (_faction == null)
			_faction = ::Const.FactionType.Bandits;

		::World.FactionManager.getFactionOfType(_faction).spawnEntity(spawnTile, "DynamicSpawns Test", false, _spawn, _resources);

		::World.setPlayerPos(::World.State.getPlayer().getPos());
		::World.setPlayerVisionRadius(::World.State.getPlayer().getVisionRadius());
	}
};
