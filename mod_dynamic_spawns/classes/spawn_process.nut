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

	__SpawnAffordables = null;
	__UpgradeAffordables = null;
	__SubSpawnProcesses = null;
	__MainSpawnProcess = null;

	constructor( _partyDef, _availableResources = -1, _isLocation = false, _customHardMin = null, _customHardMax = null )
	{
		this.SpawnInfo = {};
		this.UnitCount = 0;

		this.Resources = 0;
		this.StartingResources = 0;
		this.IdealSize = 6;

		this.__SpawnAffordables = ::MSU.Class.WeightedContainer();
		this.__UpgradeAffordables = ::MSU.Class.WeightedContainer();
		this.__SubSpawnProcesses = {};

		this.Party = typeof _partyDef == "table" ? ::DynamicSpawns.__getObjectFromDef(_partyDef, ::DynamicSpawns.Parties) : _partyDef;
		this.Party.setSpawnProcess(this);

		if (_customHardMin != null) this.Party.HardMin = _customHardMin;
		if (_customHardMax != null) this.Party.HardMax = _customHardMax;

		this.StartingResources = (_availableResources == -1) ? this.getParty().DefaultResources : _availableResources;
		this.Resources = this.StartingResources;

		this.IdealSize = this.getParty().generateIdealSize(this, _isLocation);	// Locations currently have a 50% higher IdealSize compared to roaming parties
		if (this.getIdealSize() <= 0) this.IdealSize = 1;	// To prevent division by zero later on. But realistically you should never have such a low idealSize here

		foreach (subparty in this.getParty().getSubParties())
		{
			local subSpawnProcess = ::DynamicSpawns.Class.SpawnProcess(subparty, this.Resources);			
			subSpawnProcess.__MainSpawnProcess = this.weakref();			
			this.__SubSpawnProcesses[subparty.getID()] <- subSpawnProcess;
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

	function getMainSpawnProcess()
	{
		return this.__MainSpawnProcess;
	}

	function getSubSpawnProcess( _partyID )
	{
		return this.__SubSpawnProcesses[_partyID];
	}

	function getCategoryTotal( _id )
	{
		return this.__SubSpawnProcesses[_id].getTotal();
	}

	function getAboveIdealSize()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getAboveIdealSize() : this.getTotal() - this.getIdealSize();
	}

	function getRatioToIdealSize()
	{
		return this.__MainSpawnProcess != null ? this.__MainSpawnProcess.getRatioToIdealSize() : this.getTotal().tofloat() / this.getIdealSize();
	}

	function getSpawnables()
	{
		return this.__SubSpawnProcesses.len() == 0 ? this.getParty().getUnitBlocks() : this.getParty().getSubParties();
	}

	function getSpawnable( _id )
	{
		local spawnables = this.__SubSpawnProcesses.len() == 0 ? this.getParty().getUnitBlocks() : this.getParty().getSubParties();
		foreach (spawnable in spawnables)
		{
			if (spawnable.getID() == _id)
				return spawnable;
		}
	}

	function getSpawnableTotal( _id )
	{
		return this.__SubSpawnProcesses.len() == 0 ? this.getBlockTotal(_id) : this.getCategoryTotal(_id);
	}

	function doCycle( _forceSpawn = false, _forceUpgrade = false )
	{
		this.__SpawnAffordables.clear();
		this.__UpgradeAffordables.clear();

		foreach (spawnable in this.getSpawnables())
		{
			if (!_forceUpgrade && (_forceSpawn || spawnable.canSpawn()))
			{
				if (spawnable.satisfiesRatioMin() == false)
				{
					spawnable.doCycle(true);
					return true;
				}

				// Weighted-Spawns: Every Spawnable that doesn't surpass their RatioMax if they got the next spawn compete against each other for a random spawn
				local totalCount = ::Math.max(this.getTotal() + 1, this.getParty().getHardMin());
				local weight = spawnable.RatioMax - (this.getSpawnableTotal(spawnable.getID()) / totalCount.tofloat());
				if (weight <= 0)
				{
					if (this.getTopPartyTotal() >= this.getIdealSize() * (1.0 + 1.0 - this.getParty().getUpgradeChance())) weight = 0; // TODO: Improve the logic on this line
					else weight = 0.00000001;
				}
				this.__SpawnAffordables.add(spawnable, weight);
			}

			if (!_forceSpawn && (_forceUpgrade || (this.getAboveIdealSize() >= 0 && spawnable.canUpgrade())))
			{
				local upgradeWeight = spawnable.getUpgradeWeight();
				this.__UpgradeAffordables.add(spawnable, upgradeWeight);	// Weight = maximum amount of times this spawnable can currently upgrade troops (favors blocks with many tiers)
			}
		}

		if (this.__SpawnAffordables.len() == 0 && this.__UpgradeAffordables.len() == 0) // Usually happens after ratioSpawn happened
				return false;

		if (!::DynamicSpawns.Const.Benchmark && ::DynamicSpawns.Const.DetailedLogging )
		{
			if (this.__SpawnAffordables.len() > 0)
			{
				local str = "SpawnAffordables: ";
				this.__SpawnAffordables.apply(function(_spawnable, _weight) {
					str += _spawnable.getID() + " (" + _weight + "), ";
					return _weight;
				});
				::logWarning(str.slice(0, -2));
			}

			if (this.__UpgradeAffordables.len() > 0)
			{
				local str = "UpgradeAffordables: ";
				this.__UpgradeAffordables.apply(function(_spawnable, _weight) {
					str += _spawnable.getID() + " (" + _weight + "), ";
					return _weight;
				});
				::logWarning(str.slice(0, -2) + "\n");
			}
		}

		if (this.__UpgradeAffordables.len() > 0 && (this.__SpawnAffordables.len() == 0 || ::MSU.Math.randf( 0.0, 1.0 ) < this.getRatioToIdealSize()))
		{
			// ::logWarning("Upgrade: - Resources: " + this.getResources() + " : TotalCount = " + this.getTotal());
			local toUpgrade = this.__UpgradeAffordables.roll();
			if (toUpgrade != null)
			{
				return this.getSpawnable(toUpgrade.getID()).doCycle(false, true);
			}
			else if (this.__SpawnAffordables.len() == 0)
			{
				return false;
			}
		}
		else if (this.__SpawnAffordables.len() > 0)
		{
			local toSpawn = this.__SpawnAffordables.roll();
			if (toSpawn != null)
			{
				return this.getSpawnable(toSpawn.getID()).doCycle(true);
			}
			else if (this.__UpgradeAffordables.len() == 0) return false;
		}

		return false;
	}

	function spawn()
	{
		// This will remove all unnecessary Unitblocks/Units to improve performance
		this.getParty().onBeforeSpawnStart();

		local ret = [];

		// Spawn static units
		foreach (unit in this.getParty().getStaticUnits())
		{
			if (unit.canSpawn())
			{
				this.incrementUnit(unit.getID(), "StaticUnits");
				this.consumeResources(unit.getCost());
			}
		}
		// Every while spawns or upgrades only one unit
		while (this.canDoAnotherCycle())	// Is True while Resources are positive or HardMin is not yet reached
		{
			if (!this.getParty().canSpawn() && !this.getParty().canUpgrade())
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
