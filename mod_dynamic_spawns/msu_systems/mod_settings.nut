local debugPage = ::DynamicSpawns.Mod.ModSettings.addPage("Debug");

debugPage.addBooleanSetting("Debug_SpawnsLogging", false, "Spawns Logging", "Print to log every spawn of a party.").addAfterChangeCallback(@( _ ) ::DynamicSpawns.Const.Logging = this.getValue());
debugPage.addBooleanSetting("Debug_SpawnsDetailedLogging", false, "Spawns Detailed Logging", "Print to log every step of the spawn process of a party.").addAfterChangeCallback(@( _ ) ::DynamicSpawns.Const.DetailedLogging = this.getValue());
