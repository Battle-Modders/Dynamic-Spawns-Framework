// "Class" that manages the dynamic spawning given a Party-Class and additional variables
this.spawn_process <- {
	m = {
        SpawnInfo = {},     // Array of Arrays. For each UnitBlock and for each spawned troop from that Block
        UnitCount = 0,      // Amount of units spawned during this process. This does not include Guards
		Resources = 0		// Available resources during this run
	}

    function create()
    {
    }

    function init(_party)
    {
		this.m.SpawnInfo = {};
		this.m.UnitCount = 0;
		this.m.Resources = 0;
		foreach (block in _party.getUnitBlocks())
		{
			this.m.SpawnInfo[block.ID] <- {
				Total = 0,
				Maxxed = 0
			};

			foreach (unit in ::DSS.UnitBlocks.findById(block.ID).getUnits())
			{
				this.m.SpawnInfo[block.ID][unit.getID()] <- 0;
			}
		}
    }

    function spawn(_party, _availableResources = 0, _idealSize = -1, _customHardMin = -1, _customHardMax = -1 )
    {
		this.init(_party);
		if(_customHardMin != -1) _party.m.HardMin = _customHardMin;	// Proof of Concept. We cant just overwrite the HardMins of our Data sets with these tempory onces
		if(_customHardMax != -1) _party.m.HardMax = _customHardMax;
		if(_idealSize == -1) _idealSize = ::Math.max(_party.getHardMin(), _party.getHardMax());
		if(_idealSize == 0) _idealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here
        this.m.Resources = _availableResources;
        local playerStrength = 100;     // Placeholder. This needs to be passed as argument or taken from global variable/function
		foreach (block in _party.m.UnitBlocks)
		{
			::DSS.UnitBlocks.findById(block.ID).onPartySpawnStart();
		}

		local ret = [];

        // Spawn static troops
		local budget = this.getResources();
		/*if (_party.m.StaticUnits != null)
		{
			foreach (unit in _party.getStaticUnitBlock().getUnits())
			{
				if (unit.canSpawn(playerStrength, budget))
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
			budget = (this.getTotal() < _party.getHardMin()) ? -1 : this.getResources();		// While HardMin is not reached: budget is infinite (= -1)
			spawnAffordableBlocks.clear();
			upgradeAffordableBlocks.clear();

			if(_party.canSpawn(this.getTotal() + 1))	// Checks against HardMax of the Party
			{
				// Ratio-Spawns: If a UnitBlock doesn't satisfy their PartMin yet then they will spawn a troop deterministically
				local ratioSpawn = false;			
				foreach (pBlock in _party.m.UnitBlocks)		// A pBlock (partyUnitBlock) contains a unitBlock ID and sometimes optional parameter
				{
					local unitBlock = ::DSS.UnitBlocks.findById(pBlock.ID);
					if (unitBlock.canSpawn(this.getTotal(), playerStrength, budget) == false) continue;
					if (_party.isWithinPartMax(this.getBlockTotal(pBlock.ID), this.getTotal() + 1, pBlock) == false) continue;
					if (_party.satisfiesPartMin(this.getBlockTotal(pBlock.ID), this.getTotal() + 1, pBlock) == true) continue;
	
					unitBlock.spawnUnit(this, playerStrength, budget);
					ratioSpawn = true;
					break;
				}
				if (ratioSpawn) continue;
	
				// Weighted-Spawns: Every UnitBlock that doesn't surpass their PartMax compete against each other for a random spawn
				foreach (pBlock in _party.m.UnitBlocks)		// A pBlock (partyUnitBlock) contains a unitBlock ID and sometimes optional parameter
				{
					local unitBlock = ::DSS.UnitBlocks.findById(pBlock.ID);	// @Darxo
					// if (unitBlock.IsStatic) continue;	// @Darxo: I don't understand this variables use
	
					if (unitBlock.canSpawn(this.getTotal(), playerStrength, budget))
					{
						if (_party.isWithinPartMax( this.getBlockTotal(pBlock.ID), this.getTotal() + 1, pBlock) == false) continue;
	
						local totalCount = ::Math.max(this.getTotal() + 1, _party.getHardMin());
						local weight = _party.getPartMax(pBlock) - (this.getBlockTotal(pBlock.ID) / totalCount.tofloat());
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
				local unitBlock = ::DSS.UnitBlocks.findById(pBlock.ID);	// @Darxo
				// if (unitBlock.IsStatic) continue;	// @Darxo: I don't understand this variables use
		
				if (this.getTotal() >= _idealSize && unitBlock.canUpgrade(this.m.SpawnInfo, playerStrength, budget))
				{
					local upgradeWeight = unitBlock.genUpgradeWeight(this.getUnits(unitBlock.getID())) ;
					upgradeAffordableBlocks.add(pBlock.ID, upgradeWeight);	// Weight = maximum amount of times this block can currently upgrade troops (favors blocks with many tiers)
				}
			}

			if (spawnAffordableBlocks.len() == 0 && upgradeAffordableBlocks.len() == 0) break;

			if (!::DSS.Const.Benchmark && ::DSS.Const.DetailedLogging )
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

			if (upgradeAffordableBlocks.len() > 0 && ::DSS.Const.randfloat(1.0) < (_party.getUpgradeChance() * this.getTotal() / _idealSize))
			{
				// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local blockID = upgradeAffordableBlocks.roll();				
				if (blockID != null) 
				{
					::DSS.UnitBlocks.findById(blockID).upgradeUnit( this, playerStrength, budget );
				}
				else if (spawnAffordableBlocks.len() == 0) break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local blockID = spawnAffordableBlocks.roll();				
				if (blockID != null) 
				{
					::DSS.UnitBlocks.findById(blockID).spawnUnit(this, playerStrength, budget);
				}
				else if (upgradeAffordableBlocks.len() == 0) break;
			}
		}

		if (!::DSS.Const.Benchmark) this.printLog(_party);

		ret.extend(this.getUnits());

		local spawnProcess = ::new(::DSS.Class.SpawnProcess);
		for (local i = ret.len() - 1; i >= 0; i--)		// Weird that you count backwards here. Parties are now spawned in reverse order to how they their masters are listed. - Darxo
		{
			if (ret[i].getParty() != null)
			{
				this.printPartyHeader(ret[i].getParty(), ret[i].getEntityType());
				ret.extend(spawnProcess.spawn(::DSS.Parties.findById(ret[i].getParty())));	
			}
		}

		return ret;
    }

	function getResources()
	{
		return this.m.Resources;
	}

	function consumeResources( _amount )
	{
		this.m.Resources -= _amount;
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

	function getUnits(_unitBlockID = null)
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
					units.push(::DSS.UnitBlocks.findById(blockID).getUnit(unitID));
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

	function canGenerate(_party)	// "Generate" in this context means either spawn or upgrade which is why this is a very broad check
	{
		if(this.getTotal() < _party.getHardMin()) return true;
		return this.getResources() > 0;
	}

	// Logging
	function printPartyHeader( _partyName, _vip = "" )
	{
		if (::DSS.Const.Benchmark) return;
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
			local str = (_blockID.find("Static") != null ? "Static" : _blockID) + ": " + this.m.SpawnInfo[_blockID].Total + " (" + (100 * this.m.SpawnInfo[_blockID].Total / this.getTotal()) + "%) - ";			
			foreach (unit in ::DSS.UnitBlocks.findById(_blockID).getUnits())
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