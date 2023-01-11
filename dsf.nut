// dsf-6
// ------------------------------------------------------

local detailedLogging = false; // Turn on for a detailed run down of a party generation, step by step.
local iterations = 5; // If detailedLogging is false, then generates this many parties for you to compare how the variation looks like
local benchmark = false; // If true then generates a ton of parties, without printing anything. At the end, prints the average CPU time spent per party creation.

local unitsDefs = [
	{
		ID = "ThugFromID",
		EntityType = "Thug",
		Cost = 70,
		StrengthMax = 1000		
	}
]

// You can define new unit blocks here using the format provided
// Each Unit Block must have an ID.
// Each Unit inside the block must have an ID and Cost.
// Optional fields include "StrengthMin", "StrengthMax", "Party", "MinSize"

local unitBlocks = [
	{
		ID = "Frontline",
		Units = [
			{ ID = "ThugFromID" },
			{ EntityType = "Raider", Cost = 100, },
			{ EntityType = "Veteran", Cost = 200 },
			{ EntityType = "Elite", Cost = 400, StrengthMin = 2000, Party = "BanditEliteGuards" },
		]
	},
	{
		ID = "Ranged",
		Units = [
			{ EntityType = "Poacher", Cost = 50 },
			{ EntityType = "Hunter", Cost = 100 },
			{ EntityType = "Master Archer", Cost = 300 }
		]
	},
	{
		ID = "Animals",
		MinSize = 15,
		Units = [
			{ EntityType = "Dog", Cost = 10 },
			{ EntityType = "Armored Dog", Cost = 30 }			
		]
	}
]

// Resources are consumed by each spawned unit based on the unit's Cost
// IdealSize is the ideal total number of units that should be spawned
// UpgradeChance - This is the chance that a unit is upgraded instead of spawning a new unit once the party has exceeded the IdealSize. A smaller number will lead to larger variation from the IdealSize, and more lower tier units.
// UnitBlocks should specify an ID that corresponds to a unit block ID. The Min and Max values refer to the the desired minimum and maximum ratio of this unit block in the party.
// MinSize defined here will overwrite the one defined in the original unitBlock definition

local partyDef = {
	ID = "BanditRoamers",
	Resources = 2000,
	IdealSize = 10,	
	UpgradeChance = 0.7,
	UnitBlocks = [
		{ ID = "Frontline", Min = 0.6, Max = 0.8 },
		{ ID = "Ranged", Min = 0.1, Max = 0.4 },
		{ ID = "Animals", Min = 0.05, Max = 0.1, MinSize = 0 },		
		// { 
		// 	Min = 0.5,
		// 	Max = 0.8,
		// 	Units = [
		// 		{ ID = "ThugFromID" }
		// 	]
		// }
	],
	StaticUnits = [
		{ EntityType = "Master Archer", Cost = 300, StrengthMin = 1500 }
	]
}

local guardPartyDef = {
	ID = "BanditEliteGuards"
	Resources = 100,
	IdealSize = 2,
	UpgradeChance = 0.7,
	UnitBlocks = [
		// { ID = "Ranged", Min = 0.3, Max = 0.4 },
		{ ID = "Animals", Min = 0.3, Max = 0.4 }
		// { ID = "Animals", Min = 1.0, Max = 1.0 }
	]
}

// ------------------------------------------------------

// DO NOT CHANGE ANYTHING BELOW THIS LINE

local function printn( _string )
{
	print(_string + "\n");
}

local function randfloat( _max )
{
	return 1.0 * _max * rand() / RAND_MAX;
}

local function randint( _max )
{
	return randfloat(_max).tointeger();
}

printn("======================================================================")

::DSF <- {};
::DSF.UnitBlocks <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DSF.Parties <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DSF.Units <- {
	LookupMap = {},
	function findById( _id )
	{
		return this.LookupMap[_id];
	}	
}

