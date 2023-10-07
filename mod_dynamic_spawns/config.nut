::DynamicSpawns.UnitBlocks <- {
	LookupMap = {},
	BaseClass = ::DynamicSpawns.Class.UnitBlock,
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DynamicSpawns.Parties <- {
	LookupMap = {},
	BaseClass = ::DynamicSpawns.Class.Party,
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}
::DynamicSpawns.Units <- {
	LookupMap = {},
	BaseClass = ::DynamicSpawns.Class.Unit,
	function findById( _id )
	{
		return this.LookupMap[_id];
	}
}

::DynamicSpawns.Data <- {};

::DynamicSpawns.__setClass <- function( _class, _def )
{
	if ("Class" in _def)
		_class = _def.Class;

	local hasFunction = false;
	foreach (key, value in _def)
	{
		if (typeof value == "function")
		{
			hasFunction = true;
			_class = class extends _class
			{
				constructor( _def )
				{
					base.constructor(_def);
				}
			}
			break;
		}
	}

	if (hasFunction)
	{
		local funcKeys = [];
		foreach (key, value in _def)
		{
			if (typeof value == "function")
			{
				funcKeys.push(key);
				_class[key] <- value;
			}
		}
		foreach (key in funcKeys)
		{
			delete _def[key];
		}
	}

	_def.Class <- _class;

	return _class;
}

// Creates an instance of the appropriate class from the given _def
// Creates a temporary sub-class when necessary
::DynamicSpawns.__getObjectFromDef <- function( _def, _dataset )
{
	if (typeof _def == "string")
	{
		_def = _dataset.LookupMap[_def];
		if (_def instanceof ::MSU.Class.WeightedContainer)
			_def = _dataset.LookupMap[_def + "_0"];
		return _def.Class(_def).init();
	}

	if (_def instanceof _dataset.BaseClass)
		return (clone _def).init();

	if ("ID" in _def)
	{
		local baseDef = _dataset.LookupMap[_def.ID];
		::DynamicSpawns.__setClass(baseDef.Class, _def);
		local ret = _def.Class(baseDef);
		ret.copyDataFromDef(_def);
		return ret.init();
	}
	else
	{
		::DynamicSpawns.__setClass(_dataset.BaseClass, _def);
		local ret = _def.Class(_def);
		ret.ID = ret + "";
		return ret.init();
	}
}
