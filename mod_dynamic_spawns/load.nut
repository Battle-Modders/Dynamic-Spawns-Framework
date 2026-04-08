
::include("mod_dynamic_spawns/classes/spawnable");
foreach (file in ::IO.enumerateFiles("mod_dynamic_spawns/classes"))
{
	::include(file);
}

::include("mod_dynamic_spawns/config");
::include("mod_dynamic_spawns/public");
::include("mod_dynamic_spawns/static");
::include("mod_dynamic_spawns/tests");
// ::include("mod_dynamic_spawns/data/load");

foreach (file in ::IO.enumerateFiles("mod_dynamic_spawns/hooks"))
{
	::include(file);
}

foreach (file in ::IO.enumerateFiles("mod_dynamic_spawns/msu_systems"))
{
	::include(file);
}
