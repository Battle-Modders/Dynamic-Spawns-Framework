this.party <- {
	m = {
        ID = null,	
        UnitBlocks = [],	// Array of Tables that require a 'ID' and optionally 'PartMin', 'PartMax' and 'ReqSize'
        // IdealSize = 5;	
        // Resources = 0;
        HardMin = 0,		// @Darxo: Smallest army size that is allowed for this troop to even make sense. Ressources are disregarded while trying to satisfy this. Could maybe be set to 1 be default
        HardMax = -1,		// @Darxo: Greatest army size that is allowed for this troop to even make sense. All spawning (not upgrading) is stopped when this is reached
        UpgradeChance = 0.5,
        StaticUnits = null
    }

	function create()
	{
	}

    function init( _party )
	{
		this.m.ID = _party.ID;

		if("UpgradeChance" in _party) this.m.UpgradeChance = _party.UpgradeChance;
		if("HardMin" in _party) this.m.HardMin = _party.HardMin;
		if("HardMax" in _party) this.m.HardMax = _party.HardMax;
		if("UnitBlocks" in _party)	this.m.UnitBlocks = _party.UnitBlocks;

		if ("StaticUnits" in _party)	// Haven't changed yet. Dont understand yet
		{
			this.m.StaticUnits = _party.StaticUnits;
			local block = {
				ID = this.m.ID + ".Block.Static",
				Units = _party.StaticUnits
			}
			this.m.UnitBlocks.push(block);
			::DSF.UnitBlocks.LookupMap[block.ID] <- ::new(::DSF.Class.UnitBlock).init(block);
			::DSF.UnitBlocks.findById(block.ID).IsStatic = true;
		}
		return this;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getUnitBlocks()
	{
		return this.m.UnitBlocks;
	}

	function getIdealSize()
	{
		return this.m.IdealSize != null ? this.m.IdealSize : ::World.Roster.getAll().len() * 1.5;
	}

	function getHardMin()
	{
		return this.m.HardMin;
	}

	function getHardMax()
	{
		return this.m.HardMax;
	}

	function getUpgradeChance()
	{
		return this.m.UpgradeChance;
	}

	function getStaticUnitBlock()
	{
		if (this.m.StaticUnits != null) return ::DSF.UnitBlocks.findById(this.ID + ".Block.Static");
		return null;
	}

	// Checks only against HardMax and HardMin
	function canSpawn(_currentTotal)
	{
		if(_currentTotal < this.getHardMin()) return true;
		return (this.getHardMax() == -1 || _currentTotal <= this.getHardMax());
	}

	// _blockTotal = troop count of this unitBlock; _total = total count of spawned troops; _block = UnitBlock or Table with UnitBlock Id and optional parameter
	function isWithinPartMax( _blockTotal, _total, _pBlock)		// @Darxo
	{
		local maxAllowed = ((this.getPartMax(_pBlock) * _total) + 0.5).tointeger();		// 0.5 is added to replicate a round() function
		return (_blockTotal < maxAllowed);
	}

	// _blockTotal = troop count of this unitBlock; _total = total count of spawned troops; _block = UnitBlock or Table with UnitBlock Id and optional parameter
	function satisfiesPartMin( _blockTotal, _total, _pBlock)		// @Darxo
	{
		local referencedTotal = (_total > this.getHardMin()) ? _total : this.getHardMin();		// this is just ::Math.max() function which isn't available here
		local minRequired = (referencedTotal * this.getPartMin(_pBlock)).tointeger();	// tointeger() applies a floor() cut-off. This strictness is good to prevent exotic spawns in low troop sizes.
		// In return you will sometimes be 1 troop short of the required minimum
		
		// printn("_blockTotal = " + _blockTotal + "; _total = " + _total + "; _partMin = " + _partMin);
		// printn("Returned: " + (_blockTotal >= minRequired));
		return (_blockTotal >= minRequired);
	}

// Getter to retrieve optional parameters out of the unitBlock tables of this Party
	function getPartMin(_pBlock)
	{
		if ("PartMin" in _pBlock) return _pBlock.PartMin;
		return ::DSF.UnitBlocks.findById(_pBlock.ID).getPartMin();
	}

	function getPartMax(_pBlock)
	{
		if ("PartMax" in _pBlock) return _pBlock.PartMax;
		return ::DSF.UnitBlocks.findById(_pBlock.ID).getPartMax();
	}

	function getReqSize(_pBlock)
	{
		if ("ReqSize" in _pBlock) return _pBlock.ReqSize;
		return ::DSF.UnitBlocks.findById(_pBlock.ID).getReqSize();
	}

};

