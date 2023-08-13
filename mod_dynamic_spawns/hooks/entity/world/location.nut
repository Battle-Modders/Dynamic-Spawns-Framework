::mods_hookExactClass("entity/world/location", function(o) {
	local oldCreateDefenders = o.createDefenders;
	o.createDefenders = function()
	{
		local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(this.m.DefenderSpawnList);
		if (dynamicParty != null)    // a dynamicParty was found!
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

			// The above calculations are a copy of vanilla code
			return ::DynamicSpawns.Static.addTroops(this, dynamicParty, resources);
		}
		else
		{
			return oldCreateDefenders();
		}
	}
});
