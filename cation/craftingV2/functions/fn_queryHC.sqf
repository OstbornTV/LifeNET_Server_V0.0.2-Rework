/*
    File: fn_queryHC.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Fetches crafting plans and points from database.
*/
if !(!hasInterface && !isDedicated) exitWith {};
params [
    ["_pid","",[""]],
    ["_sender",objNull,[objNull]],
    ["_side",sideUnknown,[civilian]]
];

if (_pid isEqualTo "" || _sender isEqualTo objNull) exitWith {}; // check if variable are initialized

private _query = switch (_side) do { // switch player side and build query string
    case civilian: { format["SELECT crafting.civ_plans, crafting.civ_points FROM crafting WHERE playerid='%1'",_pid]; };
    case west: { format["SELECT crafting.cop_plans, crafting.cop_points FROM crafting WHERE playerid='%1'",_pid]; };
    case independent: { format["SELECT crafting.med_plans, crafting.med_points FROM crafting WHERE playerid='%1'",_pid]; };
    case east: { format["SELECT crafting.east_plans, crafting.east_points FROM crafting WHERE playerid='%1'",_pid]; };
};
private _queryResult = [_query,2] call HC_fnc_asyncCall; // execute query

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if logging is enabled
    diag_log "------ Fetch Crafting Data From Database -------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};

if (_queryResult isEqualTo []) exitWith { // if result is empty
    [_pid,_sender,_side] spawn cat_craftingV2_fnc_addHC; // try to add database entry
};

if (_queryResult isEqualType "") exitWith { // if result is of type STRING
    [_pid,_sender,_side] spawn cat_craftingV2_fnc_addHC; // try to add database entry
};

if (count _queryResult isEqualTo 0) exitWith { // if result is empty
    [_pid,_sender,_side] spawn cat_craftingV2_fnc_addHC; // try to add database entry
};

private _plans = [_queryResult select 0] call HC_fnc_mresToArray; // parse plans array of index 0
if (_plans isEqualType "") then {_plans = call compile format["%1", _plans];}; // if array is of type STRING, format it as ArmA array

// Convert tiny int to boolean
for "_i" from 0 to (count _plans)-1 do { // for each plan array entry
    private _data = _plans select _i; // get data on index
    _plans set[_i,[_data select 0, ([_data select 1,1] call HC_fnc_bool)]]; // convert int to boolean
};

private _points = _queryResult select 1; // get points from result index 1

if ((getNumber(missionConfigFile >> "Cation_Crafting" >> "DebugMode")) isEqualTo 1) then {// if logging is enabled
    diag_log format ["Plans: %1",_plans];
    diag_log format ["Points: %1",_points];
    diag_log "------------------------------------------------";
};

[_plans] remoteExecCall ["cat_craftingV2_fnc_initPlans",_sender]; // call initialize plans
[_points] remoteExecCall ["cat_craftingV2_fnc_initLevel",_sender]; // call initialize points