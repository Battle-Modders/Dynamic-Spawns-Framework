
::include("mod_dynamic_spawns/classes/spawnable");
foreach (file in ::IO.enumerateFiles("mod_dynamic_spawns/classes"))
{
	::include(file);
}

::include("mod_dynamic_spawns/config");
::include("mod_dynamic_spawns/private");
::include("mod_dynamic_spawns/public");
::include("mod_dynamic_spawns/static");
::include("mod_dynamic_spawns/data/load");

::includeFiles(::IO.enumerateFiles("mod_dynamic_spawns/hooks"));



// if (benchmark)
