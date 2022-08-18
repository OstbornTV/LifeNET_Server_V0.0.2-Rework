/*
    File: fn_updatePlansClient.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Gets crafting plans of client and sends it to server
*/
private _array = [];
private _flag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; case east: {"east"};};
{
	private _varname = getText(_x >> "variable");
	private _plan = format["cat_crafting_plan_%1_%2",_flag,_varname];
    _array pushBack [_plan,missionNamespace getVariable [_plan,false]];
} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "plans"));

if (getNumber(missionConfigFile >> "Cation_CraftingV2" >> "HeadlessSupport") isEqualTo 0) then {
    [getPlayerUID player,_array,playerSide] remoteExecCall ["cat_craftingV2_fnc_updatePlans",2];
} else {
    if (life_HC_isActive) then {
        [getPlayerUID player,_array,playerSide] remoteExecCall ["cat_craftingV2_fnc_updatePlansHC",HC_Life];
    } else {
	    [getPlayerUID player,_array,playerSide] remoteExecCall ["cat_craftingV2_fnc_updatePlans",2];
    };
};