::DSF.Class <- {};
::DSF.Class.Party <- class
{
	ID = null;	
	UnitBlocks = null;
	Resources = null;
	IdealSize = null;
	UpgradeChance = null;
	SpawnInfo = null;
	AdditionalResources = null;
	StaticUnits = null;

	constructor( _party )
	{
		this.ID = _party.ID;		
		this.Resources = _party.Resources;
		this.IdealSize = _party.IdealSize;
		this.UpgradeChance = _party.UpgradeChance;		
		this.AdditionalResources = 0;

		if ("UnitBlocks" in _party)
		{
			this.UnitBlocks = [];
			foreach (i, blockDef in _party.UnitBlocks)
			{
				local block;
				if ("ID" in blockDef)
				{
					block = ::DSF.UnitBlocks.findById(blockDef.ID);
				}
				else
				{
					blockDef.ID <- this.ID + ".Block." + i;
					block = ::DSF.Class.UnitBlock(blockDef);
				}
				if ("MinSize" in blockDef) block.MinSize = blockDef.MinSize;
				this.UnitBlocks.push(blockDef);
				::DSF.UnitBlocks.LookupMap[blockDef.ID] <- block;
			}
		}

		if ("StaticUnits" in _party)
		{
			this.StaticUnits = _party.StaticUnits;
			local block = {
				ID = this.ID + ".Block.Static",
				Units = _party.StaticUnits
			}
			this.UnitBlocks.push(block);
			::DSF.UnitBlocks.LookupMap[block.ID] <- ::DSF.Class.UnitBlock(block);
			::DSF.UnitBlocks.findById(block.ID).IsStatic = true;
		}

		::DSF.Parties.LookupMap[this.ID] <- this;
	}

	function getUnitBlocks()
	{
		return this.UnitBlocks;
	}

	function getResources()
	{
		// if (this.Resources != null) return this.Resources + this.AdditionalResources;
		// return ::Math.rand(this.StrengthMin, this.StrengthMax == null ? ::DSF.getPlayerPartyStrength() + this.AdditionalResources);
		return this.Resources;
	}

	function getIdealSize()
	{
		return this.IdealSize != null ? this.IdealSize : ::World.Roster.getAll().len() * 1.5;
	}

	function getSpawnInfo()
	{
		return this.SpawnInfo;
	}

	function getStaticUnitBlock()
	{
		if (this.StaticUnits != null) return ::DSF.UnitBlocks.findById(this.ID + ".Block.Static");
	}

	function getSpawn( _additionalResources = 0 )
	{		
		foreach (block in this.UnitBlocks)
		{
			::DSF.UnitBlocks.findById(block.ID).onPartySpawnStart();
		}
		this.AdditionalResources = _additionalResources;
		this.SpawnInfo = ::DSF.Class.SpawnInfo(this);

		local ret = [];

		if (this.StaticUnits != null)
		{
			foreach (unit in this.getStaticUnitBlock().getUnits())
			{
				if (unit.canSpawn(this) && this.SpawnInfo.getResources() >= unit.getCost())
				{
					this.SpawnInfo.incrementUnit(unit.getID(), this.getStaticUnitBlock().getID());
					this.SpawnInfo.consumeResources(unit.getCost());
				}
			}
		}

		local spawnAffordableBlocks = ::MSU.Class.WeightedContainer();
		local upgradeAffordableBlocks = ::MSU.Class.WeightedContainer();
		local forcedSpawn = false;

		while (this.SpawnInfo.canSpawn())
		{
			if (!benchmark && detailedLogging) this.SpawnInfo.printLog(this);
			spawnAffordableBlocks.clear();
			upgradeAffordableBlocks.clear();
			forcedSpawn = false;			

			foreach (block in this.UnitBlocks)
			{
				if (::DSF.UnitBlocks.findById(block.ID).IsStatic) continue;

				if (::DSF.UnitBlocks.findById(block.ID).canAffordSpawn(this))
				{
					local weight = block.Max - (this.SpawnInfo.getBlockTotal(block.ID) / this.SpawnInfo.getTotal());
					if (weight <= 0)
					{
						if (this.SpawnInfo.getTotal() + 1 > this.IdealSize * (1.0 + 1.0 - this.UpgradeChance)) weight = 0; // TODO: Improve the logic on this line
						else weight = 0.00000001;
					} 
					if ((this.SpawnInfo.getBlockTotal(block.ID) == 0 && block.Min != 0) || (this.SpawnInfo.getBlockTotal(block.ID) / this.SpawnInfo.getTotal() < block.Min))
					{
						::DSF.UnitBlocks.findById(block.ID).spawnUnit(this);
						forcedSpawn = true;
						break;
					}
					spawnAffordableBlocks.add(block.ID, weight);
				}

				if (this.SpawnInfo.getTotal() >= this.getIdealSize() && this.SpawnInfo.getBlockTotal(block.ID) > 0 && ::DSF.UnitBlocks.findById(block.ID).canAffordUpgrade(this))
				{
					upgradeAffordableBlocks.add(block.ID, this.SpawnInfo.getBlockTotal(block.ID));
				}
			}

			if (forcedSpawn) continue;

			if (spawnAffordableBlocks.len() == 0 && upgradeAffordableBlocks.len() == 0) break;

			if (!benchmark && detailedLogging)
			{
				if (spawnAffordableBlocks.len() > 0)
				{
					local str = "spawnAffordableBlocks: ";
					spawnAffordableBlocks.apply(function(_id, _weight) {
						str += _id + " (" + _weight + "), ";
						return _weight;
					});
					printn(str.slice(0, -2));
				}

				if (upgradeAffordableBlocks.len() > 0)
				{
					local str = "upgradeAffordableBlocks: ";
					upgradeAffordableBlocks.apply(function(_id, _weight) {
						str += _id + " (" + _weight + "), ";
						return _weight;
					});
					printn(str.slice(0, -2) + "\n");
				}
			}

			if (upgradeAffordableBlocks.len() > 0 && randfloat(1.0) < (this.UpgradeChance * this.SpawnInfo.getTotal() / this.IdealSize))
			{
				local blockID = upgradeAffordableBlocks.roll();				
				if (blockID != null) ::DSF.UnitBlocks.findById(blockID).upgradeUnit(this);
				else if (spawnAffordableBlocks.len() == 0) break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				local blockID = spawnAffordableBlocks.roll();				
				if (blockID != null) ::DSF.UnitBlocks.findById(blockID).spawnUnit(this);	
				else if (upgradeAffordableBlocks.len() == 0) break;
			}
		}

		if (!benchmark) this.SpawnInfo.printLog(this);

		ret.extend(this.SpawnInfo.getUnits());

		for (local i = ret.len() - 1; i >= 0; i--)
		{
			if (ret[i].getParty() != null)
			{
				if (!benchmark) printn("====== Spawning Party for " + ret[i].getEntityType() + " ======")
				ret.extend(::DSF.Parties.findById(ret[i].getParty()).getSpawn());
			}
		}

		foreach (block in this.UnitBlocks)
		{
			::DSF.UnitBlocks.findById(block.ID).onPartySpawnEnd();
		}
		
		this.SpawnInfo = null;

		return ret;
	}
}

