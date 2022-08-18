/*
    File: fn_updatePlans.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Save crafting plans in database.
*/
if (!isServer) exitWith {};
params [
    ["_pid","",[""]],
	["_plans",[],[[]]],
    ["_side",sideUnknown,[civilian]]
];
if (_pid isEqualTo "") exitWith {};

// Convert boolean to tiny int
for "_i" from 0 to count(_plans)-1 do {
    private _bool = [(_plans select _i) select 1] call DB_fnc_bool;
    _plans set[_i,[(_plans select _i) select 0,_bool]];
};
_plans = [_plans] call DB_fnc_mresArray;

private _query = switch (_side) do { // switch player side and build query string
    case civilian: { format["UPDATE crafting SET civ_plans='%1' WHERE playerid='%2'",_plans,_pid]; };
    case west: { format["UPDATE crafting SET cop_plans='%1' WHERE playerid='%2'",_plans,_pid]; };
    case independent: { format["UPDATE crafting SET med_plans='%1' WHERE playerid='%2'",_plans,_pid]; };
    case east: { format["UPDATE crafting SET east_plans='%1' WHERE playerid='%2'",_plans,_pid]; };
};
private _queryResult = [_query,1] call DB_fnc_asyncCall;

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then {
    diag_log "------- Update Crafting Plans To Database ------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["QUERYRESULT: %1",_queryResult];
    diag_log "------------------------------------------------";
    diag_log format ["PLANS: %1",_plans];
    diag_log "------------------------------------------------";
};