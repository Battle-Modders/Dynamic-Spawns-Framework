::DynamicSpawns.Class.WeightedArray <- class extends ::MSU.Class.WeightedContainer
{
	Array = null;

	constructor( _array = null )
	{
		this.Array = [];
		base.constructor(_array);
	}

	function _get( _idx )
	{
		if (_idx < this.Array.len()) return this.Array[_idx];
		throw null;
	}

	function _nexti( _prev )
	{
		if (this.Array.len() == 0)
			return null;

		if (_prev == null)
			return 0;
		else if (_prev == this.Array.len() - 1)
			return null;

		return _prev + 1;
	}

	function _cloned( _original )
	{
		this.Total = _original.Total;
		this.Table = clone _original.Table;
		this.Forced = clone _original.Forced;
		this.Array = clone _original.Array;
	}

	function clear()
	{
		base.clear();
		this.Array.clear();
	}

	function add( _item, _weight = 1 )
	{
		local len = this.len();
		base.add(_item, _weight);
		if (this.len() > len)
			this.Array.push(_item);
	}

	function push( _item )
	{
		this.add(_item);
	}

	function append( _item )
	{
		this.add(_item);
	}

	function extend( _array )
	{
		foreach (item in _array)
		{
			this.add(item);
		}
	}

	function pop()
	{
		if (this.Array.len() != 0)
			this.remove(this.Array.len() - 1);
	}

	function remove( _idx )
	{
		base.remove(this.Array.remove(_idx));
	}

	function sort( _function )
	{
		this.Array.sort(_function);
	}

	function onDeserialize( _in )
	{
		base.onDeserialize(_in);
		this.Array = array(this.Table.len());
		local i = 0;
		foreach (key, _ in this.Table)
		{
			this.Array[i++] = key;
		}
	}
}
