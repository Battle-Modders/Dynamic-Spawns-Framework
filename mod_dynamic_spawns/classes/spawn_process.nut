// "Class" that manages the dynamic spawning given a Party-Class and additional variables
this.spawn_process <- inherit(::MSU.BBClass.Empty, {
	m = {
		// Temporary Variables, They only exist and are valid during one spawning process
        SpawnInfo = {},     // Table of Tables. For each UnitBlock and for each spawned units from that Block
        UnitCount = 0,      // Amount of units spawned during this process. This does not include SubParties

		Party = null,		// Cloned Party object, that is used for spawning
		Resources = 0,		// Available resources during this run
		StartingResources = 0,		// Resource that this spawnProcess started with
		IdealSize = 6,

		PlayerStrength = 0,		// Strength of the Playerparty
	}

    function create()
    {
    }

    function init( _party, _availableResources = -1, _isLocation = false, _customHardMin = null, _customHardMax = null )
    {
		this.m.SpawnInfo = {};
		this.m.UnitCount = 0;

		this.m.Party = _party.getClone();
		_party = this.getParty();	//
		if (_customHardMin != null) this.m.Party.m.HardMin = _customHardMin;
		if (_customHardMax != null) this.m.Party.m.HardMax = _customHardMax;

		this.m.StartingResources = (_availableResources == -1) ? this.getParty().m.DefaultResources : _availableResources;
		this.m.Resources = this.m.StartingResources;

		this.m.IdealSize = this.getParty().generateIdealSize(this, _isLocation);	// Locations currently have a 50% higher IdealSize compared to roaming parties
		if (this.getIdealSize() <= 0) this.m.IdealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here

		// Initialize SpawnInfo
		foreach (staticUnit in this.getParty().getStaticUnits())
		{
			this.m.SpawnInfo["StaticUnits"] <- {	// HardCoded entry just for static units
				Total = 0
			};
			this.m.SpawnInfo["StaticUnits"][staticUnit.getID()] <- 0;
		}

		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			this.m.SpawnInfo[unitBlock.getID()] <- {
				Total = 0
			};

			foreach (unit in unitBlock.getUnits())
			{
				this.m.SpawnInfo[unitBlock.getID()][unit.getID()] <- 0;
			}
		}

		return this;
    }

    function spawn()
    {
        this.m.PlayerStrength = 100;     // Placeholder. This needs to be passed as argument or taken from global variable/function
		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			::DynamicSpawns.UnitBlocks.findById(unitBlock.getID()).onPartySpawnStart();
		}

		local ret = [];

        // Spawn static units
		foreach (unit in this.getParty().getStaticUnits())
		{
			if (unit.canSpawn(this))
			{
				this.incrementUnit(unit.getID(), "StaticUnits");
				this.consumeResources(unit.getCost());
			}
		}

		local spawnAffordableBlocks = ::MSU.Class.WeightedContainer();
		local upgradeAffordableBlocks = ::MSU.Class.WeightedContainer();

		// Every while spawns or upgrades only one unit
		while (this.canDoAnotherCycle())	// Is True while Resources are positive or HardMin is not yet reached
		{
			spawnAffordableBlocks.clear();
			upgradeAffordableBlocks.clear();

			local ratioSpawn = false;	// A ratioSpawn is a forced spawn for a block because its RatioMin is not satisfied anymore
			foreach (unitBlock in this.getParty().getUnitBlocks())
			{
				if (this.getParty().canSpawn(this) && unitBlock.canSpawn(this))
				{
					// ::logWarning("The Block " + unitBlock.getID() + " is able to spawn!");
					if (unitBlock.satisfiesRatioMin(this) == false)	// An unsatisfied RatioMin results into an immediate forced Spawn
					{
						// ::logWarning("Force Spawn!");
						unitBlock.spawnUnit(this);
						ratioSpawn = true;
						break;
					}

					// Weighted-Spawns: Every UnitBlock that doesn't surpass their RatioMax if they got the next spawn compete against each other for a random spawn
					local totalCount = ::Math.max(this.getTotal() + 1, this.getParty().getHardMin());
					local weight = unitBlock.m.RatioMax - (this.getBlockTotal(unitBlock.getID()) / totalCount.tofloat());
					if (weight <= 0)
					{
						if (this.getTotal() >= this.getIdealSize() * (1.0 + 1.0 - this.getParty().getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
						else weight = 0.00000001;
					}
					spawnAffordableBlocks.add(unitBlock, weight);
				}

				if (this.getTotal() >= this.getIdealSize() && unitBlock.canUpgrade(this))
				{
					local upgradeWeight = unitBlock.getUpgradeWeight(this) ;
					upgradeAffordableBlocks.add(unitBlock, upgradeWeight);	// Weight = maximum amount of times this block can currently upgrade troops (favors blocks with many tiers)
				}
			}
			if (ratioSpawn) continue;

			if (spawnAffordableBlocks.len() == 0 && upgradeAffordableBlocks.len() == 0) break;	// Usually happens after ratioSpawn happened

			if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging )
			{
				if (spawnAffordableBlocks.len() > 0)
				{
					local str = "spawnAffordableBlocks: ";
					spawnAffordableBlocks.apply(function(_unitBlock, _weight) {
						str += _unitBlock.getID() + " (" + _weight + "), ";
						return _weight;
					});
					::logWarning(str.slice(0, -2));
				}

				if (upgradeAffordableBlocks.len() > 0)
				{
					local str = "upgradeAffordableBlocks: ";
					upgradeAffordableBlocks.apply(function(_unitBlock, _weight) {
						str += _unitBlock.getID() + " (" + _weight + "), ";
						return _weight;
					});
					::logWarning(str.slice(0, -2) + "\n");
				}
			}

			if (upgradeAffordableBlocks.len() > 0 && ::MSU.Math.randf( 0.0, 1.0 ) < (this.getParty().getUpgradeChance() * this.getTotal() / this.getIdealSize()))
			{
				// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local unitBlock = upgradeAffordableBlocks.roll();
				if (unitBlock != null)
				{
					unitBlock.upgradeUnit(this);
				}
				else if (spawnAffordableBlocks.len() == 0) break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local unitBlock = spawnAffordableBlocks.roll();
				if (unitBlock != null)
				{
					unitBlock.spawnUnit(this);
				}
				else if (upgradeAffordableBlocks.len() == 0) break;
			}
		}

		if (!::DynamicSpawns.Const.Benchmark) this.printLog();

		ret.extend(this.getUnits());

		// Spawn SubParties
		for (local i = ret.len() - 1; i >= 0; i--)		// Backwards counting as this array is growing during this process
		{
			if (ret[i].getSubPartyDef().len() == 0) continue;

			this.printPartyHeader(ret[i].getSubPartyDef().ID, ret[i].getEntityType());
			local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);

			local originalParty = ::DynamicSpawns.Parties.LookupMap[ret[i].getSubPartyDef().ID];	// Only the original Party can create clones because clones do not have Defs
			ret.extend(spawnProcess.init(originalParty).spawn());
		}

		this.getParty().updateFigure(this);
		return ret;
    }

	function getIdealSize()
	{
		return this.m.IdealSize;
	}

	function getResources()
	{
		return this.m.Resources;
	}

	function getStartingResources()
	{
		return this.m.StartingResources;
	}

	function getParty()
	{
		return this.m.Party;
	}

	function getPlayerStrength()
	{
		return this.m.PlayerStrength;
	}

	function consumeResources( _amount )
	{
		this.m.Resources -= _amount;
	}

	function isIgnoringCost()
	{
		return (this.getTotal() < this.getParty().getHardMin());
	}

	function getTotal()
	{
		return this.m.UnitCount;
	}

	function getBlockTotal( _unitBlockID )
	{
		return this.m.SpawnInfo[_unitBlockID].Total;
	}

	function getUnitCount( _unitID, _unitBlockID = null )
	{
		if (_unitBlockID != null) return this.m.SpawnInfo[_unitBlockID][_unitID];

		local count = 0;
		foreach (block in this.m.SpawnInfo)
		{
			if (_unitID in block) count += block[_unitID];
		}

		return count;
	}

	function getUnits( _unitBlockID = null )
	{
		local units = [];
		foreach (blockID, block in this.m.SpawnInfo)
		{
			if (_unitBlockID != null && blockID != _unitBlockID) continue;	// skip all blocks that I don't want (optional)
			foreach (unitID, count in block)
			{
				if (unitID == "Total") continue;
				for (local i = 0; i < count; i++)
				{
					units.push(::DynamicSpawns.Units.findById(unitID));
				}
			}
		}
		return units;
	}

	function incrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.m.SpawnInfo[_unitBlockID][_unitID] += _count;
		this.m.SpawnInfo[_unitBlockID].Total += _count;
		this.m.UnitCount += _count;
	}

	function decrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.m.SpawnInfo[_unitBlockID][_unitID] -= _count;
		this.m.SpawnInfo[_unitBlockID].Total -= _count;
		this.m.UnitCount -= _count;
	}

	// Returns 'True' if we should keep doing another spawn/upgrade cycle in this spawn_process
	function canDoAnotherCycle()
	{
		if (this.getTotal() < this.getParty().getHardMin()) return true;	// If the HardMin is not yet reached we ignore all other conditions
		return this.getResources() > 0;		// Currently the only real condition here is whether we still have resources to spend
	}

	// Logging
	function printPartyHeader( _partyName, _vip = "" )
	{
		if (::DynamicSpawns.Const.Benchmark) return;
		local text = "====== Spawning the Party '" + _partyName + "'";
		if (_vip != "") text += " for '" + _vip + "'";
		text += " ======";
		::logWarning(text);
	}

	function printLog()
	{
		// ::logWarning( this.getTotal() + " total unit were spawned for the party " + this.getParty().getID());
		// ::logWarning("- - - Spawn finished - - -");
		::logInfo("Resources remaining: " + this.getResources());
		local printBlock = function( _blockID )
		{
			local percentage = (this.getTotal() == 0) ? 0 : (100 * this.m.SpawnInfo[_blockID].Total / this.getTotal());
			local str = (_blockID.find("Static") != null ? "Static" : _blockID) + ": " + this.m.SpawnInfo[_blockID].Total + " (" + percentage + "%) - ";
			foreach (unit in ::DynamicSpawns.UnitBlocks.findById(_blockID).getUnits())
			{
				str += unit.getEntityType() + ": " + this.m.SpawnInfo[_blockID][unit.getID()] + ", ";
			}

			::logInfo(str.slice(0, -2));
		}

		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			printBlock(unitBlock.getID());
		}

		// Hardcoded Print for StaticUnits
		if ("StaticUnits" in this.m.SpawnInfo)
		{
			local percentage = (this.getTotal() == 0) ? 0 : (100 * this.getBlockTotal("StaticUnits") / this.getTotal());
			local staticString = "Static: " + this.getBlockTotal("StaticUnits") + " (" + percentage + "%) - ";
			foreach (key, value in this.m.SpawnInfo["StaticUnits"])
			{
				if (key == "Total") continue;
				if (value == 0) continue;
				staticString += key + ": " + value + ", ";
			}
			::logInfo(staticString.slice(0, -2));
		}

		::logInfo("Total Units: " + this.getTotal());
		::logInfo("\n");
	}
});
