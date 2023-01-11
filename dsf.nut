// dsf-1

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

local unitBlocks = {
	Frontline = { Cost = 70, Min = 0.6, Max = 0.8 },
	Backline = { Cost = 50, Min = 0.1, Max = 0.4 },
	Support = { Cost = 10, Min = 0.05, Max = 0.2 }
}

local totalCount = 0.0;
local count = {};
local unitBlockIDs = [];
foreach (blockID, block in unitBlocks)
{	
	count[blockID] <- 0;
	unitBlockIDs.push(blockID);
}

local resources = 1000;

printn("======================================================================")

while (resources > 0)
{
	local diffFromMax = 0;
	local chosenBlockID;
	foreach (blockID, block in unitBlocks)
	{		
		// print("Checking block: " + blockID + ". Current Ratio: " + (count[totalCount] / total));
		if (count[blockID] == 0 && block.Min != 0)
		{
			chosenBlockID = blockID;
			break;
		}

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

	// foreach (blockID, num in count)
	// {
	// 	printn(blockID + ": " + num + " (" + (100 * num / totalCount) + "%)");
	// }

	// printn("\nSpawning: " + chosenBlockID + "\n");

	count[chosenBlockID] += 1;
	totalCount++;
	resources -= unitBlocks[chosenBlockID].Cost;
}

foreach (blockID, num in count)
{
	printn(blockID + ": " + num + " (" + (100 * num / totalCount) + "%)");
}