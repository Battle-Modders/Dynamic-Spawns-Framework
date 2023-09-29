::DynamicSpawns.__metaObject <- {
	function _get( _key )
	{
		if (typeof _key == "function")
			return this.__ParentClass[_key];
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

::DynamicSpawns.__partyMeta <- {
	__ParentClass = ::DynamicSpawns.Class.Party
}
::DynamicSpawns.__partyMeta.setdelegate(::DynamicSpawns.__metaObject);

::DynamicSpawns.__unitBlockMeta <- {
	__ParentClass = ::DynamicSpawns.Class.UnitBlock
}
::DynamicSpawns.__unitBlockMeta.setdelegate(::DynamicSpawns.__metaObject);

::DynamicSpawns.__unitMeta <- {
	__ParentClass = ::DynamicSpawns.Class.Unit
}
::DynamicSpawns.__unitMeta.setdelegate(::DynamicSpawns.__metaObject);
