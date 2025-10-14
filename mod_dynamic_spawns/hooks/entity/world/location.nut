::DynamicSpawns.QueueBucket.Late.push(function() {
	::DynamicSpawns.MH.hook("scripts/entity/world/location", function(q) {
		q.createDefenders = @(__original) function()
		{
			__original();

			// We let the original function spawn a vanilla party. Then we look at the
			// worth of this party and replace it with our dynamic party of similar worth.
			// This method ensures that any resource scaling etc. from the original function
			// and any modifications thereof by mods etc. are automatically accounted for.
			local worth = 0;
			foreach (t in this.m.Troops)
			{
				worth += t.Cost;
			}

			local dynamicParty = ::DynamicSpawns.Static.retrieveDynamicParty(this.m.DefenderSpawnList, worth);
			if (dynamicParty != null)
			{
				// We force the __original function to choose this dynamically spawned party
				// by making it the only available choice by switcherooing DefenderSpawnList.
				local DefenderSpawnList_original = this.m.DefenderSpawnList;
				this.m.DefenderSpawnList = [
					{
						Cost = worth,
						Troops = dynamicParty.spawn(worth).getTroops()
					}
				];

				// Call the original function again to now spawn our dynamic party
				__original();

				this.m.DefenderSpawnList = DefenderSpawnList_original;
			}
		}
	});
})
