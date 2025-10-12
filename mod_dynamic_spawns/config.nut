::DynamicSpawns.getIndent <- function()
{
	local ret = "";
	for (local i = 0; i < ::DynamicSpawns.Indent; i++)
	{
		ret += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	return ret;
}
::DynamicSpawns.Indent <- -1;

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
			_def = ::DynamicSpawns.__getObjectFromDef(_def + "_0");
		return _def.Class(_def).init();
	}

	if (_def instanceof _dataset.BaseClass)
		return (clone _def).init();

	if ("BaseID" in _def)
	{
		local baseDef = _dataset.LookupMap[_def.BaseID];
		::DynamicSpawns.__setClass(baseDef.Class, _def);
		local ret = _def.Class(baseDef);
		ret.copyDataFromDef(_def);
		if (ret.ID == baseDef.ID) ret.ID += ret + "";
		return ret.init();
	}
	else
	{
		::DynamicSpawns.__setClass(_dataset.BaseClass, _def);
		local ret = _def.Class(_def);
		if (ret.ID == "") ret.ID = ret + "";
		return ret.init();
	}
}

// Unlike squirrel array.sort, this preserves the order of equal members and also returns the array at the end.
// Uses Insertion Sort algorithm. Merge Sort is slow in squirrel even for large arrays (even len 1000 array is ~1000% slower than Insertion Sort).
// A hybrid of Insertion and Merge is also considerably slower than pure Insertion (~700% slower for 1000 len array).
// This feature is planned to be implemented in MSU but until that happens we've implemented a private version of it here.
::DynamicSpawns.__stableSort <- function( _array, _compareFunc = null )
{
	if (_array.len() <= 1)
		return _array;

	local len = _array.len();
	for (local i = 1; i < len; i++)
	{
		local key = _array[i];
		local j = i - 1;

		while (j >= 0 && (_compareFunc ? _compareFunc(_array[j], key) > 0 : _array[j] > key))
		{
			_array[j + 1] = _array[j];
			j--;
		}

		_array[j + 1] = key;
	}

	return _array;
}
