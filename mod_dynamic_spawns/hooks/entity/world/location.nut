::DynamicSpawns.MH.hook("scripts/entity/world/location", function(q) {
	q.createDefenders = @(__original) function()
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

		local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(this.m.DefenderSpawnList, resources);
		if (dynamicParty != null)
		{
			this.m.Troops = [];		// Whatever was in this camp before is getting wiped

			if (::Time.getVirtualTimeF() - this.m.LastSpawnTime <= 60.0)
			{
				this.m.DefenderSpawnDay = ::World.getTime().Days - 7;
			}
			else
			{
				this.m.DefenderSpawnDay = ::World.getTime().Days;
			}

			dynamicParty.__IsLocation = true; // TODO: Not so happy with this, should think of something better
			// The above calculations are a copy of vanilla code
			foreach (troop in dynamicParty.spawn(resources).getTroops())
			{
				for (local i = 0; i < troop.Num; i++)
				{
					::Const.World.Common.addTroop(this, troop, false);
				}
			}

			this.updateStrength();
		}
		else
		{
			return __original();
		}
	}
});
