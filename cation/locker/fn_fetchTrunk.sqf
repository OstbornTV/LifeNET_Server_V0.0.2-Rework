/*
    File: fn_fetchLockerTrunk.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Fetches locker inventory from database.
*/
if (!isServer) exitWith {};
params [
    ["_pid","",[""]],
    ["_side",sideUnknown,[civilian]],
    ["_sender",objNull,[objNull]]
];

if (_pid isEqualTo "" || _side isEqualTo sideUnknown || isNull _sender) exitWith {};

private _query = switch (_side) do {
    case civilian: { format["SELECT locker.civ_locker, locker.civ_level FROM locker WHERE playerid='%1'",_pid]; };
    case west: { format["SELECT locker.cop_locker, locker.cop_level FROM locker WHERE playerid='%1'",_pid]; };
    case independent: { format["SELECT locker.med_locker, locker.med_level FROM locker WHERE playerid='%1'",_pid]; };
    case east: { format["SELECT locker.east_locker, locker.east_level FROM locker WHERE playerid='%1'",_pid]; };
};
private _queryResult = [_query,2] call DB_fnc_asyncCall;

if ((getNumber(missionConfigFile >> "Cation_Locker" >> "DebugMode")) isEqualTo 1) then {
    diag_log "------------- Fetch Locker From Database -------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};

if (_queryResult isEqualTo []) exitWith {
    [_pid,_side,_sender] spawn cat_locker_fnc_add;
};

if (_queryResult isEqualType "") exitWith {
    [_pid,_side,_sender] spawn cat_locker_fnc_add;
};

if (count _queryResult isEqualTo 0) exitWith {
    [_pid,_side,_sender] spawn cat_locker_fnc_add;
};

private _inv = [_queryResult select 0] call DB_fnc_mresToArray;
if (_inv isEqualType "") then {_inv = call compile format["%1", _inv];};

private _level = _queryResult select 1;

if ((getNumber(missionConfigFile >> "Cation_Locker" >> "DebugMode")) isEqualTo 1) then {
    diag_log format ["Inventory: %1",_inv];
    diag_log format ["Level: %1",_level];
    diag_log "------------------------------------------------";
};

[_inv,_level] remoteExecCall ["cat_locker_fnc_init",_sender];