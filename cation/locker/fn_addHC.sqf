/*
    File: fn_addLockerHC.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Inserts locker in database.
*/
if !(!hasInterface && !isDedicated) exitWith {};
params [
    ["_pid","",[""]],
    ["_side",sideUnknown,[civilian]],
    ["_sender",objNull,[objNull]]
];
if (_pid isEqualTo "" || _side isEqualTo "" || isNull _sender) exitWith {};

private _query = switch (_side) do {
    case civilian: { format["SELECT locker.civ_locker, locker.civ_level FROM locker WHERE playerid='%1'",_pid]; };
    case west: { format["SELECT locker.cop_locker, locker.cop_level FROM locker WHERE playerid='%1'",_pid]; };
    case independent: { format["SELECT locker.med_locker, locker.med_level FROM locker WHERE playerid='%1'",_pid]; };
    case east: { format["SELECT locker.east_locker, locker.east_level FROM locker WHERE playerid='%1'",_pid]; };
};
private _queryResult = [_query,2] call HC_fnc_asyncCall;
private _exit = 0;
if !(_queryResult isEqualTo []) then {
    _exit = 1;
};
if !(count _queryResult isEqualTo 0) then {
    _exit = 2;
};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "DebugMode")) isEqualTo 1) then {
    diag_log "- Check if there is a locker entry in Database -";
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
if (_exit > 0) exitWith {
    [_pid,_side,_sender] call cat_locker_fnc_fetchTrunkHC;
};

_query = format ["DELETE FROM locker WHERE playerid='%1'",_pid];
_queryResult = [_query,2] call HC_fnc_asyncCall;
waitUntil {!isNil "_queryResult"};
_query = format ["INSERT INTO locker (playerid, civ_locker, cop_locker, med_locker, east_locker, civ_level, cop_level, med_level, east_level) VALUES('%1', '""[]""','""[]""','""[]""','""[]""','0','0','0','0')",_pid];
_queryResult = [_query,2] call HC_fnc_asyncCall;
waitUntil {!isNil "_queryResult"};

if ((getNumber(missionConfigFile >> "Cation_Locker" >> "DebugMode")) isEqualTo 1) then {
    diag_log "------------- Add Locker To Database -----------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};

[_pid,_side,_sender] call cat_locker_fnc_fetchTrunkHC;