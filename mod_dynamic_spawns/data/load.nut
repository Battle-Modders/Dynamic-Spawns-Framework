local function includeFiles( _path )
{
	foreach (file in ::IO.enumerateFiles())
	{
		::include(file);
	}
}

includeFiles("mod_dynamic_spawns/data/units");
includeFiles("mod_dynamic_spawns/data/unitsblocks");
includeFiles("mod_dynamic_spawns/data/parties");
