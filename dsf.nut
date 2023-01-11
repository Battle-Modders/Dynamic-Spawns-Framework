// dsf-4
// ------------------------------------------------------

local detailedLogging = false; // Turn on for a detailed run down of a party generation, step by step.
local iterations = 5; // If detailedLogging is false, then generates this many parties for you to compare how the variation looks like

// Resources are consumed by each spawned unit based on the unit's Cost
// IdealSize is the ideal total number of units that should be spawned
// UpgradeChance - This is the chance that a unit is upgraded instead of spawning a new unit once the party has exceeded the IdealSize. A smaller number will lead to larger variation from the IdealSize, and more lower tier units.
// UnitBlocks should specify an ID that corresponds to a unit block ID. The Min and Max values refer to the the desired minimum and maximum ratio of this unit block in the party.

local partyDef = {
	Resources = 1500,
	IdealSize = 10,
	UpgradeChance = 0.8,
	UnitBlocks = [
		{ ID = "Frontline", Min = 0.6, Max = 0.8 },
		{ ID = "Ranged", Min = 0.1, Max = 0.4 },
		{ ID = "Animals", Min = 0.05, Max = 0.1 }
	]
}

// You can define new unit blocks here using the format provided
// Each Unit Block must have an ID.
// Each Unit inside the block must have an ID and Cost.

local unitBlocks = [
	{
		ID = "Frontline",
		Units = [
			{ ID = "Thug", Cost = 70 },
			{ ID = "Raider", Cost = 100 },
			{ ID = "Veteran", Cost = 200 },
			{ ID = "Elite", Cost = 400 },
		]
	},
	{
		ID = "Ranged",
		Units = [
			{ ID = "Poacher", Cost = 50 },
			{ ID = "Hunter", Cost = 100 }			
		]
	},
	{
		ID = "Animals",
		Units = [
			{ ID = "Dog", Cost = 10 },
			{ ID = "Armored Dog", Cost = 30 }			
		]
	}
]

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

	constructor( _party )
	{
		this.UnitBlocks = _party.UnitBlocks;
		this.Resources = _party.Resources;
		this.IdealSize = _party.IdealSize;
		this.UpgradeChance = _party.UpgradeChance;
		this.AdditionalResources = 0;
	}

	function getUnitBlocks()
	{
		return this.UnitBlocks;
	}

	function getResources()
	{
		// if (this.Resources != null) return this.Resources + this.AdditionalResources;
		// return ::Math.rand(this.MinStrength, this.MaxStrength == null ? ::DSF.getPlayerPartyStrength() + this.AdditionalResources);
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

	function getUnits( _additionalResources = 0 )
	{
		this.AdditionalResources = _additionalResources;
		// this.SpawnInfo = ::new(::DSF.Class.SpawnInfo).init(this);
		this.SpawnInfo = ::DSF.Class.SpawnInfo(this);		

		local spawnAffordableBlocks = ::MSU.Class.WeightedContainer();
		local upgradeAffordableBlocks = ::MSU.Class.WeightedContainer();

		while (this.SpawnInfo.canSpawn())
		{
			if (detailedLogging) this.SpawnInfo.printLog();
			spawnAffordableBlocks.clear();
			upgradeAffordableBlocks.clear();

			foreach (block in this.UnitBlocks)
			{
				local diff = block.Max - (this.SpawnInfo.getBlockTotal(block.ID) / this.SpawnInfo.getTotal());
				if (diff <= 0) continue;

				local plus1 = this.SpawnInfo.getBlockTotal(block.ID) + 1;
				if (this.SpawnInfo.getTotal() > 0 && plus1 / this.SpawnInfo.getTotal() > block.Max)
				{
					diff = 0;
				}

				if ((this.SpawnInfo.getBlockTotal(block.ID) == 0 && block.Min != 0) || (this.SpawnInfo.getBlockTotal(block.ID) / this.SpawnInfo.getTotal() < block.Min))
				{
					diff = -1;
				}
				
				if (::DSF.UnitBlocks.findById(block.ID).canAffordSpawn(this))
				{
					spawnAffordableBlocks.add(block.ID, diff);
				}

				if (this.SpawnInfo.getTotal() >= this.getIdealSize() && this.SpawnInfo.getBlockTotal(block.ID) > 0 && ::DSF.UnitBlocks.findById(block.ID).canAffordUpgrade(this))
				{
					upgradeAffordableBlocks.add(block.ID, this.SpawnInfo.getBlockTotal(block.ID));
				}
			}

			if (spawnAffordableBlocks.len() == 0 && upgradeAffordableBlocks.len() == 0) break;

			if (detailedLogging)
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
				else break;
			}
			else if (spawnAffordableBlocks.len() > 0)
			{
				local blockID = spawnAffordableBlocks.roll();				
				if (blockID != null) ::DSF.UnitBlocks.findById(blockID).spawnUnit(this);	
				else break;
				// ::DSF.UnitBlocks.findById(spawnAffordableBlocks.roll()).spawnUnit(this);
			}
		}

		this.SpawnInfo.printLog();

		local ret = this.SpawnInfo.getUnits();
		this.SpawnInfo = null;
		return ret;
	}
}