::DSF.Class.SpawnInfo <- class
{
	Info = null;
	Resources = null;
	PlayerStrength = null;
	Total = null;

	constructor( _party )
	{
		this.Info = {};
		this.Resources = _party.getResources() + _party.AdditionalResources;
		this.PlayerStrength = this.Resources;
		this.Total = 0.0;
		foreach (block in _party.getUnitBlocks())
		{
			this.Info[block.ID] <- {
				Total = 0
			};

			foreach (unit in ::DSF.UnitBlocks.findById(block.ID).getUnits())
			{
				this.Info[block.ID][unit.getID()] <- 0;
			}
		}	
	}

	function printLog( _party )
	{
		printn("Resources remaining: " + this.Resources);
		local printBlock = function( _blockID )
		{
			local str = (_blockID.find("Static") != null ? "Static" : _blockID) + ": " + this.Info[_blockID].Total + " (" + (100 * this.Info[_blockID].Total / this.Total) + "%) - ";			
			foreach (unit in ::DSF.UnitBlocks.findById(_blockID).getUnits())
			{
				str += unit.getEntityType() + ": " + this.Info[_blockID][unit.getID()] + ", ";				
			}

			printn(str.slice(0, -2));
		}
		foreach (block in _party.getUnitBlocks())
		{
			printBlock(block.ID);
		}
		printn("Total Units: " + this.Total);
		print("\n");
	}

	function canSpawn()
	{
		return this.Resources > 0;
	}

	function getTotal()
	{
		return this.Total;
	}

	function getBlockTotal( _unitBlockID )
	{
		return this.Info[_unitBlockID].Total;
	}

	function getUnitCount( _unitID, _unitBlockID = null )
	{
		if (_unitBlockID != null) return this.Info[_unitBlockID][_unitID];

		local count = 0;
		foreach (block in this.Info)
		{
			if (_unitID in block) count += block[_unitID];
		}

		return count;
	}

	function incrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.Info[_unitBlockID][_unitID] += _count;
		this.Info[_unitBlockID].Total += _count;		
		this.Total += _count;
	}

	function decrementUnit( _unitID, _unitBlockID, _count = 1 )
	{
		this.Info[_unitBlockID][_unitID] -= _count;
		this.Info[_unitBlockID].Total -= _count;
		this.Total -= _count;
	}

	function getResources()
	{
		return this.Resources;
	}

	function addResources( _amount )
	{
		this.Resources += _amount;
	}

	function consumeResources( _amount )
	{
		this.Resources -= _amount;
	}

	function getUnits()
	{
		local units = [];
		foreach (blockID, block in this.Info)
		{
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

	function getPlayerStrength()
	{
		return this.PlayerStrength;
	}
}

::DSF.Class.UnitBlock <- class
{
	ID = null;
	Units = null;
	LookupMap = null;
	IsStatic = null;
	MinSize = null;

	constructor( _unitBlock )
	{
		this.LookupMap = {};
		this.ID = _unitBlock.ID;		
		this.Units = [];
		this.IsStatic = false;
		if ("MinSize" in _unitBlock) this.MinSize = _unitBlock.MinSize;
		else this.MinSize = 0;
		this.addUnits(_unitBlock.Units);		
	}

	function getID()
	{
		return this.ID;
	}

	function getUnits()
	{
		return this.Units;
	}

	function addUnit( _unit )
	{
		local unit;
		if ("ID" in _unit)
		{
			unit = ::DSF.Units.findById(_unit.ID);
		}
		else
		{
			_unit.ID <- this.ID + ".Unit." + this.Units.len();
			unit = ::DSF.Class.Unit(_unit);
		}
		
		this.Units.push(unit);
		this.LookupMap[unit.getID()] <- unit;
	}

	function addUnits( _units )
	{
		foreach (unit in _units)
		{
			this.addUnit(unit);
		}
	}

	function removeUnit( _id )
	{
		foreach (i, unit in this.Units)
		{
			if (unit.ID == _id)
			{
				delete this.LookupMap[_id];
				return this.Units.remove(i);
			}
		}
	}

	function getUnit( _id )
	{
		return this.LookupMap[_id];
	}

	function spawnUnit( _party )
	{
		foreach (unit in this.Units)
		{
			if (unit.canSpawn(_party))
			{
				_party.getSpawnInfo().incrementUnit(unit.getID(), this.getID());
				_party.getSpawnInfo().consumeResources(unit.getCost());
				if (!benchmark && detailedLogging) printn("Spawning - Block: " + this.getID() + " - Unit: " + unit.getEntityType() + " (Cost: " + unit.getCost() + ")\n");
				break;
			}
		}
	}

	function despawnUnit( _party )
	{
		local ids = ::MSU.Class.WeightedContainer();

		foreach (unit in this.Units)
		{
			local count = _party.getSpawnInfo().getUnitCount(unit.getID(), this.getID());
			if (count > 0) ids.add(unit.ID, count);
		}

		if (ids.len() > 0)
		{
			local despawnID = ids.roll();

			_party.getSpawnInfo().addResources(this.LookupMap[despawnID].getCost());
			_party.getSpawnInfo().decrementUnit(despawnID, this.getID());
 
			if (!benchmark && detailedLogging) printn("--> Despawning - Block: " + this.getID() + " - Unit: " + ::DSF.Units.findById(despawnID).getEntityType() + " (Cost: " + this.LookupMap[roll.ID].Cost + ") <--\n");

			return true;
		}

		return false;
	}

	function upgradeUnit( _party )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the highest tier
		for (local i = 0; i < this.Units.len() - 1; i++)
		{
			if (!this.Units[i].canSpawn(_party)) continue;

			local id = this.Units[i].ID;
			local count = _party.getSpawnInfo().getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i + 1; j < this.Units.len(); j++)
				{
					if (this.Units[j].canSpawn(_party) && _party.getSpawnInfo().getResources() >= this.Units[j].getCost() - this.Units[i].getCost())
					{
						ids.add({ID = id, UpgradeID = this.Units[j].getID()}, count);
						break;
					}
				}
			}			
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();

			_party.getSpawnInfo().addResources(this.LookupMap[roll.ID].Cost);
			_party.getSpawnInfo().decrementUnit(roll.ID, this.getID());

			_party.getSpawnInfo().incrementUnit(roll.UpgradeID, this.getID());
			_party.getSpawnInfo().consumeResources(this.LookupMap[roll.UpgradeID].Cost);

			if (!benchmark && detailedLogging) printn("**Upgrading - Block: " + this.getID() + " - Unit: " + this.LookupMap[roll.ID].getEntityType() + " (Cost: " + this.LookupMap[roll.ID].Cost + ") to " + this.LookupMap[roll.UpgradeID].getEntityType() + " (Cost: " + this.LookupMap[roll.UpgradeID].Cost + ")**\n");

			return true;
		}

		return false;
	}

	function downgradeUnit( _party )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the bottom most tier
		for (local i = this.Units.len() - 1; i > 0; i--)
		{
			local id = this.Units[i].getID();
			local count = _party.getSpawnInfo().getUnitCount(id, this.getID());
			if (count > 0)
			{
				for (local j = i; j >= 0; j--)
				{
					if (this.Units[j].canSpawn(_party)) ids.add({ID = id, DowngradeID = this.Units[i-1].getID()}, count);
				}
				
			} 
		}

		if (ids.len() > 0)
		{
			local roll = ids.roll();

			_party.getSpawnInfo().addResources(this.LookupMap[roll.ID].Cost);
			_party.getSpawnInfo().decrementUnit(roll.ID, this.getID());

			_party.getSpawnInfo().incrementUnit(roll.DowngradeID, this.getID());
			_party.getSpawnInfo().consumeResources(this.LookupMap[roll.DowngradeID].Cost);

			if (!benchmark && detailedLogging) printn("!! Downgrading - Block: " + this.getID() + " - Unit: " + roll.ID + " (Cost: " + this.LookupMap[roll.ID].Cost + ") to " + roll.DowngradeID + " (Cost: " + this.LookupMap[roll.DowngradeID].Cost + ") !!\n");

			return true;
		}

		return false;
	}

	function canAffordSpawn( _party )
	{
		if (_party.getSpawnInfo().getTotal() < this.MinSize) return false;

		foreach (unit in this.Units)
		{
			if (unit.canSpawn(_party) && _party.getSpawnInfo().getResources() >= unit.getCost()) return true;
		}

		return false;
	}

	function canAffordUpgrade( _party )
	{
		for (local i = 0; i < this.Units.len() - 1; i++)
		{
			if (this.Units[i].canSpawn(_party) && _party.getSpawnInfo().getUnitCount(this.Units[i].getID(), this.getID()) > 0)
			{
				for (local j = i + 1; j < this.Units.len(); j++)
				{
					if (this.Units[j].canSpawn(_party) && _party.getSpawnInfo().getResources() >= this.Units[j].getCost() - this.Units[i].getCost()) return true;
				}
			}
		}

		return false;
	}

	function sort()
	{
		this.Units.sort(@(a, b) a.getCost() <=> b.getCost());
	}

	function onPartySpawnStart()
	{
		this.sort();
	}

	function onPartySpawnEnd()
	{		
	}
}

