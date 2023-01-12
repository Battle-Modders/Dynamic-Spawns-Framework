this.party <- {
	m = {
        ID = null,
        UnitBlocks = [],	// Array of Tables that require a 'ID' and optionally 'RatioMin', 'RatioMax' and 'ReqPartySize'
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

		foreach (key, value in _party)
		{
			if (typeof value == "function")
			{
				this[key] = value;
			}
			else
			{
				this.m[key] = value;
			}
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
	function canSpawn( _spawnProcess )
	{
		if (_spawnProcess.getTotal() < this.getHardMin()) return true;
		return (this.getHardMax() == -1 || _spawnProcess.getTotal() + 1 <= this.getHardMax());
	}

	// _blockTotal = troop count of this unitBlock; _total = total count of spawned troops; _block = UnitBlock or Table with UnitBlock Id and optional parameter
	function isWithinRatioMax( _spawnProcess, _pBlock )
	{
		local referencedTotal = (_spawnProcess.getTotal() + 1 > this.getHardMin()) ? _spawnProcess.getTotal() + 1 : this.getHardMin();
		local maxAllowed = ::Math.round(this.getRatioMax(_pBlock) * referencedTotal);
		return (_spawnProcess.getBlockTotal(_pBlock.ID) < maxAllowed);
	}

	// _blockTotal = troop count of this unitBlock; _total = total count of spawned troops; _block = UnitBlock or Table with UnitBlock Id and optional parameter
	function satisfiesRatioMin( _spawnProcess, _pBlock )
	{
		local referencedTotal = (_spawnProcess.getTotal() + 1 > this.getHardMin()) ? _spawnProcess.getTotal() + 1 : this.getHardMin();		// this is just ::Math.max() function which isn't available here
		local minRequired = ::Math.floor(referencedTotal * this.getRatioMin(_pBlock));	// This floor() strictness is good to prevent exotic spawns in low troop sizes.
		// In return you will sometimes be 1 troop short of the required minimum

		return (_spawnProcess.getBlockTotal(_pBlock.ID) >= minRequired);
	}

// Getter to retrieve optional parameters out of the unitBlock tables of this Party
	function getRatioMin( _pBlock )
	{
		if ("RatioMin" in _pBlock) return _pBlock.RatioMin;
		return ::DSF.UnitBlocks.findById(_pBlock.ID).getRatioMin();
	}

	function getRatioMax( _pBlock )
	{
		if ("RatioMax" in _pBlock) return _pBlock.RatioMax;
		return ::DSF.UnitBlocks.findById(_pBlock.ID).getRatioMax();
	}

	function getReqPartySize( _pBlock )
	{
		if ("ReqPartySize" in _pBlock) return _pBlock.ReqPartySize;
		return ::DSF.UnitBlocks.findById(_pBlock.ID).getReqPartySize();
	}

};

