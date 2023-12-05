
::include("mod_dynamic_spawns/classes_solid/spawnable");
// ::includeFiles(::IO.enumerateFiles("mod_dynamic_spawns/classes"));
::includeFiles(::IO.enumerateFiles("mod_dynamic_spawns/classes_solid"));

::include("mod_dynamic_spawns/config");
::include("mod_dynamic_spawns/public");
::include("mod_dynamic_spawns/static");
::include("mod_dynamic_spawns/tests");
// ::include("mod_dynamic_spawns/data/load");

::includeFiles(::IO.enumerateFiles("mod_dynamic_spawns/hooks"));



// if (benchmark)
