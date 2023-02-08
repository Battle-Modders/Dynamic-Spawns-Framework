// Redirect Vanilla addUnitsToEntity function to our remake
// Note: This will potentially skip hooks from other mods when they execute their code at the end of this vanilla function

::mods_hookBaseClass("contracts/contract", function(o)
{
    while(!("EmployerID" in o.m)) o = o[o.SuperName]; // find the base class

    local oldAddUnitsToEntity = o.addUnitsToEntity;
    o.addUnitsToEntity = function( _worldParty, _party, _resources )
    {
        if (::DynamicSpawns.Static.isDynamicParty(_party))    // check whether _partyList is a dynamic list or rather do we have already defined dynamic behavior for that?
        {
            // ::logWarning("Sucessful redirect to custom assignTroops");
            return ::DynamicSpawns.Static.addTroops(_worldParty, _party, _resources);
        }
        return oldAddUnitsToEntity(_worldParty, _party, _resources);
    }
});
