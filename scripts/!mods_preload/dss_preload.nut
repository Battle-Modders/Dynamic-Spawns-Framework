::DSS <- {
	Version = "0.1.0",
	ID = "mod_dss",
	Name = "Dynamic Spawn System (DSS)",
};

::mods_registerMod(::DSS.ID, ::DSS.Version, ::DSS.Name);
::mods_queue(::DSS.ID, "mod_msu", function() {

	::DSS.Mod <- ::MSU.Class.Mod(::DSS.ID, ::DSS.Version, ::DSS.Name);

	::DSS.Const <- {
		DetailedLogging = false,
		Iterations = 3,
		Benchmark = false
	};

	::include("mod_dss/load.nut");

	// Testing
	local party = ::DSS.Parties.LookupMap["Barbarians"];
	local spawnProcess = ::new(::DSS.Class.SpawnProcess);
	for (local i = 0; i < ::DSS.Const.Iterations; i++)
	{	
		::logWarning("---------------------------------- ROUND " + (i + 1) + " ------------------------------------");
		// spawnProcess.spawn(party, 250, -1, 12, 12);		// Exact 12 enemies, no more, no less
		// spawnProcess.spawn(party, 400);					// Just spend all resources. Because of no specified idealsize this results in a uber-upgraded small group
		// spawnProcess.spawn(party, 400, 17);				// Balanced Party because of idealSize 17
		// spawnProcess.spawn(party, 800, 32);				// Balanced bigger Party medium strength
		spawnProcess.spawn(party, 1000, 32);				// Balanced bigger Party high strength
	}

	party = ::DSS.Parties.LookupMap["SouthernArmy"];
	for (local i = 0; i < ::DSS.Const.Iterations; i++)
	{	
		::logWarning("---------------------------------- ROUND " + (i + 1) + " ------------------------------------");
		// spawnProcess.spawn(party);			// No Resources given so just spawns until HardMin is satisfied
		// spawnProcess.spawn(party, 250, -1, 12, 12);		// Exact 12 enemies, no more, no less
		// spawnProcess.spawn(party, 400);					// Just spend all resources. Because of no specified idealsize this results in a uber-upgraded small group
		spawnProcess.spawn(party, 400, 17);				// Balanced Party because of idealSize 17
		// spawnProcess.spawn(party, 800, 32);				// Balanced bigger Party medium strength
	}
	
});
