/*
    File: fn_init.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Initializes main variables and starts query of information from server
*/
[] spawn {
    if (!hasInterface) exitWith {}; // if not headless
	waitUntil {!isNull (findDisplay 46)}; // wait until game started

    private _flag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; case east: {"east"};}; // get side
	{
		private _varname = getText(_x >> "variable"); // get variable name
        private _plan = format["cat_crafting_plan_%1_%2",_flag,_varname]; // get plan variable name
		missionNamespace setVariable [_plan,false]; // initialize plan with owned: false
	} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "plans")); // for each plan

    missionNamespace setVariable ["cat_crafting_points",0]; // initialize points with 0
    missionNamespace setVariable ["cat_crafting_level",0]; // initialize points with 0
    
    if (getNumber(missionConfigFile >> "Cation_CraftingV2" >> "HeadlessSupport") isEqualTo 0) then { // if headless client is not enabled
        [getPlayerUID player,player,playerSide] remoteExecCall ["cat_craftingV2_fnc_query",2]; // call server
    } else {
        if (life_HC_isActive) then { // if headless client is available
            [getPlayerUID player,player,playerSide] remoteExecCall ["cat_craftingV2_fnc_queryHC",HC_Life]; // call headless client
        } else { // else headless client unavailable
            [getPlayerUID player,player,playerSide] remoteExecCall ["cat_craftingV2_fnc_query",2]; // call server
        };
    };
};

