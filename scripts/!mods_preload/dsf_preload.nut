::DynamicSpawns <- {
	Version = "0.1.0",
	ID = "mod_dynamic_spawns",
	Name = "Dynamic Spawns",
};

::mods_registerMod(::DynamicSpawns.ID, ::DynamicSpawns.Version, ::DynamicSpawns.Name);
::mods_queue(::DynamicSpawns.ID, "mod_msu", function() {

	::DynamicSpawns.Mod <- ::MSU.Class.Mod(::DynamicSpawns.ID, ::DynamicSpawns.Version, ::DynamicSpawns.Name);

	::DynamicSpawns.Const <- {
		DetailedLogging = false,
		Iterations = 3,
		Benchmark = false
	};

	::include("mod_dsf/load.nut");

	// testing();
});

function testing()
{
	::logWarning("---------------------------------- Army With Static Units ------------------------------------");
	local party = ::DynamicSpawns.Parties.LookupMap["SouthernArmyWithLeader"];
	local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
	spawnProcess.init(party, 1000, 32).spawn();

	// Testing
	local party = ::DynamicSpawns.Parties.LookupMap["Barbarians"];
	local spawnProcess = ::new(::DynamicSpawns.Class.SpawnProcess);
	for (local i = 0; i < ::DynamicSpawns.Const.Iterations; i++)
	{
		::logWarning("---------------------------------- ROUND " + (i + 1) + " ------------------------------------");
		// spawnProcess.spawn(party, 250, -1, 12, 12);		// Exact 12 enemies, no more, no less
		// spawnProcess.spawn(party, 400);					// Just spend all resources. Because of no specified idealsize this results in a uber-upgraded small group
		// spawnProcess.spawn(party, 400, 17);				// Balanced Party because of idealSize 17
		// spawnProcess.spawn(party, 800, 32);				// Balanced bigger Party medium strength
		spawnProcess.init(party, 1000, 32).spawn();				// Balanced bigger Party high strength
	}

	party = ::DynamicSpawns.Parties.LookupMap["Noble"];
	for (local i = 0; i < ::DynamicSpawns.Const.Iterations; i++)
	{
		::logWarning("---------------------------------- ROUND " + (i + 1) + " ------------------------------------");
		// spawnProcess.spawn(party);			// No Resources given so just spawns until HardMin is satisfied
		// spawnProcess.spawn(party, 250, -1, 12, 12);		// Exact 12 enemies, no more, no less
		// spawnProcess.spawn(party, 400);					// Just spend all resources. Because of no specified idealsize this results in a uber-upgraded small group
		spawnProcess.init(party, 600, 25).spawn();				// Balanced Party because of idealSize 17
		// spawnProcess.spawn(party, 800, 32);				// Balanced bigger Party medium strength
	}
}
