// dsf-2
// ------------------------------------------------

local resources = 1000;
local idealSize = 10;
local upgradeChance = 0.5;
local detailedLog = true;

local unitBlocks = {
	Frontline = { Cost = 70, Min = 0.6, Max = 0.8, UpgradeCost = 100 },
	Backline = { Cost = 50, Min = 0.1, Max = 0.4, UpgradeCost = 70 },
	Support = { Cost = 10, Min = 0.05, Max = 0.2, UpgradeCost = 30 }
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
local count = {};
local upgradeCount = {};
local unitBlockIDs = [];
foreach (blockID, block in unitBlocks)
{	
	count[blockID] <- 0;
	upgradeCount[blockID] <- 0;
	unitBlockIDs.push(blockID);
}

printn("======================================================================")

local function spawnUnit( _unitBlockID )
{
	if (detailedLog) printn("\nSpawning: " + _unitBlockID + "\n");
	count[_unitBlockID] += 1;
	totalCount++;
	resources -= unitBlocks[_unitBlockID].Cost;
}

local function upgradeUnit( _unitBlockID )
{
	if (detailedLog) printn("\n**Upgrading: " + _unitBlockID + "**\n");
	upgradeCount[_unitBlockID] += 1;		
	resources -= unitBlocks[_unitBlockID].Cost;
}

foreach (blockID, block in unitBlocks)
{
	if (block.Min != 0) spawnUnit(blockID);
}

while (resources > 0)
{	
	local diffFromMax = 0;
	local chosenBlockID;
	foreach (blockID, block in unitBlocks)
	{
		local min = rndfloat(1) > 0.5 ? block.Max : block.Min;		
		
		if (count[blockID] / totalCount < min)
		{
			chosenBlockID = blockID;
			break;
		} 

		local diff = block.Max - (count[blockID] / totalCount);
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
		foreach (blockID, num in count)
		{
			printn(blockID + ": " + num + "(" + upgradeCount[blockID] + "U) (" + (100 * num / totalCount) + "%)");
		}
	}

	if (totalCount > idealSize && rndfloat(1) > 0.5)
	{
		upgradeUnit(chosenBlockID);
	}
	else
	{
		spawnUnit(chosenBlockID);
	}
}

foreach (blockID, num in count)
{
	printn(blockID + ": " + num + "(" + upgradeCount[blockID] + "U) (" + (100 * num / totalCount) + "%)");
}

print("Total Units: " + totalCount);