::DSF.Class.SpawnInfo <- class
{
	Info = null;
	Resources = null;
	Total = null;

	constructor( _party )
	{
		this.Info = {};
		this.Resources = _party.getResources();
		this.Total = 0.0;
		foreach (block in _party.getUnitBlocks())
		{
			this.Info[block.ID] <- {
				Total = 0
			};

			foreach (unit in ::DSF.UnitBlocks.findById(block.ID).getUnits())
			{
				this.Info[block.ID][unit.ID] <- 0;
			}
		}
	}

	function printLog()
	{
		printn("Resources remaining: " + this.Resources);
		foreach (block in unitBlocks)
		{
			local str = block.ID + ": " + this.Info[block.ID].Total + " (" + (100 * this.Info[block.ID].Total / this.Total) + "%) - ";			
			foreach (unit in ::DSF.UnitBlocks.findById(block.ID).getUnits())
			{
				str += unit.ID + ": " + this.Info[block.ID][unit.ID] + ", ";				
			}

			printn(str.slice(0, -2));
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

	function incrementTotal()
	{
		this.Total++;
	}

	function incrementUnit( _unitID, _unitBlockID )
	{
		this.Info[_unitBlockID][_unitID] += 1;
		this.Info[_unitBlockID].Total += 1;
		this.incrementTotal();
	}

	function decrementTotal()
	{
		this.Total--;
	}

	function decrementUnit( _unitID, _unitBlockID )
	{
		this.Info[_unitBlockID][_unitID] -= 1;
		this.Info[_unitBlockID].Total -= 1;
		this.decrementTotal();
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
		foreach (block in this.Info)
		{
			foreach (unitID, count in block)
			{
				if (unitID == "Total") continue;
				for (local i = 0; i < count; i++)
				{
					units.push(unitID);
				}
			}
		}
		return units;
	}
}

::DSF.Class.UnitBlock <- class
{
	ID = null;
	Units = null;
	LookupMap = null;

	constructor( _unitBlock )
	{
		this.LookupMap = {};
		this.ID = _unitBlock.ID;
		this.Units = _unitBlock.Units;
		this.Units.sort(@(a, b) a.Cost <=> b.Cost);
		foreach (unit in this.Units)
		{
			this.LookupMap[unit.ID] <- unit;
		}
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
		this.Units.push(_unit);
		this.LookupMap[_unit.ID] <- _unit;
		this.Units.sort(@(a, b) a.Cost <=> b.Cost);
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

	// TODO: implement canSpawn for the unit
	function spawnUnit( _party )
	{
		_party.getSpawnInfo().incrementUnit(this.Units[0].ID, this.getID());
		_party.getSpawnInfo().consumeResources(this.Units[0].Cost);

		if (detailedLogging) printn("Spawning - Block: " + this.getID() + " - Unit: " + this.Units[0].ID + " (Cost: " + this.Units[0].Cost + ")\n");
	}

	// TODO: implement canSpawn for the unit
	function upgradeUnit( _party )
	{
		local ids = ::MSU.Class.WeightedContainer();

		// Ignore the highest tier
		for (local i = 0; i < this.Units.len() - 1; i++)
		{
			local id = this.Units[i].ID;
			local count = _party.getSpawnInfo().getUnitCount(id, this.getID());
			if (count > 0) ids.add(id, count);
		}

		while (ids.len() > 0)
		{
			local idToUpgrade = ids.roll();
			local upgradeTo;
			foreach (unit in this.Units)
			{
				if (unit.Cost > this.LookupMap[idToUpgrade].Cost)
				{
					upgradeTo = unit.ID;
					break;
				}
			}

			if (_party.getSpawnInfo().getResources() >= this.LookupMap[upgradeTo].Cost - this.LookupMap[idToUpgrade].Cost)
			{
				_party.getSpawnInfo().addResources(this.LookupMap[idToUpgrade].Cost);
				_party.getSpawnInfo().decrementUnit(idToUpgrade, this.getID());

				_party.getSpawnInfo().incrementUnit(upgradeTo, this.getID());
				_party.getSpawnInfo().consumeResources(this.LookupMap[upgradeTo].Cost);

				if (detailedLogging) printn("**Upgrading - Block: " + this.getID() + " - Unit: " + idToUpgrade + " (Cost: " + this.LookupMap[idToUpgrade].Cost + ") to " + upgradeTo + " (Cost: " + this.LookupMap[upgradeTo].Cost + ")**\n");

				return true;
			}

			ids.remove(idToUpgrade);
		}

		return false;
	}

	function canAffordSpawn( _party )
	{
		return _party.getSpawnInfo().getResources() >= this.Units[0].Cost;
	}

	function canAffordUpgrade( _party )
	{
		for (local i = 0; i < this.Units.len() - 1; i++)
		{
			if (_party.getSpawnInfo().getUnitCount(this.Units[i].ID, this.getID()) > 0 && _party.getSpawnInfo().getResources() >= this.Units[i+1].Cost - this.Units[i].Cost) return true;
		}

		return false;
	}
}

::MSU <- {
	Table = {
		function getKeys( _table )
		{
			local ret = array(_table.len());
			local i = 0;
			foreach (key, value in _table)
			{
				ret[i] = key;
				i++;
			}
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
			this.NextIItems = ::MSU.Table.getKeys(this.Table);
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
			return forced[randint(forced.len())];
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

foreach (block in unitBlocks)
{
	::DSF.UnitBlocks.LookupMap[block.ID] <- ::DSF.Class.UnitBlock(block);
}

local party = ::DSF.Class.Party(partyDef);

if (detailedLogging) iterations = 1;

printn("=== Starting Resources: " + party.getResources() + " ===\n");

for (local i = 0; i < iterations; i++)
{
	party.getUnits();
}