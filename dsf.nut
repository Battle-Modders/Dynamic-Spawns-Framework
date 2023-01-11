// dsf-3
// ------------------------------------------------

local resources = 2000;
local idealSize = 10;
local upgradeChance = 0.95;
local detailedLog = true;

local unitBlocks = {
	Frontline = {
		Min = 0.6,
		Max = 0.8,
		Units = {
			Thug = { Cost = 70 },
			Raider = { Cost = 100 },
			Veteran = { Cost = 200 },
		}
	},
	Backline = {
		Min = 0.1,
		Max = 0.4,
		Units = {
			Poacher = { Cost = 50 },
			Hunter = { Cost = 100 },	
		}
	},
	Support = {
		Min = 0.05,
		Max = 0.1,
		Units = {
			Dog = { Cost = 10 },
			ArmoredDog = { Cost = 50 }
		}
	}
}

// ------------------------------------------------

local function printn( _string )
{
	print(_string + "\n");
}

local function rndfloat( _max )
{
	return 1.0 * _max * rand() / RAND_MAX;
}

local function rndint( _max )
{
	return rndfloat(_max).tointeger();
}

local totalCount = 0.0;
local spawnedBlocks = {};
local unitBlockIDs = [];
foreach (blockID, block in unitBlocks)
{	
	spawnedBlocks[blockID] <- {};
	unitBlockIDs.push(blockID);
	foreach (unitID, unit in block.Units)
	{
		spawnedBlocks[blockID][unitID] <- 0;
	}
}

local function spawnUnit( _unitBlockID )
{
	local ids = [];
	foreach (unitID, unit in unitBlocks[_unitBlockID].Units)
	{
		ids.push([unit.Cost, unitID]);
	}

	ids.sort(@(a, b) a[0] <=> b[0]);

	local spawnID = ids[0][1];

	spawnedBlocks[_unitBlockID][spawnID] += 1;
	totalCount++;
	resources -= unitBlocks[_unitBlockID].Units[spawnID].Cost;

	if (detailedLog)
	{
		printn("\nSpawning - Block: " + _unitBlockID + " - Unit: " + spawnID + " (Cost: " + unitBlocks[_unitBlockID].Units[spawnID].Cost + ")\n");
		printn("Remaining resources: " + resources);
	}
};

local idToUpgrade;
local upgradeTo;
local function upgradeUnit( _unitBlockID )
{
	local ids = [];
	foreach (unitID, unit in unitBlocks[_unitBlockID].Units)
	{
		if (unit.Cost > unitBlocks[_unitBlockID].Units[idToUpgrade].Cost)
		{
			ids.push([unit.Cost, unitID]);
		}
	}

	if (ids.len() == 0) return;

	ids.sort(@(a, b) a[0] <=> b[0]);
	local spawnID = ids[0][1];
	resources = resources + unitBlocks[_unitBlockID].Units[idToUpgrade].Cost;
	spawnedBlocks[_unitBlockID][idToUpgrade] -= 1;
	spawnedBlocks[_unitBlockID][spawnID] += 1;
	resources = resources - unitBlocks[_unitBlockID].Units[spawnID].Cost;

	if (detailedLog)
	{
		printn("\n**Upgrading - Block: " + _unitBlockID + " - Unit: " + idToUpgrade + " (Cost: " + unitBlocks[_unitBlockID].Units[idToUpgrade].Cost + ") to " + spawnID + " (Cost: " + unitBlocks[_unitBlockID].Units[spawnID].Cost + ")**\n");
		printn("Remaining resources: " + resources);
	}
};

local function canAffordUpgradingBlock( _unitBlockID )
{
	upgradeTo = "";
	local ids = [];

	foreach (unitID, unitCount in spawnedBlocks[_unitBlockID])
	{
		for (local i = 0; i < unitCount; i++)
		{
			ids.push([unitBlocks[_unitBlockID].Units[unitID].Cost, unitID]);
		}
	}

	while (ids.len() > 0)
	{
		upgradeTo = "";
		local idx = rndint(ids.len());
		idToUpgrade = ids[idx][1];
		local possibleUpgrades = [];

		foreach( unitID, unit in unitBlocks[_unitBlockID].Units )
		{
			if (unit.Cost > unitBlocks[_unitBlockID].Units[idToUpgrade].Cost)
			{
				possibleUpgrades.push([unit.Cost, unitID]);
			}
		}

		if (possibleUpgrades.len() == 0)
		{
			ids.remove(idx);
			continue;
		}

		possibleUpgrades.sort(@(a,b) a[0] <=> b[0]);

		upgradeTo = possibleUpgrades[0][1];

		if (resources >= possibleUpgrades[0][0] - unitBlocks[_unitBlockID].Units[idToUpgrade].Cost)
		{
			return true;
		}
		else
		{
			ids.remove(idx);
		}
	}

	return false;
};

