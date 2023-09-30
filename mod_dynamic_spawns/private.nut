::DynamicSpawns.__metaObject <- {
	function _get( _key )
	{
		if (_key in this.__ParentClass) return this.__ParentClass[_key];

		throw null;
	}

	function _set( _key, _value )
	{
		if (!(_key in this.__ParentClass))
			throw format("the index \'%s\' does not exist", _key);
		this[_key] <- _value;
	}

	function _newSlot( _key, _value )
	{
		if (!(_key in this.__ParentClass))
			throw format("the index \'%s\' does not exist in the parent DynamicSpawns class for this object", _key);
		this[_key] <- _value;
	}
}

::DynamicSpawns.__partyMeta <- {__ParentClass = ::DynamicSpawns.Class.Party};
::DynamicSpawns.__partyMeta.setdelegate(::DynamicSpawns.__metaObject);

::DynamicSpawns.__unitBlockMeta <- {__ParentClass = ::DynamicSpawns.Class.UnitBlock};
::DynamicSpawns.__unitBlockMeta.setdelegate(::DynamicSpawns.__metaObject);

::DynamicSpawns.__unitMeta <- {__ParentClass = ::DynamicSpawns.Class.Unit};
::DynamicSpawns.__unitMeta.setdelegate(::DynamicSpawns.__metaObject);

::DynamicSpawns.__addFields <- function( _object, _source )
{
	foreach (key, value in _source)
	{
		if (!(key in _object))
		{
			switch (typeof value)
			{
				case "function":
					break;

				case "array":
				case "table":
				case "instance":
					_object[key] <- clone value;
					break;

				default:
					_object[key] <- value;
			}
		}
	}
}
