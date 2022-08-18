/*
    File: fn_loadSecurity.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)
    
    Description:
    Loads security system entries from Database.
*/
private ["_queryResult","_query","_pid","_unit"];
_pid = param [0,"",[""]];
_unit = param [1,objNull,[objNull]];

_query = format ["SELECT houses.pos, houses.security FROM houses WHERE houses.owned='1' AND houses.security='1' AND houses.pid = '%1'",_pid];
_queryResult = [_query,2,true] call DB_fnc_asyncCall;
if ((getNumber(missionConfigFile >> "Cation_Alarm" >> "DebugMode")) isEqualTo 1) then {
    diag_log "------ load security system from database ------";
    diag_log format ["Query: %1",_query];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};
if (count _queryResult isEqualTo 0) exitWith {};
{
    _pos = call compile format ["%1",_x select 0];
    _house = nearestObject [_pos, "House"];
    if (_x select 1 isEqualTo 1) then {
        _house setVariable ["security",true,true];
		[_house] remoteExec ["cat_alarm_fnc_houseAlarmMarker",_unit];
    } else {
        _house setVariable ["security",false,true];
    };
} forEach _queryResult;