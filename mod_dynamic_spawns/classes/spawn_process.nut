// "Class" that manages the dynamic spawning given a Party-Class and additional variables
::DynamicSpawns.Class.SpawnProcess <- class
{
// Temporary Variables, They only exist and are valid during one spawning process
	SpawnInfo = null;     // Table of Tables. For each UnitBlock and for each spawned units from that Block
	UnitCount = null;      // Amount of units spawned during this process. This does not include SubParties

	Party = null;		// Cloned Party object, that is used for spawning
	Resources = null;		// Available resources during this run
	StartingResources = null;		// Resource that this spawnProcess started with
	IdealSize = null;

	constructor( _partyDef, _availableResources = -1, _isLocation = false )
	{
		this.SpawnInfo = {};
		this.UnitCount = 0;
		this.Resources = 0;
		this.StartingResources = 0;
		this.IdealSize = 6;

		if (!("ID" in _partyDef))
		{
			::DynamicSpawns.Static.registerParty(_partyDef);
		}

		this.Party = ::DynamicSpawns.Parties.LookupMap[_partyDef.ID].getClone(_partyDef, false);
		this.Party.setSpawnProcess(this);
		this.Party.init();

		this.StartingResources = (_availableResources == -1) ? this.getParty().DefaultResources : _availableResources;
		this.Resources = this.StartingResources;

		this.IdealSize = this.getParty().generateIdealSize(this, _isLocation);	// Locations currently have a 50% higher IdealSize compared to roaming parties
		if (this.getIdealSize() <= 0) this.IdealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here

		// Initialize SpawnInfo
		this.SpawnInfo["StaticUnits"] <- {	// HardCoded entry just for static units
			Total = 0
		};
		foreach (staticUnit in this.getParty().getStaticUnits())
		{
			this.SpawnInfo["StaticUnits"][staticUnit.getID()] <- 0;
		}

		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			this.SpawnInfo[unitBlock.getID()] <- {
				Total = 0
			};

			foreach (unit in unitBlock.getUnits())
			{
				this.SpawnInfo[unitBlock.getID()][unit.getID()] <- 0;
			}
		}
	}

	function spawn()
	{
		::logWarning("=========== spawn() ===========")
		::logInfo(this.getParty().getUnitBlocks().len());
		// This will remove all unnecessary Unitblocks/Units to improve performance
		this.getParty().onBeforeSpawnStart();
		::logInfo(this.getParty().getUnitBlocks().len());

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
				if (this.getParty().canSpawn() && unitBlock.canSpawn())
				{
					// ::logWarning("The Block " + unitBlock.getID() + " is able to spawn!");
					if (unitBlock.satisfiesRatioMin() == false)	// An unsatisfied RatioMin results into an immediate forced Spawn
					{
						// ::logWarning("Force Spawn!");
						unitBlock.spawnUnit();
						ratioSpawn = true;
						break;
					}

					// Weighted-Spawns: Every UnitBlock that doesn't surpass their RatioMax if they got the next spawn compete against each other for a random spawn
					local totalCount = ::Math.max(this.getTotal() + 1, this.getParty().getHardMin());
					local weight = unitBlock.RatioMax - (this.getBlockTotal(unitBlock.getID()) / totalCount.tofloat());
					if (weight <= 0)
					{
						if (this.getTotal() >= this.getIdealSize() * (1.0 + 1.0 - this.getParty().getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
						else weight = 0.00000001;
					}
					spawnAffordableBlocks.add(unitBlock, weight);
				}

				if (this.getTotal() >= this.getIdealSize() && unitBlock.canUpgrade())
				{
					local upgradeWeight = unitBlock.getUpgradeWeight() ;
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
					unitBlock.upgradeUnit();
				}
				else if (spawnAffordableBlocks.len() == 0) break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
				local unitBlock = spawnAffordableBlocks.roll();
				if (unitBlock != null)
				{
					unitBlock.spawnUnit();
				}
				else if (upgradeAffordableBlocks.len() == 0) break;
			}
		}

		if (::DynamicSpawns.Const.Logging) this.printLog();

		ret.extend(this.getUnits());

		// Spawn SubParties
		for (local i = ret.len() - 1; i >= 0; i--)		// Backwards counting as this array is growing during this process
		{
			if (ret[i].getSubPartyDef() == null || ret[i].getSubPartyDef().len() == 0) continue;	// skip all units that don't have a subparty

			if (::DynamicSpawns.Const.Logging) this.printPartyHeader(ret[i].getSubPartyDef().ID, ret[i].getTroop());

			local spawnProcess = ::DynamicSpawns.Class.SpawnProcess(ret[i].getSubPartyDef());
			ret.extend(spawnProcess.spawn());
		}

		if (ret.len() == 0)		// This will lead to inconsistent states where parties on the world map have 0 troops in them and must be fixed as fast as possible
		{
			::logError("The Party with the ID '" + this.getParty().getID() + "' and " + this.getStartingResources() + "' Resources was not able to spawn even a single unit!");
		}

		return ret;
	}

	function getIdealSize()
	{
		return this.IdealSize;
	}

	function getResources()
	{
		return this.Resources;
	}

	function getStartingResources()
	{
		return this.StartingResources;
	}

	function getParty()
	{
		return this.Party;
	}

	function getPlayerStrength()
	{
		if (("State" in ::World) == false) return 100.0;		// fix for when we test this framework in the main menu
		return ::World.State.getPlayer().getStrength();		// This is cleaner but may be a bit inefficient compared to reading this value out once and saving it in a variable
	}

	function getWorldDays()
	{
		return ::World.getTime().Days;
	}

	function consumeResources( _amount )
	{
		this.Resources -= _amount;
	}

	function isIgnoringCost()
	{
		return (this.getTotal() < this.getParty().getHardMin());
	}

	function getTotal()
	{
		return this.UnitCount;
	}

	function getBlockTotal( _unitBlockID )
	{
		return this.SpawnInfo[_unitBlockID].Total;
	}

	function getUnitCount( _unitID, _unitBlockID = null )
	{
		if (_unitBlockID != null) return this.SpawnInfo[_unitBlockID][_unitID];

		local count = 0;
		foreach (block in this.SpawnInfo)
		{
			if (_unitID in block) count += block[_unitID];
		}

		return count;
	}

	function getUnits( _unitBlockID = null )
	{
		local units = [];
		foreach (blockID, block in this.SpawnInfo)
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
		this.SpawnInfo[_unitBlockID][_unitID] += _count;
		this.SpawnInfo[_unitBlockID].Total += _count;
		this.UnitCount += _count;
	}

	function decrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.SpawnInfo[_unitBlockID][_unitID] -= _count;
		this.SpawnInfo[_unitBlockID].Total -= _count;
		this.UnitCount -= _count;
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
		::logInfo("Party-Name: " + this.getParty().getID() + "; Resources remaining: " + this.getResources());
		local printBlock = function( _block )
		{
			local percentage = (this.getTotal() == 0) ? 0 : (100 * this.SpawnInfo[_block.getID()].Total / this.getTotal());
			local str = (_block.getID().find("Static") != null ? "Static" : _block.getID()) + ": " + this.SpawnInfo[_block.getID()].Total + " (" + percentage + "%) - ";
			foreach (unit in _block.getUnits())
			{
				str += unit.getTroop() + ": " + this.SpawnInfo[_block.getID()][unit.getID()] + ", ";
			}

			::logInfo(str.slice(0, -2));
		}

		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			printBlock(unitBlock);
		}

		// Hardcoded Print for StaticUnits
		if ("StaticUnits" in this.SpawnInfo)
		{
			local percentage = (this.getTotal() == 0) ? 0 : (100 * this.getBlockTotal("StaticUnits") / this.getTotal());
			local staticString = "Static: " + this.getBlockTotal("StaticUnits") + " (" + percentage + "%) - ";
			foreach (key, value in this.SpawnInfo["StaticUnits"])
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