::DSF.Class.Unit <- class
{
	ID = null;	
	EntityType = null;
	Cost = null;
	StrengthMin = null;
	StrengthMax = null;
	Party = null;	

	constructor( _unit )
	{
		this.ID = _unit.ID;
		if ("EntityType" in _unit) this.EntityType = _unit.EntityType;
		if ("Cost" in _unit) this.Cost = _unit.Cost;
		if ("StrengthMax" in _unit) this.StrengthMax = _unit.StrengthMax.tofloat();
		if ("StrengthMin" in _unit) this.StrengthMin = _unit.StrengthMin.tofloat();
		else this.StrengthMin = 0.0;
		if ("Party" in _unit) this.Party = _unit.Party;

		::DSF.Units.LookupMap[this.ID] <- this;
	}

	function getID()
	{
		return this.ID;
	}

	function getEntityType()
	{
		return this.EntityType;
	}

	function getCost()
	{
		return this.Cost;
	}

	function getStrengthMin()
	{
		return this.StrengthMin;
	}

	function getStrengthMax()
	{
		return this.StrengthMax;
	}

	function getParty()
	{
		return this.Party;
	}

	function canSpawn( _party )
	{	
		if (this.getStrengthMin() == 0 && this.getStrengthMax() == null) return true;
		if (this.getStrengthMax() == null) return _party.getSpawnInfo().getPlayerStrength() >= this.getStrengthMin();

		return this.getStrengthMin() <= _party.getSpawnInfo().getPlayerStrength() && _party.getSpawnInfo().getPlayerStrength() <= this.getStrengthMax();
	}
}

