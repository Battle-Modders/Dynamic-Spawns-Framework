// "Class" that manages the dynamic spawning given a Party-Class and additional variables
this.spawn_process <- {
	m = {
        SpawnInfo = {},     // Table of Tables. For each UnitBlock and for each spawned units from that Block
        UnitCount = 0,      // Amount of units spawned during this process. This does not include SubParties

		Party = null,		// Weak Reference to the party that is currently used for spawning
		Resources = 0,		// Available resources during this run
		IdealSize = -1,

		CustomHardMin = -1,
		CustomHardMax = -1,

		PlayerStrength = 0		// Strength of the Playerparty
	}

    function create()
    {
    }

    function init( _party, _availableResources = 0, _opposingParty = null, _customHardMin = -1, _customHardMax = -1 )
    {
		this.m.SpawnInfo = {};
		this.m.UnitCount = 0;

		this.m.Party = _party.weakref();
		this.m.Resources = _availableResources;
		this.m.IdealSize = _party.generateIdealSize();
		this.m.CustomHardMin = _customHardMin;
		this.m.CustomHardMax = _customHardMax;

		foreach (staticUnit in _party.getStaticUnits())
		{
			this.m.SpawnInfo["StaticUnits"] <- {	// HardCoded entry just for static units
				Total = 0
			};
			this.m.SpawnInfo["StaticUnits"][staticUnit.getID()] <- 0;
		}

		foreach (block in _party.getUnitBlocks())
		{
			this.m.SpawnInfo[block.ID] <- {
				Total = 0
			};

			foreach (unit in ::DynamicSpawns.UnitBlocks.findById(block.ID).getUnits())
			{
				this.m.SpawnInfo[block.ID][unit.getID()] <- 0;
			}
		}
		return this;
    }

    function spawn()
    {
		// Temporary overwrite Party Variables; Proof of Concept. We cant just overwrite the HardMins of our Data sets with these tempory onces. Otherwise we change other spawns in the game
		local oldHardMin = this.getParty().getHardMin();
		if (this.m.CustomHardMin != -1) this.getParty().m.HardMin = this.m.CustomHardMin;
		local oldHardMax = this.getParty().getHardMax();
		if (this.m.CustomHardMax != -1) this.getParty().m.HardMin = this.m.CustomHardMax;

		if (this.getIdealSize() == -1) this.m.IdealSize = ::Math.max(this.getParty().getHardMin(), this.getParty().getHardMax());
		if (this.getIdealSize() == 0) this.m.IdealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here

        this.m.PlayerStrength = 100;     // Placeholder. This needs to be passed as argument or taken from global variable/function
		foreach (block in this.getParty().m.UnitBlocks)
		{
			::DynamicSpawns.UnitBlocks.findById(block.ID).onPartySpawnStart();
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
		while (this.canGenerate())	// Is True while Resources are positive and HardMin is respected
		{
			spawnAffordableBlocks.clear();
			upgradeAffordableBlocks.clear();

			local ratioSpawn = false;
			foreach (pBlock in this.getParty().m.UnitBlocks)		// A pBlock (partyUnitBlock) contains a unitBlock ID and sometimes optional parameter
			{
				local unitBlock = ::DynamicSpawns.UnitBlocks.findById(pBlock.ID);

				if (this.getParty().canSpawn(this) && unitBlock.canSpawn(this) && this.getParty().isWithinRatioMax(this, pBlock))
				{
					// Ratio-Spawns: If a UnitBlock doesn't satisfy their RatioMin yet then they will spawn a troop deterministically
					if (this.getParty().satisfiesRatioMin(this, pBlock) == false)
					{
						unitBlock.spawnUnit(this);
						ratioSpawn = true;
						break;
					}

					// Weighted-Spawns: Every UnitBlock that doesn't surpass their RatioMax compete against each other for a random spawn
					local totalCount = ::Math.max(this.getTotal() + 1, this.getParty().getHardMin());
					local weight = pBlock.RatioMax - (this.getBlockTotal(pBlock.ID) / totalCount.tofloat());
					if (weight <= 0)
					{
						if (this.getTotal() >= this.getIdealSize() * (1.0 + 1.0 - this.getParty().getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
						else weight = 0.00000001;
					}
					spawnAffordableBlocks.add(pBlock.ID, weight);
				}

				if (this.getTotal() >= this.getIdealSize() && unitBlock.canUpgrade(this))
				{
					local upgradeWeight = unitBlock.getUpgradeWeight(this) ;
					upgradeAffordableBlocks.add(pBlock.ID, upgradeWeight);	// Weight = maximum amount of times this block can currently upgrade troops (favors blocks with many tiers)
				}
			}
			if (ratioSpawn) continue;

			if (spawnAffordableBlocks.len() == 0 && upgradeAffordableBlocks.len() == 0) break;	// Usually happens after ratioSpawn happened

			if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging )
			{
				if (spawnAffordableBlocks.len() > 0)
				{
					local str = "spawnAffordableBlocks: ";
					spawnAffordableBlocks.apply(function(_id, _weight) {
						str += _id + " (" + _weight + "), ";
						return _weight;
					});
					::logWarning(str.slice(0, -2));
				}

				if (upgradeAffordableBlocks.len() > 0)
				{
					local str = "upgradeAffordableBlocks: ";
					upgradeAffordableBlocks.apply(function(_id, _weight) {
						str += _id + " (" + _weight + "), ";
						return _weight;
					});
					::logWarning(str.slice(0, -2) + "\n");
				}
			}

			if (upgradeAffordableBlocks.len() > 0 && ::MSU.Math.randf( 0.0, 1.0 ) < (this.getParty().getUpgradeChance() * this.getTotal() / this.getIdealSize()))
			{
				// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local blockID = upgradeAffordableBlocks.roll();
				if (blockID != null)
				{
					::DynamicSpawns.UnitBlocks.findById(blockID).upgradeUnit(this);
				}
				else if (spawnAffordableBlocks.len() == 0) break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local blockID = spawnAffordableBlocks.roll();
				if (blockID != null)
				{
					::DynamicSpawns.UnitBlocks.findById(blockID).spawnUnit(this);
				}
				else if (upgradeAffordableBlocks.len() == 0) break;
			}
		}

		if (!::DynamicSpawns.Const.Benchmark) this.printLog();

		ret.extend(this.getUnits());

		// Fix the overwritten Variables to their original values
		this.getParty().m.HardMin = oldHardMin;
		this.getParty().m.HardMax = oldHardMax;

		// Spawn SubParties
		local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
		for (local i = ret.len() - 1; i >= 0; i--)		// Backwards counting as this array is growing during this process
		{
			if (ret[i].getSubParty() != null)
			{
				this.printPartyHeader(ret[i].getSubParty(), ret[i].getEntityType());
				ret.extend(spawnProcess.init(::DynamicSpawns.Parties.findById(ret[i].getSubParty())).spawn());
			}
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

	function canGenerate()	// "Generate" in this context means either spawn or upgrade which is why this is a very broad check
	{
		if (this.getTotal() < this.getParty().getHardMin()) return true;
		return this.getResources() > 0;
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
		foreach (block in this.getParty().getUnitBlocks())
		{
			printBlock(block.ID);
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
};
