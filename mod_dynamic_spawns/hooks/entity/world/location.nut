::mods_hookExactClass("entity/world/location", function(o) {
	local oldCreateDefenders = o.createDefenders;
	o.createDefenders = function()
	{
		if (::DynamicSpawns.Static.isDynamicParty(this.m.DefenderSpawnList))    // check whether _partyList is a dynamic list or rather do we have already defined dynamic behavior for that?
		{
			// This is 1 to 1 copy of vanilla resource scaling
			local resources = this.m.Resources;

			if (this.m.IsScalingDefenders)
			{
				resources = resources * ::Math.minf(3.0, 1.0 + ::World.getTime().Days * 0.0075);
			}

			if (!this.isAlliedWithPlayer())
			{
				resources = resources * ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
			}

			if (::Time.getVirtualTimeF() - this.m.LastSpawnTime <= 60.0)
			{
				resources = resources * 0.75;
			}

			this.m.Troops = [];

			if (::Time.getVirtualTimeF() - this.m.LastSpawnTime <= 60.0)
			{
				this.m.DefenderSpawnDay = ::World.getTime().Days - 7;
			}
			else
			{
				this.m.DefenderSpawnDay = ::World.getTime().Days;
			}

			return ::DynamicSpawns.Static.addTroops(this, this.m.DefenderSpawnList, resources);
		}

		return oldCreateDefenders();
	}
});
