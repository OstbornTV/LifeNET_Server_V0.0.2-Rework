/*
    File: fn_addHC.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Inserts crafting data in database.
*/
if !(!hasInterface && !isDedicated) exitWith {};
params [
    ["_pid","",[""]],
    ["_sender",objNull,[objNull]],
    ["_side",sideUnknown,[civilian]]
];
if (_pid isEqualTo "" || _sender isEqualTo objNull) exitWith {}; // check if variables are set

private _query = format["SELECT crafting.civ_plans, crafting.cop_plans, crafting.med_plans, crafting.east_plans, crafting.civ_points, crafting.cop_points, crafting.med_points, crafting.east_points FROM crafting WHERE playerid='%1'",_pid]; // db query string
private _queryResult = [_query,2] call HC_fnc_asyncCall; // execute query
private _exit = 0; // initialize error variable
if !(_queryResult isEqualTo []) then { // if result not equals an array
    _exit = 1; // set variable to 1
};
if !(count _queryResult isEqualTo 0) then { // if result array is not empty
    _exit = 2; // set variable to 2
};
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // handle logging
    diag_log "- Check if there is a crafting entry in database -";
    diag_log format ["QUERY: %1",_query];    
    diag_log format ["Result: %1",_queryResult];
    if (_exit isEqualTo 1) then {
        diag_log "ENTRY FOUND 1";
        diag_log "------------------------------------------------";
    };
    if (_exit isEqualTo 2) then {
        diag_log "ENTRY FOUND 2";
        diag_log "------------------------------------------------";
    };
    diag_log "NO ENTRY FOUND";
    diag_log "------------------------------------------------";
};
if (_exit > 0) exitWith { // exit if variable greater than 0, there is already an entry in the database -> call query funtion
    [_pid,_sender,_side] call cat_craftingV2_fnc_queryHC;
};

_query = format ["DELETE FROM crafting WHERE playerid='%1'",_pid]; // Query string to delete all available entries for player to be sure nothing is left
_queryResult = [_query,2] call HC_fnc_asyncCall; // execute query
waitUntil {!isNil "_queryResult"}; // wait for result
_query = format ["INSERT INTO crafting (playerid, civ_plans, cop_plans, med_plans, east_plans, civ_points, cop_points, med_points, east_points) VALUES('%1', '""[]""', '""[]""', '""[]""', '""[]""','0','0','0','0')",_pid]; // Query string to insert new crafting entry for player
_queryResult = [_query,2] call HC_fnc_asyncCall; // execute query
waitUntil {!isNil "_queryResult"}; // wait for result

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // handle logging
    diag_log "-------- Add Crafting Data To Database ---------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};

[_pid,_sender,_side] call cat_craftingV2_fnc_queryHC; // call query function