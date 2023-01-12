// "Class" that manages the dynamic spawning given a Party-Class and additional variables
this.spawn_process <- {
	m = {
        SpawnInfo = {},     // Array of Arrays. For each UnitBlock and for each spawned units from that Block
        UnitCount = 0,      // Amount of units spawned during this process. This does not include Guards
		Resources = 0,		// Available resources during this run
		Party = null,		// Reference to the party that is currently used for spawning
		PlayerStrength = 0		// Strength of the Playerparty
	}

    function create()
    {
    }

    function init(_party)
    {
		this.m.SpawnInfo = {};
		this.m.UnitCount = 0;
		this.m.Resources = 0;
		this.m.Party = _party;
		foreach (block in _party.getUnitBlocks())
		{
			this.m.SpawnInfo[block.ID] <- {
				Total = 0
			};

			foreach (unit in ::DSF.UnitBlocks.findById(block.ID).getUnits())
			{
				this.m.SpawnInfo[block.ID][unit.getID()] <- 0;
			}
		}
    }

    function spawn( _party, _availableResources = 0, _idealSize = -1, _customHardMin = -1, _customHardMax = -1 )
    {
		this.init(_party);
		if (_customHardMin != -1) _party.m.HardMin = _customHardMin;	// Proof of Concept. We cant just overwrite the HardMins of our Data sets with these tempory onces
		if (_customHardMax != -1) _party.m.HardMax = _customHardMax;
		if (_idealSize == -1) _idealSize = ::Math.max(_party.getHardMin(), _party.getHardMax());
		if (_idealSize == 0) _idealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here
        this.m.Resources = _availableResources;
        this.m.PlayerStrength = 100;     // Placeholder. This needs to be passed as argument or taken from global variable/function
		foreach (block in _party.m.UnitBlocks)
		{
			::DSF.UnitBlocks.findById(block.ID).onPartySpawnStart();
		}

		local ret = [];

        // Spawn static units
		/*if (_party.m.StaticUnits != null)
		{
			foreach (unit in _party.getStaticUnitBlock().getUnits())
			{
				if (unit.canSpawn(this.getPlayerStrength(), budget))
				{
					this.incrementUnit(unit.getID(), _party.getStaticUnitBlock().getID());
					this.consumeResources(unit.getCost());
				}
			}
		}*/

		local spawnAffordableBlocks = ::MSU.Class.WeightedContainer();
		local upgradeAffordableBlocks = ::MSU.Class.WeightedContainer();

		// Every while spawns or upgrades only one unit
		while (this.canGenerate(_party))	// Is True while Resources are positive and HardMin is respected
		{
			spawnAffordableBlocks.clear();
			upgradeAffordableBlocks.clear();

			if (_party.canSpawn(this))	// Checks against HardMax of the Party
			{
				// Ratio-Spawns: If a UnitBlock doesn't satisfy their RatioMin yet then they will spawn a troop deterministically
				local ratioSpawn = false;
				foreach (pBlock in _party.m.UnitBlocks)		// A pBlock (partyUnitBlock) contains a unitBlock ID and sometimes optional parameter
				{
					local unitBlock = ::DSF.UnitBlocks.findById(pBlock.ID);
					if (unitBlock.canSpawn(this) == false) continue;
					if (_party.isWithinRatioMax(this, pBlock) == false) continue;
					if (_party.satisfiesRatioMin(this, pBlock) == true) continue;

					unitBlock.spawnUnit(this);
					ratioSpawn = true;
					break;
				}
				if (ratioSpawn) continue;

				// Weighted-Spawns: Every UnitBlock that doesn't surpass their RatioMax compete against each other for a random spawn
				foreach (pBlock in _party.m.UnitBlocks)		// A pBlock (partyUnitBlock) contains a unitBlock ID and sometimes optional parameter
				{
					local unitBlock = ::DSF.UnitBlocks.findById(pBlock.ID);	// @Darxo
					// if (unitBlock.IsStatic) continue;	// @Darxo: I don't understand this variables use

					if (unitBlock.canSpawn(this))
					{
						if (_party.isWithinRatioMax(this, pBlock) == false) continue;

						local totalCount = ::Math.max(this.getTotal() + 1, _party.getHardMin());
						local weight = _party.getRatioMax(pBlock) - (this.getBlockTotal(pBlock.ID) / totalCount.tofloat());
						if (weight <= 0)
						{
							if (this.getTotal() + 1 > _idealSize * (1.0 + 1.0 - _party.getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
							else weight = 0.00000001;
						}
						spawnAffordableBlocks.add(pBlock.ID, weight);
					}
				}
			}

			// Weighted-Upgrades: Every UnitBlock that has upgradeable units competes against each other for a random upgrade
			foreach (pBlock in _party.m.UnitBlocks)		// A pBlock (partyUnitBlock) contains a unitBlock ID and sometimes optional parameter
			{
				local unitBlock = ::DSF.UnitBlocks.findById(pBlock.ID);	// @Darxo
				// if (unitBlock.IsStatic) continue;	// @Darxo: I don't understand this variables use

				if (this.getTotal() >= _idealSize && unitBlock.canUpgrade(this))
				{
					local upgradeWeight = unitBlock.getUpgradeWeight(this) ;
					upgradeAffordableBlocks.add(pBlock.ID, upgradeWeight);	// Weight = maximum amount of times this block can currently upgrade troops (favors blocks with many tiers)
				}
			}

			if (spawnAffordableBlocks.len() == 0 && upgradeAffordableBlocks.len() == 0) break;

			if (!::DSF.Const.Benchmark && ::DSF.Const.DetailedLogging )
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

			if (upgradeAffordableBlocks.len() > 0 && ::MSU.Math.randf( 0.0, 1.0 ) < (_party.getUpgradeChance() * this.getTotal() / _idealSize))
			{
				// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local blockID = upgradeAffordableBlocks.roll();
				if (blockID != null)
				{
					::DSF.UnitBlocks.findById(blockID).upgradeUnit(this);
				}
				else if (spawnAffordableBlocks.len() == 0) break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local blockID = spawnAffordableBlocks.roll();
				if (blockID != null)
				{
					::DSF.UnitBlocks.findById(blockID).spawnUnit(this);
				}
				else if (upgradeAffordableBlocks.len() == 0) break;
			}
		}

		if (!::DSF.Const.Benchmark) this.printLog(_party);

		ret.extend(this.getUnits());

		local spawnProcess = ::new(::DSF.Class.SpawnProcess);
		for (local i = ret.len() - 1; i >= 0; i--)		// Backwards counting as this array is growing during this process
		{
			if (ret[i].getParty() != null)
			{
				this.printPartyHeader(ret[i].getParty(), ret[i].getEntityType());
				ret.extend(spawnProcess.spawn(::DSF.Parties.findById(ret[i].getParty())));
			}
		}

		return ret;
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
		if (this.getTotal() < this.getParty().getHardMin()) return true;
		return false;
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
			if(_unitBlockID != null && blockID != _unitBlockID) continue;	// skip all blocks that I don't want (optional)
			foreach (unitID, count in block)
			{
				if (unitID == "Total") continue;
				for (local i = 0; i < count; i++)
				{
					units.push(::DSF.UnitBlocks.findById(blockID).getUnit(unitID));
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

	function canGenerate( _party )	// "Generate" in this context means either spawn or upgrade which is why this is a very broad check
	{
		if(this.getTotal() < _party.getHardMin()) return true;
		return this.getResources() > 0;
	}

	// Logging
	function printPartyHeader( _partyName, _vip = "" )
	{
		if (::DSF.Const.Benchmark) return;
		local text = "====== Spawning the Party '" + _partyName + "'";
		if(_vip != "") text += " for '" + _vip + "'";
		text += " ======";
		::logWarning(text);
	}

	function printLog( _party )
	{
		// ::logWarning( this.getTotal() + " total unit were spawned for the party " + _party.getID());
		// ::logWarning("- - - Spawn finished - - -");
		::logInfo("Resources remaining: " + this.getResources());
		local printBlock = function( _blockID )
		{
			local percentage = (this.getTotal() == 0) ? 0 : (100 * this.m.SpawnInfo[_blockID].Total / this.getTotal());
			local str = (_blockID.find("Static") != null ? "Static" : _blockID) + ": " + this.m.SpawnInfo[_blockID].Total + " (" + percentage + "%) - ";
			foreach (unit in ::DSF.UnitBlocks.findById(_blockID).getUnits())
			{
				str += unit.getEntityType() + ": " + this.m.SpawnInfo[_blockID][unit.getID()] + ", ";
			}

			::logInfo(str.slice(0, -2));
		}
		foreach (block in _party.getUnitBlocks())
		{
			printBlock(block.ID);
		}
		::logInfo("Total Units: " + this.getTotal());
		::logInfo("\n");
	}
};
