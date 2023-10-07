
::include("mod_dynamic_spawns/classes/spawnable");
::includeFiles(::IO.enumerateFiles("mod_dynamic_spawns/classes"));

::include("mod_dynamic_spawns/config");
::include("mod_dynamic_spawns/public");
::include("mod_dynamic_spawns/static");
::include("mod_dynamic_spawns/data/load");

::includeFiles(::IO.enumerateFiles("mod_dynamic_spawns/hooks"));



// if (benchmark)