::MSU <- {
	Table = {
		function keys( _table )
		{
			local ret = array(_table.len());
			local i = 0;
			foreach (key, value in _table)
			{
				ret[i] = key;
				i++;
			}

			return ret;
		}
	}
};
::MSU.Class <- {};
::MSU.Class.WeightedContainer <- class
{
	Total = null;
	Table = null;
	Forced = null;
	NextIItems = null;
	NextIIndex = null;

	constructor( _array = null )
	{
		this.Total = 0.0;
		this.Table = {};
		this.Forced = [];
		if (_array != null) this.addArray(_array);
	}

	function _get( _item )
	{
		if (_item in this.Table) return this.Table[_item];
		throw null;
	}

	function _cloned( _original )
	{
		this.Total = 0.0;
		this.Table = {};
		this.Forced = [];
		this.merge(_original);
	}

	function _nexti( _prev )
	{
		if (_prev == null)
		{
			this.NextIItems = ::MSU.Table.keys(this.Table);
			this.NextIIndex = 0;
		}
		_prev = this.NextIIndex++;

		if (_prev == this.Table.len())
		{
			this.NextIItems = null;
			this.NextIIndex = null;
			return null;
		}

		return this.NextIItems[_prev];
	}

	function toArray( _itemsOnly = true )
	{
		local ret = ::array(this.Table.len());
		local i = 0;
		foreach (item, weight in this.Table)
		{
			if (_itemsOnly) ret[i++] = item;
			else ret[i++] = [weight, item];
		}
		return ret;
	}

	function addArray( _array )
	{
		// ::MSU.requireArray(_array);
		foreach (pair in _array)
		{
			// ::MSU.requireArray(pair);
			if (pair.len() != 2) throw ::MSU.Exception.InvalidType(pair);
			
			this.add(pair[1], pair[0]);
		}
	}

	function merge( _otherContainer )
	{
		// ::MSU.requireInstanceOf(::MSU.Class.WeightedContainer, _otherContainer);
		foreach (item, weight in _otherContainer.Table)
		{
			this.add(item, weight);
		}
	}

	function add( _item, _weight = 1 )
	{
		// ::MSU.requireOneFromTypes(["integer", "float"], _weight);
		_weight = _weight.tofloat();

		if (_item in this.Table)
		{
			local newWeight = this.Table[_item] < 0 ? _weight : this.Table[_item] + _weight;
			this.updateWeight(_item, newWeight);
		}
		else
		{
			this.Table[_item] <- 0;
			this.updateWeight(_item, _weight);			
		}
	}

	function remove( _item )
	{
		if (this.Table[_item] < 0) delete this.Forced[_item];
		else this.Total -= this.Table[_item];
		delete this.Table[_item];
	}

	function contains( _item )
	{
		return _item in this.Table;
	}

	function getProbability( _item, _exclude = null )
	{
		if (_exclude != null)
		{
			// ::MSU.requireArray(_exclude);
			if (_exclude.find(_item) != null) return 0.0;
		}

		local forced = _exclude == null ? this.Forced : this.Forced.filter(@(idx, item) _exclude.find(item) == null);
		foreach (item in forced)
		{
			if (item == _item) return 1.0 / forced.len();
		}
		
		if (forced.len() != 0) return 0.0;

		return this.Table[_item] == 0 ? 0.0 : this.Table[_item] / this.getTotal(_exclude);
	}

	function getWeight( _item )
	{
		return this.Table[_item];
	}

	function setWeight( _item, _weight )
	{
		// ::MSU.requireOneFromTypes(["integer", "float"], _weight);
		this.updateWeight(_item, _weight);
	}

	function apply( _function )
	{
		// _function (_item, _weight)
		// must return new weight for _item

		foreach (item, weight in this.Table)
		{
			this.setWeight(item, _function(item, weight))
		}
	}

	function map( _function )
	{
		// _function (_item, _weight)
		// must return a len 2 array with weight, item as elements

		local ret = ::MSU.Class.WeightedContainer();
		foreach (item, weight in this.Table)
		{
			local pair = _function(item, weight); 
			ret.add(pair[1], pair[0]);
		}
		return ret;
	}

	function filter( _function )
	{
		// _function (_item, _weight)
		// must return a boolean

		local ret = ::MSU.Class.WeightedContainer();
		foreach (item, weight in this.Table)
		{
			if (_function(item, weight)) ret.add(item, weight);
		}
		return ret;
	}

	function clear()
	{
		this.Total = 0.0;
		this.Table.clear();
		this.Forced.clear();
	}

	function max()
	{
		local maxWeight = 0.0;
		local ret;

		foreach (item, weight in this.Table)
		{
			if (weight > maxWeight)
			{
				maxWeight = weight;
				ret = item;
			}
		}

		return ret;
	}

	// function rand( _exclude = null )
	// {
	// 	// if (_exclude != null) // ::MSU.requireArray(_exclude);

	// 	local rand = ::Math.rand(0, (this.Table.len() - _exclude == null ? 0 : _exclude.len()) - 1)
	// 	local i = 0;
	// 	foreach (item, weight in this.Table)
	// 	{
	// 		if (_exclude == null || _exclude.find(item) == null)
	// 		{
	// 			if (rand == i++) return item;
	// 		}
	// 	}
	// 	return null;
	// }

	function roll( _exclude = null )
	{
		// if (_exclude != null) // ::MSU.requireArray(_exclude);

		local forced = _exclude == null ? this.Forced : this.Forced.filter(@(idx, item) _exclude.find(item) == null);

		if (forced.len() > 0)
		{
			// return ::MSU.Array.rand(forced);
			return forced[randint(forced.len() - 1)];
		}

		local roll = randfloat(this.getTotal(_exclude));

		foreach (item, weight in this.Table)
		{
			if (_exclude != null && _exclude.find(item) != null) continue;

			if (roll <= weight && weight != 0.0) return item;

			roll -= weight;
		}

		return null;
	}

	function rollChance( _chance, _exclude = null )
	{
		return ::Math.rand(1, 100) <= _chance ? this.roll(_exclude) : null;
	}

	function len()
	{
		return this.Table.len();
	}

	function onSerialize( _out )
	{
		_out.writeU32(this.Total);
		::MSU.Utils.serialize(this.Table, _out);
	}

	function onDeserialize( _in )
	{
		this.Total = _in.readU32();
		this.Table = ::MSU.Utils.deserialize(_in);
	}

	// Private
	function updateWeight( _item, _newWeight )
	{
		_newWeight = _newWeight.tofloat();

		if (this.Table[_item] >= 0)
		{
			this.Total -= this.Table[_item];
			if (_newWeight < 0) this.Forced.push(_item);
		}

		if (_newWeight >= 0)
		{
			this.Total += _newWeight;
			if (this.Table[_item] < 0) this.Forced.remove(this.Forced.find(_item));
		}

		this.Table[_item] = _newWeight;
	}

	// Private
	function getTotal( _exclude = null )
	{
		if (_exclude == null) return this.Total;

		local ret = this.Total;
		foreach (item in _exclude)
		{
			if (this.Table[item] > 0) ret -= this.Table[item];
		}

		return ret;
	}
}

foreach (unit in unitsDefs)
{
	::DSF.Units.LookupMap[unit.ID] <- ::DSF.Class.Unit(unit);
}

foreach (block in unitBlocks)
{
	::DSF.UnitBlocks.LookupMap[block.ID] <- ::DSF.Class.UnitBlock(block);
}

local party = ::DSF.Class.Party(partyDef);
local guardParty = ::DSF.Class.Party(guardPartyDef);

if (detailedLogging) iterations = 1;
if (benchmark) iterations = 1000;

local time = clock();

for (local i = 0; i < iterations; i++)
{
	if (!benchmark) printn("----------------------------------------------------------------------")
	party.getSpawn();
}

if (benchmark) print("\nTime: " + ((clock() - time) / iterations));
