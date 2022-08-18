/*
    File: fn_updateTrunk.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Updates locker inventory in database.
*/
if (!isServer) exitWith {};
params [
    ["_inv",[],[[]]],
    ["_level",0,[0]],
    ["_pid","",[""]],
    ["_side",sideUnknown,[civilian]]
];
if (_pid isEqualTo "" || _side isEqualTo sideUnknown) exitWith {};

_inv = [_inv] call DB_fnc_mresArray;
private _query = switch (_side) do {
    case civilian: { format["UPDATE locker SET civ_locker='%1', civ_level='%2' WHERE playerid='%3'",_inv,_level,_pid]; };
    case west: { format["UPDATE locker SET cop_locker='%1', cop_level='%2' WHERE playerid='%3'",_inv,_level,_pid]; };
    case independent: { format["UPDATE locker SET med_locker='%1', med_level='%2' WHERE playerid='%3'",_inv,_level,_pid]; };
    case east: { format["UPDATE locker SET east_locker='%1', east_level='%2' WHERE playerid='%3'",_inv,_level,_pid]; };
};
private _queryResult = [_query,1] call DB_fnc_asyncCall;

if ((getNumber(missionConfigFile >> "Cation_Locker" >> "DebugMode")) isEqualTo 1) then {
    diag_log "------------- Update Locker To Database --------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["QUERYRESULT: %1",_queryResult];
    diag_log "------------------------------------------------";
    diag_log format ["INVENTORY: %1",_inv];
    diag_log "------------------------------------------------";
};