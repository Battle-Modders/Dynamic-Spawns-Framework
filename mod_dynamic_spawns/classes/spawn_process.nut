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

	__SpawnAffordableBlocks = null;
	__UpgradeAffordableBlocks = null;
	__SubSpawnProcesses = null;
	__MainSpawnProcess = null;

	constructor( _partyDef, _availableResources = -1, _isLocation = false, _customHardMin = null, _customHardMax = null )
	{
		this.SpawnInfo = {};
		this.UnitCount = 0;

		this.Resources = 0;
		this.StartingResources = 0;
		this.IdealSize = 6;

		this.__SpawnAffordableBlocks = ::MSU.Class.WeightedContainer();
		this.__UpgradeAffordableBlocks = ::MSU.Class.WeightedContainer();
		this.__SubSpawnProcesses = {};

		this.Party = typeof _partyDef == "table" ? ::DynamicSpawns.__getObjectFromDef(_partyDef, ::DynamicSpawns.Parties) : _partyDef;

		if (_customHardMin != null) this.Party.HardMin = _customHardMin;
		if (_customHardMax != null) this.Party.HardMax = _customHardMax;

		this.StartingResources = (_availableResources == -1) ? this.getParty().DefaultResources : _availableResources;
		this.Resources = this.StartingResources;

		this.IdealSize = this.getParty().generateIdealSize(this, _isLocation);	// Locations currently have a 50% higher IdealSize compared to roaming parties
		if (this.getIdealSize() <= 0) this.IdealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here

		foreach (subparty in this.getParty().getSubParties())
		{
			local subSpawnProcess = ::DynamicSpawns.Class.SpawnProcess(subparty, this.Resources);
			this.__SubSpawnProcesses[subparty.getID()] <- subSpawnProcess;
			subSpawnProcess.__MainSpawnProcess = this.weakref();
		}

		// Initialize SpawnInfo
		this.SpawnInfo["StaticUnits"] <- {	// HardCoded entry just for static units
			Total = 0,
			Units = {}
		};
		foreach (staticUnit in this.getParty().getStaticUnits())
		{
			this.SpawnInfo["StaticUnits"].Units[staticUnit.getID()] <- {
				Unit = staticUnit,
				Count = 0
			};
		}

		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			this.SpawnInfo[unitBlock.getID()] <- {
				UnitBlock = unitBlock,
				Total = 0,
				Units = {}
			};

			foreach (unit in unitBlock.getUnits())
			{
				this.SpawnInfo[unitBlock.getID()].Units[unit.getID()] <- {
					Unit = unit,
					Count = 0
				};
			}
		}

		return this;
	}

	function getCategoryTotal( _id )
	{
		return this.__SubSpawnProcesses[_id].getTotal();
	}

	function doSubSpawnCycle( _force = false )
	{
		this.__SpawnAffordableBlocks.clear();
		this.__UpgradeAffordableBlocks.clear();

		local ratioSpawn = false;	// A ratioSpawn is a forced spawn for a block because its RatioMin is not satisfied anymore
		foreach (subParty in this.getParty().getSubParties())
		{
			if (_force || subParty.canSpawn(this.__SubSpawnProcesses[subParty.getID()]))
			{
				// ::logWarning("The Category " + subParty.getID() + " is able to spawn!");
				if (subParty.satisfiesRatioMin(this) == false)	// An unsatisfied RatioMin results into an immediate forced Spawn
				{
					// ::logWarning("Force Spawn!");
					this.__SubSpawnProcesses[subParty.getID()].doCycle(true);
					ratioSpawn = true;
					break;
				}

				// Weighted-Spawns: Every UnitBlock that doesn't surpass their RatioMax if they got the next spawn compete against each other for a random spawn
				local totalCount = ::Math.max(this.getTotal() + 1, this.getParty().getHardMin());
				local weight = subParty.RatioMax - (this.getCategoryTotal(subParty.getID()) / totalCount.tofloat());
				if (weight <= 0)
				{
					if (this.getTopPartyTotal() >= this.getIdealSize() * (1.0 + 1.0 - this.getParty().getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
					else weight = 0.00000001;
				}
				this.__SpawnAffordableBlocks.add(subParty, weight);
			}

			if (this.getAboveIdealSize() >= 0 && subParty.canUpgrade(this.__SubSpawnProcesses[subParty.getID()]))
			{
				local upgradeWeight = subParty.getUpgradeWeight(this.__SubSpawnProcesses[subParty.getID()]) ;
				this.__UpgradeAffordableBlocks.add(subParty, upgradeWeight);	// Weight = maximum amount of times this block can currently upgrade troops (favors blocks with many tiers)
			}
		}

		if (ratioSpawn)
			return true;

		if (this.__SpawnAffordableBlocks.len() == 0 && this.__UpgradeAffordableBlocks.len() == 0) // Usually happens after ratioSpawn happened
			return false;

		if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging )
		{
			if (this.__SpawnAffordableBlocks.len() > 0)
			{
				local str = "-- SpawnAffordableCategories: ";
				this.__SpawnAffordableBlocks.apply(function(_unitBlock, _weight) {
					str += _unitBlock.getID() + " (" + _weight + "), ";
					return _weight;
				});
				::logWarning(str.slice(0, -2));
			}

			if (this.__UpgradeAffordableBlocks.len() > 0)
			{
				local str = "-- UpgradeAffordableCategories: ";
				this.__UpgradeAffordableBlocks.apply(function(_unitBlock, _weight) {
					str += _unitBlock.getID() + " (" + _weight + "), ";
					return _weight;
				});
				::logWarning(str.slice(0, -2) + "\n");
			}
		}

		if (this.__UpgradeAffordableBlocks.len() > 0 && (this.__SpawnAffordableBlocks.len() == 0 || ::MSU.Math.randf( 0.0, 1.0 ) < (this.getParty().getUpgradeChance() * this.getTotal() / this.getIdealSize())))
		{
			// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
			local subParty = this.__UpgradeAffordableBlocks.roll();
			if (subParty != null)
			{
				local ret = this.__SubSpawnProcesses[subParty.getID()].doCycle(true);
				if (!ret) ::logInfo(subParty.getID() + ": returned " + ret + " during upgrading");
				return ret;
			}
			else if (this.__SpawnAffordableBlocks.len() == 0)
			{
				return false;
			}
		}
		else if (this.__SpawnAffordableBlocks.len() > 0)
		{
			// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
			local subParty = this.__SpawnAffordableBlocks.roll();
			if (subParty != null)
			{
				local ret = this.__SubSpawnProcesses[subParty.getID()].doCycle(true);
				if (!ret) ::logInfo(subParty.getID() + ": returned " + ret + " during spawning");
				return ret;
			}
			else if (this.__UpgradeAffordableBlocks.len() == 0) return false;
		}
	}

	function getAboveIdealSize()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getAboveIdealSize() : this.getTotal() - this.getIdealSize();
	}

	function getRatioToIdealSize()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getRatioToIdealSize() : this.getTotal().tofloat() / this.getIdealSize();
	}

	function doCycle( _force = false )
	{
		if (this.__SubSpawnProcesses.len() != 0)
			return this.doSubSpawnCycle(_force);

		this.__SpawnAffordableBlocks.clear();
		this.__UpgradeAffordableBlocks.clear();

		local ratioSpawn = false;	// A ratioSpawn is a forced spawn for a block because its RatioMin is not satisfied anymore
		foreach (unitBlock in this.getParty().getUnitBlocks())
		{
			if (_force || (this.getParty().canSpawn(this) && unitBlock.canSpawn(this)))
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
				local weight = unitBlock.RatioMax - (this.getBlockTotal(unitBlock.getID()) / totalCount.tofloat());
				if (weight <= 0)
				{
					if (this.getTopPartyTotal() >= this.getIdealSize() * (1.0 + 1.0 - this.getParty().getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
					else weight = 0.00000001;
				}
				this.__SpawnAffordableBlocks.add(unitBlock, weight);
			}

			if (this.getAboveIdealSize() >= 0 && unitBlock.canUpgrade(this))
			{
				local upgradeWeight = unitBlock.getUpgradeWeight(this) ;
				this.__UpgradeAffordableBlocks.add(unitBlock, upgradeWeight);	// Weight = maximum amount of times this block can currently upgrade troops (favors blocks with many tiers)
			}
		}
		if (ratioSpawn)
			return true;

		if (this.__SpawnAffordableBlocks.len() == 0 && this.__UpgradeAffordableBlocks.len() == 0) // Usually happens after ratioSpawn happened
			return false;

		if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging )
		{
			if (this.__SpawnAffordableBlocks.len() > 0)
			{
				local str = "SpawnAffordableBlocks: ";
				this.__SpawnAffordableBlocks.apply(function(_unitBlock, _weight) {
					str += _unitBlock.getID() + " (" + _weight + "), ";
					return _weight;
				});
				::logWarning(str.slice(0, -2));
			}

			if (this.__UpgradeAffordableBlocks.len() > 0)
			{
				local str = "UpgradeAffordableBlocks: ";
				this.__UpgradeAffordableBlocks.apply(function(_unitBlock, _weight) {
					str += _unitBlock.getID() + " (" + _weight + "), ";
					return _weight;
				});
				::logWarning(str.slice(0, -2) + "\n");
			}
		}

		if (this.__UpgradeAffordableBlocks.len() > 0 && (this.__SpawnAffordableBlocks.len() == 0 || ::MSU.Math.randf( 0.0, 1.0 ) < (this.getParty().getUpgradeChance() * this.getRatioToIdealSize())))
		{
			// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
			local unitBlock = this.__UpgradeAffordableBlocks.roll();
			if (unitBlock != null)
			{
				unitBlock.upgradeUnit(this);
				return true;
			}
			else if (this.__SpawnAffordableBlocks.len() == 0) return false;
		}
		else if (this.__SpawnAffordableBlocks.len() > 0)
		{
			// ::logWarning("Spawn: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
			local unitBlock = this.__SpawnAffordableBlocks.roll();
			if (unitBlock != null)
			{
				unitBlock.spawnUnit(this);
				return true;
			}
			else if (this.__UpgradeAffordableBlocks.len() == 0) return false;
		}
	}

	function spawn()
	{
		// This will remove all unnecessary Unitblocks/Units to improve performance
		this.getParty().onBeforeSpawnStart(this);

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
		// Every while spawns or upgrades only one unit
		while (this.canDoAnotherCycle())	// Is True while Resources are positive or HardMin is not yet reached
		{
			if (!this.getParty().canSpawn(this) && !this.getParty().canUpgrade(this))
				break;

			if (!this.doCycle())
				break;
		}

		if (::DynamicSpawns.Const.Logging) this.printLog();

		ret.extend(this.getUnits());

		foreach (subSpawnProcess in this.__SubSpawnProcesses)
		{
			ret.extend(subSpawnProcess.getUnits());
		}

		// Spawn SubParties
		for (local i = ret.len() - 1; i >= 0; i--)		// Backwards counting as this array is growing during this process
		{
			if (ret[i].getSubPartyDef().len() == 0) continue;	// skip all units that don't have a subparty

			if (::DynamicSpawns.Const.Logging) this.printPartyHeader(ret[i].getSubPartyDef().ID, ret[i].getTroop());

			ret.extend(::DynamicSpawns.Class.SpawnProcess(ret[i].getSubPartyDef()).spawn());
		}

		if (ret.len() == 0)		// This will lead to inconsistent states where parties on the world map have 0 troops in them and must be fixed as fast as possible
		{
			::logError("The Party with the ID '" + this.getParty().getID() + "' and " + this.getStartingResources() + "' Resources was not able to spawn even a single unit!");
		}

		return ret;
	}

	function getIdealSize()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getIdealSize() : this.IdealSize;
	}

	function getResources()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getResources() : this.Resources;
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
		if (this.__MainSpawnProcess != null)
			this.__MainSpawnProcess.consumeResources(_amount);
		else
			this.Resources -= _amount;
	}

	function isIgnoringCost()
	{
		return (this.getTotal() < this.getParty().getHardMin());
	}

	function getTopPartyTotal()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getTopPartyTotal() : this.getTotal();
	}

	function getTotal()
	{
		local ret = this.UnitCount;
		foreach (subSpawnProcess in this.__SubSpawnProcesses)
		{
			ret += subSpawnProcess.getTotal();
		}
		return ret;
	}

	function getBlockTotal( _unitBlockID )
	{
		return this.SpawnInfo[_unitBlockID].Total;
	}

	function getUnitCount( _unitID, _unitBlockID = null )
	{
		if (_unitBlockID != null) return this.SpawnInfo[_unitBlockID].Units[_unitID].Count;

		local count = 0;
		foreach (block in this.SpawnInfo)
		{
			if (_unitID in block.Units) count += block[_unitID].Count;
		}

		return count;
	}

	function getUnits( _unitBlockID = null )
	{
		local units = [];
		foreach (blockID, block in this.SpawnInfo)
		{
			if (_unitBlockID != null && blockID != _unitBlockID) continue;	// skip all blocks that I don't want (optional)
			foreach (unitID, unitInfo in block.Units)
			{
				if (unitID == "Total") continue;
				for (local i = 0; i < unitInfo.Count; i++)
				{
					units.push(unitInfo.Unit);
				}
			}
		}
		return units;
	}

	function incrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.SpawnInfo[_unitBlockID].Units[_unitID].Count += _count;
		this.SpawnInfo[_unitBlockID].Total += _count;
		this.UnitCount += _count;
	}

	function decrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.SpawnInfo[_unitBlockID].Units[_unitID].Count -= _count;
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
		if (this.__MainSpawnProcess == null)
			::logInfo("Party-Name: " + this.getParty().getID() + "; Resources remaining: " + this.getResources());
		else
		{
			::logInfo(format("-- %s: (%f%%)", this.getParty().getID(), 100.0 * this.getTotal() /this.__MainSpawnProcess.getTotal()));
		}

		local printBlock = function( _block )
		{
			local percentage = (this.getTotal() == 0) ? 0 : (100 * this.SpawnInfo[_block.getID()].Total / this.getTotal());
			local str = (_block.getID().find("Static") != null ? "Static" : _block.getID()) + ": " + this.SpawnInfo[_block.getID()].Total + " (" + percentage + "%) - ";
			foreach (unit in _block.getUnits())
			{
				str += unit.getTroop() + ": " + this.SpawnInfo[_block.getID()].Units[unit.getID()].Count + ", ";
			}

			::logInfo(str.slice(0, -2));
		}

		foreach (subSpawnProcess in this.__SubSpawnProcesses)
		{
			subSpawnProcess.printLog();
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
			foreach (unitID, unitInfo in this.SpawnInfo["StaticUnits"].Units)
			{
				if (unitID == "Count") continue;
				if (unitInfo.Count == 0) continue;
				staticString += unitID + ": " + unitInfo.Count + ", ";
			}
			::logInfo(staticString.slice(0, -2));
		}

		::logInfo("Total Units: " + this.getTotal());
		::logInfo("\n");
	}
};
