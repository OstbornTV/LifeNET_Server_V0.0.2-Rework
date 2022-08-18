/*
    File: fn_help.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Lists all possible status.
*/
private _text = "";
private _statusArray = switch (playerSide) do {
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestVehicle");};
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentVehicle");};
	default {[];};
};
if (_statusArray isEqualTo []) exitWith {};
private _centerStatusArray = switch (playerSide) do {
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestCenter");};
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentCenter");};
	default {[];};
};
if (_centerStatusArray isEqualTo []) exitWith {};

_text = _text + format["<t align='center'>%1</t><br/><br/>",format[["statusMobile"] call cat_reporting_fnc_getText]]; 
{
	_text = _text + format["%1: %2<br/>",_x select 0,[_x select 1] call cat_reporting_fnc_getText];
} forEach _statusArray;
_text = _text + format["<br/><t align='center'>%1</t><br/><br/>",format[["statusCenter"] call cat_reporting_fnc_getText]]; 
{
	_text = _text + format["%1: %2<br/>",_x select 0,[_x select 1] call cat_reporting_fnc_getText];
} forEach _centerStatusArray;

hint parseText _text;