local function canAffordSomethingFromBlock( _unitBlockID )
{
	foreach( unit in unitBlocks[_unitBlockID].Units )
	{
		if (resources >= unit.Cost) return true;
	}

	return false;
};
printn("======================================================================");
local iterations = detailedLog ? 1 : 5;
local resourcesBackup = resources;

for (local i = 0; i < iterations; i++)
{
	resources = resourcesBackup;
	totalCount = 0.0;
	foreach (blockID, block in unitBlocks)
	{	
		spawnedBlocks[blockID] <- {};	
		unitBlockIDs.push(blockID);
		foreach (unitID, unit in block.Units)
		{
			spawnedBlocks[blockID][unitID] <- 0;
		}
	}
	
	foreach (blockID, block in unitBlocks)
	{
		if (block.Min != 0) spawnUnit(blockID);
	}
	
	if (!detailedLog) printn("Iteration " + i);
	while (resources > 0)
	{	
		local diffFromMax = 0;
		local chosenBlockID;
		local preferSpawn = false;

		foreach (blockID, block in unitBlocks)
		{
			preferSpawn = false;
			local count = 0;
			foreach (unitCount in spawnedBlocks[blockID])
			{
				count += unitCount;
			}

			local diff = block.Max - count / totalCount;

			if (diff < 0) continue;

			if (canAffordSomethingFromBlock(blockID))
			{
				affordableBlocks.push(blockID);
			}
			else
			{
				continue;
			}

			local min = rndfloat(1) > 0.5 ? block.Max : block.Min;

			if (count / totalCount < block.Min)
			{
				preferSpawn = true;
			}

			if (count / totalCount < min)
			{
				chosenBlockID = blockID;
				break;
			}

			if (diff > diffFromMax)
			{
				diffFromMax = diff;
				chosenBlockID = blockID;
			}
		}

		if (affordableBlocks.len() == 0) break;

		if (chosenBlockID == null) chosenBlockID = affordableBlocks[rndint(affordableBlocks.len())];

		if (detailedLog)
		{
			foreach (blockID, block in spawnedBlocks)
			{
				local count = 0;
				local str = "";
				foreach (unitID, unitCount in block)
				{
					count += unitCount;
					str += unitID + ": " + unitCount + ", ";
				}				
				printn(blockID + ": " + count + "(" + 100 * count / totalCount + "%) - " + str.slice(0, -2));
			}
			printn("Total Units: " + totalCount);
		}

		if (preferSpawn && detailedLog)
		{
			printn("\n--> Will prefer to spawn from block " + chosenBlockID + " as it is below its Min ratio <--");
		}

		local canAffordToUpgrade = canAffordUpgradingBlock(chosenBlockID);

		if (!preferSpawn && totalCount >= idealSize && rndfloat(1) < upgradeChance && canAffordToUpgrade)
		{
			upgradeUnit(chosenBlockID);
		}
		else
		{
			if (detailedLog && !canAffordToUpgrade)
			{
				this.print("\n!! Cannot afford to upgrade block: " + chosenBlockID + ". Unit: " + idToUpgrade);

				if (upgradeTo == "")
				{
					printn(" as it is the highest tier in its block !!");
				}
				else
				{
					printn(" (Cost: " + unitBlocks[chosenBlockID].Units[idToUpgrade].Cost + ") to " + upgradeTo + " (Cost: " + unitBlocks[chosenBlockID].Units[upgradeTo].Cost + ") !!");
				}
			}

			spawnUnit(chosenBlockID);
		}
	}

	foreach (blockID, block in spawnedBlocks)
	{
		local count = 0;
		local str = "";
		foreach (unitID, unitCount in block)
		{
			count += unitCount;
			str += unitID + ": " + unitCount + ", ";
		}				
		printn(blockID + ": " + count + "(" + (100 * count / totalCount) + "%) - " + str.slice(0, -2));				
	}

	printn("Total Units: " + totalCount);
	if (!detailedLog) printn("-----");
}

