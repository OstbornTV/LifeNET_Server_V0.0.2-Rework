/*
    File: fn_updateRank.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Updates rank in batabase
*/

if (!isServer) exitWith {};
params [
	["_level",0,[0]],
	["_receiverUID","",[""]],
	["_playerSide",sideUnknown,[west]]
];
private ["_playerid"];

if (_receiverUID isEqualTo "" || _playerSide isEqualTo sideUnknown) exitWith {};

if ((getNumber(missionConfigFile >> "Cation_Perm" >> "version")) isEqualTo 5) then {
	_playerid = "pid";
} else {
	_playerid = "playerid";
};

private _side = switch (_playerSide) do {
	case independent: { "mediclevel" };
	case west: { "coplevel" };
};

_query = format["UPDATE players SET %3='%2' WHERE %4='%1'",_receiverUID,_level,_side,_playerid];
[_query,1] call DB_fnc_asyncCall;