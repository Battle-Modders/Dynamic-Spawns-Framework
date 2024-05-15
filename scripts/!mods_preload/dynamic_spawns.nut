::DynamicSpawns <- {
	Version = "0.3.3",
	ID = "mod_dynamic_spawns",
	Name = "Dynamic Spawns",
	GitHubURL = "https://github.com/Battle-Modders/Dynamic-Spawns-Framework",
	Class = {}
};

::mods_registerMod(::DynamicSpawns.ID, ::DynamicSpawns.Version, ::DynamicSpawns.Name);
::mods_queue(::DynamicSpawns.ID, "mod_msu", function() {

	::DynamicSpawns.Mod <- ::MSU.Class.Mod(::DynamicSpawns.ID, ::DynamicSpawns.Version, ::DynamicSpawns.Name);

	::DynamicSpawns.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, ::DynamicSpawns.GitHubURL);
	::DynamicSpawns.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::DynamicSpawns.Const <- {
		Logging = false,
		DetailedLogging = false,
		Iterations = 3,
		Benchmark = false,
		MainMenuIdealSize = 12
	};

	::include("mod_dynamic_spawns/load.nut");

	// testing();
});

function testing()
{
	::logWarning("---------------------------------- Army With Static Units ------------------------------------");
	local party = ::DynamicSpawns.Parties.LookupMap["SouthernArmyWithLeader"];
	::DynamicSpawns.Class.SpawnProcess(party, 1000, 32).spawn();

	// Testing
	local party = ::DynamicSpawns.Parties.LookupMap["Barbarians"];
	for (local i = 0; i < ::DynamicSpawns.Const.Iterations; i++)
	{
		::logWarning("---------------------------------- ROUND " + (i + 1) + " ------------------------------------");
		// spawnProcess.spawn(party, 250, -1, 12, 12);		// Exact 12 enemies, no more, no less
		// spawnProcess.spawn(party, 400);					// Just spend all resources. Because of no specified idealsize this results in a uber-upgraded small group
		// spawnProcess.spawn(party, 400, 17);				// Balanced Party because of idealSize 17
		// spawnProcess.spawn(party, 800, 32);				// Balanced bigger Party medium strength
		::DynamicSpawns.Class.SpawnProcess(party, 1000, 32).spawn();				// Balanced bigger Party high strength
	}

	party = ::DynamicSpawns.Parties.LookupMap["Noble"];
	for (local i = 0; i < ::DynamicSpawns.Const.Iterations; i++)
	{
		::logWarning("---------------------------------- ROUND " + (i + 1) + " ------------------------------------");
		// spawnProcess.spawn(party);			// No Resources given so just spawns until HardMin is satisfied
		// spawnProcess.spawn(party, 250, -1, 12, 12);		// Exact 12 enemies, no more, no less
		// spawnProcess.spawn(party, 400);					// Just spend all resources. Because of no specified idealsize this results in a uber-upgraded small group
		::DynamicSpawns.Class.SpawnProcess(party, 600, 25).spawn();				// Balanced Party because of idealSize 17
		// spawnProcess.spawn(party, 800, 32);				// Balanced bigger Party medium strength
	}
}
