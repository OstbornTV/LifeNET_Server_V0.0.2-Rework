/*
    File: fn_getInfos.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Gets information from player.
*/
if (!isServer) exitWith {};
params [
	["_receiver",objNull,[objNull]],
	["_sender",objNull,[objNull]],
	["_receiverUID","",[""]],
	["_playerSide",sideUnknown,[west]]
];
private ["_playerid"];

if (isNull _receiver || isNull _sender || _receiverUID isEqualTo "" || _playerSide isEqualTo sideUnknown) exitWith {};

private _level = switch (_playerSide) do {
	case independent: { "mediclevel" };
	case west: { "coplevel" };
};

private _licences = switch (_playerSide) do {
	case independent: { "med_licenses" };
	case west: { "cop_licenses" };
};

if ((getNumber(missionConfigFile >> "Cation_Perm" >> "version")) isEqualTo 5) then {
	_playerid = "pid";
} else {
	_playerid = "playerid";
};

_query = format ["SELECT cash, bankacc, %1, %2 FROM players WHERE %3='%4'",_level,_licences,_playerid,_receiverUID];

_queryResult = [_query,2,true] call DB_fnc_asyncCall;

if (getNumber(missionConfigFile >> "Cation_Perm" >> "DebugMode") isEqualTo 1) then {
    diag_log "------ Cation Perm System: Get Player Info --------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Result: %1",_queryResult];
    diag_log "---------------------------------------------------";
};

if (_queryResult isEqualTo []) exitWith {};

_queryResult = _queryResult select 0;

private _tmp = _queryResult select 0;
_queryResult set[0,[_tmp] call cat_perm_fnc_numberSafe];

_tmp = _queryResult select 1;
_queryResult set[1,[_tmp] call cat_perm_fnc_numberSafe];

_tmp = _queryResult select 2;
if (_tmp isEqualType "") then {_tmp = parseNumber _tmp;};
_queryResult set [2,_tmp];

private _new = [(_queryResult select 3)] call cat_perm_fnc_mresToArray;
if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
_queryResult set[3,_new];

[_queryResult select 0,_queryResult select 1, _queryResult select 2, _queryResult select 3,_receiver] remoteExecCall ["cat_perm_fnc_updatePermDialog",_sender];