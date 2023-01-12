// Redirect Vanilla Spawn function to redirect to our remakes
// Note: This will potentially skip hooks from other mods when they execute their code at the end of this vanilla function
local oldAssignTroops = ::Const.World.Common.assignTroops;
::Const.World.Common.assignTroops = function( _worldParty, _partyList, _resources, _weightMode = 1 )
{
    if(::DSF.Static.isParty(_partyList))    // check whether _partyList is a dynamic list or rather do we have already defined dynamic behavior for that?
    {
        // ::logWarning("Sucessful redirect to custom assignTroops");
        return ::DSF.Static.assignTroops(_worldParty, _partyList, _resources);
    }
    return oldAssignTroops(_worldParty, _partyList, _resources, _weightMode);
}
