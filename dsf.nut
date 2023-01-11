// dsf-2
// ------------------------------------------------

local resources = 1000;
local idealSize = 10;
local upgradeChance = 0.8;
local detailedLog = false;

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

	if (detailedLog) printn("\nSpawning - Block: " + _unitBlockID + " - Unit: " + spawnID + "\n");
}

local function upgradeUnit( _unitBlockID )
{
	local ids = [];
	foreach (unitID, unitCount in spawnedBlocks[_unitBlockID])
	{
		for (local i = 0; i < unitCount; i++)
		{
			ids.push([unitBlocks[_unitBlockID].Units[unitID].Cost, unitID]);
		}		
	}

	// if (ids.len() == 0) return;

	local idToUpgrade = ids[rndint(ids.len())][1];
	ids.clear();

	foreach (unitID, unit in unitBlocks[_unitBlockID].Units)
	{
		if (unit.Cost > unitBlocks[_unitBlockID].Units[idToUpgrade].Cost) ids.push([unit.Cost, unitID]);
	}

	if (ids.len() == 0) return;

	ids.sort(@(a, b) a[0] <=> b[0]);

	local spawnID = ids[0][1];

	resources += unitBlocks[_unitBlockID].Units[idToUpgrade].Cost;
	spawnedBlocks[_unitBlockID][idToUpgrade] -= 1;

	spawnedBlocks[_unitBlockID][spawnID] += 1;
	resources -= unitBlocks[_unitBlockID].Units[spawnID].Cost;

	if (detailedLog) printn("\n**Upgrading - Block: " + _unitBlockID + " - Unit: " + idToUpgrade + " to " + spawnID + "**\n");
}

printn("======================================================================")

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
		foreach (blockID, block in unitBlocks)
		{
			local min = rndfloat(1) > 0.5 ? block.Max : block.Min;

			local count = 0;
			foreach (unitCount in spawnedBlocks[blockID])
			{
				count += unitCount;
			}
			
			if (count / totalCount < min)
			{
				chosenBlockID = blockID;
				break;
			} 

			local diff = block.Max - (count / totalCount);
			if (diff < 0) continue;

			if (diff > diffFromMax)
			{
				diffFromMax = diff;
				chosenBlockID = blockID;				
			}
		}

		if (chosenBlockID == null) chosenBlockID = unitBlockIDs[rndint(unitBlockIDs.len())];

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
				printn(blockID + ": " + count + "(" + (100 * count / totalCount) + "%) - " + str.slice(0, -2));				
			}
		}

		if (totalCount > idealSize && rndfloat(1) < upgradeChance)
		{
			upgradeUnit(chosenBlockID);
		}
		else
		{
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

