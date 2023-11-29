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
		if (_factionType == null)
			_factionType = ::Const.FactionType.Bandits;

		::World.FactionManager.getFactionOfType(_factionType).spawnEntity(_tile, "DynamicSpawns Test", false, _spawn, _resources);

		::World.setPlayerPos(::World.State.getPlayer().getPos());
		::World.setPlayerVisionRadius(::World.State.getPlayer().getVisionRadius());
	}

	function printSpawn( _partyID, _resources, _fixedResources = false, _detailedLogging = false )
	{
		local wasLogging = ::DynamicSpawns.Const.Logging;
		::DynamicSpawns.Const.Logging = true;
		local wasDetailedLogging = ::DynamicSpawns.Const.DetailedLogging;
		::DynamicSpawns.Const.DetailedLogging = _detailedLogging;
		if (!_fixedResources)
			_resources *= ::MSU.Math.randf(0.7, 1.0);
		local ret = ::DynamicSpawns.Static.getRegisteredPartyVariant(_partyID, _resources).spawn(_resources);
		::DynamicSpawns.Const.Logging = wasLogging;
		::DynamicSpawns.Const.DetailedLogging = wasDetailedLogging;
		return ret;
	}

    function printSpawnAverage( _partyID, _resources, _fixedResources = false, _iterations = 500 )
    {
    	local addValues;
    	addValues = function( _parent, _spawnable )
		{
			if ((_spawnable instanceof ::DynamicSpawns.Class.Unit) && _spawnable.__Instances.len() > 0 && _spawnable.__Instances[0] != _spawnable)
			{
				foreach (instance in _spawnable.__Instances)
				{
					addValues(_parent, instance);
				}
			}
			else
			{
				local id = _spawnable.getLogName();
				if (!(id in _parent))
				{
					_parent[id] <- {
						Total = _spawnable.getTotal()
					};
					if (_spawnable instanceof ::DynamicSpawns.Class.Unit)
						_parent[id].Cost <- _spawnable.Cost;
				}
				else
				{
					_parent[id].Total += _spawnable.getTotal();
				}

				foreach (spawnable in _spawnable.__DynamicSpawnables)
				{
					addValues(_parent[id], spawnable);
				}
				foreach (spawnable in _spawnable.__StaticSpawnables)
				{
					addValues(_parent[id], spawnable);
				}
			}
		}
		local printValues;
		printValues = function( _key, _data )
		{
			::DynamicSpawns.Indent++;
			::logInfo(format("%s%s : %.2f", ::DynamicSpawns.getIndent(), _key, (_data.Total / _iterations)));
			delete _data.Total;
			local ordered = [];
			foreach (key, value in _data)
			{
				if (key == "Cost")
					continue;

				if ("Cost" in value)
					ordered.push([key, value]);
				else
					printValues(key, value);
			}
			if (ordered.len() != 0)
			{
				ordered.sort(@(a, b) a[1].Cost <=> b[1].Cost);
				foreach (entry in ordered)
				{
					printValues(entry[0], entry[1]);
				}
			}

			::DynamicSpawns.Indent--;
		}

		local wasLogging = ::DynamicSpawns.Const.Logging;
    	::DynamicSpawns.Const.Logging = false;
    	local wasDetailedLogging = ::DynamicSpawns.Const.DetailedLogging;
    	::DynamicSpawns.Const.DetailedLogging = false;

    	local data = {};
    	local worth = 0.0;

		local party;
		local resources = _resources;
    	for (local i = 0; i < _iterations; i++)
    	{
    		if (!_fixedResources)
    			resources = _resources * ::MSU.Math.randf(0.7, 1.0);
    		party = ::DynamicSpawns.Static.getRegisteredPartyVariant(_partyID, resources);
    		party.spawn(resources);
    		worth += party.getWorth();
    		addValues(data, party);
    	}

    	_iterations = _iterations.tofloat();

    	printValues(party.getLogName(), data[party.getLogName()]);
    	::logInfo(format("Average Worth: %.2f", worth / _iterations));

    	::DynamicSpawns.Const.Logging = wasLogging;
    	::DynamicSpawns.Const.DetailedLogging = wasDetailedLogging;
    }

    function printVanillaSpawnAverage( _vanillaPartyList, _resources, _fixedResources = false, _iterations = 500 )
    {
    	if (typeof _vanillaPartyList == "string")
    		_vanillaPartyList = ::Const.World.Spawn[_vanillaPartyList];

    	local t = {
    		Total = 0,
    		Worth = 0
    	};

    	if (!_fixedResources)
    	{
    		if (_vanillaPartyList[_vanillaPartyList.len() - 1].Cost < _resources * 0.7)
			{
				_resources = _vanillaPartyList[_vanillaPartyList.len() - 1].Cost;
			}
    	}
    	else if (_iterations != 1)
    	{
    		// For performance because with fixed resources it will always be the same vanilla party that's selected
    		// We don't set it to 1 because of the way the log is printed later which checks for _iterations == 1
    		_iterations = 2;
    	}

    	local scriptToTroopNameMap = {};
    	foreach (key, troop in ::Const.World.Spawn.Troops)
    	{
    		scriptToTroopNameMap[troop.Script] <- key;
    	}

    	local potential;
    	local total_weight;
    	for (local i =0; i < _iterations; i++)
    	{
    		potential = [];
    		total_weight = 0;
    		if (!_fixedResources)
    		{
    			foreach(party in _vanillaPartyList )
				{
					if (party.Cost < _resources * 0.7)
					{
						continue;
					}

					if (party.Cost > _resources)
					{
						break;
					}

					potential.push(party);
					total_weight += party.Cost;
				}
    		}

			local p;

			if (potential.len() == 0)
			{
				local best;
				local bestCost = 9000;

				foreach (party in _vanillaPartyList)
				{
					if (::Math.abs(_resources - party.Cost) <= bestCost)
					{
						best = party;
						bestCost = ::Math.abs(_resources - party.Cost);
					}
				}

				p = best;
			}
			else
			{
				local pick = ::Math.rand(1, total_weight);

				foreach (party in potential)
				{
					if (pick <= party.Cost)
					{
						p = party;
						break;
					}

					pick -= party.Cost;
				}
			}

			t.Worth += p.Cost;
	    	foreach (troop in p.Troops)
	    	{
	    		t.Total += troop.Num;
	    		local name = scriptToTroopNameMap[troop.Type.Script];
	    		if (!(name in t))
	    			t[name] <- troop.Num;
	    		else
	    			t[name] += troop.Num;
	    	}
    	}

    	_iterations = _iterations.tofloat();

    	if (_iterations == 1)
    		::logInfo("-- Vanilla Spawn -- ");
    	else
    		::logInfo("-- Vanilla Spawn Average -- ");

    	::logInfo(format("Total: %.2f", (t.Total / _iterations)));
    	local worth = t.Worth / _iterations;
    	delete t.Total;
    	delete t.Worth;

    	::DynamicSpawns.Indent += 2;
    	foreach (name, num in t)
    	{
    		::logInfo(format("%s%s : %.2f", ::DynamicSpawns.getIndent(), name, (num / _iterations)));
    	}
    	::DynamicSpawns.Indent -= 2;
    	if (_iterations == 1)
    		::logInfo(format("Worth: %.2f", worth));
    	else
    		::logInfo(format("Average Worth: %.2f", worth));

    	::logInfo(" ------- ");
    }

    function printVanillaSpawn( _vanillaPartyList, _resources, _fixedResources = false )
    {
    	this.printVanillaSpawnAverage(_vanillaPartyList, _resources, _fixedResources, 1);
    }

    function compareSpawn( _partyID, _resources, _fixedResources = false )
    {
    	if (!_fixedResources)
    	{
    		_resources *= ::MSU.Math.randf(0.7, 1.0);
    		_fixedResources = true;
    	}
    	this.printVanillaSpawn(_partyID, _resources, _fixedResources);
    	this.printSpawn(_partyID, _resources, _fixedResources);
    }

    function compareSpawnAverage( _partyID, _resources, _fixedResources = false, _iterations = 500 )
    {
    	this.printVanillaSpawnAverage(_partyID, _resources, _fixedResources, _iterations);
    	this.printSpawnAverage(_partyID, _resources, _fixedResources, _iterations);
    }

    function printVanillaPartyInfo( _party, _minResources = null, _maxResources = null )
    {
    	if (typeof _party == "string")
    		_party = ::Const.World.Spawn[_party];

    	local troopToNameMap = {};
    	foreach (key, troop in ::Const.World.Spawn.Troops)
    	{
    		troopToNameMap[troop] <- key;
    	}

    	local troopInfo = {};

    	local partyCount = 0;
    	local minIdx = -1;
    	local maxIdx = _party.len() - 1;
    	local sizes = [];

    	foreach (i, party in _party)
    	{
    		if (_minResources != null && party.Cost < _minResources)
    		{
    			continue;
    		}
    		else if (minIdx == -1)
    			minIdx = i;

    		if (_maxResources != null && party.Cost > _maxResources)
    		{
    			maxIdx = i - 1;
    			break;
    		}

    		partyCount++;

    		local size = 0.0;
			foreach (troop in party.Troops)
			{
				size += troop.Num;
			}
			sizes.push(size);
    		foreach (troop in party.Troops)
    		{
    			local name = troopToNameMap[troop.Type];
    			if (!(name in troopInfo))
    			{
    				troopInfo[name] <- {
    					StartingResourceMin = party.Cost,
    					StartingResourceMax = party.Cost,
    					PartySizeMin = size,
    					NumMin = troop.Num,
    					NumMax = troop.Num,
    					RatioMin = troop.Num / size,
    					RatioMax = troop.Num / size,
    					PartyCount = 1,
    					FirstPartyIdx = i,
    					LastPartyIdx = i
    				}
    			}
    			else
    			{
    				local info = troopInfo[name];
    				info.StartingResourceMax = party.Cost;
    				info.NumMin = ::Math.min(info.NumMin, troop.Num);
    				info.NumMax = ::Math.max(info.NumMax, troop.Num);
    				info.RatioMin = ::Math.minf(info.RatioMin, troop.Num / size);
    				info.RatioMax = ::Math.maxf(info.RatioMax, troop.Num / size);
    				info.PartyCount++;
    				info.LastPartyIdx = i;
    			}
    		}
    	}

    	sizes.sort();
    	local sizeMin = sizes.len() == 0 ? 0 : sizes[0];
    	local sizeMax = sizes.len() == 0 ? 0 : sizes.top();

    	if (minIdx == -1)
    		minIdx = 0;

		::logInfo("Total variants: " + partyCount);
    	::logInfo("SizeMin: " + sizeMin);
    	::logInfo("SizeMax: " + sizeMax);
    	::logInfo("CostMin: " + _party[minIdx].Cost);
    	::logInfo("CostMax: " + _party[maxIdx].Cost);
    	foreach (name, info in troopInfo)
    	{
    		local startingResourceMin = info.StartingResourceMin == _party[minIdx].Cost ? "0" : info.StartingResourceMin + "";
    		local startingResourceMax = info.StartingResourceMax == _party[maxIdx].Cost ? "None" : info.StartingResourceMax + "";
    		local partySizeMin = info.PartySizeMin == sizeMin ? "None" : info.PartySizeMin + "";
    		local exclusionChance = 1.0 - info.PartyCount.tofloat() / (1 + info.LastPartyIdx - info.FirstPartyIdx);
    		::logInfo(format("%s: StartingResourceMin: %s, StartingResourceMax: %s, PartySizeMin: %s, NumMin: %i, NumMax: %i, RatioMin: %.2f, RatioMax: %.2f, ExclusionChance: %.2f", name, startingResourceMin, startingResourceMax, partySizeMin, info.NumMin, info.NumMax, info.PartyCount == partyCount ? info.RatioMin : 0.0, info.RatioMax, exclusionChance));
    	}
    }
};
